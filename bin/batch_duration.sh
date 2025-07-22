function show_batch_duration() {
  local SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/../bin/rails" runner "$(cat <<'RUBY'
  first_job = JobBenchmark.good_job.order(finished_at: :asc).select(:finished_at).first
  last_job = JobBenchmark.good_job.order(finished_at: :asc).select(:finished_at).last

  if first_job && last_job
    total_seconds = (last_job.finished_at - first_job.finished_at).to_i
    hours = total_seconds / 3600
    minutes = (total_seconds % 3600) / 60
    seconds = total_seconds % 60
    printf "\rBatch duration: %02d:%02d:%02d\n", hours, minutes, seconds
  else
    printf "\rNo jobs found to calculate duration.\n"
  end
RUBY
)"
}

