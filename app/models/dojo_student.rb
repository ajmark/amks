class DojoStudent < ActiveRecord::Base
  attr_accessible :dojo_id, :end_date, :start_date, :student_id
  
  # Relationships
  belongs_to :dojo
  belongs_to :student
  
  # Callbacks 
  before_create :end_previous_assignment
  
  # Scopes
  scope :current, where('end_date IS NULL')
  scope :by_dojo, joins(:dojo).order('name')
  scope :by_student, joins(:student).order('last_name, first_name')
  scope :chronological, order('start_date DESC, end_date DESC')
  
  # Validations
  validates_numericality_of :dojo_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :student_id, :only_integer => true, :greater_than => 0
  validates_date :start_date, :on_or_before => lambda { Date.current }, :on_or_before_message => "cannot be in the future"
  validates_date :end_date, :after => :start_date, :on_or_before => lambda { Date.current }, :allow_blank => true
  validate :student_is_active_in_system, :on => :create
  validate :dojo_is_active_in_system, :on => :create
  
  
  private  
  def end_previous_assignment
    # A few definitions
    new_start = self.start_date.to_date
    student = Student.find(self.student_id)
    # Does student currently have a dojo? If so, skip...
    current_dojo = student.current_dojo
    if current_dojo.nil?
      return true 
    else
      # find last assignment and end it as of the new start date
      was_assigned = student.dojo_students.select{|ds| ds.end_date.nil?}
      was_assigned.first.update_attribute(:end_date, new_start)
    end
  end
  
  def dojo_is_active_in_system
    # get an array of all active dojos in the system
    active_dojos_ids = Dojo.active.all.map{|d| d.id}
    # add error unless the dojo id of the assignment is in the array of active dojos
    unless active_dojos_ids.include?(self.dojo_id)
      errors.add(:dojo, "is not an active dojo in the system")
    end
  end
  
  def student_is_active_in_system
    # get an array of all active students in the system
    active_students_ids = Student.active.all.map{|s| s.id}
    # add error unless the student id of the assignment is in the array of active students
    unless active_students_ids.include?(self.student_id)
      errors.add(:student, "is not an active student in the system")
    end
  end
  
  
end
