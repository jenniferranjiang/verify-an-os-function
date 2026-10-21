#!/usr/bin/env python3
"""Manual-design support: C token equivalence and contract-copy inspection.
Does not invoke QCP parser, symbolic execution, workflow closure, VC or proof.
Reads only this trial's candidate and source-agent evidence from current C.
"""
from pathlib import Path
import hashlib,json,os,re,subprocess,time
E=Path(os.environ.get('SPEC_TRIAL_EVIDENCE', Path(__file__).resolve().parent)).resolve()
T=E.parent
A=Path(os.environ.get('SPEC_ANNOTATED_ROOT', T/'annotated_C')).resolve()
O=Path(os.environ.get('SPEC_OUTPUT_DIR', E)).resolve()
start=time.monotonic()
SPEC_REVISION_NUMBER = 6
source_result=json.loads((E/'source-check-result.json').read_text())
source_manifest=json.loads((E/'source-manifest.json').read_text())
assert source_result['source_revision']=='source-r2-0c50c37013e9'
assert source_result['config']=='board/stm32f103-nano/config'
assert len(source_manifest)==47
# Frozen current-trial target ABI evidence: this check does not claim a new ARM compile.
assert hashlib.sha256((E/'source-manifest.json').read_bytes()).hexdigest()=='0c50c37013e9cd306791865c9deafadfa2051eaaf523ee78fdfef6b8812c4651', ('changed size32 ABI evidence', 'source-manifest.json')
assert hashlib.sha256((E/'source-check-result.json').read_bytes()).hexdigest()=='798a370a8b3644afc97ff085a57766b82763966a26461c16b0dec207d159f6f8', ('changed size32 ABI evidence', 'source-check-result.json')
assert hashlib.sha256((E/'source-abi.c').read_bytes()).hexdigest()=='206bc62ad3a3231c8114b96f6413f694baf7860be16b9c71d142cf28b3ad7377', ('changed size32 ABI evidence', 'source-abi.c')
assert hashlib.sha256((E/'source-abi.s').read_bytes()).hexdigest()=='a65cefb3ec420b8ec4c7c5c75ad53ad0cec9bfb3d8dab0c6f492069b3d18d834', ('changed size32 ABI evidence', 'source-abi.s')
assert hashlib.sha256((E/'source-config/xsconfig.h').read_bytes()).hexdigest()=='ad9135bd836e78b8ace5af15e88a1e7a34a0b3d723435f85c281a18d1bdc40db', ('changed size32 ABI evidence', 'source-config/xsconfig.h')
source_root=Path(source_result['authoritative_root'])
for rel,h in source_manifest.items():
 assert hashlib.sha256((source_root/rel).read_bytes()).hexdigest()==h,('changed authoritative source',rel)
accepted=json.loads((E/'accepted-revisions.json').read_text())
assert accepted['predicate_status']=='review-passed'
assert accepted['predicate_manifest']==hashlib.sha256((E/'predicate-manifest.json').read_bytes()).hexdigest()
source=json.loads((E/'source-bodies.json').read_text())
expected=set(source)
trusted={'x_malloc','x_free','memset','DisableLocalInterrupt','EnableLocalInterrupt','KPrintf'}
keywords={'if','while','for','sizeof','switch','return'}
lex=re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|[A-Za-z_]\w*|0[xX][0-9a-fA-F]+|\d+|>>=|<<=|->|\+\+|--|\|=|&&|\|\||==|!=|<=|>=|<<|>>|[^\s]')
def tokens(s):return lex.findall(s)
def comments(s):return re.sub(r'/\*.*?\*/|//[^\n]*','',s,flags=re.S)
def definition(s,name):
 hits=list(re.finditer(r'\b'+re.escape(name)+r'\s*\([^;{}]*\)\s*\{',s))
 assert len(hits)==1,(name,'body count',len(hits))
 m=hits[0]; j=s.index('{',m.start()); k=j+1; depth=1
 while depth:
  if s[k]=='{':depth+=1
  elif s[k]=='}':depth-=1
  k+=1
 return s[m.start():k]
