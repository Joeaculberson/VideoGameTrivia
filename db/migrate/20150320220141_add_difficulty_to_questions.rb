class AddDifficultyToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :difficulty, :integer, default: 25
  end
end
