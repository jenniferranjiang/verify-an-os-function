"""One explicit QCP environment for native tools and both MCP servers."""
from pathlib import Path
import json
import os
import shlex
import sys

HERE = Path(__file__).resolve().parent
ROOT = Path(os.environ.get("ROCQ_WORKSPACE", str(HERE.parent.parent))).resolve()


def profile():
    data = json.loads((HERE / 'toolchain.json').read_text())
    data['bin'] = Path(data['opam_root']) / data['opam_switch'] / 'bin'
    data['backend_bin'] = HERE / data['backend_bin']
    return data


def launch(service, args):
    data = profile()
    for name in ('coqc', 'coqtop', 'coqdep', 'coqchk', 'pet', 'coq-lsp'):
        base = data['backend_bin'] if name in ('pet', 'coq-lsp') else data['bin']
        if not os.access(base / name, os.X_OK):
            raise SystemExit(f'QCP environment incomplete: {base / name}')
    env = os.environ.copy()
    # Do not carry a different switch's explicit library overrides into opam.
    for name in ('COQLIB', 'ROCQLIB', 'COQCORELIB', 'OCAMLPATH', 'CAML_LD_LIBRARY_PATH', 'COQPATH'):
        env.pop(name, None)
    env['COQBIN'] = str(data['bin']) + '/'
    for tool in ('coqc', 'coqtop', 'coqdep', 'coqchk'):
        env[tool.upper() + '_EXE'] = str(data['bin'] / tool)
    if service in ('rocq', 'qcp'):
        package = 'rocq-mcp' if service == 'rocq' else 'qcp-mcp'
        module = 'rocq_mcp.server' if service == 'rocq' else 'qcp_mcp.server'
        directory = Path(data['qcp_root']) / 'mcp' / package
        # Import by canonical module name: `-m rocq_mcp.server` creates a
        # second server module when its helpers import it, causing a cycle.
        command = [str(directory / '.venv/bin/python'), '-c',
                   f'from {module} import main; main()']
        env['PYTHONPATH'] = str(directory / 'src')
        if service == 'rocq':
            env['ROCQ_WORKSPACE'] = str(ROOT)
            env['ROCQ_COQC_BINARY'] = str(HERE / 'coqc')
        else:
            env['QCP_MCP_CONFIG'] = str(directory / 'CONFIGURE')
    elif service == 'run' and args:
        command = args
    else:
        raise SystemExit('usage: launch-mcp {rocq|qcp|run COMMAND [ARGS...]}')
    argv = ['opam', 'exec', '--root=' + data['opam_root'],
            '--switch=' + data['opam_switch'], '--', '/usr/bin/env',
            'PATH=' + str(data['backend_bin']) + ':' + str(data['bin']) +
            ':/home/xinra/.local/bin:/usr/local/bin:/usr/bin:/bin', *command]
    os.execve('/usr/bin/opam', argv, env)


def project_file(start):
    for parent in (start, *start.parents):
        if not parent.is_relative_to(ROOT):
            break
        for name in ('_RocqProject', '_CoqProject'):
            path = parent / name
            if path.is_file():
                return path
    return None


def project_flags(path):
    """Read the project's actual mappings; never copy its dependency tree."""
    tokens = shlex.split(path.read_text(), comments=True)
    flags = []
    i = 0
    while i < len(tokens):
        token = tokens[i]
        if token in ('-R', '-Q', '-I'):
            count = 3 if token in ('-R', '-Q') else 2
            if i + count > len(tokens):
                raise ValueError(f'Incomplete {token} in {path}')
            physical = Path(tokens[i + 1])
            if not physical.is_absolute():
                physical = path.parent / physical
            flags.extend([token, str(physical.resolve()), *tokens[i + 2:i + count]])
            i += count
        elif token == '-arg' and i + 1 < len(tokens):
            flags.append(tokens[i + 1])
            i += 2
        elif token.endswith('.v') and not token.startswith('-'):
            i += 1  # Build targets are not arguments to a single-file check.
        else:
            raise ValueError(f'Unsupported project entry {token!r} in {path}')
    return flags


def compile_file(args):
    data = profile()
    compiler = data['bin'] / 'coqc'
    if not os.access(compiler, os.X_OK):
        raise SystemExit(f'QCP compiler missing: {compiler}')
    cwd = Path.cwd().resolve()
    project = project_file(cwd)
    flags = project_flags(project) if project else []
    # Controller group workspaces stage VC objects without a project marker.
    # Reuse the project's logical alias for that staged directory.
    if project and 'verification_runs' in cwd.parts and (cwd / 'VC').is_dir():
        for i, value in enumerate(flags):
            if value in ('-R', '-Q') and Path(flags[i + 1]).name == 'VC':
                flags.extend([value, str(cwd / 'VC'), flags[i + 2]])
                break
    # Put authoritative project mappings after MCP's synthetic -Q . Test.
    launcher = str(HERE / 'launch-mcp')
    os.execv(launcher, [launcher, 'run', str(compiler), *args, *flags])
