class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy, :accept_review]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
    random_wheel_spin = session[:spun_category]
    @game = Game.find(session[:current_game_id])
    if random_wheel_spin.eql? 'challenge'
      @game.user_meter = 3
      @game.save!
      redirect_to game_path(@game)
    else
      categoryQuestions = Question.where(:category => random_wheel_spin).where(:is_authorized => 't').order("RANDOM()")
      userDifficutly = 3;

      if((current_user.level / 10) + 1 < 20)
        userDifficutly = 2;
      end
      if((current_user.level / 10) + 1 < 10)
        userDifficutly = 1;
      end

      if(categoryQuestions.first.difficulty != userDifficutly)
        categoryQuestions = categoryQuestions.order("RANDOM()")
      end
      redirect_to categoryQuestions.first
    end
  end

  def challenge
    redirect_to Question.where(:category => session[:chosen_category]).order("RANDOM()").first
  end

  def steal_piece
    session[:is_in_steal] = true
    session[:steal_question_counter] = 0
    @game = Game.find(session[:current_game_id])
    @game.bet_piece = session[:bet_piece]
    @game.wanted_piece = session[:chosen_category]

    if !@game.steal_question_ids.eql? ''
      @game.is_second_steal_turn = true
      redirect_to Question.find(@game[:steal_question_ids].split[0].to_i)
    else
      categories = ['action', 'adventure', 'arcade', 'fps', 'racing', 'role-playing']
      rand_questions = ''
      categories.each do |category|
        rand_questions += Question.where(:category => category).where(:is_authorized => 't').sample.id.to_s + ' '
      end
      rand_questions.rstrip!

      @game.steal_question_ids = rand_questions
      @game.save!
      redirect_to Question.find(rand_questions.split[session[:steal_question_counter]])
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    if !session[:current_game_id].blank?
      @game = Game.find session[:current_game_id]
      if @game.user_turn_email != current_user.email
        redirect_to games_path
      end
      if session[:question_viewed] && @game.steal_question_ids.eql?('')
        redirect_to games_path
      else
        session[:question_viewed] = true
        if @game.is_second_steal_turn && @game.user_steal_correct < 0
          flash[:alert] = 'Your opponent is trying to steal your ' + @game.wanted_piece + ' piece. Defend yourself!'
        end
      end

      if session['steal_question_' + session[:steal_question_counter].to_s + '_viewed'] && @game.is_second_steal_turn == false
        redirect_to end_attacker_steal_turn_path
      elsif session['steal_question_' + session[:steal_question_counter].to_s + '_viewed'] && @game.is_second_steal_turn
        redirect_to process_wrong_answer_path
      end

      if !@game.steal_question_ids.eql? ''
        session['steal_question_' + session[:steal_question_counter].to_s + '_viewed'] = true
      end
    end

    @answer_choices = [@question.correct_answer, @question.incorrect_answer_1, @question.incorrect_answer_2, @question.incorrect_answer_3]
    @answer_choices.shuffle!
  end

  def accept_review
    @question.is_authorized = params[:is_accepted]
    if @question.is_authorized
      flash[:notice] = 'Question was successfully accepted.'
    else
      @question.destroy
      flash[:notice] = 'Question was successfully rejected.'
    end

    @question.save
    redirect_to show_review_path
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        @question.submitter = current_user.email
        if current_user.role == 'Admin' || current_user.role == 'Reviewer'
          @question.is_authorized = true
          @question.save
          format.html { redirect_to games_url, notice: 'Question was successfully submitted.' }
        elsif current_user.role == 'Player'
          @question.is_authorized = false
          @question.save
          format.html { redirect_to games_url, notice: 'Question was successfully submitted for review.' }
        end
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  def show_review
    @questions = Question.where(:is_authorized => false)
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def pay
    current_user.coins -= params[:amount].to_i
    current_user.save!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:question_text, :correct_answer, :incorrect_answer_1, :incorrect_answer_2, :incorrect_answer_3, :category)
    end
end
