function show_spinner_until_jobs_complete() {
  local spinner='|/-\'
  local delay=0.1
  local i=0

  tput civis  # Hide cursor
  while true; do
    local count=$(bin/rails runner "puts GoodJob::Job.where(finished_at: nil).count" 2>/dev/null)

    if [[ "$count" == "0" ]]; then
      break
    fi

    i=$(( (i+1) % 4 ))
    printf "\rWaiting for jobs to finish... %s (Pending jobs: %s)" "${spinner:$i:1}" "$count"
    sleep "$delay"
  done
  printf "\rAll jobs completed.                                                  "
  tput cnorm  # Show cursor
}

