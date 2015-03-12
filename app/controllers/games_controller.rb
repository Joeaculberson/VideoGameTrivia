class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  before_filter :require_login

  def promote

  end

  # GET /games
  # GET /games.json
  def index
    if current_user.role.nil? || current_user.role.blank?
      current_user.role = 'Player'
      current_user.save
    end
    @opponent_turn_games = Game.where("user_email = ? OR opponent_user_email = ?", current_user.email, current_user.email).where.not(:user_turn_email => current_user.email).where("user_pieces != '1 2 3 4 5 6' AND opponent_pieces != '1 2 3 4 5 6'")
    @user_turn_games = Game.where(:user_turn_email => current_user.email).where("user_pieces != '1 2 3 4 5 6' AND opponent_pieces != '1 2 3 4 5 6'")
    @past_games = Game.where("user_email = ? OR opponent_user_email = ?", current_user.email, current_user.email).where("user_pieces = '1 2 3 4 5 6' OR opponent_pieces = '1 2 3 4 5 6'")
  end

  def chosen_category
    session[:chosen_category] = params[:chosen_category]
    render js: "window.location = '#{challenge_url}'"
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
  end

  def assess_answer
    @game = Game.find session[:current_game]['id']
    if session[:answered_correctly] == "true"
      @game.user_meter = @game.user_meter + 1
      session[:answered_correctly] = false

      if @game.user_meter == 4
        if session[:chosen_category].eql? 'action'
          @game.user_pieces << ' 1'
        elsif session[:chosen_category].eql? 'adventure'
          @game.user_pieces << ' 2'
        elsif session[:chosen_category].eql? 'arcade'
          @game.user_pieces << ' 3'
        elsif session[:chosen_category].eql? 'fps'
          @game.user_pieces << ' 4'
        elsif session[:chosen_category].eql? 'racing'
          @game.user_pieces << ' 5'
        elsif session[:chosen_category].eql? 'role-playing'
          @game.user_pieces << ' 6'
        end
        @game.user_pieces.lstrip!
        @game.user_meter = 0
        session[:chosen_category] = ''
      end
      @game.save!
      redirect_to '/games/' + session[:current_game]['id'].to_s
    else
      if @game.user_email.eql? current_user.email
        @game.user_turn_email = @game.opponent_user_email
        @game.user_email,@game.opponent_user_email = @game.opponent_user_email,@game.user_email
        @game.user_pieces,@game.opponent_pieces = @game.opponent_pieces,@game.user_pieces
        @game.user_meter,@game.opponent_meter = @game.opponent_meter,@game.user_meter
      end
      @game.save!
      redirect_to games_path
    end
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
