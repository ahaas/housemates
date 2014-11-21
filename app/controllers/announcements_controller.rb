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
      announcement = Announcement.new(
        user: current_user, 
        household: current_user.household,
        text: params[:text])
      if announcement.save
        AnnouncementMailer.send_announcement_email(announcement)
      end
    end
    redirect_to announcements_show_path
  end

  def update
    p '*'*80
    p params
    announcement = Announcement.find_by(id: params[:announcement_id])
    return if !announcement or announcement.user != current_user
    announcement.text = params[:announcement_text]
    if announcement.save
      flash[:success] = "Announcement updated."
    else
      flash[:danger] = "Invalid announcement!"
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
