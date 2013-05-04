Feature: Manage sections
  As an administrator
  I want to be able to manage sections
  So I can more effectively run karate tournaments

  Background:
    Given red and white belt students
    Given a logged-in admin
  
  # READ METHODS
  Scenario: View all sections
    When I go to the sections page
    Then I should see "Current Sections"
		And I should see "Event"
		And I should see "Age(s)"
		And I should see "Rank(s)"
		And I should see "Registrants"
		And I should see "Breaking"
		And I should see "Sparring"
		And I should see "Tenth Gup - Ninth Gup"
		And I should see "Third Gup - First Gup"
		And I should see "9 - 10"
		And I should see "13 - 15"
		And I should see "9 - 10"
		And I should see "2"
		And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
  Scenario: The event name in all sections is a link to section details
    When I go to the sections page
    And I click on the link "Sparring"
    And I should see "Section Details"
    And I should see "Rank(s): Tenth Gup - Ninth Gup"
    And I should see "Age(s): 9 - 10"
    And I should see "Active: Yes"
    And I should see "Students Registered"
    And I should see "Gruberman, Ed"
    And I should see "Gruberman, Ted"
    And I should not see "Breaking"
    And I should not see "Noah"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"    
  
  Scenario: View sections details for active section
    When I go to the details page for red belt breaking
    Then I should see "Section Details"
    And I should see "Rank(s): Third Gup - First Gup"
    And I should see "Age(s): 13 - 15"
    And I should see "Active: Yes"
    And I should see "Students Registered"
    And I should see "Minor, Howard"
    And I should see "Major, Noah"
    And I should see "Second Gup"
    And I should see "Age"
    And I should see "14"
    And I should not see "Sparring"
    And I should not see "Gruberman"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
  Scenario: The student name in section details is a link to student details
    When I go to the details page for red belt breaking
    And I click on the link "Minor, Howard"
    Then I should see "Minor, Howard"
    And I should see "Rank: Third Gup"
    And I should see "Waiver Signed: Yes"
    And I should see "Active: Yes"
    And I should not see "Gruberman"
    And I should not see "Noah"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
        
  # CREATE METHODS
  Scenario: Creating a new section is successful
    When I go to the new section page
    And I select "Fall Classic" from "section_tournament_id"
    And I select "Forms" from "section_event_id"
    And I fill in "section_min_age" with "35"
    And I select "Third Gup" from "section_min_rank"
    And I select "First Gup" from "section_max_rank"
    And I press "Create Section"
    Then I should see "Successfully created section"
    And I should see "Section Details"
    And I should see "Age(s): 35 and up"
    And I should see "Event: Forms"
    
  Scenario: Creating a new section is fails when missing event
    When I go to the new section page
    And I select "Fall Classic" from "section_tournament_id"
    And I fill in "section_min_age" with "40"
    And I select "Third Gup" from "section_min_rank"
    And I select "First Gup" from "section_max_rank"
    And I press "Create Section"
    Then I should see "is not a valid event"

    
  # UPDATE METHODS
  Scenario: Updating an existing section is successful
    When I go to edit white belt sparring page
    And I fill in "section_max_age" with "11"
    And I press "Update Section"
    Then I should see "Successfully updated section"
    And I should see "Age(s): 9 - 11"

