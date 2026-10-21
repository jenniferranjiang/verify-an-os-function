"""Confined include traversal for canonical CRTOS slices."""
from collections import deque
from pathlib import Path
from path_utils import fixed_path_under


def search_paths(root, target):
    from symexec_tooling import _source_includes, _input_path
    croot = fixed_path_under(root / 'annotated_C', root, label='canonical C tree')
    pending = deque([_input_path(root / target, croot, label='canonical C')])
    seen = set()
    directories = [root/'annotated_C/src', root/'annotated_C/include']
    strategies = []
    while pending:
        source = pending.popleft()
        if source in seen:
            continue
        seen.add(source)
        headers, strategy_names = _source_includes(source)
        for name in headers + strategy_names:
            relative = Path(name)
            if relative.is_absolute():
                raise ValueError(f'absolute include forbidden: {name}')
            candidate = _input_path(source.parent / relative, croot, label='local CRTOS include')
            if not candidate.is_file():
                matches = [_input_path(directory/relative, croot, label='CRTOS include') for directory in directories]
                matches = list(dict.fromkeys(path for path in matches if path.is_file()))
                if len(matches) != 1:
                    raise ValueError(f'missing/ambiguous CRTOS include: {source}: {name}')
                candidate = matches[0]
            if candidate.parent not in directories:
                directories.append(candidate.parent)
            if name in strategy_names:
                # Strategy outputs remain in the current logical VC directory.
                pair = (str(candidate.parent)+'/', 'CRTOS_Verify.VC')
                if pair not in strategies:
                    strategies.append(pair)
            pending.append(candidate)
    return [str(path)+'/' for path in directories], strategies
