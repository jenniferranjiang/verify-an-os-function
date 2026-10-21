#!/usr/bin/env python3
"""Compile the explicit fresh-trial predicate closure; never enumerate trials."""
from pathlib import Path
import argparse, hashlib, json, shlex, subprocess, time, datetime
options = argparse.ArgumentParser()
options.add_argument('--revision-number', type=int, default=3)
options.add_argument('--incremental', action='store_true')
cli = options.parse_args()
trial = Path(__file__).resolve().parents[1]
coqc = '/home/xinra/.opam/default/bin/coqc'
args = shlex.split((trial / '_CoqProject').read_text())
files = ['SemaphorePure', 'CrtosOSPure', 'CrtosHeapBridge', 'CrtosNestedState',
         'CrtosOSProtocol', 'CrtosOSProtocolProof', 'SemaphoreRep', 'CrtosOSInv', 'SemaphoreCritical']
deps = {'SemaphorePure': [], 'CrtosOSPure': ['SemaphorePure'], 'CrtosHeapBridge': [],
        'CrtosNestedState': [],
        'CrtosOSProtocol': ['CrtosOSPure', 'CrtosHeapBridge', 'CrtosNestedState'],
        'CrtosOSProtocolProof': ['CrtosOSProtocol'],
        'SemaphoreRep': ['SemaphorePure'],
        'CrtosOSInv': ['CrtosOSPure', 'SemaphoreRep', 'CrtosOSProtocol'],
        'SemaphoreCritical': ['CrtosOSInv', 'CrtosOSProtocol', 'CrtosOSProtocolProof', 'CrtosOSPure']}
evidence = trial / 'evidence'
evidence.mkdir(exist_ok=True)
old_manifest = evidence / 'predicate-manifest.json'
previous = {}
if cli.incremental and old_manifest.exists():
    previous = {x['path']: x['sha256'] for x in json.loads(old_manifest.read_text())['files']}
start = time.monotonic()
entries = [{'path': 'lib/' + name + '.v',
            'sha256': hashlib.sha256((trial / 'lib' / (name + '.v')).read_bytes()).hexdigest()}
           for name in files]
rebuild = set()
for name, entry in zip(files, entries):
    if (previous.get(entry['path']) != entry['sha256'] or
            not (trial / 'lib' / (name + '.vo')).exists() or
            any(d in rebuild for d in deps[name])):
        rebuild.add(name)
checks = []
for name in files:
    if name not in rebuild:
        checks.append({'file': 'lib/' + name + '.v', 'status': 'reused-unchanged',
                       'exit_code': 0, 'basis': 'same formal hash and no changed local dependency'})
        print(name, 'unchanged')
        continue
    command = [coqc, *args, str(trial / 'lib' / (name + '.v'))]
    result = subprocess.run(command, capture_output=True, text=True, cwd=trial)
    checks.append({'file': 'lib/' + name + '.v', 'status': 'compiled', 'command': command,
                   'exit_code': result.returncode, 'stdout': result.stdout, 'stderr': result.stderr})
    print(name, result.returncode)
    if result.returncode:
        print(result.stdout, result.stderr)
        break
manifest = {'format': 'explicit-predicate-sources-v1', 'files': entries}
encoded = (json.dumps(manifest, ensure_ascii=False, sort_keys=True, indent=2) + '\n').encode()
digest = hashlib.sha256(encoded).hexdigest()
(evidence / 'predicate-manifest.json').write_bytes(encoded)
report = {'revision': f'predicate-r{cli.revision_number}-' + digest[:12],
          'manifest_sha256': digest,
          'checked_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
          'elapsed_seconds': time.monotonic() - start, 'checks': checks,
          'result': 'passed' if len(checks) == len(files) and all(c['exit_code'] == 0 for c in checks) else 'failed'}
(evidence / 'predicate-build.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n')
print(report['result'], report['revision'], digest)
raise SystemExit(0 if report['result'] == 'passed' else 1)
