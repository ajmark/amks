class Student < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :date_of_birth, :rank, :phone, :waiver_signed, :active
  
  # Constants
  RANKS = [['Tenth Gup', 1],['Ninth Gup', 2],['Eighth Gup', 3],['Seventh Gup', 4],['Sixth Gup', 5],
           ['Fifth Gup', 6],['Fourth Gup', 7],['Third Gup', 8],['Second Gup', 9],['First Gup', 10],
           ['First Dan', 11],['Second Dan', 12],['Third Dan', 13],['Fourth Dan', 14],['Senior Master', 15]]
  
  # Callbacks
  before_save :reformat_phone
  before_destroy :check_if_destroyable
  after_rollback :deactivate_student_logic, :on => :destroy
  
  # Relationships
  has_many :registrations
  has_many :sections, :through => :registrations
  has_one :user
  has_many :tournaments, :through => :sections
  has_many :dojo_students
  has_many :dojos, :through => :dojo_students
  
  # Scopes
  scope :alphabetical, order('last_name, first_name')
  scope :by_rank, order('rank DESC')
  scope :by_age, order('date_of_birth')
  scope :active, where('students.active = ?', true)
  scope :inactive, where('students.active = ?', false)
  scope :has_waiver, where('waiver_signed = ?', true)
  scope :needs_waiver, where('waiver_signed = ?', false)
  scope :gups, where('rank < ?', 11)
  scope :dans, where('rank > ?', 10)  
  scope :juniors, where('date_of_birth > ?', 18.years.ago.to_date)
  scope :seniors, where('date_of_birth <= ?', 18.years.ago.to_date)
  # The following were replaced with class methods below
  # scope :ranks_between, lambda {|low_rank,high_rank| where("rank between ? and ?", low_rank, high_rank) }
  # scope :ages_between, lambda {|low_age,high_age| where("date_of_birth between ? and ?", ((high_age+1).years - 1.day).ago.to_date, low_age.years.ago.to_date) }
  
  # Validations
  validates_presence_of :first_name, :last_name
  validates_date :date_of_birth, :on_or_before => lambda { 5.years.ago }, :on_or_before_message => "must be at least 5 years old" #, :allow_blank => true
  validates_format_of :phone, :with => /^\(?\d{3}\)?[-. ]?\d{3}[-.]?\d{4}$/, :message => "should be 10 digits (area code needed) and delimited with dashes only", :allow_blank => true
  validates_numericality_of :rank, :only_integer => true, :greater_than => 0
  validates_inclusion_of :waiver_signed, :in => [true, false], :message => "must be true or false"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  
  # Other methods
  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
  
  def age
    return nil if date_of_birth.blank?
    (Time.now.to_s(:number).to_i - date_of_birth.to_time.to_s(:number).to_i)/10e9.to_i
  end
  
  def over_18?
    date_of_birth < 18.years.ago.to_date
  end
  
  def current_dojo
    current_dojo = self.dojo_students.select{|ds| ds.end_date.nil?}
    # alternative method for finding current dojo is to use scope 'current' in dojos:
    # current_dojo = self.dojo_students.current    # will also return an array of current dojo assignments
    return nil if current_dojo.empty?
    current_dojo.first.dojo   # return as a single dojo object, not an array of dojo assignments
  end
  
  def self.registered_for_section(section_id)
    Registration.for_section(section_id).map{|r| Student.find(r.student_id)}
  end
  
  def self.ranks_between(low_rank,high_rank)
    high_rank ||= 15
    Student.where("rank between ? and ?", low_rank, high_rank)
  end
  
  def self.ages_between(low_age,high_age)
    high_age ||= 120
    where("date_of_birth between ? and ?", ((high_age+1).years - 1.day).ago.to_date, low_age.years.ago.to_date)
  end
  
  # Private methods
  private
  def reformat_phone
    phone = self.phone.to_s  # change to string in case input as all numbers 
    phone.gsub!(/[^0-9]/,"") # strip all non-digits
    self.phone = phone       # reset self.phone to new string
  end
  
  def check_if_destroyable
    return false
  end
  
  def deactivate_student_logic
    # make the student inactive
    self.active = false
    self.save!
    # if a student's user exists, make it inactive
    unless self.user.nil?
      self.user.active = false
      self.user.save!
    end
    # if any registrations for upcoming tournments, delete them
    # but leave past registrations alone
    unless self.registrations.empty?
      upcoming_tournament_ids = self.tournaments.upcoming.uniq.map(&:id)
      upcoming_registrations = self.registrations.each{|r| r.destroy if upcoming_tournament_ids.include?(r.tournament.id) }
    end
    # if there is a current dojo assignment, end it
    if self.current_dojo
      self.dojo_students.current.first.update_attribute(:end_date, Date.today)
    end
  end
  
end
