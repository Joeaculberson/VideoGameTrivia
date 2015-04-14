class AddHideLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :hide_location, :boolean
  end
end
