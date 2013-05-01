class ApplicationController < ActionController::Base
  def sort_dojo_students(dojo_students)
    dojo_students.sort! {|a,b| a.student.last_name <=> b.student.last_name}
  end 

  protect_from_forgery
end
