class Event < ActiveRecord::Base
  attr_accessible :active, :name
  
  # Relationships
  has_many :sections
  
  # Scopes
  scope :alphabetical, order('events.name')
  scope :active, where('events.active = ?', true)
  scope :inactive, where('events.active = ?', false)
  
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false, :on => :create
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false" 
  
  # Other methods
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
  after_rollback :deactivate_event_logic
  
  
  # private
  def check_if_destroyable
    # find if there are any sections with this event that have ever had registrations
    sections_with_registrations_for_event = self.sections.select{|s| s.registrations.size > 0}
    if sections_with_registrations_for_event.empty?
      self.sections.each{|s| s.destroy}
      return true
    else
      return false
    end
  end
  
  def deactivate_event_logic
    # if any sections for upcoming tournments, deactivate them
    # but leave past sections alone
    unless self.sections.empty?
      upcoming_tournament_ids = Tournament.upcoming.all.map(&:id)
      self.sections.each do |s| 
        if upcoming_tournament_ids.include?(s.tournament.id)
          s.active = false
          s.save
        end
      end
    end
    # make the event inactive
    self.active = false
    self.save!
  end
  
  
   
end
