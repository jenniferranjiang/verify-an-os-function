from pathlib import Path
import shlex
import subprocess
root = Path(__file__).resolve().parents[2]
check = Path(__file__).resolve().parent
args = []
for line in (root / "_CoqProject").read_text().splitlines():
    words = shlex.split(line)
    if words and words[0] in ("-R", "-Q", "-I"):
        args.extend(words)
cmd = ["coqc", *args, str(check / "ReuseBaseline.v")]
result = subprocess.run(cmd, cwd=root, capture_output=True, text=True)
(check / "reuse-baseline-command.txt").write_text(shlex.join(cmd) + "\n")
(check / "reuse-baseline.log").write_text(result.stdout + result.stderr + f"\nexit_code={result.returncode}\n")
print(result.stdout + result.stderr)
print(f"exit_code={result.returncode}")
raise SystemExit(result.returncode)
