class QueueClassicRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { reading: :queue, writing: :queue }
end

module QC
  class ConnAdapter
    def connection
      if @active_record_connection_share && Object.const_defined?('ActiveRecord')
        puts "=> CONNECT WITH AR"
        QueueClassicRecord.connection.raw_connection
      else
        puts "=> CONNECT WITH ENV"
        @_connection ||= establish_new
      end
    end
  end
end
