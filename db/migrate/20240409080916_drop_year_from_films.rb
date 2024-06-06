class DropYearFromFilms < ActiveRecord::Migration[7.1]
  def change
    remove_column :films, :year
  end
end
