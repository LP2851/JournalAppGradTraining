class UsersController < ApplicationController

  def new
    if helpers.logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def create
    if user_params && !User.find_by(username: user_params[:username]).nil?
      redirect_to new_user_path, notice: "Username already exists"
    else
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path
      else
        render :new
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end