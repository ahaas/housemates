# Andre Haas, Kevin Sung, David Tien, Opal Kale

class HouseholdsController < ApplicationController

  def show
    @announcements = current_user.household.announcements
                        .order(:created_at).reverse
    @events = current_user.household.events.where('start_at >= ?', DateTime.now)
                        .order(:start_at)
    @transactions = current_user.transactions_as_payer.order(:created_at).reverse +
                        current_user.transactions_as_payee.order(:created_at).reverse
    @tasks = current_user.household.tasks
                        .order(:created_at).reverse
  end

  def new
    if current_user.household
      flash[:danger] = "You are already part of a household!"
      redirect_to homepage_for(current_user)
      return
    end
    @household = Household.new
    render 'new', layout: 'basic'
  end

  def create
    @household = Household.new(name: params[:household][:name])
    if @household.save
      current_user.household = @household
      current_user.save
      flash[:success] = "Welcome to #{@household.name}!"
      redirect_to home_path
    else
      render 'new', layout: 'basic'
    end
  end

  def leave
    current_user.household = nil
    current_user.save
    redirect_to homepage_for(current_user)
  end

  def update
    current_user.household.name = params[:household][:name]
    if not current_user.household.save
      flash.now[:danger] = 'Household name is required'
    end
    flash[:success] = "Household name successfully updated"
    render 'settings/show'
  end
end
