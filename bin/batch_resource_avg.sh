function report_resource_averages() {
  local pids=("$@")
  local peak_memories=()
  local cpu_usages=()

  for pid in "${pids[@]}"; do
    # Get peak memory usage
    local peak_mb
    peak_mb=$(get_peak_memory_mb "$pid")
    peak_memories+=("${peak_mb:-0}")

    # Get average CPU usage from log file
    local cpu_file="/tmp/goodjob_cpu_usage_${pid}.log"
    if [[ -s "$cpu_file" ]]; then
      local avg_cpu
      avg_cpu=$(awk '{ sum += $1 } END { if (NR > 0) printf "%.2f", sum / NR }' "$cpu_file")
      cpu_usages+=("$avg_cpu")
    else
      cpu_usages+=(0)
    fi
  done

  # Compute and print averages
  local avg_peak_mem avg_cpu_usage
  avg_peak_mem=$(awk '{s+=$1} END {if(NR>0) printf "%.2f", s/NR}' <(printf "%s\n" "${peak_memories[@]}"))
  avg_cpu_usage=$(awk '{s+=$1} END {if(NR>0) printf "%.2f", s/NR}' <(printf "%s\n" "${cpu_usages[@]}"))

  echo "→ Average peak memory usage: ${avg_peak_mem} MB"
  echo "→ Average CPU usage: ${avg_cpu_usage}%"
}

