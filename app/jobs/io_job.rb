require "json"

class IoJob < ApplicationJob
  def perform(_queued_at)
    @lines ||= File.readlines(Rails.root.join("lib", "movie_ids_04_13_2024.json"))
    data = JSON.parse(@lines.sample)
    title = data["original_title"]
    popularity = data["popularity"]

    Film.find_or_create_by(title:) do |film|
      film.popularity = popularity
    end
  end

  def job_type = "io"
end
