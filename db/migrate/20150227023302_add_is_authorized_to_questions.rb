class AddIsAuthorizedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :is_authorized, :string
  end
end
