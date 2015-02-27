class ChangeDataTypeForIsAuthorized < ActiveRecord::Migration
  def self.up
    change_table :questions do |t|
      t.change :is_authorized, :boolean
    end
  end
end
