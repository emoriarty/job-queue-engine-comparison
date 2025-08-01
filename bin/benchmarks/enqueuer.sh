function enqueue_jobs() {
  local spinner='|/-\\'
  local delay=0.1
  local i=0
  local job_type="${1^}"  # capitalize first letter
  local queue_count="$2"
  local total_jobs="$3"
  local job_count_per_queue=$((total_jobs / queue_count))
  local class_name="${job_type}Job"
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  (
  tput civis
  i=0
  local spinner='|/-\\'
  bin/rails runner "$(cat <<RUBY
    queue_count = $queue_count
    job_count = $job_count_per_queue
    klass = Object.const_get("$class_name")
    queue_count.times do |i|
      job_count.times do
        job_id = SecureRandom.uuid
        JobBenchmark.create!(job_id:, queued_at: Time.now, job_type: "${job_type,,}")
        klass.set(queue: "queue_#{i}").perform_later(job_id)
      end
    end
RUBY
  )" > /dev/null 2>&1 &
  ENQUEUE_PID=$!
  while kill -0 "$ENQUEUE_PID" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rEnqueuing jobs... %s" "${spinner:$i:1}"
    sleep 0.1
  done
  wait "$ENQUEUE_PID"
  tput cnorm
  printf "\rEnqueuing completed.                            "
)
}

