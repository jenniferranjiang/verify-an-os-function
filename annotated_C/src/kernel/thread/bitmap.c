/*
* Copyright (c) 2020 AIIT XUOS Lab
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
* @file:    bitmap.c
* @brief:   calculate the highest priority
* @version: 1.0
* @author:  AIIT XUOS Lab
* @date:    2020/3/15
*
*/

#include "m_assign.h"

/*@ Import Coq Require Import CRTOS_Verify.libai.Bitmap */

/*@ Extern Coq
      (bitmap_highest_priority : Z -> Z)
      (leader_zero_count_table : list Z)
      (store_prio_lookup_table : Assertion)
 */

const uint8 LeaderZeroCount[256] =
{
    8, 7, 6, 6, 5, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4,
    3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
};

/*@ include strategies "bitmap_views.strategies" */

int PrioCaculate(uint32 bitmap)
/*@ functional
    Require
      0 <= bitmap && bitmap <= UINT_MAX &&
      store_prio_lookup_table
    Ensure
      __return == bitmap_highest_priority(bitmap) &&
      store_prio_lookup_table
 */
{
    if (bitmap & 0xff000000)
    {
        /*@ Assert
              bitmap == bitmap@pre &&
              0 <= bitmap && bitmap <= UINT_MAX &&
              (bitmap & 0xff000000) != 0 &&
              0 <= ((bitmap & 0xff000000) >> 24) &&
              ((bitmap & 0xff000000) >> 24) < 256 &&
              store_prio_lookup_table
         */
        return 31 - LeaderZeroCount[(bitmap & 0xff000000) >> 24];
    }
    else if (bitmap & 0xff0000)
    {
        /*@ Assert
              bitmap == bitmap@pre &&
              0 <= bitmap && bitmap <= UINT_MAX &&
              (bitmap & 0xff000000) == 0 &&
              (bitmap & 0xff0000) != 0 &&
              0 <= ((bitmap & 0xff0000) >> 16) &&
              ((bitmap & 0xff0000) >> 16) < 256 &&
              store_prio_lookup_table
         */
        return 23 - LeaderZeroCount[(bitmap & 0xff0000) >> 16];
    }
    else if (bitmap & 0xff00)
    {
        /*@ Assert
              bitmap == bitmap@pre &&
              0 <= bitmap && bitmap <= UINT_MAX &&
              (bitmap & 0xff000000) == 0 &&
              (bitmap & 0xff0000) == 0 &&
              (bitmap & 0xff00) != 0 &&
              0 <= ((bitmap & 0xff00) >> 8) &&
              ((bitmap & 0xff00) >> 8) < 256 &&
              store_prio_lookup_table
         */
        return 15 - LeaderZeroCount[(bitmap & 0xff00) >> 8];
    }
    else if (bitmap & 0xff)
    {
        /*@ Assert
              bitmap == bitmap@pre &&
              0 <= bitmap && bitmap <= UINT_MAX &&
              (bitmap & 0xff000000) == 0 &&
              (bitmap & 0xff0000) == 0 &&
              (bitmap & 0xff00) == 0 &&
              (bitmap & 0xff) != 0 &&
              0 <= (bitmap & 0xff) &&
              (bitmap & 0xff) < 256 &&
              store_prio_lookup_table
         */
        return 7 - LeaderZeroCount[bitmap & 0xff];
    }
    else
    {
        return 0;
    }
}
