class Section < ActiveRecord::Base
  attr_accessible :active, :event_id, :min_age, :min_rank, :max_age, :max_rank, :tournament_id, :location, :round_time
  
  # Relationships
  belongs_to :event
  has_many :registrations
  has_many :students, :through => :registrations
  belongs_to :tournament
  
  # Scopes
  scope :for_event, lambda {|event_id| where("event_id = ?", event_id) }
  scope :for_rank, lambda {|desired_rank| where("min_rank <= ? and (max_rank >= ? or max_rank is null)", desired_rank, desired_rank) }
  scope :for_age, lambda {|desired_age| where("min_age <= ? and (max_age >= ? or max_age is null)", desired_age, desired_age) }
  scope :active, where('sections.active = ?', true)
  scope :inactive, where('sections.active = ?', false)
  scope :alphabetical, joins(:event).order('events.name, min_rank, min_age')
  scope :for_location, lambda {|location| where("location LIKE ?", "#{location}%") }
  scope :by_location, order('location')
  scope :for_tournament, lambda {|tournament_id| where("tournament_id = ?", tournament_id) }
  
  # Validations
  validates_numericality_of :min_rank, :only_integer => true, :greater_than => 0
  validates_numericality_of :max_rank, :only_integer => true, :greater_than_or_equal_to => :min_rank, :allow_blank => true
  validates_numericality_of :min_age, :only_integer => true, :greater_than_or_equal_to => 5
  validates_numericality_of :max_age, :only_integer => true, :greater_than_or_equal_to => :min_age, :allow_blank => true
  validates_numericality_of :event_id, :only_integer => true, :greater_than => 0, :message => "is not a valid event"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"

  validate :event_is_active_in_system, :on => :create
  validate :tournament_is_active_in_system, :on => :create
  validate :section_is_not_already_in_system, :on => :create
  validate :min_rank_at_or_above_tourney_minimum
  validate :max_rank_at_or_below_tourney_maximum

  # Not needed unless going the long route with registrations
  # def to_s
  #   "#{self.event.name} => #{self.min_rank}-#{self.max_rank} => #{self.min_age}-#{self.max_age}"
  # end
  
  def make_inactive
    self.active = false
    self.save!
  end
  
  def make_active
    self.active = true
    self.save!
  end
  
  # Callbacks
  before_destroy :check_if_destroyable
  after_rollback :deactivate_section_logic

  private
  def check_if_destroyable
    if self.registrations.empty?
      return true
    else
      return false
    end
  end
  
  def deactivate_section_logic
    # deactivate the section itself
    self.active = false
    self.save!
    # leave registrations alone for now
  end

  def event_is_active_in_system
    # get an array of all active events in the system
    active_events_ids = Event.active.all.map{|e| e.id}
    # add error unless the event id of the section is in the array of active events
    unless active_events_ids.include?(self.event_id)
      errors.add(:event, "is not an active event in the system")
      return false
    end
    return true
  end
  
  def tournament_is_active_in_system
    # get an array of all active tournaments in the system
    active_tourneys_ids = Tournament.active.all.map{|t| t.id}
    # add error unless the tournament id of the section is in the array of active tournaments
    unless active_tourneys_ids.include?(self.tournament_id)
      errors.add(:tournament, "is not an active tournament in the system")
      return false
    end
    return true
  end
  
  def section_is_not_already_in_system
    possible_repeat = Section.where(:event_id => self.event_id, :tournament_id => self.tournament_id, :min_age => self.min_age, :min_rank => self.min_rank)
    unless possible_repeat.empty?  # use .nil? if using find_by as it only returns one object, not an array
      errors.add(:min_rank, "already has a section for this event, age and rank")
    end
  end
  
  def min_rank_at_or_above_tourney_minimum
    if self.tournament.min_rank > self.min_rank
      errors.add(:min_rank, "must be at or above tournament minimum")
    else
      return true
    end
  end
  
  def max_rank_at_or_below_tourney_maximum
    tourney_max = self.tournament.max_rank
    return true if tourney_max.nil? || self.max_rank.nil?
    if tourney_max < self.max_rank
      errors.add(:max_rank, "must be at or below tournament maximum")
    else
      return true
    end
  end
end
