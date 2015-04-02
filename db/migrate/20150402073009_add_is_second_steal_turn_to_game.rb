class AddIsSecondStealTurnToGame < ActiveRecord::Migration
  def change
    add_column :games, :is_second_steal_turn, :boolean
  end
end
