"""Read an annotated-C trial's explicit project mappings without copying libraries."""
from pathlib import Path
import json
import os
import shlex

PROJECT_ROOT = None
PROJECT_MAPPINGS = ()

def is_trial(root):
    root = Path(root)
    return (root / "annotated_C").is_dir() and (root / "_CoqProject").is_file()

def mappings(root):
    from path_utils import fixed_path_under
    root = Path(root).absolute()
    project = fixed_path_under(root / "_CoqProject", root, label="trial project")
    tokens = shlex.split(project.read_text(), comments=True)
    result = []
    i = 0
    while i < len(tokens):
        if tokens[i] in ("-R", "-Q"):
            if i + 2 >= len(tokens):
                raise ValueError("Incomplete trial library mapping")
            physical = Path(os.path.abspath(root / tokens[i+1]))
            physical = fixed_path_under(physical, physical, label="declared library root")
            result.append((tokens[i], physical, tokens[i+2]))
            i += 3
        elif tokens[i].endswith(".v"):
            i += 1
        else:
            raise ValueError("Unsupported trial project option: " + tokens[i])
    return result

def formal_output(root):
    root = Path(root).absolute()
    entries = [(path, logical) for _, path, logical in mappings(root)
               if path == root / "VC"]
    if len(entries) != 1:
        raise ValueError("Trial project must explicitly map its VC output directory once")
    return Path("VC"), entries[0][1]

def configure(root):
    global PROJECT_ROOT, PROJECT_MAPPINGS
    if not is_trial(root):
        return
    import coq_tooling_common as common
    PROJECT_ROOT = Path(root).absolute()
    PROJECT_MAPPINGS = tuple(mappings(PROJECT_ROOT))
    common.FIXED_LOAD_PATH_MAPPINGS = tuple(
        (flag, path.relative_to(PROJECT_ROOT).as_posix() if path.is_relative_to(PROJECT_ROOT)
         else path.as_posix(), logical) for flag, path, logical in PROJECT_MAPPINGS)
    # Reuse the verified project toolchain; do not select an unrelated PATH coqc.
    profile = next((p / "tools/rocq/toolchain.json" for p in (PROJECT_ROOT, *PROJECT_ROOT.parents)
                    if (p / "tools/rocq/toolchain.json").is_file()), None)
    if profile is None:
        raise ValueError("Trial has no explicit tools/rocq/toolchain.json")
    data = json.loads(profile.read_text())
    bindir = Path(data["opam_root"]) / data["opam_switch"] / "bin"
    for name in ("coqc", "coqtop", "coqdep", "coqchk"):
        executable = bindir / name
        if not os.access(executable, os.X_OK):
            raise ValueError("Missing project executable: " + str(executable))
        os.environ[name.upper()+"_EXE"] = str(executable)
    for name in ("COQLIB", "ROCQLIB", "COQCORELIB", "OCAMLPATH", "CAML_LD_LIBRARY_PATH", "COQPATH"):
        os.environ.pop(name, None)

def external_path_allowed(path):
    path = Path(path)
    return PROJECT_ROOT is not None and path.is_absolute() and any(
        not directory.is_relative_to(PROJECT_ROOT) and path.is_relative_to(directory)
        for _, directory, _ in PROJECT_MAPPINGS)

def checked_external(path):
    from path_utils import fixed_path_under
    path = Path(path)
    for _, directory, _ in PROJECT_MAPPINGS:
        if directory.is_absolute() and path.is_relative_to(directory) and external_path_allowed(path):
            return fixed_path_under(path, directory, label="configured external library")
    raise ValueError("Dependency is outside declared external mappings: " + str(path))
