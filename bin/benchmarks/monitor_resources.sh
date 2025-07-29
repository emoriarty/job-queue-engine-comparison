#!/usr/bin/env bash
# Usage: monitor_resources.sh <output_csv> <pid1 pid2 ...>
set -euo pipefail

LOG="$1"; shift
PIDS=("$@")
echo "timestamp,rss_kb,cpu_percent" > "$LOG"

# Aggregate every second until killed by parent script.
while :; do
  read -r RSS CPU <<<"$(ps -o rss=,%cpu= -p "$(IFS=,; echo "${PIDS[*]}")" \
                     | awk '{rss+=$1; cpu+=$2} END{print rss, cpu}')"
  printf '%s,%s,%s\n' "$(date +%s)" "$RSS" "$CPU" >> "$LOG"
  sleep 1
done

