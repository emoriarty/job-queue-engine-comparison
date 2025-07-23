function monitor_cpu_usage_dynamic() {
  local -n result=$1
  shift
  local interval=1
  result=()

  for pid in "$@"; do
    local log_file="/tmp/goodjob_cpu_usage_${pid}.log"

    if ! kill -0 "$pid" 2>/dev/null; then
      echo "❌ PID $pid not running" >&2
      continue
    fi

    : > "$log_file"

    (
      while kill -0 "$pid" 2>/dev/null; do
        cpu=$(ps -p "$pid" -o %cpu= | tr -d ' ')
        echo "$cpu" >> "$log_file"
        sleep "$interval"
      done
    ) &
    result+=($!)
  done
}

function show_monitor_cpu_usage() {
  for pid in "$@"; do
    local log_file="/tmp/goodjob_cpu_usage_${pid}.log"

    if [[ -s "$log_file" ]]; then
      avg_cpu=$(awk '{ sum += $1 } END { if (NR > 0) printf "%.2f", sum / NR }' "$log_file")
      echo "[PID $pid] Average CPU usage: ${avg_cpu}%"
    else
      echo "[PID $pid] No CPU usage data collected."
    fi
  done
}

function show_avg_monitor_cpu_usage() {
  local total=0
  local count=0

  for pid in "$@"; do
    local log_file="/tmp/goodjob_cpu_usage_${pid}.log"

    if [[ -s "$log_file" ]]; then
      avg=$(awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' "$log_file")
      if [[ -n "$avg" ]]; then
        total=$(awk -v a="$total" -v b="$avg" 'BEGIN { print a + b }')
        count=$((count + 1))
      fi
    else
      echo "[PID $pid] No CPU usage data collected."
    fi
  done

  if (( count > 0 )); then
    overall_avg=$(awk -v sum="$total" -v n="$count" 'BEGIN { printf "%.2f", sum / n }')
    echo "Average CPU usage across ${count} monitor(s): ${overall_avg}%"
  else
    echo "❌ No CPU usage data available for any process." >&2
    return 1
  fi
}

function show_peak_memory_mb() {
  for pid in "$@"; do
    if [[ ! -r /proc/$pid/status ]]; then
      echo "⚠️  /proc/$pid/status not available for PID $pid." >&2
      continue
    fi
    peak=$(awk '/VmHWM/ { print int($2 / 1024) }' /proc/"$pid"/status)
    echo "[PID $pid] Peak memory usage: ${peak:-N/A} MB"
  done
}

function show_avg_peak_memory_mb() {
  local total=0
  local count=0

  for pid in "$@"; do
    if [[ ! -r /proc/$pid/status ]]; then
      echo "⚠️  /proc/$pid/status not available for PID $pid." >&2
      continue
    fi

    peak_kb=$(awk '/VmHWM/ { print $2 }' /proc/"$pid"/status)
    if [[ -n "$peak_kb" ]]; then
      total=$((total + peak_kb))
      count=$((count + 1))
    fi
  done

  if (( count > 0 )); then
    avg_mb=$((total / count / 1024))
    echo "Average peak memory usage: ${avg_mb} MB (${count} process${count==1 ? "" : "es"})"
  else
    echo "❌ No valid peak memory data available." >&2
    return 1
  fi
}

