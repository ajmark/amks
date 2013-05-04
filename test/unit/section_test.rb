require 'test_helper'

class SectionTest < ActiveSupport::TestCase
  # Shoulda macros
  should belong_to(:event)
  should have_many(:registrations)
  should have_many(:students).through(:registrations)
  
  # Context for rest of testing
  context "Creating context for sections" do
    setup do
      create_event_context
      create_tournament_context
      create_section_context
    end
    
    teardown do
      remove_event_context
      remove_tournament_context
      remove_section_context
    end
    
    should "does not allow sections for events not in the system" do
      @blocks = FactoryGirl.build(:event, name: "Breaking Blocks")
      bad_section = FactoryGirl.build(:section, event: @blocks, tournament: @fall)  # @blocks is not in the database yet...
      deny bad_section.valid?
    end
    
    should "does not allow sections for inactive events" do
      bad_section = FactoryGirl.build(:section, event: @weapons, tournament: @fall)  # white belts with weapons could be bad indeed...
      deny bad_section.valid?
    end
    
    should "does not allow sections for tournaments not in the system" do
      @zip = FactoryGirl.build(:tournament, :name => "Zip Tourney")
      bad_section = FactoryGirl.build(:section, event: @breaking, tournament: @zip)  # @zip is not in the database yet...
      deny bad_section.valid?
    end
    
    should "does not allow sections for inactive tournaments" do
      bad_section = FactoryGirl.build(:section, event: @breaking, tournament: @postponed) 
      deny bad_section.valid?
    end
    
    should "has max ages greater than or equal to min ages" do
      bad_section = FactoryGirl.build(:section, event: @breaking, min_age: 10, max_age: 9, tournament: @fall)
      deny bad_section.valid?
      @ok_section = FactoryGirl.build(:section, event: @breaking, min_age: 10, max_age: 10, tournament: @fall)
      assert @ok_section.valid?
    end
    
    should "has max ranks greater than or equal to min ranks" do
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 10, max_rank: 9, tournament: @fall)
      deny bad_section.valid?
      @ok_section = FactoryGirl.build(:section, event: @breaking, min_rank: 10, max_rank: 10, tournament: @fall)
      assert @ok_section.valid?
    end
    
    should "not allow duplicate sections to be created" do
      @duplicate_section = FactoryGirl.build(:section, event: @breaking, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, tournament: @fall)
      deny @duplicate_section.valid?
    end
    
    # test repeating section validation is modified on a per-tournament basis
    # (previous tests didn't account for tournaments b/c no tournaments at that time...)
    should "allow repeated section for different tournament" do
      @r_belt_breaking_2 = FactoryGirl.build(:section, event: @breaking, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, tournament: @gups)
      assert @r_belt_breaking_2.valid?
    end
    
    should "allow an existing section to be edited" do
      @wy_belt_sparring.active = false
      assert @wy_belt_sparring.valid?
    end
        
    should "not allow a section min rank below tourney min rank" do
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 8, max_rank: 13, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
    end
    
    should "not allow a section max rank above tourney max rank" do
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 8, max_rank: 14, min_age: 13, max_age: 15, tournament: @fall)
      deny bad_section.valid?
    end
    
    should "not constrain max_rank if tourney max rank nil" do
      good_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert good_section.valid?
    end
    
    # replacing the rank matchers that are broken because of new validations
    should "constrain min_rank to a positive integer" do
      good_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert good_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11.5, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: "first dan", max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: -1, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
    end
    
    should "constrain max_rank to a positive integer" do
      good_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert good_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 14.3, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: "master", min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: -1, min_age: 13, max_age: 15, tournament: @dans)
      deny bad_section.valid?
    end
    
    should "require a value for min rank but not max rank" do
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert test_section.valid?
      test_section.max_rank = nil
      assert test_section.valid?
      test_section.min_rank = nil.to_i
      deny test_section.valid?
    end
    
    # replacing the age matchers that are broken because of new validations
    should "constrain min_age to a positive integer" do
      good_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert good_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: "Younglings", max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13.14, max_age: 15, tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 1, max_rank: 15, min_age: -1, max_age: 15, tournament: @dans)
      deny bad_section.valid?
    end
    
    should "constrain max_age to a positive integer" do
      good_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert good_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: "old", tournament: @dans)
      deny bad_section.valid?
      bad_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 55.5, tournament: @dans)
      deny bad_section.valid?
    end
    
    should "require a value for min age but not max age" do
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert test_section.valid?
      test_section.max_age = nil
      assert test_section.valid?
      test_section.min_age = nil.to_i
      deny test_section.valid?
    end
    
    # replacing the event matchers that are broken because of new validations
    should "constrain event_ids to a positive integer" do
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      assert test_section.valid?
      @breaking.id = -1
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny test_section.valid?, "#{@breaking.to_yaml}, #{test_section.to_yaml}"
      @breaking.id = 3.14
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny test_section.valid?, "#{@breaking.to_yaml}, #{test_section.to_yaml}"
      @breaking.id = "bad"
      test_section = FactoryGirl.build(:section, event: @breaking, min_rank: 11, max_rank: 15, min_age: 13, max_age: 15, tournament: @dans)
      deny test_section.valid?, "#{@breaking.to_yaml}, #{test_section.to_yaml}"
    end
    
    should "have a scope to alphabetize sections by event name" do
      assert_equal ["Breaking", "Breaking", "Breaking", "Forms", "Sparring", "Sparring"], Section.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to show only active sections" do
      assert_equal ["Breaking", "Breaking", "Breaking", "Forms", "Sparring"], Section.active.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to show only inactive sections" do
      assert_equal ["Sparring"], Section.inactive.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to alphabetize sections by location" do
      assert_equal ["Breaking", "Breaking", "Forms", "Sparring", "Sparring", "Breaking"], Section.by_location.alphabetical.map{|s| s.event.name}
    end
    
    should "have a scope to find sections for a particular location" do
      assert_equal 1, Section.for_location("Stage").size
      assert_equal 5, Section.for_location("Main gym").size  # "Main" would also work...
    end
    
    should "have a scope to show all sections for a particular age (allow nil max_age)" do
      assert_equal ["Breaking:13-15", "Sparring:13-15"], Section.for_age(14).alphabetical.map{|s| "#{s.event.name}:#{s.min_age}-#{s.max_age}"}
      assert_equal ["Breaking:18-"], Section.for_age(19).alphabetical.map{|s| "#{s.event.name}:#{s.min_age}-#{s.max_age}"}
    end
    
    should "have a scope to show all sections for a particular rank (allow nil max_rank)" do
      assert_equal ["Breaking:1-2", "Forms:1-2", "Sparring:1-2"], Section.for_rank(2).alphabetical.map{|s| "#{s.event.name}:#{s.min_rank}-#{s.max_rank}"}
      assert_equal ["Breaking:11-"], Section.for_rank(11).alphabetical.map{|s| "#{s.event.name}:#{s.min_rank}-#{s.max_rank}"}
    end
    
    should "have a scope to show all sections for a particular event" do
      assert_equal ["rank:1 - age:9", "rank:8 - age:13", "rank:11 - age:18"], Section.for_event(@breaking.id).alphabetical.map{|s| "rank:#{s.min_rank} - age:#{s.min_age}"}
      assert_equal ["rank:1 - age:9", "rank:8 - age:13"], Section.for_event(@sparring.id).alphabetical.map{|s| "rank:#{s.min_rank} - age:#{s.min_age}"}
    end
    
    should "have a scope to show all sections for a particular tournament" do
      assert_equal ["rank:1 - age:9", "rank:8 - age:13", "rank:1 - age:9", "rank:1 - age:9", "rank:8 - age:13"], Section.for_tournament(@fall.id).alphabetical.map{|s| "rank:#{s.min_rank} - age:#{s.min_age}"}
      assert_equal ["Breaking:11-"], Section.for_tournament(@dans.id).map{|s| "#{s.event.name}:#{s.min_rank}-#{s.max_rank}"}
    end
    
    should "have a working make_inactive method" do
      @wy_belt_sparring.make_inactive
      deny @wy_belt_sparring.active
    end

    should "have a working make_active method" do
      @r_belt_sparring.make_active
      assert @r_belt_sparring.active
    end
    
    # should "allow sections without registrations to be deleted" do
    #   assert_equal 0, @bl_belt_breaking.registrations.size  # just to show nothing is there to start
    #   @bl_belt_breaking.destroy
    #   assert @bl_belt_breaking.destroyed?
    # end
    # 
    # should "make sections with registrations to be inactive" do
    #   ed = FactoryGirl.create(:student)
    #   ted = FactoryGirl.create(:student, first_name: "Ted")
    #   reg_ed_sp = FactoryGirl.create(:registration, student: ed, section: @wy_belt_sparring)
    #   reg_ted_sp = FactoryGirl.create(:registration, student: ted, section: @wy_belt_sparring)
    #   assert_equal 2, @wy_belt_sparring.registrations.size  # just to show nothing is there to start
    #   @wy_belt_sparring.destroy
    #   deny @wy_belt_sparring.destroyed?
    #   deny @wy_belt_sparring.active
    #   ed.delete
    #   ted.delete
    #   reg_ed_sp.delete
    #   reg_ted_sp.delete
    # end
  end
end