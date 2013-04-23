FactoryGirl.define do
  factory :student do
    first_name "Ed"
    last_name "Gruberman"
    rank 1
    waiver_signed true
    date_of_birth 9.years.ago.to_date
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    active true
  end
  
  factory :event do
    name "Sparring"
    active true
  end
  
  factory :tournament do
    name "Fall Classic"
    date 3.weeks.from_now.to_date
    min_rank 1
    max_rank 13
    active true
  end
  
  factory :section do
    association :tournament
    association :event
    min_age 9
    max_age 10
    min_rank 1
    max_rank 2
    location "Main gym"
    round_time Time.local(2000,1,1,11,0,0)
    active true
  end

  factory :registration do
    association :section
    association :student
    date Date.today
    fee_paid true
    final_standing 1
  end
  
  factory :dojo do
    name "CMU"
    street "5000 Forbes Avenue"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    active true
  end

  factory :dojo_student do
    association :dojo
    association :student
    start_date 1.year.ago.to_date
    end_date 1.month.ago.to_date
  end

  factory :user do
    email "gruberman@example.com"
    role "member"
    association :student
    password "secret"
    password_confirmation "secret"
    active true
  end
end





