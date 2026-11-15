#!/usr/bin/env python3
"""Typecheck all trial header Extern declarations using the configured Rocq.

Run only after the complete current trial library has been freshly compiled.
This checks Rocq vocabulary, never invokes QCP or proves a C implementation.
"""
import hashlib
import json
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import tempfile

TRIAL = Path(__file__).resolve().parents[1]
PROJECT = TRIAL.parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    headers = sorted((TRIAL / "annotated_C/src").glob("*logic.h"))
    formal = sorted((TRIAL / "lib").glob("*.v"))
    frozen_headers = {str(p.relative_to(TRIAL)): sha(p) for p in headers}
    frozen_formal = {str(p.relative_to(TRIAL)): sha(p) for p in formal}
    # A source newer than its .vo would make the audit use stale definitions.
    for path in formal:
        vo = path.with_suffix(".vo")
        if not vo.exists() or vo.stat().st_mtime_ns < path.stat().st_mtime_ns:
            raise RuntimeError(f"Compile current formal input before audit: {path}")
    statements = ["Require Import Coq.ZArith.ZArith Coq.Lists.List."]
    imports = set()
    printing = {"program": "MonadErr.M", "return": "MonadErr.ret", "safeExec": "monadesafe_lib.safeExec"}
    for header in headers:
        for name, target in re.findall(r"/\*@ Printing Coq Name\s+([\w:]+)\s*:=\s*([\w.]+)\s*\*/", header.read_text()):
            printing[name] = target

    def translate_type(typ):
        typ = re.sub(r"\baddr\b", "Z", typ)
        for name, target in sorted(printing.items(), key=lambda item: len(item[0]), reverse=True):
            typ = re.sub(r"(?<![\w.])" + re.escape(name) + r"(?![\w.])", target, typ)
        return typ

    for header in headers:
        for command in re.findall(r"/\*@ Import Coq\s+(.*?)\*/", header.read_text(), re.S):
            command = command.strip().rstrip(".")
            # Import order is semantically relevant; keep first occurrence.
            if command not in imports:
                imports.add(command)
                statements.append(command + ".")
    entries = []
    for header in headers:
        for block in re.findall(r"/\*@ Extern Coq\s+(.*?)\*/", header.read_text(), re.S):
            if ":=" in block:
                if not re.fullmatch(r"addr\s*:=\s*Z\s*", block):
                    raise ValueError(f"Unsupported alias: {block}")
                entries.append({"header": header.name, "symbol": "addr", "kind": "QCP alias to Z"})
                statements.append(f"Definition header_audit_{len(entries)} : Type := Z.")
                continue
            offset = 0
            while offset < len(block):
                if block[offset] != "(":
                    offset += 1
                    continue
                end, depth = offset + 1, 1
                while depth:
                    depth += (block[end] == "(") - (block[end] == ")")
                    end += 1
                declaration = block[offset + 1:end - 1]
                offset = end
                if " :: " in declaration:
                    name, typ = declaration.split(" :: ", 1)
                    typ = typ.replace("*", "Type").replace("=>", "->")
                    symbol = printing.get(name, name)
                    kind = "type constructor"
                else:
                    name, typ = declaration.split(" : ", 1)
                    binders = re.match(r"((?:\{\w+\}\s*)+)\s*->\s*", typ)
                    if binders:
                        names = re.findall(r"\{(\w+)\}", binders[1])
                        typ = "forall " + " ".join("{" + x + " : Type}" for x in names) + ", " + typ[binders.end():]
                    typ = translate_type(typ)
                    symbol = printing.get(name, name.replace("::", "."))
                    kind = "term"
                entries.append({"header": header.name, "symbol": name, "kind": kind, "coq_type": typ, "coq_symbol": symbol})
                statements.append(f"Definition header_audit_{len(entries)} : {typ} := @{symbol}.")
    identities = {
        "CoreVarGlobalState": "CRTOS_Verify.lib.common.CrtosGlobState.VarGlobalState",
        "core_os_inv": "CRTOS_Verify.lib.common.CrtosInv.os_inv",
        "core_LastSeen": "CRTOS_Verify.lib.common.CrtosRules.LastSeen",
        "core_OutsideCritical": "CRTOS_Verify.lib.common.CrtosRules.OutsideCritical",
    }
    for index, (name, original) in enumerate(identities.items()):
        if name not in printing:
            raise RuntimeError(f"Explicit core alias mapping required: {name}")
        statements.append(f"Definition header_core_identity_{index} : {printing[name]} = {original} := eq_refl.")
    arguments = shlex.split((TRIAL / "_CoqProject").read_text())
    mappings, index = [], 0
    while index < len(arguments):
        if arguments[index] in ("-R", "-Q"):
            mappings.extend(arguments[index:index + 3])
            index += 3
        else:
            index += 1
    config = json.loads((PROJECT / ".agents/verify-os.config.json").read_text())
    compiler = str(Path(config["coq_bin"]) / "coqc")
    temporary = Path(tempfile.mkdtemp(prefix="crtos-verify-initdataqueue-final-header-types-"))
    source = temporary / "HeaderTypes.v"
    source.write_text("\n".join(statements) + "\n")
    result = subprocess.run([compiler, *mappings, str(source)], cwd=TRIAL, capture_output=True, text=True)
    unchanged = frozen_headers == {str(p.relative_to(TRIAL)): sha(p) for p in headers}
    unchanged &= frozen_formal == {str(p.relative_to(TRIAL)): sha(p) for p in formal}
    passed = result.returncode == 0 and unchanged
    audit = {
        "status": "passed" if passed else "failed",
        "scope": "All final logic-header Extern declarations; explicit Rocq types only, no QCP parser/symbolic/VC",
        "declaration_count": len(entries),
        "symbols": [entry["symbol"] for entry in entries],
        "entries": entries,
        "headers": frozen_headers,
        "printing_name_mapping": printing,
        "core_alias_definitional_identities": identities,
        "formal_dependencies": frozen_formal,
        "compiler": compiler,
        "load_path_source": "_CoqProject -R/-Q mappings",
        "project_sha256": sha(TRIAL / "_CoqProject"),
        "audit_script_sha256": sha(Path(__file__)),
        "audit_source_sha256": sha(source),
        "inputs_unchanged_during_compile": unchanged,
        "exit_code": result.returncode,
        "diagnostic": (result.stdout + result.stderr)[-3000:],
    }
    (TRIAL / "header-type-audit.json").write_text(json.dumps(audit, ensure_ascii=False, indent=2) + "\n")
    print(f"{audit['status']}: {len(entries)} declarations in {len(headers)} headers; {len(formal)} formal dependencies")
    if passed:
        sources_path = TRIAL / "spec-sources.json"
        sources = json.loads(sources_path.read_text())
        for entry in sources.get("new_headers", []):
            entry["sha256"] = sha(TRIAL / entry["path"])
        for entry in sources.get("canonical_targets", []):
            entry["sha256"] = sha(TRIAL / entry["path"])
        sources["integration_state"] = "shared-carrier inputs compiled; complete header vocabulary typechecked; independent review still required"
        sources["header_audit_binding"] = {
            "result_sha256": sha(TRIAL / "header-type-audit.json"),
            "headers": frozen_headers,
            "formal_dependencies": frozen_formal,
        }
        sources_path.write_text(json.dumps(sources, ensure_ascii=False, indent=2) + "\n")
        shutil.rmtree(temporary)
    else:
        print(audit["diagnostic"])
        print(f"Temporary audit input retained: {source}")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
