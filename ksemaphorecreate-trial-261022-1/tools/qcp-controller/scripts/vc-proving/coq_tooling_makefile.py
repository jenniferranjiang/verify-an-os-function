"""Discover the exact Rocq source closure and build its base with GNU Make."""

from __future__ import annotations

import json
import os
import re
import shlex
import shutil
import tempfile
from collections.abc import Sequence
from pathlib import Path

import coq_tooling_common as common
from path_utils import fixed_path_under

BUILD_MODE = "makefile"


def _fixed(root: Path, relative: Path, label: str) -> Path:
    try:
        return fixed_path_under(relative, root, label=label)
    except SystemExit as exc:
        raise common.CoqBuildPlanError(
            category="contract", kind="path-boundary", message=str(exc),
            repair="Restore a fixed non-link path inside the repository.",
        ) from exc


def configured_program(root: Path, tool: str) -> str:
    """Select an executable from explicit environment, CONFIGURE, then PATH."""
    overrides = {"coqc": "COQC_EXE", "coqtop": "COQTOP_EXE",
                 "coqdep": "COQDEP_EXE", "make": "MAKE_EXE"}
    if tool not in overrides:
        raise ValueError(f"unsupported Rocq build tool: {tool}")
    if tool != "make":
        from crtos_layout import COQ_BIN
        return str(COQ_BIN / tool)
    override = os.environ.get(overrides[tool], "").strip()
    if override:
        return override
    if tool == "make":
        return shutil.which("make") or (shutil.which("mingw32-make") if os.name == "nt" else None) or "make"
    values = {name: os.environ[name] for name in ("COQBIN", "SUF") if name in os.environ}
    configuration = _fixed(root, Path("Rocq/CONFIGURE"), "Rocq configuration")
    if configuration.exists():
        common.fixed_source(root, Path("Rocq/CONFIGURE"), label="Rocq configuration")
        for line in configuration.read_text(encoding="utf-8").splitlines():
            match = re.match(r"\s*([A-Za-z_][A-Za-z0-9_]*)\s*(\?=|:=|=)\s*(.*?)\s*$", line.split("#", 1)[0])
            if match:
                name, operator, value = match.groups()
                if operator != "?=" or name not in values:
                    values[name] = value
    value = values.get(tool.upper(), f"$(COQBIN){tool}$(SUF)")
    variable = re.compile(r"\$\(([^()]+)\)|\$\{([^{}]+)\}")
    for _ in range(len(values) + 2):
        if not variable.search(value):
            break
        value = variable.sub(lambda match: values.get(match[1] or match[2], ""), value)
    else:
        raise common.CoqBuildPlanError(
            category="tooling", kind="makefile-configuration-recursion",
            message="recursive executable configuration in Rocq/CONFIGURE",
            repair="Repair Rocq/CONFIGURE before preparing dependencies.",
        )
    value = value.strip() or tool
    return shutil.which(value) or value


def base_load_paths(root: Path) -> list[tuple[str, Path, str]]:
    """Return checked absolute roots; commands can make them cwd-relative."""
    from crtos_layout import load_paths
    return [(flag, physical, logical) for flag, _, physical, logical in load_paths()]


def _parse_dependencies(text: str, root: Path) -> dict[Path, tuple[Path, ...]]:
    """Read Make-escaped coqdep rules, retaining repository Rocq sources."""
    graph: dict[Path, set[Path]] = {}

    def sources(words: str) -> list[Path]:
        result = []
        for word in re.findall(r"(?:\\.|[^\s])+", words):
            # Make escapes whitespace and Windows drive colons; ordinary
            # Windows backslashes must remain directory separators.
            word = re.sub(r"\\([ \t:#])", r"\1", word).replace("$$", "$")
            candidate = Path(word)
            if candidate.suffix not in {".v", ".vo", ".vos", ".vok"}:
                continue
            candidate = candidate.with_suffix(".v")
            from crtos_layout import dependency_node
            result.append(dependency_node(candidate, root))
        return result

    for line in text.replace("\\\r\n", " ").replace("\\\n", " ").splitlines():
        delimiter = re.search(r":(?:\s|$)", line)
        if delimiter is None:
            continue
        targets = sources(line[:delimiter.start()])
        dependencies = sources(line[delimiter.end():])
        for source in targets:
            graph.setdefault(source, set()).update(item for item in dependencies if item != source)
    return {source: tuple(sorted(dependencies)) for source, dependencies in graph.items()}


def _make_token(path: Path) -> str:
    value = path.as_posix()
    if any(character in value for character in "\n\r\0\t#$%;|*?[]:\\"):
        raise common.CoqBuildPlanError(
            category="contract", kind="targeted-make-target-boundary",
            message=f"unsupported Makefile path syntax: {value!r}",
            repair="Use repository paths without Make metacharacters.",
        )
    return value.replace(" ", "\\ ")


def _recipe(argv: Sequence[str]) -> str:
    if os.name == "nt":
        if any(any(character in item for character in '\"\n\r') for item in argv):
            raise ValueError("invalid character in Windows Make recipe argument")
        # cmd.exe treats &, | and parentheses specially even without spaces.
        command = " ".join('"' + item + '"' for item in argv)
    else:
        command = shlex.join(argv)
    return command.replace("$", "$$")


