#!/usr/bin/env python3
"""Build an isolated real-case context and test the actual interactive MCP API.

Run with the rocq-mcp venv Python. This starts a separate server, so its success
does not certify that an IDE's already-running connection has been restarted.
"""
import argparse
import asyncio
from datetime import datetime, timezone, timedelta
import hashlib
import json
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import sys

from qcp_toolchain import HERE, ROOT, profile, project_flags


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def save(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + '\n')


def checked_command(argv, cwd, log, timeout=240):
    with log.open('w') as stream:
        result = subprocess.run(argv, cwd=cwd, stdout=stream,
                                stderr=subprocess.STDOUT, timeout=timeout)
    if result.returncode:
        raise RuntimeError(f'Command failed ({result.returncode}); see {log}')


def prepare(trial, case, output):
    if not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*', case):
        raise ValueError('case must be a Coq artifact stem')
    output.mkdir(parents=True, exist_ok=False)
    (output / 'VC').mkdir()
    cfg = profile()
    copied = {}
    for suffix in ('lib', 'goal'):
        source = trial / 'VC' / f'{case}_{suffix}.v'
        copied[str(source)] = sha(source)
        shutil.copyfile(source, output / 'VC' / source.name)
    flags = project_flags(trial / '_CoqProject')
    # Match the case's existing logical namespace while staging only two files.
    alias = None
    for i, flag in enumerate(flags):
        if flag in ('-R', '-Q') and Path(flags[i + 1]) == trial / 'VC':
            alias = flags[i + 2]
            flags[i + 1] = str(output / 'VC')
    if alias is None:
        raise ValueError('No explicit mapping for trial/VC in _CoqProject')
    flags.extend(['-R', str(output), 'QcpToolProbe'])
    # Specific VC mapping must follow the enclosing probe mapping.
    flags.extend(['-R', str(output / 'VC'), alias])
    rows = []
    i = 0
    while i < len(flags):
        n = 3 if flags[i] in ('-R', '-Q') else 2
        rows.append(' '.join(shlex.quote(s) for s in flags[i:i+n]))
        i += n
    (output / '_CoqProject').write_text('\n'.join(rows) + '\n')
    source = (
        f'From {alias} Require Import {case}_goal.\n'
        'From SimpleC.SL Require Import Mem SeparationLogic.\n'
        'Require Import Logic.LogicGenerator.demo932.Interface.\n'
        'From CRTOS_Verify.lib Require Import KSemaphoreDelete.\n'
        'Local Open Scope sac.\n'
        'Lemma qcp_mcp_environment_probe : forall sg st,\n'
        '  os_inv sg st |-- os_inv sg st.\n'
        'Proof.\nAbort.\n'
    )
    (output / 'Probe.v').write_text(source)
    # These are preserved formal inputs, not outputs of this environment test.
    protected = {
        **copied,
        str(ROOT / 'lib/KSemaphoreDelete.vo'): sha(ROOT / 'lib/KSemaphoreDelete.vo'),
        str(Path(cfg['qcp_root']) / 'Rocq/SeparationLogic/Mem.vo'):
            sha(Path(cfg['qcp_root']) / 'Rocq/SeparationLogic/Mem.vo'),
    }
    report = {'status': 'building', 'workspace': str(output), 'trial': str(trial),
              'case': case, 'toolchain': json.loads((HERE / 'toolchain.json').read_text()),
              'preserved_inputs': protected, 'calls': [],
              'connection': 'independently started MCP stdio service; not the old IDE connection'}
    report['executables'] = {}
    for name in ('coqc', 'coqtop', 'coqdep', 'coqchk', 'ocamlc', 'pet', 'coq-lsp'):
        base = cfg['backend_bin'] if name in ('pet', 'coq-lsp') else cfg['bin']
        path = base / name
        report['executables'][name] = {'path': str(path), 'sha256': sha(path)}
    report['backend_build'] = json.loads((HERE / '.local/build.json').read_text())
    report['versions'] = {}
    for command in (['coqc', '--version'], ['coqc', '-where'], ['ocamlc', '-version'],
                    ['pet', '--version'], ['coq-lsp', '--version']):
        result = subprocess.run([str(HERE / 'launch-mcp'), 'run', *command],
                                capture_output=True, text=True, timeout=30, check=True)
        report['versions'][' '.join(command)] = result.stdout.strip()
    save(output / 'result.json', report)
    compiler = str(cfg['bin'] / 'coqc')
    for suffix in ('lib', 'goal'):
        filename = f'VC/{case}_{suffix}.v'
        checked_command([str(HERE / 'launch-mcp'), 'run', compiler, '-q', *flags, filename], output,
                        output / f'build-{suffix}.log')
    return report


