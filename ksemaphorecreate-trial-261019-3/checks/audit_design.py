"""Read-only structural/source audit; no QCP parser, symbolic execution or VC.

The authoritative body evidence was freshly extracted in this trial. This audit
does not replace semantic review of predicates and contracts.
"""
from pathlib import Path
import hashlib
import json
import re

TRIAL = Path(__file__).resolve().parents[1]
SOURCE = Path('/home/xinra/crtos/Ubiquitous/XiZi_IIoT_Macro').resolve()
TRUSTED = {'x_malloc', 'x_free', 'memset', 'CriticalAreaLock',
           'CriticalAreaUnLock', 'KPrintf'}
LEX = re.compile(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'|'
                 r'/\*.*?\*/|//[^\n]*|[A-Za-z_]\w*|\d+|\S', re.S)


def tokens(text):
    return [s for s in LEX.findall(text)
            if not s.startswith(('/*', '//'))]


def fingerprint(text):
    return hashlib.sha256(text.encode()).hexdigest()


def declaration_view(text):
    # Preserve offsets while hiding prose and non-contract annotations. Their
    # parentheses must not be mistaken for the next C function declarator.
    chars = list(text)
    for match in LEX.finditer(text):
        token = match.group()
        if token.startswith(('/*', '//')) and not re.match(
                r'/\*@\s*(?:With|Require)\b', token):
            chars[match.start():match.end()] = [
                '\n' if char == '\n' else ' ' for char in token]
    return ''.join(chars)


def run():
    evidence = json.loads((TRIAL/'checks/source-bodies.json').read_text())
    files = sorted((TRIAL/'annotated_C/src').glob('*.c'))
    expected_canonical = set(evidence) - TRUSTED
    assert {p.stem for p in files} == expected_canonical, 'Canonical file set mismatch'
    specs, declarations, observed_calls, hashes = {}, {}, {}, {}
    for p in files:
        name = p.stem
        src = Path(evidence[name]['source']).resolve()
        assert src.is_relative_to(SOURCE), 'Source outside authority'
        assert fingerprint(src.read_text()) == evidence[name]['source_sha256']
        text = p.read_text()
        hashes[str(p.relative_to(TRIAL))] = fingerprint(text)
        # Every function contract is placed between signature and ; or {.
        pattern = re.compile(
            r'(?P<name>[A-Za-z_]\w*)\s*\([^;{}]*?\)\s*'
            r'(?P<spec>/\*@\s*(?:With|Require).*?\*/)\s*(?P<kind>[;{])',
            re.S)
        entries = list(pattern.finditer(declaration_view(text)))
        active = [m for m in entries if m['kind'] == '{']
        assert len(active) == 1 and active[0]['name'] == name, p
        assert all('Require' in m['spec'] and 'Ensure' in m['spec'] for m in entries)
        specs[name] = tokens(active[0]['spec'][3:-2])
        declarations[name] = {m['name']: tokens(m['spec'][3:-2])
                              for m in entries if m['kind'] == ';'}
        assert len(declarations[name]) == len(entries)-1, 'Duplicate declaration'
        # Compare the entire active body, including macro branches and strings.
        body = text[active[0].end()-1:]
        expected = evidence[name]['normalized'].split('{', 1)[1]
        if name == '_SemaphoreCreate':
            # TrustBase.md explicitly permits removal of KPrintf debug output.
            # This exact source statement is disabled by the actual if (0).
            debug = ('do { if (0) { KPrintf("[%s:%d] ", __func__, 59); '
                     'KPrintf ("created semaphore: id %d, value %d\\n", id, '
                     '(int)val); } } while (0);')
            assert expected.count(debug) == 1, 'Debug normalization source changed'
            expected = expected.replace(debug, '')
            # Both real and slice headers pass the ILP32 static ABI assertions.
            # Keep this frontend constant fold limited to these two arguments.
            sizeof_evidence = json.loads(
                (TRIAL/'checks/sizeof-constant-fold-evidence.json').read_text())
            assert sizeof_evidence['status'] == 'passed'
            assert expected.count('sizeof(struct Semaphore)') == 2
            expected = expected.replace('sizeof(struct Semaphore)', '32')
        assert tokens(body) == tokens('{'+expected), f'Body mismatch: {name}'
        bt = tokens(body)
        calls = {bt[i] for i in range(len(bt)-1)
                 if re.fullmatch(r'[A-Za-z_]\w*', bt[i]) and bt[i+1] == '('
                 and bt[i] not in {'if', 'while', 'for', 'sizeof', 'switch'}}
        observed_calls[name] = calls
        assert calls == set(declarations[name]), f'Call/API mismatch: {name}'
    seen_trusted, trusted_specs = set(), {}
    for caller, entries in declarations.items():
        for callee, spec in entries.items():
            if callee in TRUSTED:
                seen_trusted.add(callee)
                assert trusted_specs.setdefault(callee, spec) == spec
            else:
                assert callee in specs, f'Unresolved {caller} -> {callee}'
                assert spec == specs[callee], f'Contract drift: {caller} -> {callee}'
    assert seen_trusted == TRUSTED, 'Trusted contract coverage mismatch'
    reachable, pending = set(), ['KSemaphoreCreate']
    while pending:
        name = pending.pop()
        if name in reachable or name in TRUSTED:
            continue
        reachable.add(name)
        pending.extend(observed_calls[name])
    assert reachable == expected_canonical, 'Unreachable or absent canonical function'
    result = {'status': 'passed', 'non_trusted': sorted(reachable),
              'trusted': sorted(seen_trusted),
              'calls': {k: sorted(v) for k, v in observed_calls.items()},
              'canonical_sha256': hashes,
              'checks': ['authoritative source hashes unchanged',
                         'seven unique active canonical bodies',
                         'normalized source tokens equal active C bodies, with TrustBase-authorized dead KPrintf removal and two checked sizeof constant folds in _SemaphoreCreate',
                         'complete declaration-only caller contracts',
                         'caller copies exactly match canonical contracts',
                         'six and only six trusted symbols',
                         'full source call reachability'],
              'limitations': 'Structural audit only; semantic review is separate.'}
    (TRIAL/'checks/design-audit.json').write_text(json.dumps(result, indent=2)+'\n')
    print('PASS: source/body/API/closure structural checks (no QCP invoked).')


if __name__ == '__main__':
    run()
