# Andre Haas

class UsersController < ApplicationController
  layout 'signed_in'

  def show
    # To delete.
    @user = User.find(params[:id])
  end

  def new
    if logged_in?
      redirect_to current_user
      return
    end
    @user = User.new
    render 'new', layout: 'signed_out'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Housemates!"
      redirect_to @user
    else
      render 'new', layout: 'signed_out'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
