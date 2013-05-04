Feature: Manage events
	As an administrator
	I want to be able to manage event information
	So I can more effectively run tournaments

	Background:
	  Given an initial setup
	  Given a logged-in admin
	
	# READ METHODS
	Scenario: View all events
		When I go to the events page
		Then I should see "List of Events"
		And I should see "Name"
		And I should see "Active"
		And I should see "Breaking"
		And I should see "Sparring"
		And I should see "Forms"
		And I should see "Weapons"
    And I should not see "true"
    And I should not see "True"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		And I should not see "created"
			
	Scenario: View event details
		When I go to the sparring details page
		Then I should see "Event Details"
		And I should see "Name"
		And I should see "Sparring"
		And I should see "Active"
		And I should not see "Breaking"
		And I should not see "Forms"
		And I should not see "true"
	
	Scenario: The event name is a link to details
		When I go to the events page
		And I click on the link "Breaking"
		And I should see "Event Details"
		And I should see "Name"
		And I should see "Breaking"
		And I should see "Active"
		And I should not see "Sparring"
		And I should not see "Forms"
		And I should not see "true"
    And I should not see "True"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		And I should not see "created"
	    	
	
	# CREATE METHODS
  Scenario: Creating a new event is successful
    When I go to the new event page
    And I fill in "event_name" with "Breaking Blocks"
    And I press "Create Event"
    Then I should see "Successfully created Breaking Blocks"
    And I should see "Name: Breaking Blocks"
    And I should see "Active: Yes"
  
  Scenario: Creating a new event fails without a name
    When I go to the new event page
    And I press "Create Event"
    Then I should see "can't be blank"
  
  Scenario: Creating a new event fails without unique name
    When I go to the new event page
    And I fill in "event_name" with "breaking"
    And I press "Create Event"
    Then I should see "has already been taken"
  
  
  # UPDATE METHODS
  Scenario: Updating an existing event is successful
    When I go to edit breaking event page
    And I fill in "event_name" with "Breaking Boards"
    And I press "Update Event"
    Then I should see "Successfully updated Breaking Boards"
    And I should see "Name: Breaking Boards"
  
