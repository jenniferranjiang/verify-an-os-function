/*
 * Copyright (c) 2022 AIIT XUOS Lab
 * XiUOS is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *        http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

/**
 * @file jerry_main.c
 * @brief support jerryscript
 * @version 1.0
 * @author AIIT XUOS Lab
 * @date 2023.08.07
 */

#include <transform.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "jerryscript.h"
#include "jerryscript-ext/debugger.h"
#include "jerryscript-ext/handler.h"
#include "jerryscript-port.h"
#include "setjmp.h"


/* Maximum command line arguments number.*/
#define JERRY_MAX_COMMAND_LINE_ARGS (16)

/*Standalone Jerry exit codes.*/
#define JERRY_STANDALONE_EXIT_CODE_OK   (0)
#define JERRY_STANDALONE_EXIT_CODE_FAIL (1)

/* Context size of the SYNTAX_ERROR */
#define SYNTAX_ERROR_CONTEXT_SIZE 2


static void print_help(char *name)
{
  printf ("Usage: %s [OPTION]... [FILE]...\n"
          "\n"
          "Options:\n"
          "  --log-level [0-3]\n"
          "  --mem-stats\n"
          "  --mem-stats-separate\n"
          "  --show-opcodes\n"
          "  --start-debug-server\n"
          "  --debug-server-port [port]\n"
          "\n",
          name);
}

/**
 * Read source code into buffer.
 *
 * Returned value must be freed with jmem_heap_free_block if it's not NULL.
 * @return NULL, if read or allocation has failed
 *         pointer to the allocated memory block, otherwise
 */
static const uint8_t *read_file (const char *file_name, size_t *out_size_p)
{
  FILE *file = fopen (file_name, "r");
  if (file == NULL)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Error: cannot open file: %s\n", file_name);
    return NULL;
  }

  int fseek_status = fseek (file, 0, SEEK_END);
  if (fseek_status != 0)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Failed to seek (error: %d)\n", fseek_status);
    fclose (file);
    return NULL;
  }

  long script_len = ftell (file);
  if (script_len < 0)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Failed to get the file size(error %ld)\n", script_len);
    fclose (file);
    return NULL;
  }

  rewind (file);

  uint8_t *buffer = (uint8_t *) malloc (script_len);

  if (buffer == NULL)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Out of memory error\n");
    fclose (file);
    return NULL;
  }

  size_t bytes_read = fread (buffer, 1u, script_len, file);

  if (!bytes_read || bytes_read != script_len)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Error: failed to read file: %s\n", file_name);
    free ((void*) buffer);

    fclose (file);
    return NULL;
  }

  fclose (file);

  *out_size_p = bytes_read;
  return (const uint8_t *) buffer;
}

/**
 * Convert string into unsigned integer
 *
 * @return converted number
 */
static uint32_t str_to_uint (const char *num_str_p) /**< string to convert */
{
  uint32_t result = 0;

  while (*num_str_p != '\0')
  {
    result *= 10;
    result += (uint32_t) (*num_str_p - '0');
    num_str_p++;
  }
  return result;
}

/**
 * Print error value
 */
