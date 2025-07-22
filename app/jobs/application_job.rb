class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  around_perform do |_job, block|
    record = JobBenchmark.create!(engine_type: "good_job", job_type:, started_at: Time.now)
    block.call
    finished_at = Time.now
    record.update!(finished_at:, duration: finished_at - record.started_at)
  end

  def job_type
    raise NotImplementedError
  end
end
