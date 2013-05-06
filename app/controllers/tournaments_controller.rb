class TournamentsController < ApplicationController
  def index
  	@tournaments = Tournament.alphabetical.paginate(:page => params[:page]).per_page(8)
  end

  def show
  	@tournament = Tournament.find(params[:id])
    @tournament_sections = @tournament.sections.alphabetical.paginate(:page => params[:page]).per_page(8) 
  end

  def new
  	@tournament = Tournament.new
  end

  def edit
  	@tournament = Tournament.find(params[:id])
  end

  def create
    @tournament = Tournament.new(params[:tournament])
    if @tournament.save
      # if saved to database
      flash[:notice] = "Successfully created #{@tournament.name}."
      redirect_to @tournament # go to show event page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(params[:tournament])
      flash[:notice] = "Successfully updated #{@tournament.name}."
      redirect_to @tournament
    else
      render :action => 'edit'
    end
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
    flash[:notice] = "Successfully removed #{@tournament.name} from karate tournament system"
    redirect_to tournament_url
  end
end
