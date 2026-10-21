"""Trial-local paths. External formal inputs are read-only, never build outputs.

Dependency plans use virtual ``external/<n>`` nodes, resolved only by this
allowlisted reader. Current/overlay/publication destinations retain the upstream
fixed_path_under boundary; no symbolic links or duplicated canonical C bodies.
"""
from pathlib import Path
import hashlib
import json
import shlex

TRIAL_ROOT = Path(__file__).absolute().parents[4]
QCP_ROOT = Path('/home/xinra/qcp-binary-democases')
# This trial now targets the installed parameterized ARM32/little-endian framework.
COQ_BIN = Path('/home/xinra/.opam/pv-bench-8.20.1/bin')
SKILLS = QCP_ROOT / '.agents/skills'


def load_paths():
    entries = []
    for line in (TRIAL_ROOT / '_CoqProject').read_text().splitlines():
        tokens = shlex.split(line, comments=True)
        if not tokens:
            continue
        if len(tokens) != 3 or tokens[0] not in {'-R', '-Q'}:
            raise ValueError('adapter requires explicit three-token _CoqProject load paths')
        flag, physical, logical = tokens
        path = Path(physical)
        if not path.is_absolute():
            path = TRIAL_ROOT / path
        allowed = (TRIAL_ROOT/'lib', TRIAL_ROOT/'VC', TRIAL_ROOT/'shared-candidate/arm32le', TRIAL_ROOT/'framework-candidate', Path('/home/xinra/crtos/lib'), QCP_ROOT/'SeparationLogic', QCP_ROOT/'Rocq')
        if not any(path == base or path.is_relative_to(base) for base in allowed):
            raise ValueError(f'load path outside approved inputs: {path}')
        # Check every component before any reading or resolving.
        from path_utils import fixed_path_under
        fixed_path_under(path, next(base for base in allowed if path == base or path.is_relative_to(base)), label='approved Rocq load path')
        if not path.is_dir():
            raise ValueError(f'missing approved load path: {path}')
        key = path.relative_to(TRIAL_ROOT) if path.is_relative_to(TRIAL_ROOT) else Path('external') / str(len(entries))
        entries.append((flag, key, path, logical))
    return entries


def external_source(relative):
    relative = Path(relative)
    if relative.is_absolute() or '..' in relative.parts:
        raise ValueError(f'invalid external dependency node: {relative}')
    if relative.parts[:1] != ('external',):
        return None
    from path_utils import fixed_path_under
    for _, key, physical, _ in load_paths():
        if key.parts[:1] == ('external',) and relative.is_relative_to(key):
            return fixed_path_under(physical / relative.relative_to(key), physical, label='read-only external dependency')
    raise ValueError(f'unknown external dependency node: {relative}')


def dependency_node(path, root):
    path = Path(path)
    if not path.is_absolute():
        path = root / path
    # Lexical normalization needed for coqdep's ../ paths, confinement is then
    # checked against the exact allowlist before any file is read.
    import os
    path = Path(os.path.abspath(path))
    from path_utils import fixed_path_under
    for _, key, physical, _ in load_paths():
        if path.is_relative_to(physical):
            fixed_path_under(path, physical, label='coqdep dependency')
            return key / path.relative_to(physical)
    raise ValueError(f'coqdep dependency outside approved load paths: {path}')


def external_fingerprint(graph):
    records = {}
    for node in sorted(graph):
        source = external_source(node)
        if source is None:
            continue
        item = {}
        if not source.exists():
            item[str(source)] = None  # Installed object-only QCP module; no fabricated source.
        for path in ((source,) if source.exists() else ()) + (external_source(node.with_suffix('.vo')),):
            if not path.is_file():
                raise ValueError(f'missing precompiled read-only dependency: {path}')
            item[str(path)] = hashlib.sha256(path.read_bytes()).hexdigest()
        records[str(node)] = item
    return records


def check_external_pin(root, graph):
    """Pin source/object pairs on first encounter; reject later mutation."""
    from path_utils import fixed_path_under, write_json
    path = fixed_path_under(root/'evidence/controller-external-inputs.json', root, label='dependency pin')
    current = external_fingerprint(graph)
    old = json.loads(path.read_text()) if path.exists() else {}
    for node, values in current.items():
        if node in old and old[node] != values:
            raise ValueError(f'read-only dependency changed: {node}')
    merged = old | current
    if merged != old:
        write_json(path, merged)
