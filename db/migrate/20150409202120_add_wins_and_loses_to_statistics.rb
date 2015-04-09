class AddWinsAndLosesToStatistics < ActiveRecord::Migration
  def change
    add_column :statistics, :wins, :integer
    add_column :statistics, :loses, :integer
  end
end