async def interactive(output, report):
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client

    params = StdioServerParameters(command=str(HERE / 'launch-mcp'),
                                  args=['rocq'], cwd=str(ROOT))
    with (output / 'server.log').open('w') as errors:
        async with stdio_client(params, errlog=errors) as (reader, writer):
            async with ClientSession(reader, writer, read_timeout_seconds=timedelta(seconds=120)) as session:
                await session.initialize()

                async def call(name, arguments):
                    raw = await session.call_tool(name, arguments,
                                                 read_timeout_seconds=timedelta(seconds=120))
                    data = raw.structuredContent
                    if not isinstance(data, dict) or 'success' not in data:
                        blocks = [x.text for x in raw.content if x.type == 'text']
                        data = json.loads('\n'.join(blocks))
                    report['calls'].append({'tool': name, 'arguments': arguments, 'result': data})
                    save(output / 'result.json', report)
                    if raw.isError or data.get('success') is not True:
                        raise RuntimeError(f'{name} failed: {data}')
                    if data.get('stale_warning') or data.get('given_up_goals') or data.get('shelved_goals'):
                        raise RuntimeError(f'{name} returned an incomplete/stale state')
                    print(name, 'passed', flush=True)
                    return data

                state = await call('rocq_start', {
                    'workspace': str(output), 'file': 'Probe.v',
                    'theorem': 'qcp_mcp_environment_probe', 'timeout': 90})
                if not state.get('goals') or state.get('proof_finished'):
                    raise RuntimeError('rocq_start did not return the expected open proof')
                await call('rocq_query', {'from_state': state['state_id'],
                           'command': 'Check os_inv. Check semaphore_pending_nodes.', 'timeout': 30})
                state = await call('rocq_check', {'from_state': state['state_id'],
                                   'body': 'intros sg st.', 'timeout': 30})
                if not state.get('goals') or state.get('proof_finished'):
                    raise RuntimeError('Expected an entailment after intros')
                alternatives = await call('rocq_step_multi', {
                    'from_state': state['state_id'],
                    'tactics': ['apply derivable1_refl.', 'exact I.'], 'timeout': 30})
                good, bad = alternatives['results']
                if not good.get('success') or not good.get('proof_finished') or bad.get('success'):
                    raise RuntimeError('Tactic exploration did not distinguish the expected outcomes')
                # step_multi does not advance the parent state.
                state = await call('rocq_check', {'from_state': state['state_id'],
                                   'body': 'apply derivable1_refl.', 'timeout': 30})
                if not state.get('proof_finished'):
                    raise RuntimeError('The actual committed proof is incomplete')
                state = await call('rocq_check', {'from_state': state['state_id'],
                                   'body': 'Qed.', 'timeout': 30})
                await call('rocq_query', {'from_state': state['state_id'],
                           'command': 'Check qcp_mcp_environment_probe.', 'timeout': 30})
                source = (output / 'Probe.v').read_text().replace(
                    'Proof.\nAbort.', 'Proof.\n  intros sg st.\n  apply derivable1_refl.\nQed.')
                (output / 'Probe.v').write_text(source)
                await call('rocq_compile_file', {'workspace': str(output), 'file': 'Probe.v',
                           'timeout': 90, 'keep_vo': True, 'include_warnings': False})
                await call('rocq_diag', {})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--trial', required=True, type=Path)
    parser.add_argument('--case', required=True)
    parser.add_argument('--output', required=True, type=Path)
    args = parser.parse_args()
    output = args.output.resolve()
    if not output.is_relative_to(ROOT):
        parser.error('output must be under the repository workspace')
    report = None
    try:
        report = prepare(args.trial.resolve(), args.case, output)
        report['status'] = 'interactive-testing'
        asyncio.run(interactive(output, report))
        for path, digest in report['preserved_inputs'].items():
            if sha(Path(path)) != digest:
                raise RuntimeError(f'Preserved input changed: {path}')
        report.update(status='passed', checked_at=datetime.now(timezone.utc).isoformat(),
                      current_ide_connection_ready=False, preserved_inputs_unchanged=True)
        save(output / 'result.json', report)
        print('Interactive MCP preflight passed; IDE connection reload is separate.')
    except Exception as error:
        if report is None and (output / 'result.json').is_file():
            report = json.loads((output / 'result.json').read_text())
        if report is not None:
            report.update(status='failed', error=str(error))
            save(output / 'result.json', report)
        raise


if __name__ == '__main__':
    main()
