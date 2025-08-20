set -euo pipefail

function reset_batch() {
  local spinner='|/-\\'
  local delay=0.1
  local i=0
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  tput civis 2>/dev/null
  bin/rails runner "JobBenchmark.delete_all" 2>&1 &
  local CLEAN_PID=$!

  while kill -0 "$CLEAN_PID" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rCleaning... %s                                 " "${spinner:$i:1}"
    sleep "$delay"
  done

  wait "$CLEAN_PID"
  local status=$?
  printf "\rCleaning completed.                     "
  tput cnorm 2>/dev/null

  return $status
}

