class AddCorrectAnswersInARowToUser < ActiveRecord::Migration
  def change
    add_column :users, :correct_answers_in_a_row, :integer
  end
end
