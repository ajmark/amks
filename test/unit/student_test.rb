require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # Test relationships
  should have_many(:registrations)
  should have_many(:sections).through(:registrations)
  should have_many(:dojo_students)
  should have_many(:dojos).through(:dojo_students)
  should have_many(:tournaments).through(:sections)
  should have_one(:user)
  
  # Test basic validations
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)

  # tests for rank
  should validate_numericality_of(:rank)
  should allow_value(1).for(:rank)
  should allow_value(7).for(:rank)
  should allow_value(10).for(:rank)
  should allow_value(14).for(:rank)
  should allow_value(19).for(:rank)
  should_not allow_value(0).for(:rank)
  should_not allow_value(-1).for(:rank)
  should_not allow_value(3.14159).for(:rank)
  should_not allow_value(nil).for(:rank)
  
  # tests for phone
  should allow_value("4122683259").for(:phone)
  should allow_value("412-268-3259").for(:phone)
  should allow_value("412.268.3259").for(:phone)
  should allow_value("(412) 268-3259").for(:phone)
  should allow_value(nil).for(:phone)
  should_not allow_value("2683259").for(:phone)
  should_not allow_value("14122683259").for(:phone)
  should_not allow_value("4122683259x224").for(:phone)
  should_not allow_value("800-EAT-FOOD").for(:phone)
  should_not allow_value("412/268/3259").for(:phone)
  should_not allow_value("412-2683-259").for(:phone)

  # test date_of_birth
  should allow_value(29.years.ago.to_date).for(:date_of_birth)
  should allow_value(19.years.ago.to_date).for(:date_of_birth)
  should allow_value(14.years.ago.to_date).for(:date_of_birth)
  should allow_value(9.years.ago.to_date).for(:date_of_birth)
  should allow_value(5.years.ago.to_date).for(:date_of_birth)
  should_not allow_value(4.years.ago).for(:date_of_birth)
  should_not allow_value("bad").for(:date_of_birth)
  should_not allow_value(nil).for(:date_of_birth)
  
  # test active and waiver
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
  should allow_value(true).for(:waiver_signed)
  should allow_value(false).for(:waiver_signed)
  should_not allow_value(nil).for(:waiver_signed)

  context "Creating a student context" do
    setup do 
      create_student_context
    end
    
    teardown do
      remove_student_context
    end

    should "allow an existing student to be edited" do
      @jason.active = true
      assert @jason.valid?
    end
    
    should "have working name method" do 
      assert_equal "Gruberman, Ed", @ed.name
    end
    
    should "have working proper_name method" do 
      assert_equal "Ed Gruberman", @ed.proper_name
    end
    
    should "have working age method" do 
      assert_equal 14, @howard.age
      assert_equal 13, @noah.age
      assert_equal 19, @julie.age
    end
    
    should "identifies students over_18? correctly" do 
      deny @ed.over_18?
      deny @noah.over_18?
      assert @jason.over_18?
      assert @julie.over_18?
    end
    
    should "strip non-digits from phone" do 
      assert_equal "4122682323", @ted.phone
    end
    
    should "have class method for finding students in particular section" do
      # add to context for this one test
      @sparring = FactoryGirl.create(:event)
      @wy_belt_sparring = FactoryGirl.create(:section, :event => @sparring)
      @reg_ed = FactoryGirl.create(:registration, :student => @ed, :section => @wy_belt_sparring)
      @reg_ted = FactoryGirl.create(:registration, :student => @ted, :section => @wy_belt_sparring)
      
      # run the test
      students = Student.registered_for_section(@wy_belt_sparring.id)
      assert_equal ["Ed","Ted"], students.map{|s| s.first_name}.sort!
      
      # remove extra context
      @sparring.destroy
      @wy_belt_sparring.destroy
      @reg_ed.destroy
      @reg_ted.destroy
    end
    
    should "have class method for finding students between two ranks" do 
      assert_equal ["Gruberman","Major","Minor"], Student.ranks_between(8,10).alphabetical.all.map(&:last_name)
    end
    
    should "allow ranks_between class method to have a nil value for high_rank" do 
      assert_equal ["Hanson", "Hoover"], Student.ranks_between(12,nil).alphabetical.all.map(&:last_name)
    end
    
    should "have class method for finding students between two ages" do 
      assert_equal ["Gruberman","Gruberman","Gruberman","Gruberman","Hanson","Major","Minor"], Student.ages_between(5,14).alphabetical.all.map(&:last_name)
      assert_equal ["Gruberman","Hanson","Henderson","Major","Minor"], Student.ages_between(11,19).alphabetical.all.map(&:last_name)
    end
    
    should "allow ages_between class method to have a nil value for high_age" do 
      assert_equal ["Henderson", "Hoover"], Student.ages_between(18,nil).alphabetical.all.map(&:last_name)
    end
    
    # start testing scopes...    
    should "have scope for alphabetical listing" do 
      assert_equal ["Gruberman","Gruberman","Gruberman","Gruberman","Hanson","Henderson","Hoover","Major","Minor"], Student.alphabetical.all.map(&:last_name)
    end
    
    should "have scope for active students" do 
      assert_equal ["Gruberman","Gruberman","Gruberman","Gruberman","Hanson","Henderson","Major","Minor"], Student.active.alphabetical.all.map(&:last_name)
    end
    
    should "have scope for inactive students" do 
      assert_equal ["Hoover"], Student.inactive.alphabetical.all.map(&:last_name)
    end
    
    should "have scope for students with signed waiver" do 
      assert_equal ["Gruberman","Gruberman","Gruberman","Gruberman","Hanson","Hoover","Major","Minor"], Student.has_waiver.alphabetical.all.map(&:last_name)
    end
    
    should "have scope for students without signed waiver" do 
      assert_equal ["Henderson"], Student.needs_waiver.alphabetical.all.map(&:last_name)
    end
    
    should "have scope for ordering by rank" do 
      assert_equal ["Hoover","Hanson","Henderson","Gruberman","Major","Minor","Gruberman","Gruberman","Gruberman"], Student.by_rank.all.map(&:last_name)
    end
    
    should "have scope for ordering by age" do 
      assert_equal ["Hoover","Henderson","Minor","Hanson","Gruberman","Major","Gruberman","Gruberman","Gruberman"], Student.by_age.all.map(&:last_name)
    end
    
    should "have scope for listing all gups" do 
      assert_equal ["Gruberman","Major","Minor","Gruberman","Gruberman","Gruberman"], Student.gups.by_rank.all.map(&:last_name)
    end
    
    should "have scope for listing all dans" do 
      assert_equal ["Hoover","Hanson","Henderson"], Student.dans.by_rank.all.map(&:last_name)
    end
    
    should "have scope for listing all juniors" do 
      assert_equal ["Hanson","Gruberman","Major","Minor","Gruberman","Gruberman","Gruberman"], Student.juniors.by_rank.all.map(&:last_name)
    end
    
    should "have scope for listing all seniors" do 
      assert_equal ["Hoover","Henderson"], Student.seniors.by_rank.all.map(&:last_name)
    end
    
    # should "deactivate not destroy student and associated user" do
    #   @noah_user = FactoryGirl.create(:user, student: @noah, email: "noah@example.com")
    #   @noah.destroy
    #   # test that Noah is now inactive
    #   # reload Noah again in the database to make sure changes saved
    #   @noah.reload
    #   deny @noah.active
    #   # test that the noah_user is also inactive
    #   deny @noah.user.active
    #   @noah_user.delete
    # end
    # 
    # should "deactivate student but not err if no user account" do
    #   @ted.destroy
    #   # test that Ted is now inactive
    #   # find Ted again in the database to make sure changes saved
    #   @ted.reload
    #   deny @ted.active
    # end
    # 
    # should "deactivate student should remove any upcoming registrations" do
    #   # additional context for this test
    #   sparring = FactoryGirl.create(:event)
    #   breaking = FactoryGirl.create(:event, name: "Breaking")
    #   fall = FactoryGirl.create(:tournament)
    #   wy_belt_sparring = FactoryGirl.create(:section, event: sparring, tournament: fall)
    #   wy_belt_breaking = FactoryGirl.create(:section, event: breaking, tournament: fall)
    #   reg_ted_sp = FactoryGirl.create(:registration, student: @ted, section: wy_belt_sparring)
    #   reg_ted_br = FactoryGirl.create(:registration, student: @ted, section: wy_belt_breaking)
    #   
    #   @ted.destroy
    #   # reload Ted from the database to make sure changes saved
    #   @ted.reload
    #   # test that both of Ted's registrations are removed
    #   assert_equal 0, @ted.registrations.size
    #   
    #   # remove additional context
    #   sparring.delete
    #   breaking.delete
    #   fall.delete
    #   wy_belt_sparring.delete
    #   wy_belt_breaking.delete
    #   reg_ted_sp.delete
    #   reg_ted_br.delete
    # end
    # 
    # should "deactivate student should end any current dojo assignment" do
    #   cmu = FactoryGirl.create(:dojo)
    #   ted_assignment = FactoryGirl.create(:dojo_student, student: @ted, dojo: cmu, end_date: nil)
    #   @ted.destroy
    #   @ted.reload
    #   assert_equal Date.today, @ted.dojo_students.last.end_date
    # end
  end
end