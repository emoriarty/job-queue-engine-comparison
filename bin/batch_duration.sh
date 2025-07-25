function show_batch_duration() {
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  "$SCRIPT_DIR/../bin/rails" runner "$(cat <<'RUBY'
    first_job = JobBenchmark.order(finished_at: :asc).select(:finished_at).first
    last_job = JobBenchmark.order(finished_at: :asc).select(:finished_at).last

    if first_job && last_job
      duration = last_job.finished_at - first_job.finished_at
      total_ms = (duration * 1000).round
      hours = total_ms / 1000 / 3600
      minutes = (total_ms / 1000 % 3600) / 60
      seconds = (total_ms / 1000) % 60
      milliseconds = total_ms % 1000
      printf "\rBatch duration: %02d:%02d:%02d.%03d\n", hours, minutes, seconds, milliseconds
    else
      printf "\rNo jobs found to calculate duration.\n"
    end
RUBY
  )"
}

