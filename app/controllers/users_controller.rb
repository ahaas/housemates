# Andre Haas

class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :forget_password, :reset_create, :reset, :reset_password]
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

  def reset_create
    user = User.find_by(email: params[:email])
    if user != nil
      # set token here
      user.create_reset_digest
      user.send_password_reset_email
    end
    redirect_to signup_path
  end

  def reset
    @token = params[:token]
    @email = params[:email]
    @user = User.find_by(email: @email, reset_digest: @token)
  end
    
  def reset_password
    @token = params[:token]
    @password = params[:password]
    @password_confirmation = params[:password_confirmation]
    @user = User.find_by(email: params[:email])
    @res = @user.reset_password(
      @token, @password, @password_confirmation)
    if @res == -1
      flash[:danger] = "Password reset failed!"
    elsif @res == 0
      flash[:success] = "Success!"
    end
    redirect_to signup_path
  end

  def forget_password
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
