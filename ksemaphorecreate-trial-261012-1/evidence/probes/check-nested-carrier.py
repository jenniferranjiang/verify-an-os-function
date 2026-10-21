#!/usr/bin/env python3
"""Reproduce the isolated carrier probe; does not change any formal r1 file."""
from pathlib import Path
import hashlib, json, shlex, subprocess, sys
here = Path(__file__).resolve().parent
trial = here.parents[1]
framework = here / 'framework'
provenance = json.loads((framework / 'adapter-provenance.json').read_text())
official = Path(provenance['official_source'])
original = official.read_text()
if hashlib.sha256(official.read_bytes()).hexdigest() != provenance['original_sha256']:
    raise SystemExit('Official NestedCriticalSTS source changed; review provenance before rerunning.')
replacement = provenance['only_replacement']
expected = original.replace(replacement['before'], replacement['after'])
adapted = framework / 'NestedCriticalAdapter.v'
if adapted.read_text() != expected:
    raise SystemExit('Adapter differs from the recorded module-interface-only substitution.')
manifest = json.loads((trial / 'evidence/predicate-manifest.json').read_text())
formal_before = {f['path']: hashlib.sha256((trial / f['path']).read_bytes()).hexdigest()
                 for f in manifest['files']}
args = shlex.split((trial / '_CoqProject').read_text())
args += ['-Q', str(framework), 'CrtosProbeFramework']
results = []
for source in [adapted, here / 'NestedCarrierProbe.v']:
    command = ['/home/xinra/.opam/default/bin/coqc', *args, str(source)]
    done = subprocess.run(command, capture_output=True, text=True)
    results.append({'source': str(source), 'command': command,
                    'exit_code': done.returncode, 'stdout': done.stdout,
                    'stderr': done.stderr})
    print(source.name, done.returncode)
    if done.returncode:
        print(done.stdout, done.stderr)
        break
formal_after = {p: hashlib.sha256((trial / p).read_bytes()).hexdigest()
                for p in formal_before}
passed = len(results) == 2 and all(x['exit_code'] == 0 for x in results)
report = {'scope': 'carrier/heap typecheck only; no IRQ semantic approval',
          'checks': results, 'formal_sources_unchanged': formal_before == formal_after,
          'result': 'passed' if passed and formal_before == formal_after else 'failed'}
(here / 'nested-probe-reproduction.json').write_text(json.dumps(report, indent=2) + '\n')
sys.exit(0 if report['result'] == 'passed' else 1)
