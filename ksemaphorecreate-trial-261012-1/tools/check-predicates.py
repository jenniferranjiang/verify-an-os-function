#!/usr/bin/env python3
"""Recheck the explicitly accepted formal closure without rewriting its revision.

Predicate authors create/review revisions separately. This verifier consumes the
current immutable manifest in dependency order and the accepted ABI/toolchain.
It is not a substitute for controller C/VC/proof actions.
"""
from pathlib import Path
import argparse,hashlib,json,shlex,subprocess,time
parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--dry-run',action='store_true')
args=parser.parse_args()
root=Path(__file__).resolve().parents[1]
evidence=root/'evidence'
accepted=json.loads((evidence/'accepted-revisions.json').read_text())
assert accepted['predicate_status']=='review-passed', 'predicate is not accepted'
manifest_bytes=(evidence/'predicate-manifest.json').read_bytes()
assert hashlib.sha256(manifest_bytes).hexdigest()==accepted['predicate_manifest']
project=(root/'_CoqProject').read_bytes()
assert hashlib.sha256(project).hexdigest()==accepted['coqproject_sha256']
files=json.loads(manifest_bytes)['files']
for entry in files:
 path=root/entry['path']
 assert not path.is_symlink() and path.is_file()
 assert hashlib.sha256(path.read_bytes()).hexdigest()==entry['sha256'],str(path)
compiler=accepted['compiler']
flags=shlex.split(project.decode())
commands=[[compiler,*flags,str(root/entry['path'])] for entry in files]
if args.dry_run:
 print(json.dumps({'status':'inputs-validated','revision':accepted['predicate_revision'],'file_count':len(files),'compiler':compiler,'compilation_performed':False},indent=2))
 raise SystemExit(0)
start=time.monotonic();checks=[]
for entry,command in zip(files,commands):
 process=subprocess.run(command,cwd=root,capture_output=True,text=True)
 checks.append({'file':entry['path'],'command':command,'exit_code':process.returncode,'stdout':process.stdout,'stderr':process.stderr})
 print(entry['path'],process.returncode,flush=True)
 if process.returncode:
  print(process.stdout,process.stderr);break
passed=len(checks)==len(files) and all(item['exit_code']==0 for item in checks)
(evidence/'predicate-recheck.json').write_text(json.dumps({'revision':accepted['predicate_revision'],'status':'passed' if passed else 'failed','elapsed_seconds':time.monotonic()-start,'checks':checks},indent=2)+'\n')
raise SystemExit(0 if passed else 1)
