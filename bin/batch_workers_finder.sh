function find_worker_pids_by_parent() {
  local parent_pid=$1
  local match_pattern=${2:-"solid-queue-worker"}
  local retries=${3:-10}
  local delay=${4:-0.5}

  for ((i = 1; i <= retries; i++)); do
    # Use mapfile to read all matching PIDs into array
    mapfile -t pids < <(pgrep -f "$match_pattern" -P "$parent_pid" 2>/dev/null || true)

    if (( ${#pids[@]} > 0 )); then
      echo "${pids[@]}"
      return 0
    fi

    sleep "$delay"
  done

  echo "❌ Failed to find worker PIDs matching '$match_pattern' for parent $parent_pid" >&2
  return 1
}

