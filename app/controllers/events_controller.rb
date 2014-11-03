#Kevin Sung
class EventsController < ApplicationController
  def show
  end

  def new
    render 'events/edit'
  end

  def create
    p params
    @event = Event.new(name: params[:name], start_at: params[:start_at], end_at: params[:end_at])
    @event.user = current_user
    @event.household = current_user.household
    if @event.save
      redirect_to events_show_path
    else
      render 'events/edit'
    end
  end

  def delete
    event_id = params[:event.id]
    if Event.find(event_id).destroy
      redirect_to events_show_path
    else
      # if we cannot find event, stay on edit page; this should never happen though...
      render 'events/edit'
    end
  end

  def edit
    render 'events/edit'
  end

  def update
    event_id = params[:event.id]
    event_to_update = Event.find(event_id)
    event_to_update.name = params[:name]
    event_to_update.start_at = params[:start_at]
    event_to_update.end_at = params[:end_at]
    if event_to_update.save
      redirect_to events_show_path
    else
      render 'events/edit'
    end
  end
end