def _makefile(root: Path, graph: dict[Path, tuple[Path, ...]], family: set[Path], flags: list[str]) -> str:
    from crtos_layout import external_source, check_external_pin
    check_external_pin(root, graph)
    external = {node for node in graph if external_source(node) is not None}
    base = set(graph) - family - external
    for source in base:
        outside = set(graph[source]) - base - external
        if outside:
            raise common.CoqBuildPlanError(
                category="contract", kind="trusted-base-depends-on-current-case",
                message=f"base source {source} depends on current source {min(outside)}",
                repair="Repair the dependency direction before preparing the base.",
            )
    configurations = []
    for relative in (Path("Rocq/Makefile"), Path("Rocq/CONFIGURE")):
        if _fixed(root, relative, "Rocq build configuration").exists():
            common.fixed_source(root, relative, label="Rocq build configuration")
            configurations.append(relative)
    lines = [".DEFAULT_GOAL := trusted-base", ".DELETE_ON_ERROR:", ".NOTPARALLEL:",
             ".SUFFIXES:", ".PHONY: trusted-base"]
    if os.name == "nt":
        lines.extend(("SHELL := cmd.exe", ".SHELLFLAGS := /d /s /c"))
    lines.append("trusted-base: " + " ".join(_make_token(source.with_suffix(".vo")) for source in sorted(base)))
    compiler = [configured_program(root, "coqc"), "-q", *flags]
    for source in sorted(base):
        _fixed(root, source.with_suffix(".vo"), "base output")
        prerequisites = [source, *configurations, *(external_source(dependency.with_suffix(".vo")) or dependency.with_suffix(".vo") for dependency in graph[source])]
        lines.append(_make_token(source.with_suffix(".vo")) + ": " + " ".join(map(_make_token, prerequisites)))
        lines.append("\t" + _recipe([*compiler, source.as_posix()]))
    return "\n".join(lines) + "\n"


def prepare_native(
    *, root: Path, targets: Sequence[Path], family: set[Path], deadline: float,
) -> dict[Path, tuple[Path, ...]]:
    """Discover in breadth batches, then build only the exact base closure."""
    root = root.expanduser().resolve()
    flags = [token for flag, physical, logical in base_load_paths(root)
             for token in (flag, str(physical), logical)]
    graph: dict[Path, tuple[Path, ...]] = {}
    pending = set(targets)
    with tempfile.TemporaryDirectory(prefix=".qcp-exact-make-", dir=root) as directory:
        while pending:
            from crtos_layout import external_source
            object_only = {source for source in pending if external_source(source) is not None and not external_source(source).exists()}
            for source in object_only:
                common.fixed_source(root, source.with_suffix(".vo"), label="installed object-only input")
                graph[source] = ()  # coqchk validates its compiled transitive imports below.
            batch = sorted(pending - object_only)
            if not batch:
                break
            for source in batch:
                common.fixed_source(root, source, label="coqdep source")
            # coqdep resolves -f entries relative to the argument file, not cwd.
            # Close before launch for Windows; the context still removes it.
            with tempfile.NamedTemporaryFile(
                mode="w", encoding="utf-8", newline="\n", dir=root,
                prefix=".qcp-coqdep-", suffix=".args", delete_on_close=False,
            ) as arguments:
                arguments.write(" ".join(json.dumps(token, ensure_ascii=False) for token in [*flags, *(str(common.fixed_source(root, source)) for source in batch)]) + "\n")
                arguments.close()
                process = common.run_tool(
                    [configured_program(root, "coqdep"), "-f", arguments.name],
                    cwd=root, deadline=deadline, label="coqdep dependency discovery",
                )
            discovered = _parse_dependencies(process.stdout, root)
            for source in batch:
                if source not in discovered:
                    raise common.CoqBuildPlanError(
                        category="tooling", kind="dependency-resolver-output",
                        message=f"coqdep omitted requested source: {source}",
                        repair="Repair the Rocq source or load-path configuration.",
                    )
                graph[source] = discovered[source]
            pending = {dependency for source in batch for dependency in graph[source]} - graph.keys()
        common.dependency_closure(graph, targets)
        from crtos_layout import COQ_BIN, check_external_pin
        check_external_pin(root, graph)
        external_modules = [common.relative_to_logical_module(source) for source in sorted(graph) if external_source(source) is not None]
        if external_modules:
            from crtos_layout import external_fingerprint
            from path_utils import write_json
            cache = fixed_path_under(root / "evidence/controller-external-kernel-check.json", root, label="external kernel receipt")
            selected = external_fingerprint(graph)
            previous = json.loads(cache.read_text()) if cache.exists() else {}
            covered = previous.get("status") == "passed" and all(previous.get("inputs", {}).get(key) == value for key, value in selected.items())
            if not covered:
                common.run_tool([str(COQ_BIN / "coqchk"), "-silent", *flags, *external_modules],
                                cwd=root, deadline=deadline, label="Read-only external kernel check")
                write_json(cache, {"status": "passed", "modules": external_modules, "inputs": selected,
                                   "scope": "installed external base; final full proof coqchk still required"})
        makefile = Path(directory) / "Makefile"
        makefile.write_text(_makefile(root, graph, family, flags), encoding="utf-8", newline="\n")
        environment = dict(os.environ)
        for name in ("MAKEFLAGS", "MFLAGS", "GNUMAKEFLAGS", "MAKELEVEL", "MAKEFILES",
                     "MAKEOVERRIDES", "COQC", "COQDEP", "COQFLAGS", "COQPATH", "ROCQPATH"):
            environment.pop(name, None)
        common.run_tool(
            [configured_program(root, "make"), "--no-print-directory", "--no-builtin-rules",
             "--no-builtin-variables", "-f", str(makefile), "trusted-base"],
            cwd=root, deadline=deadline, label="Make trusted base", environment=environment,
        )
    return graph
