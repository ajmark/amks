Feature: Authentication
	As an admin
	I want to create and access an account on the system
	In order to manage the system
	
  Scenario: Login successful
    Given a valid admin
    When I go to the login page
    And I fill in "email" with "profh@cmu.edu"
    And I fill in "password" with "secret"
    And I press "Log In"
    Then I should see "You are logged into karate tournament system"
		
  Scenario: Login failed
    Given a valid admin
    When I go to the login page
    And I fill in "email" with "profh@cmu.edu"
    And I fill in "password" with "foobar"
    And I press "Log In"
    Then I should see "Email or password is invalid"
		
  # Scenario: Logout
  #   Given a logged in admin
  #   When I go to the home page
  #   And I click on the link "Logout"
  #   Then I should see "Logged out!"
	