static void print_unhandled_exception (jerry_value_t error_value, const jerry_char_t *source_p)
{
  error_value = jerry_get_value_from_error (error_value, false);
  jerry_value_t err_str_val = jerry_value_to_string (error_value);
  jerry_size_t err_str_size = jerry_get_string_size (err_str_val);
  jerry_char_t err_str_buf[256];

  jerry_release_value (error_value);

  if (err_str_size >= 256)
  {
    const char msg[] = "[Error message too long]";
    err_str_size = sizeof (msg) / sizeof (char) - 1;
    memcpy (err_str_buf, msg, err_str_size);
  }
  else
  {
    jerry_size_t sz = jerry_string_to_char_buffer (err_str_val, err_str_buf, err_str_size);
    err_str_buf[err_str_size] = 0;

    if (jerry_is_feature_enabled (JERRY_FEATURE_ERROR_MESSAGES)
        && jerry_get_error_type (error_value) == JERRY_ERROR_SYNTAX)
    {
      uint32_t err_line = 0;
      uint32_t err_col = 0;

      /* 1. parse column and line information */
      for (uint32_t i = 0; i < sz; i++)
      {
        if (!strncmp ((char *) (err_str_buf + i), "[line: ", 7))
        {
          i += 7;

          char num_str[8];
          uint32_t j = 0;

          while (i < sz && err_str_buf[i] != ',')
          {
            num_str[j] = (char) err_str_buf[i];
            j++;
            i++;
          }
          num_str[j] = '\0';

          err_line = str_to_uint (num_str);

          if (strncmp ((char *) (err_str_buf + i), ", column: ", 10))
          {
            break; /* wrong position info format */
          }

          i += 10;
          j = 0;

          while (i < sz && err_str_buf[i] != ']')
          {
            num_str[j] = (char) err_str_buf[i];
            j++;
            i++;
          }
          num_str[j] = '\0';

          err_col = str_to_uint (num_str);
          break;
        }
      } /* for */

      if (err_line != 0 && err_col != 0)
      {
        uint32_t curr_line = 1;

        bool is_printing_context = false;
        uint32_t pos = 0;

        /* 2. seek and print */
        while (source_p[pos] != '\0')
        {
          if (source_p[pos] == '\n')
          {
            curr_line++;
          }

          if (err_line < SYNTAX_ERROR_CONTEXT_SIZE
              || (err_line >= curr_line
                  && (err_line - curr_line) <= SYNTAX_ERROR_CONTEXT_SIZE))
          {
            /* context must be printed */
            is_printing_context = true;
          }

          if (curr_line > err_line)
          {
            break;
          }

          if (is_printing_context)
          {
            jerry_port_log (JERRY_LOG_LEVEL_ERROR, "%c", source_p[pos]);
          }

          pos++;
        }

        jerry_port_log (JERRY_LOG_LEVEL_ERROR, "\n");

        while (--err_col)
        {
          jerry_port_log (JERRY_LOG_LEVEL_ERROR, "~");
        }

        jerry_port_log (JERRY_LOG_LEVEL_ERROR, "^\n");
      }
    }
  }

  jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Script Error: %s\n", err_str_buf);
  jerry_release_value (err_str_val);
}


/**
 * Register a JavaScript function in the global object.
 */
static void register_js_function (const char *name_p,jerry_external_handler_t handler_p)
{
  jerry_value_t result_val = jerryx_handler_register_global ((const jerry_char_t *) name_p, handler_p);

  if (jerry_value_is_error (result_val))
  {
    jerry_port_log (JERRY_LOG_LEVEL_WARNING, "Warning: failed to register '%s' method.", name_p);
  }

  jerry_release_value (result_val);
}

void js_add_function(const jerry_value_t obj, const char *name,
                     jerry_external_handler_t func)
{
    jerry_value_t str = jerry_create_string((const jerry_char_t *)name);
    jerry_value_t jfunc = jerry_create_external_function(func);

    jerry_set_property(obj, str, jfunc);

    jerry_release_value(str);
    jerry_release_value(jfunc);
}

void js_set_property(const jerry_value_t obj, const char *name,
                     const jerry_value_t prop)
{
    jerry_value_t str = jerry_create_string((const jerry_char_t *)name);
    jerry_set_property(obj, str, prop);
    jerry_release_value (str);
}

int js_console_init(void)
{
    jerry_value_t console = jerry_create_object();
    jerry_value_t global_obj = jerry_get_global_object();

    js_add_function(console, "log", jerryx_handler_print);

    js_set_property(global_obj, "console", console);

    jerry_release_value(global_obj);
    jerry_release_value(console);

    return 0;
}

static jerry_log_level_t jerry_log_level = JERRY_LOG_LEVEL_ERROR;


