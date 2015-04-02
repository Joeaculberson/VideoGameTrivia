class AddAnotherColumnToGame < ActiveRecord::Migration
  def change
    add_column :games, :steal_question_ids, :string
  end
end
