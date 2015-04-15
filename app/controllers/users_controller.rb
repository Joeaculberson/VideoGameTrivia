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

  def add_location
    current_user.location = params[:user]['location']
    current_user.save!
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