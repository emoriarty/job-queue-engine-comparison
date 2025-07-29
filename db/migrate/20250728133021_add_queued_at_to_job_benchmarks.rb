class AddQueuedAtToJobBenchmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :job_benchmarks, :queued_at, :datetime
  end
end
