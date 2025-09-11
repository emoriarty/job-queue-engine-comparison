function enqueue_jobs() {
  local spinner='|/-\\'
  local delay=0.1
  local i=0
  local job_type="${1^}"  # capitalize first letter
  local queue_count="$2"
  local total_jobs="$3"
  local job_count_per_queue=$(awk "BEGIN {print $total_jobs/$queue_count}")

  local class_name="${job_type}Job"
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  if [[ $job_count_per_queue =~ ^-?[0-9]*\.[0-9]+$ ]]; then
    # Delete the decimal part and add one
    # This way when checking the current count will be greater than the total count
    # allowing to break the loop
    job_count_per_queue=${job_count_per_queue%.*}
    ((job_count_per_queue++))
  fi

  (
  tput civis
  i=0
  local spinner='|/-\\'
  bin/rails runner "$(cat <<RUBY
    queue_count = $queue_count
    job_count = ${job_count_per_queue%.*}
    klass = Object.const_get("$class_name")
    queue_count.times do |i|
      job_count.times do
        klass.set(queue: "queue_#{i}").perform_later(Time.now)
      end
    end
RUBY
  )" > /dev/null 2>&1 &
  ENQUEUE_PID=$!
  while kill -0 "$ENQUEUE_PID" 2>/dev/null; do
    i=$(( (i+1) % 4 ))
    printf "\rEnqueuing jobs... %s                            " "${spinner:$i:1}"
    sleep 0.1
  done
  wait "$ENQUEUE_PID"
  tput cnorm
  printf "\rEnqueuing completed.                              "
)
}

function enqueue_jobs_for_duration() {
  local job_type="${1^}"  # capitalize first letter
  local queue_count="$2"
  local duration_seconds="$3"
  local class_name="${job_type}Job"
  
  local end_time=$(($(date +%s) + duration_seconds))
  local batch_size=50  # Enqueue jobs in batches for better performance
  
  while [[ $(date +%s) -lt $end_time ]]; do
    bin/rails runner "$(cat <<RUBY
      queue_count = $queue_count
      batch_size = $batch_size
      klass = Object.const_get("$class_name")
      queue_count.times do |i|
        batch_size.times do
          klass.set(queue: "queue_#{i}").perform_later(Time.now)
        end
      end
RUBY
    )" > /dev/null 2>&1
    
    # Small delay to prevent overwhelming the system
    sleep 0.1
  done
}

function wait_for_duration() {
  local duration_seconds="$1"
  local start_time="$2"
  local spinner='|/-\\'
  local i=0
  
  while true; do
    local current_time=$(date +%s)
    local elapsed=$((current_time - start_time))
    
    if [[ $elapsed -ge $duration_seconds ]]; then
      break
    fi
    
    local remaining=$((duration_seconds - elapsed))
    i=$(( (i+1) % 4 ))
    printf "\rRunning benchmark... %s (${remaining}s remaining)                     " "${spinner:$i:1}"
    sleep 1
  done
}

