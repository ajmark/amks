class DojoStudentsController < ApplicationController
  def index
  	@dojo_students = DojoStudent.current.by_student
  end

  def show
  	@dojo_student = DojoStudent.find(params[:id])
  end

  def new
  	@dojo_student = DojoStudent.new
  end

  def edit
  	@dojo_student = DojoStudent.find(params[:id])
  end

  def create
    @dojo_student = DojoStudent.new(params[:dojo_student])
    @dojo_student.start_date = Date.today
    if @dojo_student.save!
      # if saved to database
      flash[:notice] = "Successfully added #{@dojo_student.student.proper_name} to #{@dojo_student.dojo.name}"
      redirect_to dojo_path(@dojo_student.dojo_id) # go to show section page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @dojo_student = DojoStudent.find(params[:id])
    if @dojo_student.update_attributes(params[:dojo_student])
      flash[:notice] = "Successfully added #{@dojo_student.student.proper_name} to #{@dojo_student.dojo.name}"
      redirect_to @dojo_student
    else
      render :action => 'edit'
    end
  end

  def destroy
    @dojo_student = DojoStudent.find(params[:id])
    dojo_id = @dojo_student.dojo.id
    @dojo_student.destroy
    flash[:notice] = "Successfully removed #{@dojo_student.student.proper_name} from #{@dojo_student.dojo.name}"
    # redirect_to registrations_url
    redirect_to dojo_path(dojo_id) # go to show section page
  end
end
