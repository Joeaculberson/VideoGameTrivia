class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_filter :require_login
  autocomplete :user, :email

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
      current_user.correct_answers_in_a_row = 0
      current_user.save
    end

    if Statistic.where(:email => current_user.email).blank?
      Statistic.create email: current_user.email, action_correct: 0, action_total: 0, adventure_correct: 0, adventure_total: 0, arcade_correct: 0, arcade_total: 0, fps_correct: 0, fps_total: 0, racing_correct: 0, racing_total: 0, role_playing_correct: 0, role_playing_total: 0, wins: 0, loses: 0
    end

    @opponent_turn_games = Game.where('user_email = ? OR opponent_user_email = ?', current_user.email, current_user.email).where.not(:user_turn_email => current_user.email).where(:is_game_over => false)
    @user_turn_games = Game.where(:user_turn_email => current_user.email).where(:is_game_over => false)
    @past_games = Game.where('user_email = ? OR opponent_user_email = ?', current_user.email, current_user.email).where(:is_game_over => true)
  end

  def spun_category
    session[:spun_category] = params[:spun_category]
    render js: "window.location = '#{questions_url}'"
  end

  def chosen_category
    session[:chosen_category] = params[:chosen_category]
    render js: "window.location = '#{challenge_url}'"
  end

  def steal_piece_settings
    session[:chosen_category] = params[:chosen_category]
    session[:bet_piece] = params[:bet_piece]
    render js: "window.location = '#{steal_piece_url}'"
  end

  def resign
    @game = Game.find session[:current_game_id]
    @user = current_user
    opponent = User.find_by(email: @game.opponent_user_email)
    opponent.coins += 5
    opponent.save!
    end_turn
    @game.is_game_over = true
    @game.save!
    redirect_to games_path
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @categories = ['action', 'adventure', 'arcade', 'fps', 'racing', 'role-playing']
    if @game.nil?
      @game = Game.find session[:current_game_id]
    end
    if session[:question_viewed] && @game.steal_question_ids.eql?('')
      session[:question_viewed] = false
      end_turn
      redirect_to games_path
    else
      @current_opponent = User.find_by email: @game.opponent_user_email
      @game.save!
      session[:current_game_id] = @game.id
      if !@game.steal_question_ids.eql? ''
        flash[:notice] = 'You opponent is trying to steal your ' + @game.bet_piece + ' piece. Answer more than ' + @game.opponent_steal_correct.to_s + ' question(s) correct to fend off the opponent.'
        redirect_to steal_piece_path
      end
      @won_games = Game.where(:user_email => current_user.email).where(:opponent_user_email => @current_opponent.email).where(:is_game_over => true)
      @lost_games = Game.where(:opponent_user_email => current_user.email).where(:user_email => @current_opponent.email).where(:is_game_over => true)
    end
  end

  def assess_answer
    @game = Game.find session[:current_game_id]
    @user = current_user
    @question = Question.find params[:question_id]
    session[:question_viewed] = false

    add_to_total_stat

    if !session[:steal_question_counter].blank?
      session[:steal_question_counter] += 1
    end

    if params[:answered_correctly] == "true"
      process_correct_answer
    else
      process_wrong_answer
    end

    set_question_difficulty
    @question.save!
  end

  def set_question_difficulty
    if (@question.difficulty > 39)
      @question.difficulty = 39
    elsif (@question.difficulty < 10)
      @question.difficulty = 10
    end
  end

  def process_correct_steal_turn
    @game.user_steal_correct += 1
    @game.save!

    if session[:steal_question_counter] == 6
      if @game.is_second_steal_turn
        if @game.user_steal_correct == @game.opponent_steal_correct
          process_tie_breaker
        elsif @game.user_steal_correct < @game.opponent_steal_correct
          give_piece_to_opponent @game.wanted_piece
        else
          award_piece @game.bet_piece
          remove_opponent_piece @game.bet_piece
          end_steal
          flash[:notice] = "Congrats! You stole the " + @game.bet_piece + " piece from your opponent."
          redirect_to game_path @game
        end
      else
        end_attacker_steal_turn
      end
    elsif session[:steal_question_counter] == 7
      remove_opponent_piece @game.bet_piece
      flash[:notice] = "Congrats! You sent your opponent's " + @game.bet_piece + " piece to the void!"
      end_steal
      redirect_to game_path @game
    else
      if @game.is_second_steal_turn && (@game.user_steal_correct > @game.opponent_steal_correct)
        flash[:notice] = 'Congrats, you successfully defended yourself and stole your opponents ' + @game.bet_piece + ' piece.'
        end_steal
        redirect_to game_path @game
      else
        redirect_to question_path @game.steal_question_ids.split[session[:steal_question_counter]]
      end
    end
  end

  def process_tie_breaker
    flash[:notice] = 'Tie breaker! Answer this correctly or else the opponent will steal your ' + @game.wanted_piece + ' piece.'
    @game.is_tie_breaker = true
    @game.save!
    redirect_to Question.where(:is_authorized => true).sample
  end

  def end_steal
    @game.is_second_steal_turn = false
    @game.bet_piece = ''
    @game.wanted_piece = ''
    @game.steal_question_ids = ''
    @game.is_tie_breaker = false
    @game.opponent_steal_correct = 0
    @game.user_steal_correct = 0
    @game.save!
    (0..session[:steal_question_counter].to_i).each do |i|
      session['steal_question_' + i.to_s + '_viewed'] = false
    end
    session[:steal_question_counter] = nil
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
    if @question.category.eql? 'action'
      statistic.action_correct += 1
    elsif @question.category.eql? 'adventure'
      statistic.adventure_correct += 1
    elsif @question.category.eql? 'arcade'
      statistic.arcade_correct += 1
    elsif @question.category.eql? 'fps'
      statistic.fps_correct += 1
    elsif @question.category.eql? 'racing'
      statistic.racing_correct += 1
    elsif @question.category.eql? 'role-playing'
      statistic.role_playing_correct += 1
    end
    statistic.save!
  end

  def add_to_total_stat
    statistic = Statistic.find_by email: @game.user_email
    if @question.category.eql? 'action'
      statistic.action_total += 1
    elsif @question.category.eql? 'adventure'
      statistic.adventure_total += 1
    elsif @question.category.eql? 'arcade'
      statistic.arcade_total += 1
    elsif @question.category.eql? 'fps'
      statistic.fps_total += 1
    elsif @question.category.eql? 'racing'
      statistic.racing_total += 1
    elsif @question.category.eql? 'role-playing'
      statistic.role_playing_total += 1
    end
    statistic.save!
  end

  def end_turn
    session[:question_viewed] = false
    @game.round = @game.round + 1
    if(current_user.level > 0)
      current_user.level -= 1
    end

    if @game.user_meter == 3
      @game.user_meter = 0
    end
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
    if @game.user_pieces.eql? '1 2 3 4 5 6'
      @game.is_game_over = true
      user_stats = Statistic.find_by(email: current_user.email)
      user_stats.wins += 1
      user_stats.save!

      opponent_stats = Statistic.find_by(email: @game.opponent_user_email)
      opponent_stats.loses += 1
      opponent_stats.save!
    end
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
      if params[:game][:opponent_user_email].eql? current_user.email
        flash[:alert] = 'Cannot play against yourself.'
        redirect_to games_url
      else
        @game = Game.new(game_params)
        initialize_game @game
      end
    end
  end

  def random_game
    rand_user = User.where.not(:id => current_user.id).sample
    award_badge(5)
    @game = Game.new
    @game.opponent_user_email = rand_user.email
    initialize_game @game
  end

  def coin_store

  end

  def leaderboard
    @times = ['weekly', 'monthly']
    @categories = ['action', 'adventure', 'arcade', 'fps', 'racing', 'role_playing']
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

  def end_attacker_steal_turn
    if @game.nil?
      @game = Game.find session[:current_game_id]
    end
    flash[:notice] = 'You got ' + @game.user_steal_correct.to_s + ' out of 6 questions correct. It is now your opponents turn.'
    session[:steal_question_counter] == 0
    @game.is_second_steal_turn = true
    end_turn
    (0..6).each do |i|
      session['steal_question_' + i.to_s + '_viewed'] = false
    end
    redirect_to games_path
  end

  def process_wrong_answer
    if @game.nil?
      @game = Game.find session[:current_game_id]
      session[:steal_question_counter] = 6

      (0..5).each do |i|
        session['steal_question_' + i.to_s + '_viewed'] = false
      end
    else
      @question.difficulty += 1
    end

    if !@game.steal_question_ids.eql? ''
      if @game.is_second_steal_turn
        if @game.user_steal_correct == @game.opponent_steal_correct
          if @game.is_tie_breaker
            give_piece_to_opponent @game.wanted_piece
          else
            if session[:steal_question_counter] == 6
              process_tie_breaker
            else
              redirect_to question_path Question.find(@game.steal_question_ids.split[session[:steal_question_counter]])
            end
          end
          #If it is impossible for the defender to win the steal, end the steal
        elsif @game.opponent_steal_correct > (@game.user_steal_correct + (6 - session[:steal_question_counter]))
          flash[:alert] = 'It became impossible for you to win. '
          give_piece_to_opponent @game.wanted_piece
        else
          if session[:steal_question_counter] == 6
            give_piece_to_opponent @game.wanted_piece
          else
            redirect_to question_path Question.find(@game.steal_question_ids.split[session[:steal_question_counter]])
          end
        end
      else
        if session[:steal_question_counter] == 6
          end_attacker_steal_turn
        else
          redirect_to question_path Question.find(@game.steal_question_ids.split[session[:steal_question_counter]])
        end
      end
    else
      end_turn
      redirect_to games_path
    end
  end

  private
  def process_correct_answer
    @question.difficulty -= 1
    add_to_partial_stat
    current_user.level += (@question.difficulty / 10)

    if current_user.correct_answers_in_a_row.nil?
      current_user.correct_answers_in_a_row = 0
    end

    current_user.correct_answers_in_a_row = current_user.correct_answers_in_a_row + 1
    award_badges_if_earned
    handle_user_level_and_role

    @user.save!

    if !@game.steal_question_ids.eql? ''
      process_correct_steal_turn
    else
      @game.user_meter = @game.user_meter + 1
      if @game.user_meter == 4
        award_piece @question.category
        @game.user_meter = 0
      end
      @game.save!
      current_user.save!
      redirect_to game_path session[:current_game_id]
    end
  end

  def handle_user_level_and_role
    if (@user.level < 0)
      @user.level = 0
    end

    if ((@user.level / 10) + 1 > 10)
      if @user.role != 'Admin'
        @user.role = 'Reviewer'
      end
    end
  end

  def award_badges_if_earned
    if current_user.correct_answers_in_a_row == 5
      award_badge(3)
    end

    if Statistic.find_by(email: current_user.email).fps_correct == 20
      award_badge(4)
    end
  end

  def give_piece_to_opponent piece
    remove_piece piece
    award_opponent_piece piece
    if flash[:alert].blank?
      flash[:alert] = 'Oh no! You lost your ' + piece + ' piece to the opponent.'
    else
      flash[:alert] += ' You lost your ' + piece + ' piece to the opponent.'
    end

    end_steal
    if @game.opponent_pieces.eql? '1 2 3 4 5 6'
      flash[:alert] += ' You lose the game.'
      end_turn
      (0..session[:steal_question_counter].to_i).each do |i|
        session['steal_question_' + i.to_s + '_viewed'] = false
      end
      redirect_to games_path
    else
      redirect_to game_path @game
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  def initialize_game game
    game.user_email = current_user.email
    game.user_pieces = ''
    game.opponent_pieces = ''
    game.round = 0
    game.user_turn_email = current_user.email
    game.user_meter = 0
    game.opponent_meter = 0
    game.steal_question_ids = ''
    game.user_steal_correct = 0
    game.opponent_steal_correct = 0
    game.is_second_steal_turn = false
    game.bet_piece = ''
    game.wanted_piece = ''
    game.is_game_over = false

    respond_to do |format|
      if game.save
        format.html { redirect_to games_url }
        if flash[:notice].blank?
          flash[:notice] = 'Game was successfully created against: ' + game.opponent_user_email
        else
          flash[:notice] += ' Game was successfully created against: ' + game.opponent_user_email
        end
      else
        format.html { render :new }
        format.json { render json: game.errors, status: :unprocessable_entity }
      end
    end
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
      if flash[:notice].blank?
        flash[:notice] = Merit::Badge.find(id).name + ' achievement earned.'
      else
        flash[:notice] += ' ' + Merit::Badge.find(id).name + ' achievement earned.'
      end

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
