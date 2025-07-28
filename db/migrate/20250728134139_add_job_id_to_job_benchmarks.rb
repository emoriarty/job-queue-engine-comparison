class AddJobIdToJobBenchmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :job_benchmarks, :job_id, :uuid
  end
end
