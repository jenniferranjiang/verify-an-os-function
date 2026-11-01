"""Prepare recorded CRTOS inputs for the installed QCP frontend.

Adaptations are explicit IdNode field notation, one bound-type alpha rename,
exact NONE macro expansion and the sanctioned NULL_PARAM_CHECK_1 API boundary.
Canonical specs are not rewritten. Each change and its source basis is recorded;
line counts are preserved. The NULL API substitution is a documented model
boundary, not a claim that executable tokens or termination behavior are identical.
"""
import hashlib
import json
import re
from pathlib import Path

from path_utils import fixed_path_under, write_text, write_json
from spec_freeze import ANNOTATION_RE, _enclosing_function, _strip_comments


def normalize_idnode_contracts(source):
    changes = []
    link = 'field_addr(idnode, struct IdNode, link)'
    replacements = [
        ('(idnode->id == 65535)',
         'store(field_addr(idnode, struct IdNode, id), unsigned short, 65535)'),
        *[(f'(idnode->link.{field} == &(idnode->link))',
           f'store(field_addr({link}, struct SysDoubleLinklistNode, {field}), '
           f'struct SysDoubleLinklistNode *, {link})')
          for field in ('node_prev', 'node_next')],
        ('&(idnode->link)', link),
    ]

    def replace(match):
        block = match.group(0)
        function = _enclosing_function(source, match.start())
        if (function == 'DoubleLinkListRmNode'
                and re.match(r'/\*@\s*remove_from_head\b', block)
                and re.search(r'\bWith\s+\{A\}', block)):
            # QCP currently leaks a polymorphic binder across named specs of
            # one function. Alpha-rename this unused sibling contract's bound
            # type consistently, retaining its API name and logical meaning.
            if 'A_from_head' in block:
                raise ValueError('Parser alpha-renaming would capture a name')
            count = len(re.findall(r'\bA\b', block))
            changes.append({'kind': 'bound-type-alpha-rename',
                            'function': function, 'spec': 'remove_from_head',
                            'old': 'A', 'new': 'A_from_head', 'count': count})
            return re.sub(r'\bA\b', 'A_from_head', block)
        if function != 'IdRemoveObj':
            return block
        if not any(name in block for name in ('high_level_spec', 'low_level_spec')):
            return block
        for old, new in replacements:
            count = block.count(old)
            if count:
                block = block.replace(old, new)
                changes.append({'old': old, 'new': new, 'count': count})
        return block

    result = ANNOTATION_RE.sub(replace, source)
    if _strip_comments(source) != _strip_comments(result):
        raise ValueError('Parser normalization changed C code')
    if source.count('\n') != result.count('\n'):
        raise ValueError('Parser normalization changed source line mapping')
    return result, changes


