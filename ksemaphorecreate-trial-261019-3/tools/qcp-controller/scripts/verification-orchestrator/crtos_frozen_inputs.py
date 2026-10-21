"""Pin this implementation's shared semantic inputs without claiming review."""
import hashlib
import json
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
