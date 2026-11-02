#!/usr/bin/env python3
"""Exercise a fresh QCP MCP server and compile a generated diagnostic VC file."""
import argparse
import asyncio
from datetime import timedelta
import hashlib
import json
from pathlib import Path
import subprocess

from qcp_toolchain import HERE, ROOT, profile, project_flags

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--project', required=True, type=Path)
parser.add_argument('--output', required=True, type=Path)
args = parser.parse_args()
output = args.output.resolve()
if not output.is_relative_to(ROOT):
    parser.error('output must be under repository')
output.mkdir(parents=True, exist_ok=False)
source = output / 'Smoke.c'
source.write_text('int increment(int x)\n/*@ Require 0 <= x && x < 100 && emp\n'
                  '    Ensure __return == x + 1 && emp */\n{\n  return x + 1;\n}\n')
cfg = profile()
report = {'status': 'testing', 'calls': [], 'scope': 'tool diagnostic only'}


def save():
    (output / 'result.json').write_text(json.dumps(report, indent=2, ensure_ascii=False) + '\n')


async def check():
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client
    params = StdioServerParameters(command=str(HERE / 'launch-mcp'), args=['qcp'], cwd=str(ROOT))
    with (output / 'server.log').open('w') as log:
        async with stdio_client(params, errlog=log) as (reader, writer):
            async with ClientSession(reader, writer, read_timeout_seconds=timedelta(seconds=120)) as session:
                await session.initialize()
                for name, arguments in [('load_target_file', {'file': str(source)}),
                                        ('symbolic', {'line': 6}), ('close', {})]:
                    raw = await session.call_tool(name, arguments,
                                                  read_timeout_seconds=timedelta(seconds=60))
                    text = '\n'.join(x.text for x in raw.content if x.type == 'text')
                    report['calls'].append({'tool': name, 'arguments': arguments,
                                            'response': text, 'isError': raw.isError})
                    save()
                    if raw.isError:
                        raise RuntimeError(f'{name} failed: {text}')
                    if name == 'symbolic':
                        data = json.loads(text)
                        if isinstance(data, dict) and set(data) == {'result'}:
                            data = json.loads(data['result'])
                        report['symbolic'] = data
                        # Require a structured QCP response, not just transport success.
                        if (not isinstance(data, dict) or 'errormessage' not in data
                                or data['errormessage'] or data.get('result') != 'success'):
                            raise RuntimeError(f'Unexpected symbolic result: {data}')
                    print(name, 'passed', flush=True)


try:
    asyncio.run(check())
    binary = Path(cfg['qcp_root']) / 'linux-binary/symexec'
    command = [str(binary), '--input-file=' + str(source),
               '--goal-file=' + str(output / 'Smoke_goal.v'),
               '--proof-auto-file=' + str(output / 'Smoke_proof_auto.v'),
               '--proof-manual-file=' + str(output / 'Smoke_proof_manual.v'),
               '--coq-logic-path=QcpSmoke', '--no-exec-info']
    report['symexec_command'] = command
    report['symexec_sha256'] = hashlib.sha256(binary.read_bytes()).hexdigest()
    with (output / 'symexec.log').open('w') as log:
        subprocess.run(command, stdout=log, stderr=subprocess.STDOUT, check=True, timeout=60)
    flags = project_flags(args.project.resolve())
    flags.extend(['-R', str(output), 'QcpSmoke'])
    # The generated goal imports the actual configured QCP libraries.
    command = [str(HERE / 'launch-mcp'), 'run', 'coqc', '-q', *flags, 'Smoke_goal.v']
    report['compile_command'] = command
    with (output / 'compile.log').open('w') as log:
        subprocess.run(command, cwd=output, stdout=log, stderr=subprocess.STDOUT,
                       check=True, timeout=90)
    report.update(status='passed', generated_goal_compiled=True,
                  generated_proof_templates_proved=False,
                  note='Generated proof templates are deliberately unproved; no target proof is certified.')
except Exception as error:
    report.update(status='failed', error=str(error))
    raise
finally:
    save()
