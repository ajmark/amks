class StudentsController < ApplicationController

  def index
    @students = Student.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_students = Student.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @student = Student.find(params[:id])
    # @dojo_history = @student.dojo_students.chronological.all
    @registrations = @student.registrations.by_event_name.paginate(:page => params[:page]).per_page(10)
  end
  
  def new
    @student = Student.new
    @student.build_user
  end

  def edit
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(params[:student])
    if @student.save
      # if saved to database
      flash[:notice] = "Successfully created #{@student.proper_name}."
      redirect_to @student # go to show student page
    else
      # return to the 'new' form
      render :action => 'new'
    end
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(params[:student])
      flash[:notice] = "Successfully updated #{@student.proper_name}."
      redirect_to @student
    else
      render :action => 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    flash[:notice] = "Successfully removed #{@student.proper_name} from karate tournament system"
    redirect_to students_url
  end
end