require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # matchers
  should belong_to(:student)
  
  # tests for role
  should allow_value("admin").for(:role)
  should allow_value("member").for(:role)
  should_not allow_value("bad").for(:role)
  should_not allow_value("hacker").for(:role)
  should_not allow_value(10).for(:role)
  should_not allow_value("leader").for(:role)
  should_not allow_value(nil).for(:role)
  
  # tests for email
  should validate_uniqueness_of(:email).case_insensitive
  should allow_value("fred@fred.com").for(:email)
  should allow_value("fred@andrew.cmu.edu").for(:email)
  should allow_value("my_fred@fred.org").for(:email)
  should allow_value("fred123@fred.gov").for(:email)
  should allow_value("my.fred@fred.net").for(:email)
  
  should_not allow_value("fred").for(:email)
  should_not allow_value("fred@fred,com").for(:email)
  should_not allow_value("fred@fred.uk").for(:email)
  should_not allow_value("my fred@fred.com").for(:email)
  should_not allow_value("fred@fred.con").for(:email)
  
  should allow_value(true).for(:active)
  should allow_value(false).for(:active)
  should_not allow_value(nil).for(:active)
  
  # context
  context "Creating context for users" do
    setup do
      create_student_context
      create_user_context
    end
    
    teardown do
      remove_student_context
      remove_user_context
    end
    
    should "not create a user without password inputs" do
      howard_user = FactoryGirl.build(:user, student: @howard, email: "howard@example.com", password: nil, password_confirmation: nil)
      deny howard_user.valid?
    end
    
    should "not create a user without matching password inputs" do
      howard_user = FactoryGirl.build(:user, student: @howard, email: "howard@example.com", password: "notsecret", password_confirmation: "secret")
      deny howard_user.valid?
    end
    
    should "double-checking email for uniqueness" do
      bad_ted_user = FactoryGirl.build(:user, student: @ted, email: "tgruberman@example.com")
      deny bad_ted_user.valid?
      capital_ted_user = FactoryGirl.build(:user, student: @ted, email: "TGRUBERMAN@example.com")
      deny capital_ted_user.valid?
    end
    
    # should "require students to be active and in the system" do
    #   jason_user = FactoryGirl.build(:user, student: @jason, email: "jason@example.com")
    #   deny jason_user.valid?
    #   jamie = FactoryGirl.build(:student, first_name: "Jamie")
    #   jamie_user = FactoryGirl.build(:user, student: jamie, email: "jamie@example.com")
    #   deny jamie_user.valid?
    # end
    
    should "have role? method" do
      deny @jen_user.role?(:member)
      assert @julie_user.role?(:admin)
      assert @ed_user.role?(:member)
      deny @noah_user.role?(:admin)
    end
    
    should "have is_admin? method" do
      assert @jen_user.is_admin?
      assert @julie_user.is_admin?
      deny @ed_user.is_admin?
      deny @noah_user.is_admin?
    end

    should "have is_member? method" do
      deny @jen_user.is_member?
      deny @julie_user.is_member?
      assert @ed_user.is_member?
      assert @noah_user.is_member?
    end
    
    should "have working authenticate method" do
      deny User.authenticate('gruberman@example.com', 'notsecret')
      assert User.authenticate('gruberman@example.com', 'secret')
    end
  end
end
