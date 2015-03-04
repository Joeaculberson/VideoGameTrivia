class AddIsAuthorizedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_authorized, :boolean
  end
end
