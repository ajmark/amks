require 'simplecov'
SimpleCov.start 'rails'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Prof. H's deny method to improve readability of tests
  def deny(condition, msg="")
    # a simple transformation to increase readability IMO
    assert !condition, msg
  end
  
  # Context for events
  def create_event_context
    @sparring = FactoryGirl.create(:event)
    @breaking = FactoryGirl.create(:event, name: "Breaking")
    @weapons = FactoryGirl.create(:event, name: "Weapons", active: false)
    @forms = FactoryGirl.create(:event, name: "Forms")
  end
  
  def remove_event_context
    @sparring.delete
    @breaking.delete
    @weapons.delete
    @forms.delete
  end
  
  # Context for tournaments
  def create_tournament_context
    @fall = FactoryGirl.create(:tournament)
    @dans = FactoryGirl.create(:tournament, name: "Dan Tournament", min_rank: 11, max_rank: nil, date: 4.weeks.from_now.to_date)
    @gups = FactoryGirl.create(:tournament, name: "Gup Tournament", min_rank: 1, max_rank: 10, date: 5.weeks.from_now.to_date)
    @postponed = FactoryGirl.create(:tournament, name: "Inactive Tournament", active: false, date: 25.days.from_now.to_date)
  end
  
  def remove_tournament_context
    @fall.delete
    @dans.delete
    @gups.delete
    @postponed.delete
  end
  
  # Context for students
  def create_student_context
    @ed = FactoryGirl.create(:student)
    @ted = FactoryGirl.create(:student, first_name: "Ted", phone: "412-268-2323")
    @fred = FactoryGirl.create(:student, first_name: "Fred", rank: 9)
    @ned = FactoryGirl.create(:student, first_name: "Ned", date_of_birth: 13.years.ago.to_date)
    @noah = FactoryGirl.create(:student, first_name: "Noah", last_name: "Major", rank: 9, date_of_birth: 13.years.ago.to_date)
    @howard = FactoryGirl.create(:student, first_name: "Howard", last_name: "Minor", rank: 8, date_of_birth: 169.months.ago.to_date)
    @jen = FactoryGirl.create(:student, first_name: "Jen", last_name: "Hanson", rank: 12, date_of_birth: 167.months.ago.to_date)
    @julie = FactoryGirl.create(:student, first_name: "Julie", last_name: "Henderson", rank: 11, date_of_birth: 1039.weeks.ago.to_date, waiver_signed: false)
    @jason = FactoryGirl.create(:student, first_name: "Jason", last_name: "Hoover", rank: 14, active: false, date_of_birth: 36.years.ago.to_date)
  end
  
  def remove_student_context
    @ed.delete
    @ted.delete
    @fred.delete
    @ned.delete
    @noah.delete
    @jen.delete
    @howard.delete
    @julie.delete
    @jason.delete
  end
  
  # Context for users
  def create_user_context
    @ed_user = FactoryGirl.create(:user, student: @ed)
    @ted_user = FactoryGirl.create(:user, student: @ted, email: "tgruberman@example.com")
    @fred_user = FactoryGirl.create(:user, student: @fred, email: "fgruberman@example.com")
    @ned_user = FactoryGirl.create(:user, student: @ned, email: "ngruberman@example.com")
    @noah_user = FactoryGirl.create(:user, student: @noah, email: "noah@example.com")
    @jen_user = FactoryGirl.create(:user, student: @jen, role: 'admin', email: "jen@example.com")
    @julie_user = FactoryGirl.create(:user, student: @julie, role: 'admin', email: "julie@example.com")
  end
  
  def remove_user_context
    @ed_user.delete
    @ted_user.delete
    @fred_user.delete
    @ned_user.delete
    @noah_user.delete
    @jen_user.delete
    @julie_user.delete
  end
  
  # Context for sections (requires events)
  def create_section_context
    @wy_belt_sparring = FactoryGirl.create(:section, event: @sparring, tournament: @fall)
    @wy_belt_breaking = FactoryGirl.create(:section, event: @breaking, tournament: @fall, location: "Stage")
    @wy_belt_forms = FactoryGirl.create(:section, event: @forms, tournament: @fall)
    @r_belt_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, tournament: @fall)
    @r_belt_sparring = FactoryGirl.create(:section, event: @sparring, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, active: false, tournament: @fall)
    @bl_belt_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 11, max_rank: nil, min_age: 18, max_age: nil, tournament: @dans)
  end
  
  def remove_section_context
    @wy_belt_sparring.delete
    @wy_belt_breaking.delete
    @wy_belt_forms.delete
    @r_belt_breaking.delete
    @r_belt_sparring.delete
    @bl_belt_breaking.delete
  end
  
  # Context for registrations (requires sections, students)
  def create_registration_context
    @reg_ed_sp = FactoryGirl.create(:registration, student: @ed, section: @wy_belt_sparring, fee_paid: false)
    @reg_ted_sp = FactoryGirl.create(:registration, student: @ted, section: @wy_belt_sparring)
    @reg_ted_br = FactoryGirl.create(:registration, student: @ted, section: @wy_belt_breaking)
    @reg_hm_br = FactoryGirl.create(:registration, student: @howard, section: @r_belt_breaking, date: 1.day.ago.to_date)
    @reg_nm_br = FactoryGirl.create(:registration, student: @noah, section: @r_belt_breaking, date: 2.days.ago.to_date)
  end
  
  def remove_registration_context
    @reg_ed_sp.delete
    @reg_ted_sp.delete
    @reg_ted_br.delete
    @reg_nm_br.delete
    @reg_hm_br.delete
  end
  
  def create_dojo_context
    @cmu = FactoryGirl.create(:dojo)
    sleep 1
    @north = FactoryGirl.create(:dojo, name: "North Side", street: "250 East Ohio St", city:"Pittsburgh", zip: "15212")
    sleep 1
    @sqhill = FactoryGirl.create(:dojo, name: "Squirrel Hill", street: "5738 Forbes Avenue", city:"Pittsburgh", zip: "15217", active: false)
  end
  
  def remove_dojo_context
    @cmu.delete
    @north.delete
    @sqhill.delete
  end
  
  def create_dojo_student_context
    @ed_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ed)
    @ted_cmu_dojo = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @ted, start_date: 2.years.ago.to_date, end_date: 1.year.ago.to_date)
    @ted_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ted, start_date: 1.year.ago.to_date, end_date: nil)
    @fred_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @fred, start_date: 2.years.ago.to_date, end_date: nil)
    @noah_dojo = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @noah, end_date: nil)
  end
  
  def remove_dojo_student_context
    @ed_dojo.delete
    @ted_dojo.delete
    @ted_cmu_dojo.delete
    @fred_dojo.delete
    @noah_dojo.delete
  end
  
  def create_min_dojo_context
    @north = FactoryGirl.create(:dojo, name: "North Side", street: "250 East Ohio St", city:"Pittsburgh", zip: "15212")
  end
  
  def remove_min_dojo_context
    @north.delete
  end
  
  def create_min_dojo_student_context
    @ed_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ed)
    @ted_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ted, start_date: 1.year.ago.to_date, end_date: nil)
    @fred_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @fred, start_date: 2.years.ago.to_date, end_date: nil)
  end
  
  def remove_min_dojo_student_context
    @ed_dojo.delete
    @ted_dojo.delete
    @fred_dojo.delete
  end
end