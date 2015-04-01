class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    @user = user
    if user.persisted?
      if user.role.nil? || user.role.blank?
        user.role = 'Player'
        user.correct_answers_in_a_row = 0
        user.save
      end
      sign_in_and_redirect user, notice: "Signed in!"
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :facebook, :all
  alias_method :google_oauth2, :all

  def update
    @user = resource # Needed for Merit
    super
  end

end
