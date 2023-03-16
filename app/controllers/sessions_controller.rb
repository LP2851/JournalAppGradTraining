class SessionsController < ApplicationController

  def create
    @user = User.find_by(username: params[:username])

    if !!@user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to login_path, notice: "Invalid username/password"
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end