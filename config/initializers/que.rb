class QueRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :queue }
end

module Que
  module ActiveRecord
    module Connection
      def self.checkout
        wrap_in_rails_executor do
          QueRecord.connection_pool.with_connection do |conn|
            yield conn.raw_connection
          end
        end
      end
    end
  end
end

# Important: trigger Que to use ActiveRecord mode
Que.connection = 'ActiveRecord'
