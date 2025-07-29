class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  after_enqueue do |job|
    job_id = job.arguments.first
    JobBenchmark.create!(job_id:, job_type:, queued_at: Time.now)
  end

  around_perform do |job, block|
    started_at = Time.now
    block.call
    finished_at = Time.now
    job_id = job.arguments.first
    record = JobBenchmark.find_by!(job_id:)
    record.update!(started_at:, finished_at:, duration: finished_at - started_at)
  end

  def job_type
    raise NotImplementedError
  end
end
