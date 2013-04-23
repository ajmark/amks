require 'test_helper'

class DojoStudentTest < ActiveSupport::TestCase
  # matchers
  should belong_to(:dojo)
  should belong_to(:student)
  # quick tests of ids
  should validate_numericality_of(:student_id)
  should validate_numericality_of(:dojo_id)
  should_not allow_value(3.14159).for(:student_id)
  should_not allow_value(0).for(:student_id)
  should_not allow_value(-1).for(:student_id)
  should_not allow_value(3.14159).for(:dojo_id)
  should_not allow_value(0).for(:dojo_id)
  should_not allow_value(-1).for(:dojo_id)
  # for start date
  should allow_value(7.weeks.ago.to_date).for(:start_date)
  should allow_value(1.day.ago.to_date).for(:start_date)
  should allow_value(Date.today).for(:start_date)
  should_not allow_value(1.week.from_now.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)
  
  # context
  context "Creating a dojo_student context" do
    setup do 
      create_dojo_context
      create_student_context
      create_dojo_student_context
    end
    
    teardown do
      remove_dojo_context
      remove_student_context
      remove_dojo_student_context
    end

    should "not allow dojo_students for non-existent students" do
      george = FactoryGirl.build(:student, :first_name => "George")
      bad_assignment = FactoryGirl.build(:dojo_student, dojo: @cmu, student: george)
      deny bad_assignment.valid?
    end
    
    should "not allow dojo_students for inactive students" do
      bad_assignment = FactoryGirl.build(:dojo_student, dojo: @cmu, student: @jason)
      deny bad_assignment.valid?
    end
    
    should "not allow dojo_students for non-existent dojos" do
      cherrytree = FactoryGirl.build(:dojo, name: "Cherry Tree", street: "640 Cherry Tree Lane", city: "Uniontown", state: "PA", zip: "15401")
      bad_assignment = FactoryGirl.build(:dojo_student, dojo:cherrytree, student: @julie)
      deny bad_assignment.valid?
    end
    
    should "not allow dojo_students for inactive dojos" do
      bad_assignment = FactoryGirl.build(:dojo_student, dojo: @sqhill, student: @julie)
      deny bad_assignment.valid?
    end
    
    should "allow for a end date in the past (or today) but after the start date" do
      # Note that we've been testing :end_date => nil for a while now so safe to assume works...
      howard_dojo = FactoryGirl.build(:dojo_student, dojo: @north, student: @howard, end_date: 5.days.ago.to_date)
      assert howard_dojo.valid?
      second_dojo_for_howard = FactoryGirl.build(:dojo_student, dojo: @cmu, student: @howard, start_date: 4.days.ago.to_date, end_date: Date.today)
      assert second_dojo_for_howard.valid?
    end
    
    should "not allow for a end date in the future or before the start date" do
      howard_dojo = FactoryGirl.build(:dojo_student, dojo: @north, student: @howard, start_date: 4.days.ago.to_date, end_date: 5.days.ago.to_date)
      deny howard_dojo.valid?
      second_dojo_for_howard = FactoryGirl.build(:dojo_student, dojo: @cmu, student: @howard, start_date: 4.days.ago.to_date, end_date: 5.days.from_now.to_date)
      deny second_dojo_for_howard.valid?
    end
    
    should "have a scope to alphabetize assignments by dojo name" do
      assert_equal ["CMU", "CMU", "North Side", "North Side", "North Side"], DojoStudent.by_dojo.map{|ds| ds.dojo.name}
    end
    
    should "have a scope to alphabetize assignments by student name" do
      assert_equal ["Ed", "Fred", "Ted", "Ted", "Noah"], DojoStudent.by_student.map{|ds| ds.student.first_name}
    end
    
    should "have a scope to order assignments by date" do
      assert_equal [["#{1.year.ago.to_date.to_s}", false],["#{1.year.ago.to_date.to_s}", true],["#{1.year.ago.to_date.to_s}", true],["#{2.years.ago.to_date.to_s}", false],["#{2.years.ago.to_date.to_s}", true]], DojoStudent.chronological.map{|ds| [ds.start_date.to_s, ds.end_date.nil?]}
    end
    
    should "have a scope to find all current assignments" do
      assert_equal [["Ted", "North Side", "#{1.year.ago.to_date.to_s}"],["Fred", "North Side", "#{2.years.ago.to_date.to_s}"],["Noah", "CMU", "#{1.year.ago.to_date.to_s}"]], DojoStudent.current.map{|ds| [ds.student.first_name, ds.dojo.name, ds.start_date.to_s]}
    end
    
    should "end current assignment (if exists) before assigning a new dojo to a student" do
      move_ted_to_cmu = FactoryGirl.create(:dojo_student, student: @ted, dojo: @cmu, start_date: Date.today, end_date: nil)
      @ted_dojo.reload # reload from db
      assert_equal Date.today, @ted_dojo.end_date
      move_ted_to_cmu.delete
    end
  end
end
