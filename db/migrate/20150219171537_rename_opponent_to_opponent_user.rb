class RenameOpponentToOpponentUser < ActiveRecord::Migration
  def change
    rename_column :games, :opponent, :opponent_user
  end
end
