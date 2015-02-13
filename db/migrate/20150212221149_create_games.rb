class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :opponent
      t.string :your_pieces
      t.string :opponent_pieces

      t.timestamps null: false
    end
  end
end
