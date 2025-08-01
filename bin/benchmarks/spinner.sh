function display_progress_until_jobs_complete() {
  local spinner='|/-\'
  local delay=0.1
  local i=0
  local jobs_count=$1

  tput civis  # Hide cursor
  while true; do
    local pending=$(bin/rails runner "puts JobBenchmark.where(finished_at: nil).count" || echo 0)

    if [[ "$pending" -ge "0" ]]; then
      break
    fi

    i=$(( (i+1) % 4 ))
    printf "\rWaiting for jobs to finish... %s (Pending jobs: %d)         " "${spinner:$i:1}" "$pending"
    sleep "$delay"
  done
  printf "\rAll jobs completed.                                                  \n"
  tput cnorm  # Show cursor
}

