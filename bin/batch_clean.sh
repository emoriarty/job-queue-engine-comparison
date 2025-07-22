function show_spinner_clean_batch() {
  local spinner='|/-\\'
  local delay=0.1
  local i=0
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  tput civis 2>/dev/null
  "$script_dir/../bin/rails" runner "GoodJob::Job.delete_all; JobBenchmark.delete_all" > /dev/null 2>&1 &
  CLEAN_PID=$!
  while kill -0 "$CLEAN_PID" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rCleaning... %s" "${spinner:$i:1}"
    sleep "$delay"
  done
  wait "$CLEAN_PID"
  printf "\rCleaning completed.   \n"
  tput cnorm 2>/dev/null
}

function show_spinner_clean_batch() {
  local spinner='|/-\\'
  local delay=0.1
  local i=0
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  tput civis 2>/dev/null
  "$script_dir/../bin/rails" runner "GoodJob::Job.delete_all; JobBenchmark.delete_all" > /dev/null 2>&1 &
  local CLEAN_PID=$!

  while kill -0 "$CLEAN_PID" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rCleaning... %s" "${spinner:$i:1}"
    sleep "$delay"
  done

  wait "$CLEAN_PID"
  local status=$?
  printf "\rCleaning completed.       "
  tput cnorm 2>/dev/null

  return $status
}

