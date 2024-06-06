require "json"

class IoJob < ApplicationJob
  def perform
    # 1st
    # Open a file and read the contents
    File.open(Rails.root.join("lib", "movie_ids_04_13_2024.json")) do |f|
      random_number = rand(0..16000)
      line = f.take(random_number).last

      # Parse the line to get the title and popularity
      data = JSON.parse(line)
      title = data["original_title"]
      popularity = data["popularity"]

      # 2nd
      # Save the key value pair to the database
      film = Film.find_by(title:)

      if film.nil?
        film = Film.create!(title:, popularity:)
        Rails.logger.info "Film created: #{film.inspect}"
      else
        film.update!(popularity:)
        Rails.logger.info "Film updated: #{film.inspect}"
      end
    end
  end
end
