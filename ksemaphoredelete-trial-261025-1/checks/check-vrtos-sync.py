"""Check imported contracts and source integrity; does not run QCP proofs."""
from pathlib import Path
import argparse
import hashlib
import json
import re

TRIAL = Path(__file__).resolve().parents[1]
ROOT = TRIAL.parent
RECORD = TRIAL / 'checks/vrtos-sync-261029'


def contracts(text, name):
    found = []
    pattern = r'\b' + re.escape(name) + r'\s*\([^;{}]*?\)\s*((?:/\*.*?\*/\s*)+)(?=[;{])'
    for match in re.finditer(pattern, text, re.S):
        for item in re.findall(r'/\*@.*?\*/', match[1], re.S):
            if 'Require' in item:
                item = re.sub(r'\s+', '', item.replace('KNONE', '0'))
                if item not in found:
                    found.append(item)
    return found


def executable_hash(text):
    text = re.sub(r'/\*.*?\*/|//[^\n]*', '', text, flags=re.S)
    tokens = re.findall(r'\w+|[^\s\w]', text)
    return hashlib.sha256(json.dumps(tokens).encode()).hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--upstream', type=Path, default=Path('/home/xinra/vrtos'))
    parser.add_argument('--record', type=Path, default=RECORD)
    args = parser.parse_args()
    manifest = json.loads((args.record / 'source-manifest.json').read_text())
    errors = []
    copies = 0
    for name, source in manifest['contract_sources'].items():
        expected = contracts((args.upstream / source).read_text(), name)
        if name == 'GetTaskWithIdnodeInfo':
            expected = [s for s in expected if s.startswith('/*@inside_')]
        for folder in (TRIAL / 'annotated_C/src', ROOT / 'annotated_C/src'):
            for path in folder.glob('*.c'):
                actual = contracts(path.read_text(), name)
                if not actual:
                    continue
                wanted = expected
                if (path.name == 'KTaskWakeup.c' and name == 'KTaskWakeup'
                        and manifest.get('legacy_wakeup_canonical', len(expected) == 2)):
                    wanted = [s for s in expected if not s.startswith('/*@detached_sched_null_delay')]
                if actual != wanted:
                    errors.append(f'contract mismatch: {path.relative_to(ROOT)} / {name}')
                copies += 1
    for relative, original_hash in manifest['trial_executable_hashes'].items():
        if executable_hash((ROOT / relative).read_text()) != original_hash:
            errors.append(f'executable tokens changed: {relative}')
    resume = []
    for base in (TRIAL, ROOT):
        for name in ('LinklistResumeAll.c', '_SemaphoreDelete.c'):
            path = base / 'annotated_C/src' / name
            actual = contracts(path.read_text(), 'LinklistResumeAll')
            resume.append(actual)
            if 'wakeup_unified' in path.read_text():
                errors.append(f'old wakeup interface: {path.relative_to(ROOT)}')
    if any(x != resume[0] for x in resume):
        errors.append('LinklistResumeAll caller/canonical mismatch')
    for path in (TRIAL / 'lib').glob('*.v'):
        shared = ROOT / 'lib' / path.name
        if shared.exists() and path.read_bytes() != shared.read_bytes():
            errors.append(f'trial library copy differs: {path.name}')
    result = {'contract_copies': copies, 'imported_functions': len(manifest['contract_sources']),
              'trial_bodies': len(manifest['trial_executable_hashes']),
              'resume_contract_copies': len(resume), 'errors': errors}
    (args.record / 'interface-checks.json').write_text(json.dumps(result, indent=2) + '\n')
    print(json.dumps(result, ensure_ascii=False))
    return bool(errors)


if __name__ == '__main__':
    raise SystemExit(main())
