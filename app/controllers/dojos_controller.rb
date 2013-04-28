class DojosController < ApplicationController
  def index
  	@dojos = Dojo.alphabetical.all
  end

  def show
  	@dojo = Dojo.find(params[:id])
  end

  def new
  	@dojo = Dojo.new
  end

  def edit
  	 @dojo = Dojo.find(params[:id])
  end

  def create
    @dojo = Dojo.new(params[:dojo])
    if @dojo.save
      # if saved to database
      flash[:notice] = "Successfully created #{@dojo.name}."
      redirect_to @dojo # go to show event page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @dojo = Dojo.find(params[:id])
    if @dojo.update_attributes(params[:dojo])
      flash[:notice] = "Successfully updated #{@dojo.name}."
      redirect_to @dojo
    else
      render :action => 'edit'
    end
  end

  def destroy
    @dojo = Dojo.find(params[:id])
    @dojo.destroy
    flash[:notice] = "Successfully removed #{@dojo.name} from karate tournament system"
    redirect_to dojo_url
  end
end
