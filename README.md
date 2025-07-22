# GoodJob Benchmarks

Run the following Bash script from the terminal, starting at the project root:

## CPU
```bash
for count in 16000 8000 4000 2000 1000; do ./bin/perform_good_job_benchmarks "cpu" "$count"; done
```

## IO
```bash
for count in 16000 8000 4000 2000 1000; do ./bin/perform_good_job_benchmarks "io" "$count"; done
```
