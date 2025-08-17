class AddPidToJobBenchmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :job_benchmarks, :pid, :integer
  end
end
