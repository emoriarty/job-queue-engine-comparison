class CreateFilms < ActiveRecord::Migration[7.1]
  def change
    create_table :films do |t|
      t.string :title, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
