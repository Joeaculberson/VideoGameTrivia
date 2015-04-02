class AddBetPieceToGames < ActiveRecord::Migration
  def change
    add_column :games, :bet_piece, :string
    add_column :games, :wanted_piece, :string
  end
end