int jerrytest(int argc, char *argv[])
{
  if (argc > JERRY_MAX_COMMAND_LINE_ARGS)
  {
    jerry_port_log (JERRY_LOG_LEVEL_ERROR,
                    "Too many command line arguments. Current maximum is %d\n",
                    JERRY_MAX_COMMAND_LINE_ARGS);

    return JERRY_STANDALONE_EXIT_CODE_FAIL;
  }

  const char *file_names[JERRY_MAX_COMMAND_LINE_ARGS];
  int i;
  int files_counter = 0;
  bool start_debug_server = false;
  uint16_t debug_port = 5001;

  jerry_init_flag_t flags = JERRY_INIT_EMPTY;

  for (i = 1; i < argc; i++)
  {
    if (!strcmp ("-h", argv[i]) || !strcmp ("--help", argv[i]))
    {
      print_help (argv[0]);
      return JERRY_STANDALONE_EXIT_CODE_OK;
    }
    else if (!strcmp ("--mem-stats", argv[i]))
    {
      flags |= JERRY_INIT_MEM_STATS;
      jerry_log_level = JERRY_LOG_LEVEL_DEBUG;
    }
    else if (!strcmp ("--mem-stats-separate", argv[i]))
    {
      flags |= JERRY_INIT_MEM_STATS_SEPARATE;
      jerry_log_level = JERRY_LOG_LEVEL_DEBUG;
    }
    else if (!strcmp ("--show-opcodes", argv[i]))
    {
      flags |= JERRY_INIT_SHOW_OPCODES | JERRY_INIT_SHOW_REGEXP_OPCODES;
      jerry_log_level = JERRY_LOG_LEVEL_DEBUG;
    }
    else if (!strcmp ("--log-level", argv[i]))
    {
      if (++i < argc && strlen (argv[i]) == 1 && argv[i][0] >='0' && argv[i][0] <= '3')
      {
        jerry_log_level = argv[i][0] - '0';
      }
      else
      {
        jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Error: wrong format or invalid argument\n");
        return JERRY_STANDALONE_EXIT_CODE_FAIL;
      }
    }
    else if (!strcmp ("--start-debug-server", argv[i]))
    {
      start_debug_server = true;
    }
    else if (!strcmp ("--debug-server-port", argv[i]))
    {
      if (++i < argc)
      {
        debug_port = str_to_uint (argv[i]);
      }
      else
      {
        jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Error: wrong format or invalid argument\n");
        return JERRY_STANDALONE_EXIT_CODE_FAIL;
      }
    }
    else
    {
      file_names[files_counter++] = argv[i];
    }
  }

  jerry_init (flags);

  if (start_debug_server)
  {
    jerryx_debugger_after_connect (jerryx_debugger_tcp_create (debug_port)
                                   && jerryx_debugger_ws_create ());
  }

  register_js_function ("gc", jerryx_handler_gc);
  register_js_function ("print", jerryx_handler_print);
  js_console_init();
  

  jerry_value_t ret_value = jerry_create_undefined ();

  if (files_counter == 0)
  {
    printf ("running a hello world demo:");
    const jerry_char_t script[] = "var str = 'Hello World'; print(str + ' from JerryScript.')";

    ret_value = jerry_parse (NULL, 0, script, sizeof (script) - 1, JERRY_PARSE_NO_OPTS);

    if (!jerry_value_is_error (ret_value))
    {
      ret_value = jerry_run (ret_value);
    }
  }
  else
  {
    for (i = 0; i < files_counter; i++)
    {
      size_t source_size;
      const jerry_char_t *source_p = read_file (file_names[i], &source_size);

      if (source_p == NULL)
      {
        jerry_port_log (JERRY_LOG_LEVEL_ERROR, "Source file load error\n");
        return JERRY_STANDALONE_EXIT_CODE_FAIL;
      }

      ret_value = jerry_parse ((jerry_char_t *) file_names[i],
                               strlen (file_names[i]),
                               source_p,
                               source_size,
                               JERRY_PARSE_NO_OPTS);

      if (!jerry_value_is_error (ret_value))
      {
        jerry_value_t func_val = ret_value;
        ret_value = jerry_run (func_val);
        jerry_release_value (func_val);
      }

      if (jerry_value_is_error (ret_value))
      {
        print_unhandled_exception (ret_value, source_p);
        free ((void*) source_p);

        break;
      }

      free ((void*) source_p);

      jerry_release_value (ret_value);
      ret_value = jerry_create_undefined ();
    }
  }

  int ret_code = JERRY_STANDALONE_EXIT_CODE_OK;

  if (jerry_value_is_error (ret_value))
  {
    ret_code = JERRY_STANDALONE_EXIT_CODE_FAIL;
  }

  jerry_release_value (ret_value);

  ret_value = jerry_run_all_enqueued_jobs ();

  if (jerry_value_is_error (ret_value))
  {
    ret_code = JERRY_STANDALONE_EXIT_CODE_FAIL;
  }

  jerry_release_value (ret_value);
  jerry_cleanup ();

  return ret_code;
}

PRIV_SHELL_CMD_FUNCTION(jerrytest, jerryscript test sample, PRIV_SHELL_CMD_MAIN_ATTR);
