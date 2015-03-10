class AddColumnsToGame < ActiveRecord::Migration
  def change
    add_column :games, :user_meter, :int
    add_column :games, :opponent_meter, :int
  end
end
