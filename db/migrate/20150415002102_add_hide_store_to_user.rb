class AddHideStoreToUser < ActiveRecord::Migration
  def change
    add_column :users, :hide_store, :boolean
  end
end
