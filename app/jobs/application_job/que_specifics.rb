class ApplicationJob
  module QueSpecifics
    extend ActiveSupport::Concern

    included do
      after_perform :keep_job
    end

    def keep_job
      finish
    end
  end
end
