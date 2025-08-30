#!/usr/bin/env bash

set -euo pipefail

# p50/p90/p99 for queue_wait, run_time, and end_to_end (milliseconds)
bundle exec rails runner "
  row = JobBenchmark.connection.select_one(%{
    SELECT
      round(percentile_cont(0.50) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (started_at  - queued_at))  * 1000)::numeric, 0) AS p50_queue_wait,
      round(percentile_cont(0.90) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (started_at  - queued_at))  * 1000)::numeric, 0) AS p90_queue_wait,
      round(percentile_cont(0.99) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (started_at  - queued_at))  * 1000)::numeric, 0) AS p99_queue_wait,

      round(percentile_cont(0.50) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - started_at)) * 1000)::numeric, 0) AS p50_run,
      round(percentile_cont(0.90) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - started_at)) * 1000)::numeric, 0) AS p90_run,
      round(percentile_cont(0.99) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - started_at)) * 1000)::numeric, 0) AS p99_run,

      round(percentile_cont(0.50) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - queued_at)) * 1000)::numeric, 0) AS p50_e2e,
      round(percentile_cont(0.90) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - queued_at)) * 1000)::numeric, 0) AS p90_e2e,
      round(percentile_cont(0.99) WITHIN GROUP
        (ORDER BY EXTRACT(EPOCH FROM (finished_at - queued_at)) * 1000)::numeric, 0) AS p99_e2e
    FROM job_benchmarks
  })
  puts %i[
    p50_queue_wait p90_queue_wait p99_queue_wait
    p50_run        p90_run        p99_run
    p50_e2e        p90_e2e        p99_e2e
  ].map { |k| row[k.to_s] }.join(' ')
"


