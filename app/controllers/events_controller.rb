class EventsController < ApplicationController

  def index
    @events = Event.alphabetical.paginate(:page => params[:page]).per_page(8)
    @inactive_events = Event.inactive.alphabetical.paginate(:page => params[:page]).per_page(8)
  end

  def show
    @event = Event.find(params[:id])
  end
  
  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      # if saved to database
      flash[:notice] = "Successfully created #{@event.name}."
      redirect_to @event # go to show event page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Successfully updated #{@event.name}."
      redirect_to @event
    else
      render :action => 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Successfully removed #{@event.name} from karate tournament system"
    redirect_to events_url
  end
end