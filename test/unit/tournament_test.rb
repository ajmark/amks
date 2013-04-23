require 'test_helper'

class TournamentTest < ActiveSupport::TestCase
  # matchers
  should have_many(:sections)
  should have_many(:registrations).through(:sections)
  should have_many(:students).through(:registrations)
  
  should validate_presence_of(:name)
  
  # tests for min_rank
  should validate_numericality_of(:min_rank)
  should allow_value(1).for(:min_rank)
  should allow_value(7).for(:min_rank)
  should allow_value(10).for(:min_rank)
  should allow_value(12).for(:min_rank)
  should_not allow_value(0).for(:min_rank)
  should_not allow_value(-1).for(:min_rank)
  should_not allow_value(3.14159).for(:min_rank)
  should_not allow_value(nil).for(:min_rank)
  
  # limited tests for max_rank
  should validate_numericality_of(:max_rank)
  should allow_value(nil).for(:max_rank)

  # test date
  should allow_value(Date.today).for(:date)
  should allow_value(1.day.from_now.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(3.14159).for(:date)
  should_not allow_value(1.day.ago.to_date).for(:date)
  
  # test active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
  
  context "Creating context for tournaments" do
    setup do
      create_tournament_context
    end
    
    teardown do
      remove_tournament_context
    end
    
    should "allow an existing tournament to be edited" do
      @gups.active = false
      assert @gups.valid?
    end

    should "have working factories" do
      assert_equal "Fall Classic", @fall.name
      assert_equal "Dan Tournament", @dans.name
      assert_equal "Gup Tournament", @gups.name
      assert_equal "Inactive Tournament", @postponed.name
    end
  
    should "have an alphabetical scope" do
      assert_equal ["Dan Tournament", "Fall Classic", "Gup Tournament", "Inactive Tournament"], Tournament.alphabetical.map(&:name)
    end
  
    should "have an chronological scope" do
      assert_equal ["Fall Classic", "Inactive Tournament", "Dan Tournament", "Gup Tournament"], Tournament.chronological.map(&:name)
    end
  
    should "have an active scope" do
      assert_equal ["Dan Tournament", "Fall Classic", "Gup Tournament"], Tournament.active.map(&:name).sort
    end
  
    should "have an inactive scope" do
      assert_equal ["Inactive Tournament"], Tournament.inactive.map(&:name).sort
    end
  
    should "have a scope for past tournaments" do
      @dans.date = 2.days.ago.to_date
      @dans.save
      assert_equal 1, Tournament.past.size
    end
  
    should "have a scope for upcoming tournaments" do
      assert_equal 4, Tournament.upcoming.size
    end
  
    should "have an next scope to get the next X tourneys" do
      assert_equal ["Fall Classic", "Inactive Tournament", "Dan Tournament"], Tournament.chronological.next(3).map(&:name)
    end
    
    should "destroy tournaments with no registrations" do
      @gups.destroy
      assert @gups.destroyed?
      # assert_nil Tournament.find_by_name("Gup Tournament")
    end
  
    should "destroy sections when a tournament is destroyed" do
      assert_equal 0, @gups.sections.size  # just to show nothing is there to start
      breaking = FactoryGirl.create(:event, name: "Breaking")
      wy_belt_breaking = FactoryGirl.create(:section, event: breaking, tournament: @gups, location: "Stage")
      r_belt_breaking = FactoryGirl.create(:section, event: breaking, min_rank: 8, max_rank: 10, tournament: @gups, location: "Stage")
      assert_equal 2, Section.find_all_by_location("Stage").size # since only these sections are at 'Stage'
      @gups.reload
      assert_equal 2, @gups.sections.size   # just to show they are the same...
      @gups.destroy
      assert @gups.destroyed?               # verify the destroy took place
      assert_equal 0, Section.find_all_by_location("Stage").size
      breaking.delete
    end
  
    should "deactive tournaments (and sections) with registrations" do
      create_event_context
      create_section_context
      create_student_context
      create_registration_context
      # assert_equal 4, Section.find_all_by_tournament_id_and_active(@fall.id, true).size
      @fall.destroy
      @fall.reload
      deny @fall.active
      deny @fall.sections.first.active, "#{@fall.sections.first.to_yaml}"
      deny @fall.sections.last.active, "#{@fall.sections.last.to_yaml}"
      remove_event_context     
      remove_section_context
      remove_student_context
      remove_registration_context
    end
  end
end
