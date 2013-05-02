class Tournament < ActiveRecord::Base
  attr_accessible :active, :date, :max_rank, :min_rank, :name
  
  # Relationships
  has_many :sections
  has_many :registrations, :through => :sections
  has_many :students, :through => :registrations
  
  # Validations
  validates_presence_of :name
  validates_date :date, :on_or_after => lambda { Date.current }, :on_or_before_message => "cannot be in the past", :on => :create
  validates_numericality_of :min_rank, :only_integer => true, :greater_than => 0
  validates_numericality_of :max_rank, :only_integer => true, :greater_than_or_equal_to => :min_rank, :allow_blank => true
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  
  # Scopes
  scope :alphabetical, order('tournaments.name')
  scope :chronological, order('tournaments.date')
  scope :active, where('tournaments.active = ?', true)
  scope :inactive, where('tournaments.active = ?', false)
  scope :past, where('tournaments.date < ?', Date.today)
  scope :upcoming, where('tournaments.date >= ?', Date.today)
  scope :next, lambda {|num| limit(num) }
  
  # Callbacks
  before_destroy :check_if_destroyable
  after_rollback :deactivate_tournament_logic, :on => :destroy

  private
  def check_if_destroyable
    if self.registrations.empty?
      self.sections.each{|s| s.delete}
      return true
    else
      return false
    end
  end
  
  def deactivate_tournament_logic
    # deactivate sections
    unless self.sections.empty?
      self.sections.active.each do |section|
        section.active = false
        section.save!
      end
    end
    # deactivate the tournament itself
    self.active = false
    self.save!
  end
  
end
