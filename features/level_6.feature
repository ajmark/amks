Feature: Manage dojos
	As an administrator
	I want to be able to manage dojo information
	So I can more effectively run the karate school

	Background:
	  Given dojos and students
	  Given a logged-in admin
	
	# READ METHODS
	Scenario: View all dojos
		When I go to the dojos page
		Then I should see "Active Dojos"
		And I should see "CMU"
		And I should see "North Side"
		And I should see "Pittsburgh, PA"
		And I should see "Members"
		And I should see "2"
    And I should not see "true"
    And I should not see "True"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		And I should not see "created"
			
	Scenario: View dojo details
		When I go to the details page for the North Side dojo
		Then I should see "Dojo Details"
		And I should see "North Side"
		And I should see "250 East Ohio St"
		And I should see "Pittsburgh, PA 15212"
		And I should see "Current Members"
		And I should see "Gruberman, Ted"
		And I should see "Gruberman, Fred"
		And I should see "Tenth Gup"
		And I should not see "CMU"
		And I should not see "Gruberman, Ed"  
		And I should not see "Corrlucci, Steve"
		And I should not see "true"
		And I should not see "true"
	
	Scenario: The dojo name is a link to details
		When I go to the dojos page
		And I click on the link "CMU"
		Then I should see "Dojo Details"
		And I should see "CMU"
		And I should see "5000 Forbes Avenue"
		And I should see "Pittsburgh, PA 15213"
		And I should see "Current Members"
		And I should see "Major, Noah"
		And I should see "Corrlucci, Steve"
		And I should see "Second Gup"
		And I should not see "true"
    And I should not see "True"
		And I should not see "ID"
		And I should not see "_id"
		And I should not see "Created"
		And I should not see "created"
	    	
	
	# CREATE METHODS
  Scenario: Creating a new dojo is successful
    When I go to the new dojo page
    And I fill in "dojo_name" with "Cherry Tree"
    And I fill in "dojo_street" with "640 Cherry Tree Lane"
    And I fill in "dojo_city" with "Uniontown"
    And I select "Pennsylvania" from "dojo_state"
    And I fill in "dojo_zip" with "15401"
    And I press "Create Dojo"
    Then I should see "Successfully created Cherry Tree dojo"
    And I should see "Uniontown, PA 15401"
    And I should see "Current Members"
    And I should see "None at this time"
  
  
  # UPDATE METHODS
  Scenario: Updating an existing dojo is successful
    When I go to edit the North Side dojo
    And I fill in "dojo_name" with "NorthSide"
    And I press "Update Dojo"
    Then I should see "Successfully updated NorthSide dojo"
    And I should see "NorthSide"
  
