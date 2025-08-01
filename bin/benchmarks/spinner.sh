function display_progress_until_jobs_complete() {
  local spinner='|/-\'
  local delay=0.1
  local i=0
  local jobs_count=$1

  tput civis  # Hide cursor
  while true; do
    local count
    count=$(bin/rails runner "puts JobBenchmark.where.not(finished_at: nil).count" 2>/dev/null || echo 0)

    if [[ "$count" -ge "$jobs_count" ]]; then
      break
    fi

    local pending=$(( jobs_count - count ))
    i=$(( (i+1) % 4 ))
    printf "\rWaiting for jobs to finish... %s (Pending jobs: %s)       " "${spinner:$i:1}" "$pending"
    sleep "$delay"
  done
  tput cnorm  # Show cursor
}

