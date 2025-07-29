# Usage: run_que.sh <threads>

threads=$1

bundle exec que \
  --worker-count "$threads" \
  -q queue_0 \
  --poll-interval 0.1
