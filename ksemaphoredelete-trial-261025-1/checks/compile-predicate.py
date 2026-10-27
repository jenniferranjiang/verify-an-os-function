"""Rebuild the merged shared libraries and affected dependents using the root project."""
from pathlib import Path
import subprocess, json
trial = Path(__file__).resolve().parents[1]
root = trial.parent
commands = [
    ["coq_makefile", "-f", "_CoqProject", "-o", "Makefile.coq"],
    ["make", "-f", "Makefile.coq", "-j2", "COQBIN=/home/xinra/.opam/pv-bench-8.20.1/bin/",
     "lib/TaskInv.vo", "lib/SemaphoreInv.vo", "lib/CrtosInv.vo",
     "lib/KTaskUnSetDelay.vo", "lib/KTaskWakeup.vo", "lib/SemaphoreOps.vo",
     "lib/KSemaphoreDelete.vo", "lib/KSemaphoreCreate.vo"]
]
results = []
for number, command in enumerate(commands):
    result = subprocess.run(command, cwd=root, text=True, capture_output=True)
    log = trial / "checks" / ("root-configure.log" if number == 0 else "root-library-build.log")
    log.write_text(result.stdout + result.stderr + "\nexit_code=" + str(result.returncode) + "\n")
    results.append({"command": command, "cwd": str(root), "exit_code": result.returncode, "log": str(log)})
    print(log.name, "exit_code=" + str(result.returncode), flush=True)
    if result.returncode:
        print(result.stdout + result.stderr)
        break
(trial / "checks/root-build-results.json").write_text(json.dumps(results, indent=2) + "\n")
raise SystemExit(0 if len(results) == 2 and all(x["exit_code"] == 0 for x in results) else 1)
