require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  setup do
    @question = questions(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @question
    assert_response :success
  end

  test "should update question" do
    patch :update, id: @question, question: { category: @question.category, correct_answer: @question.correct_answer, incorrect_answer_1: @question.incorrect_answer_1, incorrect_answer_2: @question.incorrect_answer_2, incorrect_answer_3: @question.incorrect_answer_3, question_text: @question.question_text }
    assert_redirected_to question_path(assigns(:question))
  end

  test "should destroy question" do
    assert_difference('Question.count', -1) do
      delete :destroy, id: @question
    end

    assert_redirected_to questions_path
  end
end
