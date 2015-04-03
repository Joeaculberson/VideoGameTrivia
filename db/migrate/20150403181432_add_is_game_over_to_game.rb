class AddIsGameOverToGame < ActiveRecord::Migration
  def change
    add_column :games, :is_game_over, :boolean
  end
end
