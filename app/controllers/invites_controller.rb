# Kevin Sung and Andre Haas

class InvitesController < ApplicationController
  layout 'basic'

  def create
    @invite = Invite.new(email: params[:invite][:email])
    @invite.household = current_user.household

    if @invite.save
      render 'households/show', layout: 'household'
    else
      flash.now[:danger] = 'Email ' + @invite.errors[:email].first
      render 'households/show', layout: 'household'
    end
  end

  def accept
    household_id = params[:household].keys.first.to_i
    invite = Invite.find_by(household_id: household_id,
                               email: current_user.email)
    household = invite.household
    if household
      current_user.household = household
      current_user.save
      invite.destroy
      current_user.housemates.each do |housemate|
        Balance.create(user1: current_user, user2: housemate)
      end
    end
    redirect_to homepage_for(current_user)
  end

  def show
  end
end
