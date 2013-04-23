require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Shoulda macros
  should have_many(:sections)
  # should have_many(:registrations).through(:sections)
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name).case_insensitive
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
  
  # Context for rest of testing
  context "Creating three events" do
    setup do
      create_event_context
    end
    
    teardown do
      remove_event_context
    end

    should "verify that name is unique, including case insensitivity" do
      @break = FactoryGirl.build(:event, :name => "breaking")
      deny @break.valid?
      @swords = FactoryGirl.build(:event, :name => "Weapons")
      deny @swords.valid?
    end
    
    should "have a scope to alphabetize events" do
      assert_equal ["Breaking", "Forms", "Sparring", "Weapons"], Event.alphabetical.map(&:name)
    end
    
    should "have a scope to select only active events" do
      assert_equal ["Breaking", "Forms", "Sparring"], Event.active.alphabetical.map(&:name)
    end
    
    should "have a scope to select only inactive events" do
      assert_equal ["Weapons"], Event.inactive.alphabetical.map(&:name)
    end
    
    should "respond to the make_inactive message" do
      @breaking.make_inactive
      deny @breaking.active
    end
    
    should "respond to the make_active message" do
      @weapons.make_active
      assert @breaking.active
    end
    
    should "be able to delete events with no section registrants" do
      @forms.destroy
      forms_prime = Event.find_by_name("Forms")
      deny forms_prime, "#{forms_prime.to_yaml}"
    end
    
    
    should "destroy sections when an event is destroyed" do
      fall = FactoryGirl.create(:tournament)
      wy_belt_forms = FactoryGirl.create(:section, event: @forms, tournament: fall)
      forms_id = @forms.id
      @forms.destroy
      assert @forms.destroyed?
      assert_nil Section.find_by_event_id(forms_id), "#{Section.find_by_event_id(forms_id).to_yaml}"
      fall.delete
    end
    
    should "make events with section registrants inactive instead of deleted" do
      # build additional context
      ted = FactoryGirl.create(:student, first_name: "Ted")
      fall = FactoryGirl.create(:tournament)
      wy_belt_breaking = FactoryGirl.create(:section, event: @breaking, tournament: fall)
      reg_ted_br = FactoryGirl.create(:registration, student: ted, section: wy_belt_breaking)
      # now try to destroy an event with an upcoming section and registration
      @breaking.destroy
      deny @breaking.destroyed?
      @breaking.reload
      deny @breaking.active
      # verify that event's section is also inactive
      wy_belt_breaking.reload
      deny wy_belt_breaking.active
      # remove the additional context
      ted.delete
      fall.delete
      wy_belt_breaking.delete
      reg_ted_br.delete
    end
    
    

  end
end
