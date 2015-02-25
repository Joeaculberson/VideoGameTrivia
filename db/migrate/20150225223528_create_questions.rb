class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :question_text
      t.text :correct_answer
      t.text :incorrect_answer_1
      t.text :incorrect_answer_2
      t.text :incorrect_answer_3
      t.string :category

      t.timestamps null: false
    end
  end
end
