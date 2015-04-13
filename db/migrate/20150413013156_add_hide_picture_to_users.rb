class AddHidePictureToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hide_picture, :boolean, default: false
  end
end
