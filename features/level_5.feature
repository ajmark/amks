Feature: Manage tournaments
  As an administrator
  I want to be able to manage tournaments
  So I can more effectively run karate tournaments

  Background:
    Given red and white belt students
    Given a logged-in admin
  
  # READ METHODS
  Scenario: View all tournaments
    When I go to the tournaments page
    Then I should see "Tournaments"
		And I should see "Date"
		And I should see "Name"
		And I should see "Ranks"
		And I should see "Fall Classic"
		And I should see "Tenth Gup - Third Dan"
		And I should see "5"
		And I should see "Dan Tournament"
		And I should see "First Dan and up"
		And I should see "0"
		And I should see "Gup Tournament"
		And I should see "Tenth Gup - First Gup"
		And I should see "0"
		And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
  Scenario: The tournament name in all tourneys is a link to details
    When I go to the tournaments page
    And I click on the link "Fall Classic"
    And I should see "Tournament Details"
    And I should see "Ranks: Tenth Gup - Third Dan"
    And I should see "Fall Classic"
    And I should see "Active: Yes"
    And I should see "Sections"
    And I should see "Event"
    And I should see "Age"
    And I should not see "Dan Tournament"
    And I should not see "First Dan and up"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"    
  
  
  Scenario: Event name in tourney details is a link to section details
    When I go to the details page for fall classic
    And I click on the link "Sparring"
    Then I should see "Gruberman, Ed"
    And I should see "Gruberman, Ted"
    And I should see "Event: Sparring"
    And I should see "Tenth Gup - Ninth Gup"
    And I should see "Active: Yes"
    And I should not see "Howard"
    And I should not see "Noah"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
        
  # CREATE METHODS
  Scenario: Creating a new tournament is successful
    When I go to the new tournament page
    And I fill in "tournament_name" with "Tang Soo Do Championship"
    And I select "October" from "tournament_date_2i"
    And I select "30" from "tournament_date_3i"
    And I select "2013" from "tournament_date_1i"
    And I select "Third Gup" from "tournament_min_rank"
    And I select "Third Dan" from "tournament_max_rank"
    And I press "Create Tournament"
    Then I should see "Successfully created Tang Soo Do Championship"
    And I should see "Tournament Details"
    And I should see "Ranks: Third Gup - Third Dan"
    And I should not see "Fall Classic"


  # UPDATE METHODS
  Scenario: Updating an existing tournament is successful
    When I go to edit fall classic page
    And I select "Fourth Dan" from "tournament_max_rank"
    And I press "Update Tournament"
    Then I should see "Successfully updated Fall Classic"
    And I should see "Tenth Gup - Fourth Dan"

