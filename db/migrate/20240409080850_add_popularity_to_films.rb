class AddPopularityToFilms < ActiveRecord::Migration[7.1]
  def change
    add_column :films, :popularity, :float, default: 0.0
  end
end
