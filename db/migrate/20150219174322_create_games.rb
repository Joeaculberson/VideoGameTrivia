class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :user_email
      t.string :opponent_user_email
      t.string :user_pieces
      t.string :opponent_pieces
      t.integer :round
      t.string :user_turn_email

      t.timestamps null: false
    end
  end
end
