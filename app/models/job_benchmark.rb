class JobBenchmark < ApplicationRecord
  enum :engine_type, [:good_job, :queue, :solid_queue]
  enum :job_type, [:cpu, :io]
end
