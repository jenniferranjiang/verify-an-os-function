from pathlib import Path
import hashlib, json, re, shutil, shlex, subprocess, time

trial=Path('/home/xinra/crtos/ksemaphorecreate-trial-261012-1')
candidate=trial/'evidence/nonzero-candidate'
review=trial/'evidence/nonzero-review'
build=review/'independent-build'
build.mkdir(exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((candidate/'candidate-manifest.json').read_text())
assert sha(candidate/'candidate-manifest.json')=='fe8c4261db5cff754395f3d9038769b3e50420d542347262a831aa3ce6a422b3'
result={'revision':'predicate-nonzero-candidate-fe8c4261db5c','formal_count':len(manifest['files']),'hash_mismatches':[],'changed_vs_active':[],'introduced_forbidden_tokens':[],'imports':{},'delivery_mismatches':[]}
files=[]
for entry in manifest['files']:
    rel=entry['path']; source=candidate/rel
    assert sha(source)==entry['sha256'], rel
    if not (trial/rel).exists() or sha(source)!=sha(trial/rel): result['changed_vs_active'].append(rel)
    target=build/rel; target.parent.mkdir(parents=True,exist_ok=True); shutil.copyfile(source,target)
    files.append(rel)
    body=source.read_text(); old=(trial/rel).read_text() if (trial/rel).exists() else ''
    stripped=re.sub(r'\(\*.*?\*\)','',body,flags=re.S)
    hits=re.findall(r'\b(?:Axiom|Parameter|Admitted|admit|Abort)\b',stripped)
    oldhits=re.findall(r'\b(?:Axiom|Parameter|Admitted|admit|Abort)\b',re.sub(r'\(\*.*?\*\)','',old,flags=re.S))
    if hits!=oldhits: result['introduced_forbidden_tokens'].append({'file':rel,'new':hits,'old':oldhits})
    result['imports'][rel]=[line for line in body.splitlines() if line.startswith(('Require','From '))]
for entry in json.loads((candidate/'delivery-manifest.json').read_text())['artifacts']:
    if sha(candidate/entry['path'])!=entry['sha256']: result['delivery_mismatches'].append(entry['path'])
shutil.copyfile(candidate/'CandidateChecks.v',build/'CandidateChecks.v'); files.append('CandidateChecks.v')
project=(candidate/'_CoqProject').read_text().replace(str(candidate),str(build))
(build/'_CoqProject').write_text(project)
args=shlex.split(project)
start=time.monotonic(); checks=[]
for rel in files:
    cmd=['/home/xinra/.opam/pv-bench-8.20.1/bin/coqc',*args,str(build/rel)]
    p=subprocess.run(cmd,text=True,capture_output=True,cwd=build)
    checks.append({'file':rel,'returncode':p.returncode,'stdout':p.stdout,'stderr':p.stderr})
    (review/'independent-checks.json').write_text(json.dumps({**result,'compile':checks,'elapsed_seconds':time.monotonic()-start},indent=2))
    print(rel,p.returncode,flush=True)
    if p.returncode: break
assert len(checks)==22 and all(c['returncode']==0 for c in checks)
assert not result['delivery_mismatches'] and not result['introduced_forbidden_tokens']
print('All checks passed',time.monotonic()-start,flush=True)