def normalize(s,name,authoritative=False):
 s=s.replace('__FUNCTION__','"'+name+'"')
 if name=='KSemaphoreCreate':
  s=s.replace('done.SemaphoreCreate','_SemaphoreCreate')
  s=re.sub(r'\{\s*;','{',s,count=1)
 if name=='_SemaphoreCreate':
  s=re.sub(r'do\s*\{\s*if\s*\(0\)\s*\{.*?\}\s*\}\s*while\s*\(0\);','',s,flags=re.S)
 if name=='IdInsertObj':
  s=re.sub(r'if\s*\(\(id\s*=\s*AllocId\(manager\)\)\s*<\s*0\)', 'id = AllocId(manager); if (id < 0)',s)
 ts=tokens(re.sub(r'\(0\)','0',s))
 if name=='_SemaphoreCreate' and authoritative:
  # DCHG-20261016-01: only these two complete fixed-struct call patterns.
  # Applied to authoritative tokens only; never erase sizeof on the candidate.
  for old,new in [
   ('x_malloc(sizeof(struct Semaphore))','x_malloc((x_size_t)32)'),
   ('memset(sem, 0, sizeof(struct Semaphore))','memset(sem, 0, (x_size_t)32)')]:
   a,b=tokens(old),tokens(new)
   hits=[i for i in range(len(ts)-len(a)+1) if ts[i:i+len(a)]==a]
   assert len(hits)==1,('fixed sizeof source call count',old,len(hits))
   i=hits[0]; ts[i:i+len(a)]=b
 return ts
files=sorted((A/'src').glob('*.c'))
assert {p.stem for p in files}==expected
canonical={}; api={}; bodies={}; checks={}; calls={}
for p in files:
 raw=p.read_text(); name=p.stem
 pp=subprocess.run(['gcc','-E','-P',str(p)],check=True,capture_output=True,text=True).stdout
 body=definition(pp,name); bodies[name]=body
 assert normalize(body,name)==normalize(source[name],name,authoritative=True),(name,'source token mismatch',normalize(body,name),normalize(source[name],name,authoritative=True))
 without_strings=re.sub(r'"(?:\\.|[^"\\])*"','""',body[body.index('{'):])
 calls[name]=sorted(set(re.findall(r'\b([A-Za-z_]\w*)\s*\(',without_strings))-keywords)
 specs={}
 for symbol in expected|trusted:
  pattern=r'^(?:void\s*\*|void|int32|int|x_base)\s*'+re.escape(symbol)+r'\([^\n]*\)\s*(/\*@.*?\*/)\s*([;{])'
  matches=list(re.finditer(pattern,raw,re.M|re.S))
  if not matches:continue
  assert len(matches)==1,(name,symbol,'duplicate declaration or body')
  m=matches[0];spec=m.group(1)
  assert 'Require' in spec and 'Ensure' in spec,(name,symbol,'incomplete API')
  specs[symbol]=spec
  if m.group(2)=='{':
   assert symbol==name,(name,symbol,'foreign active body')
   canonical[symbol]=spec
 assert set(specs)==set(calls[name])|{name},(name,'missing or unused API',set(specs),calls[name])
 api[name]=specs
 checks[name]={'source_token_equivalent':True,'direct_calls':calls[name],'api_complete':True,'unique_active_body':True}
for name,decls in api.items():
 for callee in calls[name]:
  assert callee in canonical or callee in trusted,(name,callee,'outside approved scope')
  if callee in canonical:assert decls[callee]==canonical[callee],(name,callee,'nonidentical canonical contract')
for sym in trusted:
 copies=[decls[sym] for decls in api.values() if sym in decls]
 assert copies and len(set(copies))==1,(sym,'trusted copies inconsistent')
