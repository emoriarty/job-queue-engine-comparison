class CreateJobBenchmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :job_benchmarks do |t|
      t.string :job_type
      t.float :duration
      t.datetime :started_at
      t.datetime :finished_at
      t.string :engine_type

      t.timestamps
    end
  end
end
