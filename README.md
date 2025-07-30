# DB-backed Background Processing Frameworks Benchmarks

This repository contains the code used to benchmark the most popular database-backed background processing frameworks in the Ruby (and Rails) ecosystem, and compares their performance with Sidekiq, the widely used Redis-based solution.

The libraries under evaluation are:

- [GoodJob](https://github.com/bensheldon/good_job/) ([branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/goodjob))
- [Solid Queue](https://github.com/rails/solid_queue) ([branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/solid_queue))
- [que](https://github.com/que-rb/que) ([branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/que))
- [Queue Classic](https://github.com/QueueClassic/queue_classic) ([branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/queue_classic))
- [Delayed::Job](https://github.com/collectiveidea/delayed_job) ([branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/delayed_job))

Each runner is tested in its own dedicated Git branch to ensure isolation and reproducibility of results.

## Purpose

The goal of this benchmark is to compare the different architectural approaches of each job runner under similar conditions. Configuration has been intentionally kept minimal—only what is required to ensure parity across tools. Performance differences should primarily reflect the internal design and strategy of each library, rather than fine-tuned optimization.

## Benchmark Environment

All tests were executed on the following system:

- **Operating System:** Arch Linux  
- **CPU:** AMD Ryzen 7 7700 (16 cores)  
- **Memory:** 64 GB RAM  

**Technical stack:**

- **Ruby:** 3.2 (MRI/CRuby) 
- **Rails:** 7.1  
- **PostgreSQL:** 17.5  
- **Environment:** `RAILS_ENV=production`

### Additional Considerations

- To ensure the most consistent setup across job runners, separate databases were used to match SolidQueue’s default behavior of isolating its queue backend. While this may not be a critical factor—since all runners ultimately rely on the same RDBMS—it could slightly affect performance due to differences in caching and database connections.

- In this setup, each worker is configured to process jobs from **all defined queues**, ensuring maximum flexibility and even workload distribution across the system.

## Notes

These benchmarks should not be considered definitive. Many external factors—such as database tuning, system load, or I/O characteristics—can significantly affect performance. Nonetheless, these tests aim to provide a consistent and practical baseline to evaluate the relative efficiency and trade-offs of each solution.
