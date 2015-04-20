class UsersController < ApplicationController
  def promote
    @user = User.new
  end

  def update
    if User.find_by(email: params[:user][:email]).blank?
      flash[:notice] = 'Could not find ' + params[:user][:email] + '.'
    else
      user = User.find_by(email: params[:user][:email])
      user.role = params[:user][:role]
      user.save

      flash[:notice] = user.email + ' was successfully changed to ' + params[:user][:role] + '.'
    end

    redirect_to root_url
  end

  def update_profile
    if params[:user]['location']
      current_user.location = params[:user]['location']
      flash[:notice] = 'Location successfully set.'
    elsif params[:user]['security_question'] && params[:user]['security_question']
      current_user.security_question = params[:user]['security_question']
      current_user.security_answer = params[:user]['security_answer']
      flash[:notice] = 'Security question successfully set.'
    elsif params[:user]['security_answer']
      if params[:user]['security_answer'].eql? current_user.security_answer
        current_user.hide_store = false
      else
        flash[:error] = 'Incorrect password. Please try again.'
      end
    end

    current_user.save!
    redirect_to edit_user_registration_path
  end

  def sound_on
    current_user.sound = true
    current.user.save
    redirect_to edit_user_registration_path
  end

  def sound_off
    current_user.sound = false
    current.user.save
    redirect_to edit_user_registration_path
  end

  def hide_picture
    current_user.hide_picture = true
    current_user.save
    redirect_to edit_user_registration_path
  end

  def show_picture
    current_user.hide_picture = false
    current_user.save
    redirect_to edit_user_registration_path
  end

  def hide_email
    current_user.hide_email = true
    current_user.save
    redirect_to edit_user_registration_path
  end

  def show_email
    current_user.hide_email = false
    current_user.save
    redirect_to edit_user_registration_path
  end

  def hide_location
    current_user.hide_location = true
    current_user.save
    redirect_to edit_user_registration_path
  end

  def show_location
    current_user.hide_location = false
    current_user.save
    redirect_to edit_user_registration_path
  end

  def hide_store
    current_user.hide_store = true
    current_user.save
    redirect_to edit_user_registration_path
  end

  def show_store
    current_user.hide_store = false
    current_user.save
    redirect_to edit_user_registration_path
  end

end