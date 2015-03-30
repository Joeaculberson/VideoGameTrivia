class AddExperienceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experience, :integer, default: 0
  end
end
