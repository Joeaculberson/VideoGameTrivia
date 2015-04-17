class User < ActiveRecord::Base
  has_merit

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.image = auth.info.image
      user.role = 'Player'
      user.correct_answers_in_a_row = 0

      Statistic.create email: user.email, action_correct: 0, action_total: 0, adventure_correct: 0, adventure_total: 0, arcade_correct: 0, arcade_total: 0, fps_correct: 0, fps_total: 0, racing_correct: 0, racing_total: 0, role_playing_correct: 0, role_playing_total: 0, wins: 0, loses: 0

      user.skip_confirmation!
      user.save(:validate => false)
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
end

  def get_games_won_monthly
      Game.where(:user_email => self.email).where(:is_game_over => true).where("created_at > ?", 1.month.ago).size
  end

  def get_games_won_weekly
    Game.where(:user_email => self.email).where(:is_game_over => true).where("created_at > ?", 1.week.ago).size
  end

end
