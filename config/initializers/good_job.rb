GoodJob.configure_active_record do
  connects_to database: { reading: :queue, writing: :queue }
end
