class IoJob < ApplicationJob
  def perform(_queued_at)
    # Simulate I/O-bound work using PostgreSQL sleep
    # This creates database connection overhead without CPU-intensive operations
    ActiveRecord::Base.connection.execute("SELECT pg_sleep(0.01)")
  end

  def job_type = "io"
end
