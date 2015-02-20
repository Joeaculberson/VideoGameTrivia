class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  before_filter :require_login

  # GET /games
  # GET /games.json
  def index
    #Also needs to be checking if the game is over, currently is not.
    @opponent_turn_games = Game.where(:user_email => current_user.email).where.not(:user_turn_email => current_user.email)
    #Also needs to be checking if the game is over, currently is not.
    @user_turn_games = Game.where(:user_email => current_user.email).where(:user_turn_email => current_user.email)
    #This query isn't working for some reason.
    @past_games = Game.where(:user_email => current_user.email).where(:opponent_pieces.to_s.split == 6, :user_pieces.to_s.split == 6)
  end

  # GET /games/1
  # GET /games/1.json
  def show
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
    @game = Game.new(game_params)
    @game.user_email = current_user.email
    @game.user_pieces = ''
    @game.opponent_pieces = ''
    @game.round = 0
    @game.user_turn_email = current_user.email

    respond_to do |format|
      if @game.save
        format.html { redirect_to games_url, notice: 'Game was successfully created against: ' + @game.opponent_user_email }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
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
