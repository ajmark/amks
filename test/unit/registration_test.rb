require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  # Shoulda macros
  should belong_to(:student)
  should belong_to(:section)
  should have_one(:event).through(:section)
  should have_one(:tournament).through(:section)
  
  # test date
  should allow_value(Date.today).for(:date)
  should allow_value(1.day.ago.to_date).for(:date)
  should_not allow_value("bad").for(:date)
  should_not allow_value(2).for(:date)
  should_not allow_value(3.14159).for(:date)
  should_not allow_value(1.day.from_now.to_date).for(:date)
  
  # quick tests of ids
  should validate_numericality_of(:student_id)
  should validate_numericality_of(:section_id)
  should_not allow_value(3.14159).for(:student_id)
  should_not allow_value(0).for(:student_id)
  should_not allow_value(-1).for(:student_id)
  should_not allow_value(3.14159).for(:section_id)
  should_not allow_value(0).for(:section_id)
  should_not allow_value(-1).for(:section_id)
  
  # Context for rest of testing
  context "Creating registrations context" do
    setup do
      create_event_context
      create_tournament_context
      create_student_context
      create_section_context
      create_registration_context
    end
    
    teardown do
      remove_event_context
      remove_tournament_context 
      remove_student_context
      remove_section_context
      remove_registration_context
    end
        
    should "show proper counts for registrations for students" do
      assert_equal 1, @ed.registrations.size
      assert_equal 2, @ted.registrations.size
      assert_equal 1, @howard.registrations.size
      assert_equal 1, @noah.registrations.size
      assert_equal 0, @julie.registrations.size
    end
    
    should "not allow registrations for non-existent students" do
      @george = FactoryGirl.build(:student, :first_name => "George")
      @bad_registration = FactoryGirl.build(:registration, :section => @bl_belt_breaking, :student => @george)
      deny @bad_registration.valid?
    end
    
    should "not allow registrations for inactive students" do
      @bad_registration = FactoryGirl.build(:registration, :section => @bl_belt_breaking, :student => @jason)
      deny @bad_registration.valid?
    end
    
    should "not allow registrations for non-existent sections" do
      @bl_belt_sparring = FactoryGirl.build(:section, :event => @sparring, :min_rank => 11, :max_rank => 13)
      @bad_registration = FactoryGirl.build(:registration, :section => @bl_belt_sparring, :student => @julie)
      deny @bad_registration.valid?
    end
    
    should "not allow registrations for inactive sections" do
      @bad_registration = FactoryGirl.build(:registration, :section => @r_belt_sparring, :student => @noah)
      deny @bad_registration.valid?
    end
    
    should "not allow registrations for students above or below rank range" do
      @too_high_rank = FactoryGirl.build(:registration, :section => @wy_belt_breaking, :student => @fred)
      deny @too_high_rank.valid?
      @too_low_rank = FactoryGirl.build(:registration, :section => @r_belt_breaking, :student => @ned)
      deny @too_low_rank.valid?
    end
    
    should "not allow registrations for students above or below age range" do
      @too_young = FactoryGirl.build(:registration, :section => @bl_belt_breaking, :student => @jen)
      deny @too_young.valid?
      @too_old = FactoryGirl.build(:registration, :section => @wy_belt_breaking, :student => @ned)
      deny @too_old.valid?
    end
    
    should "not allow duplicate registration to be created" do
      @duplicate_registration = FactoryGirl.build(:registration, :student => @ed, :section => @wy_belt_sparring)
      deny @duplicate_registration.valid?
    end
    
    should "allow an existing registration to be edited" do
      @reg_nm_br.date = 4.days.ago.to_date
      assert @reg_nm_br.valid?
    end
    
    should "have a scope to alphabetize registrations by event name" do
      assert_equal ["Breaking", "Breaking", "Breaking", "Sparring", "Sparring"], Registration.by_event_name.map{|r| r.section.event.name}
    end
    
    should "have a scope to alphabetize registrations by student name" do
      assert_equal ["Ed", "Ted", "Ted", "Noah", "Howard"], Registration.by_student.map{|r| r.student.first_name}
    end
    
    should "have a scope to order registrations by date" do
      assert_equal ["Noah", "Howard", "Ed", "Ted", "Ted"], Registration.by_date.by_student.map{|r| r.student.first_name}
    end
    
    should "have a scope to filter registrations by student" do
      assert_equal 2, Registration.for_student(@ted.id).size
      assert_equal 1, Registration.for_student(@ed.id).size
      assert_equal 0, Registration.for_student(@julie.id).size
    end
    
    should "have a scope to filter registrations by section" do
      assert_equal 2, Registration.for_section(@wy_belt_sparring.id).size
      assert_equal 1, Registration.for_section(@wy_belt_breaking.id).size
      assert_equal 0, Registration.for_section(@bl_belt_breaking.id).size
    end
    
    should "have a scope to filter paid and unpaid registrations" do
      assert_equal 1, Registration.unpaid.size
      assert_equal 4, Registration.paid.size
    end
    
  end
end
