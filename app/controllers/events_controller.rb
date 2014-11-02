# Kevin Sung, Andre Haas

class EventsController < ApplicationController
  DT_FORMAT = '%m/%d/%Y %I:%M %p'  # datetime format from frontend
                                   # datetimepicker

  def show
  end

  def new
    @datetime = params[:datetime]
  end

  def create
    @event = Event.new(name: params[:name])
    @event.user = current_user
    @event.household = current_user.household

    # Attempt to get start and end datetimes
    begin
      @event.start_at = DateTime.strptime(params[:start_at], DT_FORMAT)
      @event.end_at = DateTime.strptime(params[:end_at], DT_FORMAT)
    rescue ArgumentError
      flash.now[:danger] = 'Invalid start and end date'
      render 'events/new'
      return
    end

    if @event.save
      redirect_to events_show_path
    else
      flash.now[:danger] = 'Must enter an event name'
      render 'events/new'
    end
  end

  def delete
    event_id = params[:event.id]
    Event.find(event_id).destroy
    render 'events/show'
  end

  def edit
    event = Event.where(id: params[:id])
    if event.empty?
      flash[:danger] = 'Unknown event'
      redirect_to events_show_path
    end
    @event = event.first
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
