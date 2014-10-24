# Andre Haas, Kevin Sung

class HouseholdsController < ApplicationController

  def show
  end

  def new
    if current_user.household
      flash[:error] = "You are already part of a household!"
      redirect_to homepage_for(current_user)
      return
    end
    @household = Household.new
    render 'new', layout: 'basic'
  end

  def create
    @household = Household.new(name: params[:household][:name])
    if @household.save
      current_user.update_attributes(household: @household)
      flash[:success] = "Welcome to #{@household.name}!"
      redirect_to home_path
    else
      render 'new', layout: 'basic'
    end
  end
  
  
end
