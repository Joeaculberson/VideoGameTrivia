json.array!(@questions) do |question|
  json.extract! question, :id, :question_text, :correct_answer, :incorrect_answer_1, :incorrect_answer_2, :incorrect_answer_3, :category
  json.url question_url(question, format: :json)
end
