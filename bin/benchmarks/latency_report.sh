#!/usr/bin/env bash

set -euo pipefail

# Query P50 / P90 / P99 in milliseconds
bundle exec rails runner "
  row = JobBenchmark.connection.select_one(%{
    SELECT
      round(percentile_cont(0.50) WITHIN GROUP
            (ORDER BY EXTRACT(EPOCH FROM (started_at - queued_at)) * 1000)::numeric, 0) AS p50,
      round(percentile_cont(0.90) WITHIN GROUP
            (ORDER BY EXTRACT(EPOCH FROM (started_at - queued_at)) * 1000)::numeric, 0) AS p90,
      round(percentile_cont(0.99) WITHIN GROUP
            (ORDER BY EXTRACT(EPOCH FROM (started_at - queued_at)) * 1000)::numeric, 0) AS p99
    FROM job_benchmarks
  })
  puts [row['p50'], row['p90'], row['p99']].join(' ')
"

