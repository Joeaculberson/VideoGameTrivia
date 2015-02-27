class AddSubmitterToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :submitter, :string
  end
end
