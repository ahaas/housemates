# Andre Haas

class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  include UsersHelper

  def show
    # To delete.
    @user = User.find(params[:id])
    raise "This action ('users#show') is going to be deleted"
  end

  def new
    if logged_in?
      redirect_to homepage_for(current_user)
      return
    end
    @user = User.new
    render 'new', layout: 'basic'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Housemates!"
      redirect_to homepage_for(@user)
    else
      render 'new', layout: 'basic'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
