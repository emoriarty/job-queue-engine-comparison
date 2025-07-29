#!/usr/bin/env bash
# Usage: batch_duration.sh <batch_id>
# Prints: seconds  (and a human-readable H:MM:SS line on stderr)
set -euo pipefail

bundle exec rails runner "
seconds = JobBenchmark.connection.select_value(%{
  SELECT EXTRACT(EPOCH FROM MAX(finished_at) - MIN(started_at))
  FROM   job_benchmarks
})

if seconds
  sec  = seconds.to_i
  hrs  = sec / 3600
  mins = (sec % 3600) / 60
  rem  = sec % 60
  STDERR.puts sprintf('Current batch duration: %02d:%02d:%02d', hrs, mins, rem)
  puts sec                # easy to capture in Bash with \$(…)
else
  STDERR.puts 'No jobs found for current batch'
  exit 1
end
"

