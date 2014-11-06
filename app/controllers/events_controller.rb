# Kevin Sung, Andre Haas

class EventsController < ApplicationController

  def show
  end

  def new
    @datetime = params[:datetime]
  end

  def create
    if not event_params
      render 'new'
      return
    end

    @event = Event.new(event_params)
    @event.user = current_user
    @event.household = current_user.household

    if @event.save
      flash[:success] = 'Event has been created'
      redirect_to events_show_path
    else
      render 'new'
    end
  end

  def edit
    event = Event.where(id: params[:id])
    if event.empty?
      flash[:danger] = 'Unknown event'
      redirect_to events_show_path
      return
    end
    @event = event.first
  end

  def update
    event = Event.where(id: params[:id], household: current_user.household)
    if event.empty?
      flash[:danger] = 'Unknown event'
      redirect_to events_show_path
      return
    end
    @event = event.first

    if params[:commit] == 'Delete event'
      @event.destroy
      redirect_to events_show_path
      return
    end

    if not event_params
      render 'edit'
      return
    end

    if @event.update(event_params)
      flash[:success] = 'Event has been updated'
      redirect_to events_show_path
    else
      render 'edit'
    end
  end

  private

    def event_params
      dt_format = '%m/%d/%Y %I:%M %p'  # datetime format from frontend
                                 # datetimepicker
      out = params.permit(:id, :name)
      # Attempt to get start and end datetimes
      if params[:fullcalendar]
        out[:start_at] = params[:start_at].to_datetime
        out[:end_at] = params[:end_at].to_datetime
      else
        begin
          out[:start_at] = DateTime.strptime(params[:start_at], dt_format)
          out[:end_at] = DateTime.strptime(params[:end_at], dt_format)
        rescue ArgumentError
        end
      end
      return out
    end
end
