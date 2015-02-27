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
end