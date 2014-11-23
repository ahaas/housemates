# Kevin Sung, Andre Haas, David Tien

class InvitesController < ApplicationController
  layout 'basic'

  def create
    @invite = Invite.new(email: params[:invite][:email])
    @invite.household = current_user.household

    if @invite.save
      flash[:success] = 'Invite sent!'
      redirect_to homepage_for(current_user)
      InviteMailer.invite_email(@invite, current_user).deliver
    else
      flash[:danger] = 'Email ' + @invite.errors[:email].first
      redirect_to homepage_for(current_user)
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
