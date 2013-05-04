# Context for events
def create_events_and_tournaments_context
  @sparring = FactoryGirl.create(:event)
  @breaking = FactoryGirl.create(:event, name: "Breaking")
  @forms = FactoryGirl.create(:event, name: "Forms")
  @weapons = FactoryGirl.create(:event, name: "Weapons", active: false)

  @fall = FactoryGirl.create(:tournament)
  @dans = FactoryGirl.create(:tournament, name: "Dan Tournament", min_rank: 11, max_rank: nil, date: 4.weeks.from_now.to_date)
  @gups = FactoryGirl.create(:tournament, name: "Gup Tournament", min_rank: 1, max_rank: 10, date: 5.weeks.from_now.to_date)
  @postponed = FactoryGirl.create(:tournament, name: "Inactive Tournament", active: false, date: 25.days.from_now.to_date)
end

def create_students_and_dojos_context
  @ed = FactoryGirl.create(:student)
  @ted = FactoryGirl.create(:student, first_name: "Ted", phone: "412-268-2323", date_of_birth: Date.new(2003,04,01))
  @ned = FactoryGirl.create(:student, first_name: "Ned", date_of_birth: 13.years.ago.to_date)
  @fred = FactoryGirl.create(:student, first_name: "Fred")
  
  @steve = FactoryGirl.create(:student, first_name: "Steve", last_name: "Corrlucci", rank: 9)
  @noah = FactoryGirl.create(:student, first_name: "Noah", last_name: "Major", rank: 9, date_of_birth: 13.years.ago.to_date)
  @howard = FactoryGirl.create(:student, first_name: "Howard", last_name: "Minor", rank: 8, date_of_birth: 169.months.ago.to_date)
  
  @jen = FactoryGirl.create(:student, first_name: "Jen", last_name: "Hanson", rank: 12, date_of_birth: 167.months.ago.to_date)
  @julie = FactoryGirl.create(:student, first_name: "Julie", last_name: "Henderson", rank: 11, date_of_birth: 1039.weeks.ago.to_date, waiver_signed: false)
  @jason = FactoryGirl.create(:student, first_name: "Jason", last_name: "Hoover", rank: 14, active: false, date_of_birth: 36.years.ago.to_date)
  
  @cmu = FactoryGirl.create(:dojo)
  sleep 1
  @north = FactoryGirl.create(:dojo, name: "North Side", street: "250 East Ohio St", city:"Pittsburgh", zip: "15212")
  sleep 1
  @sqhill = FactoryGirl.create(:dojo, name: "Squirrel Hill", street: "5738 Forbes Avenue", city:"Pittsburgh", zip: "15217", active: false)
end

# Context for students
def create_white_yellow_belt_context
  # ASSUMES THAT EVENT & TOURNAMENT CONTEXTS WERE CREATED FIRST
  
  # first, create sections for white and yellow belts
  @wy_belt_sparring = FactoryGirl.create(:section, event: @sparring, tournament: @fall)
  @wy_belt_breaking = FactoryGirl.create(:section, event: @breaking, tournament: @fall, location: "Stage")
  @wy_belt_forms = FactoryGirl.create(:section, event: @forms, tournament: @fall)
  
  # second, create some students who could register 
  
  # finally, create some registrations
  @reg_ed_sp = FactoryGirl.create(:registration, student: @ed, section: @wy_belt_sparring)
  @reg_ted_sp = FactoryGirl.create(:registration, student: @ted, section: @wy_belt_sparring)
  @reg_ted_br = FactoryGirl.create(:registration, student: @ted, section: @wy_belt_breaking)
end

def create_red_belt_context
  # ASSUMES THAT EVENT & TOURNAMENT CONTEXTS WERE CREATED FIRST
  
  # first, create sections for red belts (1st-3rd gups)
  @r_belt_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, tournament: @fall)
  # @r_belt_sparring = FactoryGirl.create(:section, event: @sparring, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, active: false)
  @r_belt_forms = FactoryGirl.create(:section, event: @forms, min_rank: 8, max_rank: 10, min_age: 13, max_age: 15, active: false, tournament: @fall)
  
  # second, create some red belt students
  
  # finally, create some registrations
  @reg_hm_br = FactoryGirl.create(:registration, student: @howard, section: @r_belt_breaking, date: 1.day.ago.to_date)
  @reg_nm_br = FactoryGirl.create(:registration, student: @noah, section: @r_belt_breaking, date: 2.days.ago.to_date)
end

def create_black_belt_context
  # sections
  @bl_belt_breaking = FactoryGirl.create(:section, event: @breaking, min_rank: 11, max_rank: nil, min_age: 18, max_age: nil, tournament: @dans)
  # students
end

def create_dojo_student_context
  # ASSUMES STUDENT & DOJO CONTEXTS WERE CREATED FIRST
  @ed_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ed)
  @ted_cmu_dojo = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @ted, start_date: 2.years.ago.to_date, end_date: 1.year.ago.to_date)
  @ted_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @ted, start_date: 1.year.ago.to_date, end_date: nil)
  @fred_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @fred, start_date: 2.years.ago.to_date, end_date: nil)
  @noah_dojo = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @noah, end_date: nil)
  @steve_cmu_dojo_1 = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @steve, start_date: 2.years.ago.to_date, end_date: 13.months.ago.to_date)
  @steve_north_dojo = FactoryGirl.create(:dojo_student, dojo: @north, student: @steve, start_date: 13.months.ago.to_date, end_date: 3.months.ago.to_date)
  @steve_cmu_dojo_2 = FactoryGirl.create(:dojo_student, dojo: @cmu, student: @steve, start_date: 3.months.ago.to_date, end_date: nil)
  
end

Given /^an initial setup$/ do
  create_events_and_tournaments_context
  create_students_and_dojos_context
  create_white_yellow_belt_context
end

Given /^red and white belt students$/ do
  create_events_and_tournaments_context
  create_students_and_dojos_context
  create_white_yellow_belt_context
  create_red_belt_context
end

Given /^dojos and students$/ do
  create_students_and_dojos_context
  create_dojo_student_context
end

Given /^a valid admin$/ do
  @profh = FactoryGirl.create(:student, first_name: "Professor", last_name: "Heimann", rank: 14)
  @profh_user = FactoryGirl.create(:user, student: @profh, email: "profh@cmu.edu", role: "admin")
end

Given /^a logged-in admin$/ do
  # Given "a valid admin"
  # visit login_url
  step "a valid admin"
  visit login_path
  fill_in "Email", :with => "profh@cmu.edu"
  fill_in "Password", :with => "secret"
  click_button("Log In")
end