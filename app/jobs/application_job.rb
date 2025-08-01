class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  around_perform do |job, block|
    started_at = Time.now
    block.call
    finished_at = Time.now
    queued_at = job.arguments.first
    JobBenchmark.create!(queued_at:, started_at:, finished_at:, duration: finished_at - started_at)
  end

  def job_type
    raise NotImplementedError
  end
end
