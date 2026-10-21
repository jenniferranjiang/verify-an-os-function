#!/usr/bin/env bash

set -uo pipefail

usage() {
    cat >&2 <<'EOF'
usage: check-spec-closure.sh <trial-dir> [legacy-timing-tsv]
       [--timing <timing-v2.tsv>] [--affected <annotated-c-file>]...

Without --affected, checks the full flat annotated_C/src closure.
With --affected, checks only the named C files; affected runs are not
review-ready full-closure evidence.
EOF
    exit 2
}

[[ $# -ge 1 ]] || usage

trial_dir=$(realpath "$1")
shift
src_dir="$trial_dir/annotated_C/src"
timing_file=""
closure_kind=full
declare -a affected_args=()

# Preserve the old optional positional timing path.
if [[ $# -gt 0 && $1 != --* ]]; then
    timing_file=$1
    shift
fi

while [[ $# -gt 0 ]]; do
    case $1 in
        --timing)
            [[ $# -ge 2 ]] || usage
            timing_file=$2
            shift 2
            ;;
        --affected)
            [[ $# -ge 2 ]] || usage
            closure_kind=affected
            affected_args+=("$2")
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

timing_file=${timing_file:-"$trial_dir/.docs/Report/check-timings-v2.tsv"}

[[ -d "$src_dir" ]] || {
    echo "missing annotated source directory: $src_dir" >&2
    exit 2
}

symexec_bin=${SYMEXEC_BIN:-}
if [[ -z "$symexec_bin" && -f "$trial_dir/CONFIGURE" ]]; then
    symexec_dir=$(sed -n 's/^[[:space:]]*SymExec_DIR[[:space:]]*=[[:space:]]*//p' \
        "$trial_dir/CONFIGURE" | tail -n 1)
    [[ -n "$symexec_dir" ]] && symexec_bin="${symexec_dir%/}/symexec"
fi
symexec_bin=${symexec_bin:-/home/xinra/qcp-binary-democases/linux-binary/symexec}

[[ -x "$symexec_bin" ]] || {
    echo "symexec is not executable: $symexec_bin" >&2
    exit 2
}

cd "$trial_dir"

declare -a c_files=()
if [[ "$closure_kind" == full ]]; then
    mapfile -t c_files < <(
        find annotated_C/src -maxdepth 1 -type f -name '*.c' -printf '%p\n' |
            sort
    )
else
    declare -A seen_files=()
    for requested in "${affected_args[@]}"; do
        case $requested in
            /*) candidate=$(realpath "$requested") ;;
            annotated_C/src/*) candidate=$(realpath "$trial_dir/$requested") ;;
            *) candidate=$(realpath "$src_dir/$requested") ;;
        esac
        [[ -f "$candidate" && $(dirname "$candidate") == "$src_dir" && $candidate == *.c ]] || {
            echo "invalid affected C file: $requested" >&2
            exit 2
        }
        relative="annotated_C/src/$(basename "$candidate")"
        if [[ -z ${seen_files[$relative]+x} ]]; then
            c_files+=("$relative")
            seen_files[$relative]=1
        fi
    done
fi

[[ ${#c_files[@]} -gt 0 ]] || {
    echo "no annotated C files selected" >&2
    exit 2
}

if [[ -n ${PREDICATE_FILE:-} ]]; then
    predicate_path="$trial_dir/${PREDICATE_FILE#./}"
    [[ -f "$predicate_path" ]] || {
        echo "missing PREDICATE_FILE: $predicate_path" >&2
        exit 2
    }
    predicate_revision=$(sha256sum "$predicate_path" | cut -d' ' -f1)
    predicate_revision_kind="file:${PREDICATE_FILE#./}"
else
    predicate_revision=$(
        find lib -maxdepth 1 -type f -name '*.v' -printf './%P\n' |
            sort |
            while read -r path; do
                sha256sum "lib/${path#./}" | sed 's#  lib/#  ./#'
            done |
            sha256sum |
            cut -d' ' -f1
    )
    predicate_revision_kind=lib-manifest
fi

spec_revision=$(
    find annotated_C/src -type f \( -name '*.c' -o -name '*.h' \) -printf './%P\n' |
        sort |
        while read -r path; do
            sha256sum "annotated_C/src/${path#./}" | sed 's#  annotated_C/src/#  ./#'
        done |
        sha256sum |
        cut -d' ' -f1
)

run_id="$(date +%Y%m%dT%H%M%S)-$$"
file_count=${#c_files[@]}
rocq_mode=unknown
expected_header='timestamp\trun_id\tclosure_kind\tfile_count\trocq_mode\tpredicate_revision\tspec_revision\tphase\titem\tduration_ms\tstatus'

mkdir -p "$(dirname "$timing_file")"
if [[ -s "$timing_file" ]]; then
    actual_header=$(sed -n '1p' "$timing_file")
    [[ "$actual_header" == "$expected_header" ]] || {
        echo "timing file uses a legacy/incompatible schema: $timing_file" >&2
        echo "use --timing with a new v2 path; the legacy file is preserved" >&2
        exit 2
    }
else
    printf '%s\n' "$expected_header" >"$timing_file"
fi

now_ms() {
    date +%s%3N
}

record() {
    local phase=$1 item=$2 start=$3 status=$4 end
    end=$(now_ms)
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$(date --iso-8601=seconds)" "$run_id" "$closure_kind" "$file_count" \
        "$rocq_mode" "$predicate_revision" "$spec_revision" "$phase" "$item" \
        "$((end - start))" "$status" >>"$timing_file"
}

overall_start=$(now_ms)
overall_status=fail
total_recorded=0

record_total() {
    if [[ $total_recorded -eq 0 ]]; then
        record total closure "$overall_start" "$overall_status"
        total_recorded=1
    fi
}
trap record_total EXIT

run_checked() {
    local phase=$1 item=$2 start output status
    shift 2
    start=$(now_ms)
    output=$(mktemp)
    if "$@" >"$output" 2>&1; then
        status=pass
    else
        status=fail
    fi
    record "$phase" "$item" "$start" "$status"
    if [[ "$status" == fail ]]; then
        echo "FAIL $phase $item" >&2
        sed -n '1,240p' "$output" >&2
        rm -f "$output"
        return 1
    fi
    rm -f "$output"
    echo "PASS $phase $item"
}

rocq_start=$(now_ms)
rocq_output=$(mktemp)
if make -q lib >"$rocq_output" 2>&1; then
    rocq_mode=cached
    record rocq lib "$rocq_start" pass
    rm -f "$rocq_output"
    echo "PASS rocq lib (cached)"
else
    rocq_mode=rebuild
    if make lib >"$rocq_output" 2>&1; then
        record rocq lib "$rocq_start" pass
        rm -f "$rocq_output"
        echo "PASS rocq lib (rebuild)"
    else
        record rocq lib "$rocq_start" fail
        echo "FAIL rocq lib (rebuild)" >&2
        sed -n '1,240p' "$rocq_output" >&2
        rm -f "$rocq_output"
        exit 1
    fi
fi

for file in "${c_files[@]}"; do
    run_checked c-syntax "${file#annotated_C/src/}" \
        gcc -std=gnu11 -fsyntax-only -Iannotated_C/src "$file" || exit 1
done

for file in "${c_files[@]}"; do
    start=$(now_ms)
    output=$(mktemp)
    if "$symexec_bin" \
        --input-file="$file" \
        -slp annotated_C/src/ CRTOS_Verify.VC.strategy \
        --no-coq-gen --no-exec-info >"$output" 2>&1 &&
       grep -q 'Successfully finished symbolic execution' "$output"; then
        status=pass
    else
        status=fail
    fi
    record symbolic-dry-run "${file#annotated_C/src/}" "$start" "$status"
    if [[ "$status" == fail ]]; then
        echo "FAIL symbolic-dry-run ${file#annotated_C/src/}" >&2
        sed -n '1,260p' "$output" >&2
        rm -f "$output"
        exit 1
    fi
    rm -f "$output"
    echo "PASS symbolic-dry-run ${file#annotated_C/src/}"
done

trust_start=$(now_ms)
if rg -n --pcre2 '\b(Parameter|Axiom|Admitted|admit)\b' lib -g '*.v'; then
    record trust-scan lib "$trust_start" fail
    echo "FAIL trust-scan lib" >&2
    exit 1
fi
record trust-scan lib "$trust_start" pass
echo "PASS trust-scan lib"

vc_count=$(find VC -type f | wc -l)
overall_status=pass
record_total
trap - EXIT

echo "RUN_ID $run_id"
echo "CLOSURE_KIND $closure_kind"
echo "REVIEW_EVIDENCE_READY $([[ $closure_kind == full ]] && echo yes || echo no)"
echo "ROCQ_MODE $rocq_mode"
echo "PREDICATE_REVISION $predicate_revision"
echo "PREDICATE_REVISION_KIND $predicate_revision_kind"
echo "SPEC_REVISION $spec_revision"
echo "ANNOTATED_C_COUNT $file_count"
echo "VC_FILE_COUNT $vc_count"
echo "TIMING_FILE $timing_file"
