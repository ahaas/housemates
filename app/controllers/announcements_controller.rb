# Tom Lai

class AnnouncementsController < ApplicationController
  def new
  end

  def show
     @announcements = current_user.household.announcements.to_a
                       .sort_by! {:created_at}
  end

  def create
    if params[:commit] == 'Post'
      announcement = Announcement.create(
        user: current_user, 
        household: current_user.household,
        text: params[:text])
    end
    redirect_to announcements_show_path
  end

  def destroy
    announcement = Announcement.find_by(id: params[:id])
    if announcement and announcement.user == current_user
      announcement.destroy
    end
    redirect_to announcements_show_path
  end
end
