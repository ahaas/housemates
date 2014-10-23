class InvitesController < ApplicationController
  def create
    @invite = Invite.new(email: params[:invite][:email])
    @invite.household = current_user.household
    
    if @invite.save
      render 'households/show'
    else
      flash.now[:danger] = 'Invalid email'
      render 'households/show'
    end
  end
end
