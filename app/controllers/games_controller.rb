class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  before_filter :require_login

  def promote

  end

  # GET /games
  # GET /games.json
  def index
    @user = current_user # Needed for Merit

    if current_user.badges.size == 0
      award_badge(1)
    end


    if current_user.sign_in_count == 5
      award_badge(2)
    end

    if current_user.role.nil? || current_user.role.blank?
      current_user.role = 'Player'
      current_user.save
    end

    if Statistic.where(:email => current_user.email).blank?
      Statistic.create email: current_user.email, action_correct: 0, action_total: 0, adventure_correct: 0, adventure_total: 0, arcade_correct: 0, arcade_total: 0, fps_correct: 0, fps_total: 0, racing_correct: 0, racing_total: 0, role_playing_correct: 0, role_playing_total: 0
    end

    @opponent_turn_games = Game.where("user_email = ? OR opponent_user_email = ?", current_user.email, current_user.email).where.not(:user_turn_email => current_user.email).where("user_pieces != '1 2 3 4 5 6' AND opponent_pieces != '1 2 3 4 5 6'")
    @user_turn_games = Game.where(:user_turn_email => current_user.email).where("user_pieces != '1 2 3 4 5 6' AND opponent_pieces != '1 2 3 4 5 6'")
    @past_games = Game.where("user_email = ? OR opponent_user_email = ?", current_user.email, current_user.email).where("user_pieces = '1 2 3 4 5 6' OR opponent_pieces = '1 2 3 4 5 6'")
  end

  def chosen_category
    session[:chosen_category] = params[:chosen_category]
    render js: "window.location = '#{challenge_url}'"
  end

  def steal_piece_settings
    session[:chosen_category] = params[:chosen_category]
    session[:bet_piece] = params[:bet_piece]
    session[:type] = params[:type]
    render js: "window.location = '#{steal_piece_url}'"
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if @game.nil?
      @game = Game.find session[:current_game]['id']
    end
    @current_opponent = User.find_by email: @game.opponent_user_email
    @game.save!
    session[:current_game] = @game
    if !@game.steal_question_ids.eql? ''
      redirect_to steal_piece_path
    end
  end


  def assess_answer
    @game = Game.find session[:current_game]['id']
    @user = User.find_by(email: @game.user_email)

    add_to_total_stat

    if session[:answered_correctly] == "true"
      @user.level += (session[:question_difficulty] / 10)

      if current_user.correct_answers_in_a_row.nil?
        current_user.correct_answers_in_a_row = 0
      end

      current_user.correct_answers_in_a_row = current_user.correct_answers_in_a_row + 1

      if current_user.correct_answers_in_a_row == 5
        award_badge(3)
      end

      add_to_partial_stat

      if(@user.level < 0)
        @user.level = 0
      end
      if((@user.level / 10) + 1 > 10)
        @user.role = "Reviewer"
      end

      @user.save

      if !@game.steal_question_ids.eql? ''
        process_steal_turn
      else
        @game.user_meter = @game.user_meter + 1
        if @game.user_meter == 4
          award_piece session[:chosen_category]
          session[:chosen_category] = ''
          @game.user_meter = 0
        end
        @game.save!
        current_user.save!
        redirect_to '/games/' + session[:current_game]['id'].to_s
      end
    else
      if !@game.steal_question_ids.eql? ''
        if @game.is_second_steal_turn
          if @game.user_steal_correct == @game.opponent_steal_correct
            flash[:notice] = "Game is a tie, no one wins or loses a piece."
            @game.save!
          else
            flash[:alert] = 'You lose the challenge! Opponent successfully the ' + @game.wanted_piece + ' piece.'
            remove_piece @game.wanted_piece
            award_opponent_piece @game.wanted_piece
            @game.save!
          end
          @game.user_steal_correct = 0
          @game.opponent_steal_correct = 0
          @game.steal_question_ids = ''
          @game.is_second_steal_turn = false
          @game.bet_piece = ''
          @game.wanted_piece = ''
          @game.save!
          redirect_to '/games/' + session[:current_game]['id'].to_s
        else
          @game.is_second_steal_turn = true
          @game.user_meter = 0
          @game.save!
          end_turn
          redirect_to games_path
        end
      else
        @game.user_meter = 0
        @game.save!
        end_turn
        redirect_to games_path
      end

    end
  end

  def process_steal_turn
    @game.user_steal_correct += 1
    @game.save!

    if @game.user_steal_correct > @game.opponent_steal_correct && @game.is_second_steal_turn
      @game.is_second_steal_turn = false


      award_piece @game.bet_piece
      remove_opponent_piece @game.bet_piece

      flash[:notice] = 'You won the challenge! ' + @game.opponent_user_email + ' surrenders the ' + @game.bet_piece + ' piece.'
      session[:chosen_category] = ''
      @game.user_steal_correct = 0
      @game.opponent_steal_correct = 0
      @game.opponent_meter = 0
      @game.steal_question_ids = ''
      @game.bet_piece = ''
      @game.wanted_piece = ''
      @game.save!
      redirect_to '/games/' + session[:current_game]['id'].to_s
    elsif @game.user_steal_correct == 6
      if @game.is_second_steal_turn
        flash[:notice] = "Game is a tie, no one wins or loses a piece."
        @game.user_steal_correct = 0
        @game.opponent_steal_correct = 0
        @game.steal_question_ids = ''
        @game.is_second_steal_turn = false
        @game.bet_piece = ''
        @game.wanted_piece = ''
        @game.save!
        redirect_to '/games/' + session[:current_game]['id'].to_s
      else
        flash[:notice] = "You have answered 6 questions correctly, it is now your opponent's turn."
        @game.user_meter = 0
        @game.is_second_steal_turn = true
        @game.save!
        end_turn
        redirect_to games_path
      end

    else
      rand_question = Question.all.sample
      question_ids = @game.steal_question_ids.split
      if @game.is_second_steal_turn
        redirect_to Question.find(question_ids[@game.user_steal_correct].to_i)
      else
        @game.steal_question_ids += ' ' + rand_question.id.to_s
        @game.steal_question_ids.strip!
        @game.save!
        redirect_to rand_question
      end

    end
  end

  def remove_piece category
    if category.eql? 'action'
      @game.user_pieces = @game.user_pieces.delete('1').strip
    elsif category.eql? 'adventure'
      @game.user_pieces = @game.user_pieces.delete('2').strip
    elsif category.eql? 'arcade'
      @game.user_pieces = @game.user_pieces.delete('3').strip
    elsif category.eql? 'fps'
      @game.user_pieces = @game.user_pieces.delete('4').strip
    elsif category.eql? 'racing'
      @game.user_pieces = @game.user_pieces.delete('5').strip
    elsif category.eql? 'role-playing'
      @game.user_pieces = @game.user_pieces.delete('6').strip
    end
    @game.save!
  end

  def remove_opponent_piece category
    if category.eql? 'action'
      @game.opponent_pieces = @game.opponent_pieces.delete('1').strip
    elsif category.eql? 'adventure'
      @game.opponent_pieces = @game.opponent_pieces.delete('2').strip
    elsif category.eql? 'arcade'
      @game.opponent_pieces = @game.opponent_pieces.delete('3').strip
    elsif category.eql? 'fps'
      @game.opponent_pieces = @game.opponent_pieces.delete('4').strip
    elsif category.eql? 'racing'
      @game.opponent_pieces = @game.opponent_pieces.delete('5').strip
    elsif category.eql? 'role-playing'
      @game.opponent_pieces = @game.opponent_pieces.delete('6').strip
    end
    @game.save!
  end

  def add_to_partial_stat
    statistic = Statistic.find_by email: @game.user_email
    if session[:question_category].eql? 'action'
      statistic.action_correct = statistic.action_correct + 1
    elsif session[:question_category].eql? 'adventure'
      statistic.adventure_correct = statistic.adventure_correct + 1
    elsif session[:question_category].eql? 'arcade'
      statistic.arcade_correct = statistic.arcade_correct + 1
    elsif session[:question_category].eql? 'fps'
      statistic.fps_correct = statistic.fps_correct + 1
    elsif session[:question_category].eql? 'racing'
      statistic.racing_correct = statistic.racing_correct + 1
    elsif session[:question_category].eql? 'role-playing'
      statistic.role_playing_correct = statistic.role_playing_correct + 1
    end
    statistic.save!
  end

  def add_to_total_stat
    statistic = Statistic.find_by email: @game.user_email
    if session[:question_category].eql? 'action'
      statistic.action_total = statistic.action_total + 1
    elsif session[:question_category].eql? 'adventure'
      statistic.adventure_total = statistic.adventure_total + 1
    elsif session[:question_category].eql? 'arcade'
      statistic.arcade_total = statistic.arcade_total + 1
    elsif session[:question_category].eql? 'fps'
      statistic.fps_total = statistic.fps_total + 1
    elsif session[:question_category].eql? 'racing'
      statistic.racing_total = statistic.racing_total + 1
    elsif session[:question_category].eql? 'role-playing'
      statistic.role_playing_total = statistic.role_playing_total + 1
    end
    statistic.save!
  end

  def end_turn
    @game.round = @game.round + 1
    @user.level -= 1
    current_user.correct_answers_in_a_row = 0
    if @game.user_email.eql? current_user.email
      @game.user_turn_email = @game.opponent_user_email
      @game.user_email,@game.opponent_user_email = @game.opponent_user_email,@game.user_email
      @game.user_pieces,@game.opponent_pieces = @game.opponent_pieces,@game.user_pieces
      @game.user_meter,@game.opponent_meter = @game.opponent_meter,@game.user_meter
      @game.user_steal_correct,@game.opponent_steal_correct = @game.opponent_steal_correct,@game.user_steal_correct
    end
    @game.save!
    current_user.save!
  end

  def award_piece category
    if category.eql? 'action'
      @game.user_pieces << ' 1'
    elsif category.eql? 'adventure'
      @game.user_pieces << ' 2'
    elsif category.eql? 'arcade'
      @game.user_pieces << ' 3'
    elsif category.eql? 'fps'
      @game.user_pieces << ' 4'
    elsif category.eql? 'racing'
      @game.user_pieces << ' 5'
    elsif category.eql? 'role-playing'
      @game.user_pieces << ' 6'
    end
    @game.user_pieces.lstrip!
    sorted_pieces = @game.user_pieces.split.sort
    @game.user_pieces = sorted_pieces.join(' ')
  end

  def award_opponent_piece category
    if category.eql? 'action'
      @game.opponent_pieces << ' 1'
    elsif category.eql? 'adventure'
      @game.opponent_pieces << ' 2'
    elsif category.eql? 'arcade'
      @game.opponent_pieces << ' 3'
    elsif category.eql? 'fps'
      @game.opponent_pieces << ' 4'
    elsif category.eql? 'racing'
      @game.opponent_pieces << ' 5'
    elsif category.eql? 'role-playing'
      @game.opponent_pieces << ' 6'
    end
    @game.opponent_pieces.lstrip!
    sorted_pieces = @game.opponent_pieces.split.sort
    @game.opponent_pieces = sorted_pieces.join(' ')
    @game.save!
  end


  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games
  # POST /games.json
  def create
    if User.find_by(email: params[:game][:opponent_user_email]).blank?
      flash[:alert] = 'Could not find user ' + params[:game][:opponent_user_email]
      redirect_to games_url
    else
      @game = Game.new(game_params)
      @game.user_email = current_user.email
      @game.user_pieces = ''
      @game.opponent_pieces = ''
      @game.round = 0
      @game.user_turn_email = current_user.email
      @game.user_meter = 0
      @game.opponent_meter = 0
      @game.steal_question_ids = ''
      @game.user_steal_correct = 0
      @game.opponent_steal_correct = 0
      @game.is_second_steal_turn = false
      @game.bet_piece = ''
      @game.wanted_piece = ''

      respond_to do |format|
        if @game.save
          format.html { redirect_to games_url, notice: 'Game was successfully created against: ' + @game.opponent_user_email }
        else
          format.html { render :new }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def award_badge(id)
    has_badge = false
    current_user.badges.each do |badge|
      if badge.id == id
        has_badge = true
      end
    end

    if has_badge == false
      current_user.add_badge(id)
      flash.now[:notice] = Merit::Badge.find(id).name + ' achievement earned.'
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def game_params
    params.require(:game).permit(:user_email, :opponent_user_email, :user_pieces, :opponent_pieces, :round, :user_turn_email)
  end

  def require_login
    unless current_user
      redirect_to '/users/sign_in'
    end
  end
end
