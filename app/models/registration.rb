class Registration < ActiveRecord::Base
  attr_accessible :date, :section_id, :student_id, :fee_paid, :final_standing
  
  STANDINGS = [['1st', 1], ['2nd', 2], ['3rd', 3]]
  # Relationships
  belongs_to :section
  belongs_to :student
  has_one :event, :through => :section
  has_one :tournament, :through => :section
  
  # Scopes
  scope :for_section, lambda {|section_id| where("section_id = ?", section_id) }
  scope :for_student, lambda {|student_id| where("student_id = ?", student_id) }
  scope :by_student, joins(:student).order('last_name, first_name')
  scope :by_date, order('registrations.date')
  scope :by_event_name, joins(:section, :event).order('events.name')
  scope :paid, where('fee_paid = ?', true)
  scope :unpaid, where('fee_paid = ?', false)
  scope :by_final_standing, order('final_standing')
  
  # Validations
  validates_date :date, :on_or_before => lambda { Date.current }, :on_or_before_message => "cannot be in the future"
  validates_numericality_of :section_id, :only_integer => true, :greater_than => 0
  validates_numericality_of :student_id, :only_integer => true, :greater_than => 0
  validate :student_is_appropriate_rank
  validate :student_is_appropriate_age
  validate :section_is_active_in_system, :on => :create
  validate :student_is_active_in_system, :on => :create
  validate :registration_is_not_already_in_system, :on => :create
  # validates_uniqueness_of :student_id, scope: :section_id
  
  private
  def section_is_active_in_system
    # get an array of all active sections in the system
    active_sections_ids = Section.active.all.map{|s| s.id}
    # add error unless the section id of the registration is in the array of active sections
    unless active_sections_ids.include?(self.section_id)
      errors.add(:section, "is not an active section in the system")
    end
  end
  
  def student_is_active_in_system
    # get an array of all active students in the system
    active_students_ids = Student.active.all.map{|s| s.id}
    # add error unless the student id of the registration is in the array of active students
    unless active_students_ids.include?(self.student_id)
      errors.add(:student, "is not an active student in the system")
    end
  end
  
  def student_is_appropriate_rank
    return true if self.student.nil? || self.section.nil? # should be caught by other validations; no double error
    rank = self.student.rank
    min = self.section.min_rank
    max = self.section.max_rank
    unless rank >= min && (max.nil? || rank <= max)
      errors.add(:student_id, "does not have an appropriate rank")
    end
  end
  
  def student_is_appropriate_age
    return true if self.student.nil? || self.section.nil? # should be caught by other validations; no double error
    age = self.student.age
    min = self.section.min_age
    max = self.section.max_age
    unless age >= min && (max.nil? || age <= max)
      errors.add(:student_id, "is not within the age range for this section")
    end
  end
  
  def registration_is_not_already_in_system
    return true if self.student_id.nil? || self.section_id.nil? # should be caught by other validations; no double error
    possible_repeat = Registration.where(section_id: section_id, student_id: student_id)
    # notice that I am using the Ruby 1.9 hashes here as opposed to the 1.8 style in Section
    # again, an alternate method would be using the dynamic find_by method...
    # possible_repeat = Registration.find_by_section_id_and_student_id(section_id, student_id)
    unless possible_repeat.empty? # use .nil? if using find_by as it only returns one object, not an array
      errors.add(:student_id, "is already registered for this section")
    end
  end

end
