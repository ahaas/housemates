# Andre Haas

class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  layout 'basic'

  include UsersHelper

  def new
    if logged_in?
      redirect_to homepage_for(current_user)
      return
    end
    @user = User.new
    render 'new'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Housemates!"
      redirect_to homepage_for(@user)
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
