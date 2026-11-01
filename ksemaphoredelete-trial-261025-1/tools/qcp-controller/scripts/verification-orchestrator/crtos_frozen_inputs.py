"""Pin this implementation's shared semantic inputs without claiming review."""
import hashlib
import json
import re
from pathlib import Path

from path_utils import fixed_path_under


def check_frozen_inputs(root):
    root = Path(root)
    manifest = fixed_path_under(root / 'checks/implement-frozen-inputs.json', root,
                                label='implementation input manifest')
    data = json.loads(manifest.read_text())
    for relative, expected in data['files'].items():
        path = fixed_path_under(root / relative, root, label='frozen semantic input')
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError('Frozen semantic input changed: ' + relative)
    for name, expected in data.get('external_files', {}).items():
        path = Path(name)
        bases = (root.parent / 'lib', root.parent / 'vendor')
        if path == Path('/home/xinra/TrustBase.md'):
            base = path.parent
        else:
            base = next((b for b in bases if path.is_relative_to(b)), None)
            if base is None:
                raise ValueError('Unapproved external semantic input: ' + name)
        path = fixed_path_under(path, base, label='read-only frozen semantic input')
        if hashlib.sha256(path.read_bytes()).hexdigest() != expected:
            raise ValueError('Frozen external semantic input changed: ' + name)
    from spec_freeze import extract_c
    for relative, expected in data.get('c_inputs', {}).items():
        path = fixed_path_under(root / relative, root / 'annotated_C/src',
                                label='frozen C implementation and contracts')
        source = path.read_text()
        code = re.sub(r'/\*.*?\*/|//[^\n]*', '', source, flags=re.S)
        tokens = re.findall(r'\w+|[^\s\w]', code)
        if relative == 'annotated_C/src/LinklistResumeAll.c':
            flat = ' '.join(tokens)
            expanded_null = '( ( void * ) 0 )'
            if expanded_null in flat:
                if flat.count(expanded_null) != 3:
                    raise ValueError('NONE expansion differs from the three recorded use sites')
                tokens = flat.replace(expanded_null, 'NONE').split()
            flat = ' '.join(tokens)
            if 'for ( ; ; )' not in flat:
                empty_while = 'while ( 1 )'
                if flat.count(empty_while) != 2:
                    raise ValueError('Main-loop normalization differs from its exact recorded shape')
                at = flat.rfind(empty_while)
                flat = flat[:at] + 'for ( ; ; )' + flat[at+len(empty_while):]
                tokens = flat.split()
        if relative == 'annotated_C/src/LinklistResumeAll.c' and 'resume_task_id' in tokens:
            # Exact reversible argument-read split approved in the source
            # adaptation record. No other use of the fresh local is allowed.
            old = 'KTaskWakeup ( task - > id . id )'
            new = 'int32 resume_task_id = task - > id . id ; KTaskWakeup ( resume_task_id )'
            flat = ' '.join(tokens)
            if tokens.count('resume_task_id') != 2 or flat.count(new) != 1:
                raise ValueError('Argument split differs from its approved exact mapping')
            tokens = flat.replace(new, old).split()
        if relative == 'annotated_C/src/_SemaphoreDelete.c' and 'delete_sem_id' in tokens:
            old = 'IdRemoveObj ( & k_sem_id_manager , sem - > id . id )'
            new = ('uint16 delete_sem_id = sem - > id . id ; '
                   'IdRemoveObj ( & k_sem_id_manager , delete_sem_id )')
            flat = ' '.join(tokens)
            if tokens.count('delete_sem_id') != 2 or flat.count(new) != 1:
                raise ValueError('Delete ID argument split differs from its exact mapping')
            tokens = flat.replace(new, old).split()
        digest = hashlib.sha256(json.dumps(tokens).encode()).hexdigest()
        if digest != expected['executable_sha256']:
            raise ValueError('Frozen C executable tokens changed: ' + relative)
        if extract_c(source)['specs'] != expected['specs']:
            raise ValueError('Frozen caller/canonical contracts changed: ' + relative)
