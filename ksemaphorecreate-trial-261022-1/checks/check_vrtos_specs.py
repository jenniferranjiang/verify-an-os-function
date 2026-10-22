"""Check selected VRTOS contract identity and isolation from the prior trial.

This is a source comparison, not QCP execution, a proof, or model equivalence.
"""
from pathlib import Path
import hashlib
import json
import re

TRIAL = Path(__file__).resolve().parents[1]


def pattern(name):
    return re.compile(
        r'^[ \t]*(?:void|int|int32|x_base)[ \t*]+\b' + re.escape(name)
        + r'\s*\([^;{}]*?\)\s*(?P<spec>/\*@.*?\*/)', re.M | re.S)


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def tokens(spec):
    return re.findall(r'[A-Za-z_]\w*|\d+|\S', spec)


def run():
    manifest = json.loads((TRIAL / 'checks/spec-alignment.json').read_text())
    results = {}
    for name, entry in manifest['functions'].items():
        source = Path(entry['reference'])
        assert digest(source) == entry['reference_header_sha256'], source
        candidates = list(pattern(name).finditer(source.read_text()))
        label = entry['selected_case']
        if label:
            candidates = [m for m in candidates
                          if re.match(r'/\*@\s*' + label + r'\b', m['spec'])]
        assert len(candidates) == 1, name
        expected = candidates[0].group()
        occurrences = 0
        for item in entry['occurrences']:
            matches = list(pattern(name).finditer((TRIAL / item['file']).read_text()))
            assert len(matches) == item['count'], (name, item['file'])
            for match in matches:
                assert tokens(match.group()) == tokens(expected), (name, item['file'])
                occurrences += 1
        results[name] = {'signature_and_spec_tokens_identical': True,
                         'case': label, 'occurrences': occurrences}
    origin = json.loads((TRIAL / 'checks/trial-origin.json').read_text())
    baseline = Path(origin['baseline'])
    for relative, expected in origin['baseline_source_sha256'].items():
        assert digest(baseline / relative) == expected, ('baseline changed', relative)
    # Public creation specs and the debug-only trusted interface are retained.
    for symbol, filename in [('_SemaphoreCreate', '_SemaphoreCreate.c'),
                             ('KSemaphoreCreate', 'KSemaphoreCreate.c'),
                             ('KPrintf', 'AllocId.c')]:
        old = pattern(symbol).search((baseline / 'annotated_C/src' / filename).read_text())
        new = pattern(symbol).search((TRIAL / 'annotated_C/src' / filename).read_text())
        assert old and new and tokens(old.group()) == tokens(new.group()), symbol
    assert str(baseline) not in (TRIAL / '_CoqProject').read_text()
    result = {'status': 'passed', 'functions': results,
              'baseline_sources_unchanged': True,
              'public_specs_and_debug_spec_unchanged': True,
              'x_free': 'Separate trusted KERNEL_FREE macro-target adaptation; not a VRTOS spec identity claim.',
              'old_trial_not_in_load_path': True,
              'generated_vc_validation': 'Outside this source comparison; use current controller runs.',
              'limitations': 'Token identity only. Models differ; no C proof or compatibility theorem checked.'}
    (TRIAL / 'checks/vrtos-spec-comparison.json').write_text(
        json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    count = sum(item['occurrences'] for item in results.values())
    print(f'PASS: {len(results)} selected VRTOS interfaces, {count} occurrences; baseline unchanged.')


if __name__ == '__main__':
    run()
