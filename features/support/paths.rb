module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #

  def path_to(page_name)
    case page_name

    when /the home\s?page/
      '/'
      
      
    #### USERS
    when /the login page/
      login_path
    
    #### EVENTS
    when /the events page/
      events_path
    
    when /the sparring details page/
      event_path(@sparring)
      
    when /the breaking details page/
      event_path(@breaking)
      
    when /the new event page/
      new_event_path
      
    when /edit breaking event page/
      edit_event_path(@breaking)
      
    #### STUDENTS
    when /the students page/
      students_path

    when /the details page for Ed Gruberman/
      student_path(@ed)

    when /the details page for Ted Gruberman/
      student_path(@ted)

    when /the new student page/
      new_student_path

    when /edit Ed Gruberman page/
      edit_student_path(@ed)
      
    when /edit Ted Gruberman page/
      edit_student_path(@ted)
      
    #### TOURNAMENTS
    when /the tournaments page/
      tournaments_path

    when /the details page for fall classic/
      tournament_path(@fall)

    when /the new tournament page/
      new_tournament_path

    when /edit fall classic page/
      edit_tournament_path(@fall)


    #### SECTIONS
    when /the sections page/
      sections_path

    when /the details page for white belt sparring/
      section_path(@wy_belt_sparring)

    when /the details page for red belt breaking/
      section_path(@r_belt_breaking)

    when /the new section page/
      new_section_path

    when /edit white belt sparring page/
      edit_section_path(@wy_belt_sparring)

    when /edit red belt breaking page/
      edit_section_path(@r_belt_breaking)
      
      
    #### DOJOS
    when /the dojos page/
      dojos_path

    when /the details page for the North Side dojo/
      dojo_path(@north)

    when /the new dojo page/
      new_dojo_path

    when /edit the North Side dojo/
      edit_dojo_path(@north)
          
            
    #### SEMI-STATIC PAGES
    when /the About Us page/
      about_path
      
    when /the Contact Us page/
      contact_path
      
    when /the Privacy page/
      privacy_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
