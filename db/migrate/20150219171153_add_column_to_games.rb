class AddColumnToGames < ActiveRecord::Migration
  def self.up

  end

  def change
    add_column :games, :user, :string
  end
end
