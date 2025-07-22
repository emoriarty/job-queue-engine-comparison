# Monitor average CPU usage of a process over N seconds
# Global accumulator
function monitor_cpu_usage_dynamic() {
  local pid=$1
  local interval=1
  local log_file="/tmp/goodjob_cpu_usage_${pid}.log"

  if ! kill -0 "$pid" 2>/dev/null; then
    echo "❌ monitor_cpu_usage_dynamic: PID $pid not running" >&2
    return 1
  fi

  : > "$log_file"  # Clear file

  while kill -0 "$pid" 2>/dev/null; do
    cpu=$(ps -p "$pid" -o %cpu= 2>/dev/null | tr -d ' ')
    if [[ -z "$cpu" ]]; then
      echo "⚠️  Empty CPU reading for PID $pid" >&2
      break
    fi
    echo "$cpu" >> "$log_file"
    sleep "$interval"
  done
}

function show_monitor_cpu_usage() {
  local pid=$1
  local log_file="/tmp/goodjob_cpu_usage_${pid}.log"

  if [[ -s "$log_file" ]]; then
    avg_cpu=$(awk '{ sum += $1 } END { if (NR > 0) printf "%.2f", sum / NR }' "$log_file")
    echo "[PID $pid] GoodJob average CPU usage: ${avg_cpu}%"
  else
    echo "No CPU usage data collected."
  fi
}

# Get peak memory usage (VmHWM) of a process in MB
function get_peak_memory_mb() {
  local pid=$1
  if [[ ! -r /proc/$pid/status ]]; then
    echo "⚠️  /proc/$pid/status not available." >&2
    return 1
  fi
  awk '/VmHWM/ { print int($2 / 1024) }' /proc/"$pid"/status
}

