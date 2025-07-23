# DB-based Queuing Backend Benchmarks

This repository contains the code used to benchmark the most popular **database-backed job runners** in the Ruby (and Rails) ecosystem—excluding the more common Redis-based alternatives like Sidekiq.

The libraries under evaluation are:

- [GoodJob](https://github.com/bensheldon/good_job/) ([test branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/goodjob))
- [Solid Queue](https://github.com/rails/solid_queue) ([test branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/solid_queue))
- [Que](https://github.com/que-rb/que) ([test branch](https://github.com/emoriarty/job-queue-engine-comparison/tree/que))

Each runner is tested in its own dedicated Git branch to ensure isolation and reproducibility of results.

---

## Purpose

The goal of this benchmark is to compare the different architectural approaches of each job runner under similar conditions. Configuration has been intentionally kept minimal—only what is required to ensure parity across tools. Performance differences should primarily reflect the internal design and strategy of each library, rather than fine-tuned optimization.

---

## Benchmark Environment

All tests were executed on the following system:

- **Operating System:** Arch Linux  
- **CPU:** AMD Ryzen 7 7700 (16 cores)  
- **Memory:** 64 GB RAM  

Shared benchmark parameters:

- **Threads per worker:** 5  
- **Number of queues:** 8  

Technical stack:

- **Ruby:** 3.2  
- **Rails:** 7.1  
- **PostgreSQL:** 17.5  
- **Environment:** `RAILS_ENV=production`  

---

## Notes

These benchmarks should not be considered definitive. Many external factors—such as database tuning, system load, or I/O characteristics—can significantly affect performance. Nonetheless, these tests aim to provide a consistent and practical baseline to evaluate the relative efficiency and trade-offs of each solution.
