class AddMoreColumnsToGame < ActiveRecord::Migration
  def change
    add_column :games, :user_steal_correct, :integer
    add_column :games, :opponent_steal_correct, :integer
  end
end
