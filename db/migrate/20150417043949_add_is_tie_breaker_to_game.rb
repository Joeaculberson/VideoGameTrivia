class AddIsTieBreakerToGame < ActiveRecord::Migration
  def change
    add_column :games, :is_tie_breaker, :boolean
  end
end
