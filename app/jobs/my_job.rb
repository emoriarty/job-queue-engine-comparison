class MyJob < ApplicationJob
  def perform(*args)
    # Do something later
    puts "I am in the job: #{args.join(", ")}"
    finish # This ensures that the job is kept in the database
  end
end
