class Dojo < ActiveRecord::Base
  attr_accessible :active, :city, :name, :state, :street, :zip, :latitude, :longitude
  
  # Callbacks
  before_validation :get_dojo_coordinates
  
  # Relationships
  has_many :dojo_students
  has_many :students, :through => :dojo_students
  
  # Scopes
  scope :alphabetical, order('name')
  scope :active, where('active = ?', true)
  scope :inactive, where('active = ?', false)
  
  # Lists
  STATES_LIST = [['Alabama', 'AL'],['Alaska', 'AK'],['Arizona', 'AZ'],['Arkansas', 'AR'],['California', 'CA'],['Colorado', 'CO'],['Connectict', 'CT'],['Delaware', 'DE'],['District of Columbia ', 'DC'],['Florida', 'FL'],['Georgia', 'GA'],['Hawaii', 'HI'],['Idaho', 'ID'],['Illinois', 'IL'],['Indiana', 'IN'],['Iowa', 'IA'],['Kansas', 'KS'],['Kentucky', 'KY'],['Louisiana', 'LA'],['Maine', 'ME'],['Maryland', 'MD'],['Massachusetts', 'MA'],['Michigan', 'MI'],['Minnesota', 'MN'],['Mississippi', 'MS'],['Missouri', 'MO'],['Montana', 'MT'],['Nebraska', 'NE'],['Nevada', 'NV'],['New Hampshire', 'NH'],['New Jersey', 'NJ'],['New Mexico', 'NM'],['New York', 'NY'],['North Carolina','NC'],['North Dakota', 'ND'],['Ohio', 'OH'],['Oklahoma', 'OK'],['Oregon', 'OR'],['Pennsylvania', 'PA'],['Rhode Island', 'RI'],['South Carolina', 'SC'],['South Dakota', 'SD'],['Tennessee', 'TN'],['Texas', 'TX'],['Utah', 'UT'],['Vermont', 'VT'],['Virginia', 'VA'],['Washington', 'WA'],['West Virginia', 'WV'],['Wisconsin ', 'WI'],['Wyoming', 'WY']]
  
  # Validations
  validates_presence_of :name, :street, :city
  validates_uniqueness_of :name, :case_sensitive => false
  validates_inclusion_of :state, :in => STATES_LIST.map {|k, v| v}, :message => "is not a recognized state in the system"
  validates_format_of :zip, :with => /^\d{5}$/, :message => "should be five digits long"
  validates_inclusion_of :active, :in => [true, false], :message => "must be true or false"
  
  # Other methods
  def current_students
    self.students.alphabetical.select{|s| s.current_dojo == self}.uniq
  end
  
  # Callbacks
  before_destroy :check_if_destroyable
  after_rollback :deactivate_dojo_logic, :on => :destroy

  private
  def check_if_destroyable
    if self.dojo_students.empty?
      return true
    else
      return false
    end
  end
  
  def deactivate_dojo_logic
    # end current assignments, if any
    unless self.current_students.empty?
      self.dojo_students.select{|ds| ds.end_date.nil?}.each do |assignment|
        assignment.end_date = Date.today
        assignment.save!
      end
    end
    # deactivate the dojo itself
    self.active = false
    self.save!
  end
  
  def get_dojo_coordinates
    str = self.street
    zip = self.zip
    
    coord = Geocoder.coordinates("#{str}, #{zip}")
    if coord
      self.latitude = coord[0]
      self.longitude = coord[1]
    else 
      errors.add(:base, "Error with geocoding")
    end
    coord
  end
end
