#!/usr/bin/env python3
"""Build pet/coq-lsp against the exact core used by existing project objects.

The source must be the unpacked coq-lsp 0.2.5+8.20 release. Install its build
dependencies first (see README); this does not rebuild Coq or proof libraries.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess

from qcp_toolchain import HERE, profile

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--source', required=True, type=Path)
args = parser.parse_args()
cfg = profile()
source = args.source.resolve()
target = HERE / '.local/source'
target.parent.mkdir(exist_ok=True)
if target.exists():
    raise SystemExit(f'Build directory exists; inspect before replacing: {target}')
shutil.copytree(source, target, ignore=shutil.ignore_patterns('_build', '.git'))
hashes = {str(p.relative_to(target)): hashlib.sha256(p.read_bytes()).hexdigest()
          for p in target.rglob('*') if p.is_file()}
env = os.environ.copy()
for name in ('OCAMLPATH', 'COQLIB', 'ROCQLIB', 'COQCORELIB', 'CAML_LD_LIBRARY_PATH', 'COQPATH'):
    env.pop(name, None)
command = ['opam', 'exec', '--root=' + cfg['opam_root'],
           '--switch=' + cfg['opam_switch'], '--', 'dune', 'build',
           '--root=' + str(target), '-j', '2',
           'petanque/json_shell/pet.exe', 'lsp-server/native/coq_lsp.exe']
with (target.parent / 'build.log').open('w') as stream:
    subprocess.run(command, env=env, stdout=stream, stderr=subprocess.STDOUT, check=True)
cfg['backend_bin'].mkdir(exist_ok=True)
artifacts = {}
for name, relative in [('pet', 'petanque/json_shell/pet.exe'),
                       ('coq-lsp', 'lsp-server/native/coq_lsp.exe')]:
    dest = cfg['backend_bin'] / name
    shutil.copy2(target / '_build/default' / relative, dest)
    artifacts[name] = hashlib.sha256(dest.read_bytes()).hexdigest()
(target.parent / 'build.json').write_text(json.dumps({
    'status': 'built-not-yet-interactively-validated', 'command': command,
    'source': str(source), 'source_hashes': hashes, 'artifacts': artifacts,
    'core_switch': cfg['opam_switch'],
    'interruption_backend': 'Coq (upstream fallback; memprof-limits is not installed)'
}, indent=2) + '\n')
print('Backend built; run check-interactive.py before target proof work.')
