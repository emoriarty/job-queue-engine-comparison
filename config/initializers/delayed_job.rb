unless Rails.env.local?
  class DelayedJobRecord < Delayed::Backend::ActiveRecord::Job
    self.abstract_class = true
    connects_to database: { reading: :queue, writing: :queue }
  end

  class DelayedJob < DelayedJobRecord
  end

  Delayed::Job = DelayedJob
end
