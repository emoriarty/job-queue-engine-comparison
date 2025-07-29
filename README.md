# Sidekiq Benchmarks

Run the following Bash script from the terminal, starting at the project root:

## CPU
```bash
for (i=0;i<3;++); do ./bin/perform_cpu_benchmarks 10000; done
```

## IO
```bash
for (i=0;i<3;++); do ./bin/perform_io_benchmarks 10000; done
```