def parser_argv(root, plan):
    original = fixed_path_under(root / plan['target_c_file'], root,
                                label='canonical parser input')
    source = original.read_text()
    normalized, changes = normalize_idnode_contracts(source)
    if original.name == 'LinklistResumeAll.c':
        scope_path = fixed_path_under(root / 'checks/verification-scope.json', root,
                                     label='approved external contract scope')
        scope = json.loads(scope_path.read_text())
        wakeup = [item for item in scope['external_contracts']
                  if item['function'] == 'KTaskWakeup' and item['prove_body_in_this_trial'] is False]
        if len(wakeup) != 1 or wakeup[0].get('selected_contract_for_LinklistResumeAll') != 'semaphore_pending_head_ic':
            raise ValueError('Wakeup imported-contract scope is not the reviewed scope')
        allowed = ('detached_sched_null_delay', 'semaphore_pending_head_ic',
                   'msgqueue_send_pending_head_ic', 'msgqueue_recv_pending_head_ic')
        def import_contract(match):
            block = match.group(0)
            if _enclosing_function(normalized, match.start()) != 'KTaskWakeup':
                return block
            pattern = r'(/\*@\s*)(' + '|'.join(allowed) + r')\s*<=\s*wakeup_by_id_ic\b'
            head = re.match(pattern, block)
            if head is None:
                return block
            changes.append({'kind': 'imported-contract-proof-boundary',
                            'function': 'KTaskWakeup', 'spec': head.group(2),
                            'upstream_refinement_source': 'wakeup_by_id_ic',
                            'source_commit': wakeup[0]['source_commit'],
                            'contract_body_unchanged': True,
                            'local_derivation_proved': False,
                            'basis': 'Approved complete named external contracts; no local derivation proof claim.'})
            old_head = head.group(0)
            return head.group(1) + head.group(2) + '\n' * old_head.count('\n') + block[head.end():]
        normalized = ANNOTATION_RE.sub(import_contract, normalized)
    if original.name == 'LinklistResumeAll.c':
        # This exact NULL_PARAM_CHECK expansion may be modeled by the API
        # explicitly permitted in the project's source-processing guide.
        # Its normal-return contract does NOT assert termination for NULL.
        lex = re.compile(r'/\*.*?\*/|//[^\n]*|"(?:\\.|[^"\\])*"|\w+|[^\s\w]', re.S)
        code_tokens = [m for m in lex.finditer(normalized)
                       if not m.group().startswith(('/*', '//'))]
        patterns = [
            'if ( list = = NONE ) { while ( 1 ) { } }'.split(),
            'if ( list = = ( ( void * ) 0 ) ) { while ( 1 ) { } }'.split(),
        ]
        positions = [(i, len(pattern)) for pattern in patterns
                     for i in range(len(code_tokens) - len(pattern) + 1)
                     if [m.group() for m in code_tokens[i:i+len(pattern)]] == pattern]
        if len(positions) != 1 or 'NULL_PARAM_CHECK_1' in normalized:
            raise ValueError('NULL-check model requires the exact reviewed macro expansion')
        i, length = positions[0]
        start, end = code_tokens[i].start(), code_tokens[i+length-1].end()
        old = normalized[start:end]
        normalized = (normalized[:start] + 'NULL_PARAM_CHECK_1(list);'
                      + '\n' * old.count('\n') + normalized[end:])
        declaration = 'void NULL_PARAM_CHECK_1(void *p) /*@ Require emp Ensure p != 0 */;'
        if '\n\n' not in normalized:
            raise ValueError('No blank line available for model declaration')
        normalized = normalized.replace('\n\n', '\n' + declaration + '\n', 1)
        changes.append({'kind': 'sanctioned-macro-API-boundary',
                        'macro': 'NULL_PARAM_CHECK', 'function': 'NULL_PARAM_CHECK_1',
                        'old': old, 'new': 'NULL_PARAM_CHECK_1(list);',
                        'declaration': declaration,
                        'contract': 'Require emp; Ensure p != 0 (normal returns only)',
                        'rule': '.agents/skills/verify-an-os-function/references/源代码处理.md',
                        'review': '.docs/Report/implementation-adaptations-review.md',
                        'local_helper_body_proved': False})
    # The bundled preprocessor attempts integer evaluation of the cast-valued
    # NONE macro. Expand this exact frozen macro at C token use sites instead.
    # Comments and strings stay untouched; no macro value is guessed.
    header = fixed_path_under(root / 'annotated_C/include/slice_types.h', root,
                              label='frozen macro definition').read_text()
    definition = re.search(r'^#define\s+NONE\s+([^\n]+)$', header, re.M)
    if definition is None or re.sub(r'\s+', '', definition.group(1)) != '((void*)0)':
        raise ValueError('NONE macro differs from the reviewed parser adaptation')
    if re.search(r'^\s*#\s*(?:define|undef)\s+NONE\b', source, re.M):
        raise ValueError('Source overrides the normalized NONE macro')
    token = re.compile(r'"(?:\\.|[^"\\])*"|/\*.*?\*/|//[^\n]*|\bNONE\b', re.S)
    expanded_count = 0
    def expand(match):
        nonlocal expanded_count
        if match.group(0) == 'NONE':
            expanded_count += 1
            return definition.group(1)
        return match.group(0)
    normalized = token.sub(expand, normalized)
    if expanded_count:
        changes.append({'kind': 'exact-C-macro-expansion', 'old': 'NONE',
                        'new': definition.group(1), 'count': expanded_count,
                        'definition': 'annotated_C/include/slice_types.h:16'})
    if original.name == 'LinklistResumeAll.c':
        protected = [(m.start(), m.end()) for m in re.finditer(
            r'"(?:\\.|[^"\\])*"|/\*.*?\*/|//[^\n]*', normalized, re.S)]
        def normalize_empty_for(match):
            if any(a <= match.start() < b for a, b in protected):
                return match.group(0)
            changes.append({'kind': 'equivalent-empty-for-header',
                            'old': match.group(0), 'new': 'while (1)',
                            'basis': 'Empty init/update do nothing; omitted condition is true; body and break/continue unchanged.'})
            return 'while (1)' + '\n' * match.group(0).count('\n')
        normalized = re.sub(r'\bfor\s*\(\s*;\s*;\s*\)', normalize_empty_for, normalized)
    if source.count('\n') != normalized.count('\n'):
        raise ValueError('Parser normalization changed source line count')
    if not changes:
        return plan['argv'], None
    digest = hashlib.sha256(normalized.encode()).hexdigest()
    directory = fixed_path_under(root / 'evidence/parser-normalization' / digest,
                                 root, label='recorded parser normalization')
    directory.mkdir(parents=True, exist_ok=True)
    staged = directory / original.name
    write_text(staged, normalized)
    receipt = {'canonical': plan['target_c_file'],
               'canonical_sha256': hashlib.sha256(source.encode()).hexdigest(),
               'parser_input': str(staged.relative_to(root)),
               'parser_sha256': digest, 'changes': changes,
               'canonical_code_unchanged': True,
               'preprocessed_executable_code_unchanged': not any(
                   c.get('kind') == 'sanctioned-macro-API-boundary' for c in changes),
               'line_count_unchanged': True,
               'basis': '/home/xinra/crtos/annotated_C/src/kernel/thread/ktask_id_delete.c:19-29'}
    write_json(directory / 'mapping.json', receipt)
    expected = '--input-file=' + plan['target_c_file']
    if plan['argv'].count(expected) != 1:
        raise ValueError('Unexpected parser input argument')
    return [('--input-file=' + str(staged)) if item == expected else item
            for item in plan['argv']], receipt