# The two IRQ declarations only thread the newly explicit caller stack.
# This is a textual guard, not a proof of predicate semantic equivalence.
trusted_delta={}
for sym in trusted:
 old=[]
 for p in (E/'spec-r1-snapshot/annotated_C/src').glob('*.c'):
  pattern=r'^(?:void\s*\*|void|int32|int|x_base)\s*'+re.escape(sym)+r'\([^\n]*\)\s*(/\*@.*?\*/)\s*;'
  old.extend(m.group(1) for m in re.finditer(pattern,p.read_text(),re.M|re.S))
 new=next(decls[sym] for decls in api.values() if sym in decls)
 erased=new.replace('(hs : list Z) ', '').replace('SemaphoreOutsideCritical(sg, hs, ', 'SemaphoreOutsideCritical(sg, ').replace('SemaphoreInsideCritical(sg, hs, ', 'SemaphoreInsideCritical(sg, ').replace('SemaphoreRely(hs, ', 'SemaphoreRely(')
 assert old and all(erased==c for c in old),(sym,'extra trusted contract change')
 trusted_delta[sym]='caller-stack parameter only; semantics accepted in bound predicate revision' if sym in {'DisableLocalInterrupt','EnableLocalInterrupt'} else 'byte-identical contract'
seen=set();todo=['KSemaphoreCreate']
while todo:
 n=todo.pop()
 if n in seen:continue
 seen.add(n)
 if n in calls:todo.extend(calls[n])
assert seen==expected|trusted,('closure mismatch',seen)
arm=Path(os.environ.get('SPEC_ARM_CC','/tmp/crtos-arm-toolchain/root/usr/bin/arm-none-eabi-gcc'))
current_arm_compile=arm.is_file()
if current_arm_compile:
 compiler_args=[str(arm),'-mcpu=cortex-m3','-mthumb']
else:
 compiler_args=['gcc','-m32']
 # Only the two reviewed fixed-size call arguments are normalized. The physical
 # slice layout remains byte-identical; authoritative C hashes matched above.
 basis=json.loads((E/'spec-arm32le-r4/accepted-r3-annotated-manifest.json').read_text())
 layout='annotated_C/include/crtos_semaphore_layout.h'
 assert hashlib.sha256((A/'include/crtos_semaphore_layout.h').read_bytes()).hexdigest()==basis[layout]
command=[*compiler_args,'-std=gnu11','-ffreestanding','-fno-builtin','-Wall','-Wextra','-fsyntax-only',*[str(p) for p in files],str(O/'spec-layout-check.c')]
subprocess.run(command,check=True,capture_output=True,text=True)
manifest={str(Path('annotated_C')/p.relative_to(A)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(A.rglob('*')) if p.is_file()}
manifest_sha=hashlib.sha256(json.dumps(manifest,sort_keys=True,separators=(',',':')).encode()).hexdigest()
(O/'spec-annotated-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
result={'status':'checks-passed-awaiting-independent-spec-delta-review','predicate_revision':accepted['predicate_revision'],'predicate_manifest_sha256':accepted['predicate_manifest'],'source_revision':source_result['source_revision'],'current_authoritative_source_hashes_checked':len(source_manifest),'spec_revision':'spec-r'+str(SPEC_REVISION_NUMBER)+'-'+manifest_sha[:12], 'annotated_manifest_sha256':manifest_sha,'source_check_result_sha256':hashlib.sha256((E/'source-check-result.json').read_bytes()).hexdigest(),'source_equivalence':'token equality after documented normalizations against current-source preprocessing','checks':checks,'nontrusted':sorted(expected),'trusted':sorted(trusted),'all_caller_contracts_identical':True,'trusted_declaration_delta':trusted_delta,'current_c_syntax_and_slice_layout':'passed','current_c_compiler_target':'Cortex-M3' if current_arm_compile else 'native ILP32 gcc -m32','current_arm_compile':current_arm_compile,'cortex_m3_abi_evidence':'new target compilation' if current_arm_compile else 'reused unchanged current-source ARM evidence; temporary ARM compiler no longer installed','source_abi_assembly_sha256':hashlib.sha256((E/'source-abi.s').read_bytes()).hexdigest(),'command':command,'qcp_started':False,'elapsed_seconds':time.monotonic()-start}
(O/'spec-check-result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k not in ['checks','command']},indent=2))
