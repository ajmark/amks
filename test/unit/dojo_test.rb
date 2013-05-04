require 'test_helper'

class DojoTest < ActiveSupport::TestCase
  # matchers
  should have_many(:dojo_students)
  should have_many(:students).through(:dojo_students)
  should validate_presence_of(:name)
  should validate_presence_of(:street)
  should validate_presence_of(:city)  
  # tests for zip
  should allow_value("15213").for(:zip)
  should_not allow_value("bad").for(:zip)
  should_not allow_value("1512").for(:zip)
  should_not allow_value("152134").for(:zip)
  should_not allow_value("15213-0983").for(:zip)
  # tests for state
  should allow_value("OH").for(:state)
  should allow_value("PA").for(:state)
  should allow_value("WV").for(:state)
  should_not allow_value("bad").for(:state)
  should allow_value("NY").for(:state)
  should_not allow_value(10).for(:state)
  should allow_value("CA").for(:state)
  # tests for active
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)

  context "Creating a dojo context" do
    setup do 
      create_dojo_context
    end

    teardown do
      remove_dojo_context
    end
    
    should "allow an existing dojo to be edited" do
      @north.active = false
      assert @north.valid?
    end
    
    should "verify that name is unique, including case insensitivity" do
      @bad_dojo = FactoryGirl.build(:dojo, :name => "North Side")
      deny @bad_dojo.valid?
      @bad_dojo_2 = FactoryGirl.build(:dojo, :name => "squirrel hill")
      deny @bad_dojo_2.valid?
    end
    
    should "have a scope to alphabetize dojos" do
      assert_equal ["CMU", "North Side", "Squirrel Hill"], Dojo.alphabetical.map(&:name)
    end

    should "have a scope to select only active dojos" do
      assert_equal ["CMU", "North Side"], Dojo.active.map(&:name).sort
    end

    should "have a scope to select only inactive dojos" do
      assert_equal ["Squirrel Hill"], Dojo.inactive.map(&:name).sort
    end

    should "have a method to find all current students" do
      create_student_context
      create_dojo_student_context
      assert_equal ["Fred", "Ted"], @north.current_students.map(&:first_name).sort
      remove_student_context
      remove_dojo_student_context
    end   
    
    should "have a method to identify geocoordinates" do
      assert_in_delta(40.444167, @cmu.latitude, 0.00001)
      assert_in_delta(-79.943361, @cmu.longitude, 0.00001)
    end
    
    should "fail to identify geocoordinates for nonsense addresses" do
      bad_dojo = FactoryGirl.build(:dojo, name: "Bad Dojo", street: "Qo'noS", city: "Qo'noS", state: "PA", zip: "00001")
      deny bad_dojo.valid?, "#{bad_dojo.to_yaml}"
    end
    
    # should "delete dojos that have never had students assigned" do
    #   uif = FactoryGirl.create(:dojo, name: "UIF", street: "801 Union Place", city:"Pittsburgh", zip: "15212")
    #   uif.destroy
    #   assert uif.destroyed?
    # end
    # 
    # should "deactivate dojos that have had students ever assigned" do
    #   create_student_context
    #   create_min_dojo_student_context
    #   assert_equal 3, @north.dojo_students.size
    #   @north.destroy
    #   deny @north.destroyed?
    #   @north.reload
    #   deny @north.active
    #   remove_student_context
    #   remove_min_dojo_student_context
    # end
    # 
    # should "end current assignments at a deactivated dojo" do
    #   create_student_context
    #   create_min_dojo_student_context
    #   assert_equal 3, @north.dojo_students.size
    #   @north.destroy
    #   @north.reload
    #   assert_equal 0, @north.current_students.size
    #   remove_student_context
    #   remove_min_dojo_student_context
    # end
  end
end