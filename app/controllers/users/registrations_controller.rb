class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @user = build_resource # Needed for Merit
    super
  end

  def destroy
    Statistic.find_by(email: current_user.email).destroy
    Game.where('user_email = ? OR opponent_user_email = ?', current_user.email, current_user.email).destroy_all
    super
  end

  def update
    @user = resource # Needed for Merit
    super
  end

end