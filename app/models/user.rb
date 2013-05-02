class User < ActiveRecord::Base  
  # Use built-in rails support for password protection
  has_secure_password
  
  attr_accessible :active, :email, :password, :password_confirmation, :role, :student_id
  
  # Relationships
  belongs_to :student
  
  # Validations
  validates_uniqueness_of :email, :case_sensitive => false
  validates_format_of :email, :with => /^[\w]([^@\s,;]+)@(([\w-]+\.)+(com|edu|org|net|gov|mil|biz|info))$/i, :message => "is not a valid format"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  validates_inclusion_of :role, :in => %w[admin member], :message => "is not recognized by the system"
  # validate :student_is_active_in_system, :on => :create
  
  # for use in authorizing with CanCan
  ROLES = [['Administrator', :admin],['Member', :member]]

  def role?(authorized_role)
    return false if role.nil?
    role.downcase.to_sym == authorized_role
  end
  
  # alternative methods (some find more natural...)
  def is_admin?
    role == 'admin'
  end
  
  def is_member?
    role == 'member'
  end

  # login by email address
  def self.authenticate(email, password)
    find_by_email(email).try(:authenticate, password)
  end
  
  private
  def student_is_active_in_system
    # get an array of all active students in the system
    active_students_ids = Student.active.all.map{|s| s.id}
    # add error unless the student id of the registration is in the array of active students
    unless active_students_ids.include?(self.student_id)
      errors.add(:student, "is not an active student in the system")
    end
  end
  
end
