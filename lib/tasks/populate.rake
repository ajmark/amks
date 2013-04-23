namespace :db do
  desc "Erase and fill database"
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    # Invoke rake db:migrate just in case...
    Rake::Task['db:migrate'].invoke
    
    # Need gem to make this work: faker [http://faker.rubyforge.org/rdoc/]
    require 'faker'
    
    # Step 0: clear any old data in the db
    [Tournament, Event, Student, Dojo, Section, User, Registration, DojoStudent].each(&:delete_all)
      
    # Step 1: add a tournament
    tournament = Tournament.new
    tournament.name = "15th Annual A&M Karate Tournament"
    tournament.date = 2.months.from_now.to_date
    tournament.min_rank = 1
    tournament.max_rank = 14
    tournament.active = true
    tournament.save!
    tourney_id = tournament.id
    
    # Step 2: add some events
    events = %w[Sparring Forms Breaking]
    events.each do |ename|
      event = Event.new
      event.name = ename
      event.active = true
      event.save!
    end
    event_ids = Event.all.map(&:id)  # could also write as = Event.pluck(:id)
    sparring_id = Event.find_by_name('Sparring').id
    forms_id = Event.find_by_name('Forms').id
    breaking_id = Event.find_by_name('Breaking').id
    
    # Step 3: add some students, sections, and registrations
    age_ranges = [[5,6],[7,8],[9,10],[11,12],[13,15],[16,18],[19,24],[25,34],[35,70]]
    rank_ranges = [[1,2],[3,4],[5,7],[8,10],[11,13]]
    rank_ranges.each do |r_range|
      age_ranges.each do |a_range|
        # Step 3a: add some students that are in this age and rank range
        eligible_students_ids = Array.new
        n = (4..12).to_a.sample
        n.times do
          months_old = ((a_range[0]*12+1)..(a_range[1]*12+10)).to_a.sample
          stu = Student.new
          stu.first_name = Faker::Name.first_name
          stu.last_name = Faker::Name.last_name
          stu.date_of_birth = months_old.months.ago.to_date
          stu.rank = (r_range[0]..r_range[1]).to_a.sample
          stu.phone = rand(10 ** 10).to_s.rjust(10,'0')
          stu.waiver_signed = true
          stu.active = true
          stu.save!
          eligible_students_ids << stu.id
        end
        
        # Step 3b: add a section for each event for this age/rank range
        sections_for_group = Array.new
        event_ids.each do |e_id|
          section = Section.new
          section.tournament_id = tourney_id
          section.event_id = e_id
          section.min_age = a_range[0]
          section.max_age = a_range[1]
          section.min_rank = r_range[0]
          section.max_rank = r_range[1]
          section.active = true
          section.save!
          sections_for_group << section
        end
        
        # Step 3c: register some, most or all students for the sections just created
        eligible_students_ids.each do |e_stu_id|
          # almost everyone is in forms event
          unless rand(9).zero?
            forms_reg = Registration.new
            forms_reg.student_id = e_stu_id
            forms_reg.section_id = sections_for_group.select{|s| s.event_id == forms_id}.first.id
            forms_reg.date = (2..16).to_a.sample.days.ago.to_date
            forms_reg.fee_paid = true
            forms_reg.save!
          end
          
          # majority are in sparring (none in old black-belt sparring)
          unless rand(3).zero? || (a_range[0]==35 && r_range[0]==11)
            sparring_reg = Registration.new
            sparring_reg.student_id = e_stu_id
            sparring_reg.section_id = sections_for_group.select{|s| s.event_id == sparring_id}.first.id
            sparring_reg.date = (2..16).to_a.sample.days.ago.to_date
            sparring_reg.fee_paid = true
            sparring_reg.save!          
          end
          
          # minority in breaking (none in two junior sections)
          unless rand(5) > 2 || (a_range[0]==5 && r_range[0]==1) || (a_range[0]==9 && r_range[0]==3)
            breaking_reg = Registration.new
            breaking_reg.student_id = e_stu_id
            breaking_reg.section_id = sections_for_group.select{|s| s.event_id == breaking_id}.first.id
            breaking_reg.date = (2..16).to_a.sample.days.ago.to_date
            breaking_reg.fee_paid = true
            breaking_reg.save!          
          end
        end     
      end
    end
    
    # Step 4: create some dojos
    dojos = [["Oakland", "5000 Forbes Avenue", "Pittsburgh", "15213"],
            ["North Side", "250 East Ohio Street", "Pittsburgh", "15212"],
            ["Squirrel Hill", "5738 Forbes Avenue", "Pittsburgh", "15217"],
            ["Murrysville", "4130 Old William Penn Highway", "Murrysville", "15668"], 
            ["Somerset", "708 Stoystown Road", "Somerset", "15501"], 
            ["Indiana", "2510 Warren Road", "Indiana", "15701"], 
            ["Cherry Tree", "640 Cherry Tree Lane", "Uniontown", "15401"], 
            ["McKeesport", "938 Summitt Street", "McKeesport", "15132"]]
            
    dojos.each do |d|
      dojo = Dojo.new
      dojo.name = d[0]
      dojo.street = d[1]
      dojo.city = d[2]
      dojo.state = "PA"
      dojo.zip = d[3]
      dojo.active = true
      dojo.save!
      sleep 1
    end
    
    # Step 5: assign students to dojos randomly
    all_dojo_ids = Dojo.pluck(:id)
    all_student_ids = Student.pluck(:id).shuffle!
    basic_size = all_student_ids.size/all_dojo_ids.size
    
    all_dojo_ids.each do |dojo_id|
      # set the dojo size
      if dojo_id != all_dojo_ids.last
        dojo_size = basic_size + rand(6)
      else
        dojo_size = all_student_ids.size # whatever is left
      end
      
      dojo_size.times do
        ds = DojoStudent.new
        ds.dojo_id = dojo_id
        ds.student_id = all_student_ids.pop
        ds.start_date = (2..20).to_a.sample.months.ago.to_date
        ds.end_date = nil
        ds.save!
      end
    end
    
    # Step 6: give the black belts some additional dojos in their history
    black_belts = Student.dans.by_age.limit(24)
    black_belts.each do |dan|
      possible_dojos = all_dojo_ids.reject{ |d| d==dan.dojos.first.id }
      ds = DojoStudent.new
      ds.dojo_id = possible_dojos.sample
      ds.student_id = dan.id
      ds.start_date = (2..4).to_a.sample.years.ago.to_date
      ds.end_date = dan.dojo_students.first.start_date
      ds.save!
    end
    
    old_black_belts = Student.dans.by_age.limit(12)
    old_black_belts.each do |dan|
      possible_dojos = all_dojo_ids.reject{ |d| dan.dojos.map(&:id).include? d }
      ds = DojoStudent.new
      ds.dojo_id = possible_dojos.sample
      ds.student_id = dan.id
      ds.start_date = (5..7).to_a.sample.years.ago.to_date
      ds.end_date = dan.dojo_students.last.start_date
      ds.save!
    end
  
  end
end