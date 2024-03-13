class MyJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    puts "I am in the job: #{args.join(", ")}"
  end
end
