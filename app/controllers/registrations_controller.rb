class RegistrationsController < ApplicationController

  def index
    @registrations = Registration.by_student.paginate(:page => params[:page]).per_page(8)
  end

  def show
    @registration = Registration.find(params[:id])
  end
  
  def new
    @registration = Registration.new
  end

  def edit
    @registration = Registration.find(params[:id])
  end

  def create
    @registration = Registration.new(params[:registration])
    @registration.date = Date.today
    if @registration.save!
      # if saved to database
      flash[:notice] = "Successfully created registration for #{@registration.student.proper_name}."
      redirect_to section_path(@registration.section_id) # go to show section page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @registration = Registration.find(params[:id])
    if @registration.update_attributes(params[:registration])
      flash[:notice] = "Successfully updated registration for #{@registration.student.proper_name}."
      redirect_to @registration
    else
      render :action => 'edit'
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    section_id = @registration.section.id
    @registration.destroy
    flash[:notice] = "Successfully removed registration for #{@registration.student.proper_name} from karate tournament system"
    # redirect_to registrations_url
    redirect_to section_path(section_id) # go to show section page
  end
end