Feature: Manage students
  As an administrator
  I want to be able to manage student data
  So I can more effectively run the karate school

  Background:
    Given red and white belt students
    Given a logged-in admin
  
  # READ METHODS
  Scenario: View all students
    When I go to the students page
    Then I should see "Active Students"
		And I should see "Name"
		And I should see "Age"
		And I should see "Rank"
		And I should see "Gruberman, Ed"
		And I should see "Gruberman, Ted"
		And I should see "Major, Noah"
		And I should see "Tenth Gup"
		And I should see "Third Gup"
		And I should see "Tenth Gup"
		And I should see "13"
		And I should see "Inactive Students"
		And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
  Scenario: The student name in all students is a link to student details
    When I go to the students page
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

  Scenario: View student details for active student
    When I go to the details page for Ted Gruberman
    Then I should see "Gruberman, Ted"
    And I should see "Phone: 412-268-2323"
    And I should not see "Phone: 4122682323"
    And I should see "Date of Birth: 04/01/03"
    And I should not see "Date of birth: 2003-04-01"
    And I should see "Active: Yes"
    And I should see "Tournament Activity"
    And I should see "Event"
    And I should see "Breaking"
    And I should not see "Forms"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    
  Scenario: The event name in student details is a link to section details
    When I go to the details page for Ted Gruberman
    And I click on the link "Sparring"
    Then I should see "Section Details"
    And I should see "Students Registered"
    And I should see "Sparring"
    And I should see "Gruberman, Ted"
    And I should see "Gruberman, Ed"
    
        
  # CREATE METHODS
  Scenario: Creating a new student is successful
    When I go to the new student page
    And I fill in "student_first_name" with "Zaphod"
    And I fill in "student_last_name" with "Beeblebrox"
    And I fill in "student_phone" with "724.364.9511"
    And I select "April" from "student_date_of_birth_2i"
    And I select "30" from "student_date_of_birth_3i"
    And I select "1993" from "student_date_of_birth_1i"
    And I select "Fifth Gup" from "student_rank"
    And I check "student_active"
    And I press "Create Student"
    Then I should see "Successfully created Zaphod Beeblebrox"
    And I should see "Name: Beeblebrox, Zaphod"
    And I should see "Date of Birth: 04/30/93"
    And I should see "Phone: 724-364-9511"
    
  Scenario: Creating a new student fails without a name
    When I go to the new student page
    And I fill in "student_phone" with "724.364.9511"
    And I select "April" from "student_date_of_birth_2i"
    And I select "30" from "student_date_of_birth_3i"
    And I select "1993" from "student_date_of_birth_1i"
    And I select "Fifth Gup" from "student_rank"
    And I check "student_active"
    And I press "Create Student"
    Then I should not see "Successfully created Zaphod Beeblebrox"
    And I should see "can't be blank"
    
  Scenario: Creating a new student fails with bad phone
    When I go to the new student page
    And I fill in "student_first_name" with "Zaphod"
    And I fill in "student_last_name" with "Beeblebrox"
    And I fill in "student_phone" with "364-87-9511"
    And I select "April" from "student_date_of_birth_2i"
    And I select "30" from "student_date_of_birth_3i"
    And I select "1993" from "student_date_of_birth_1i"
    And I select "Fifth Gup" from "student_rank"
    And I check "student_active"
    And I press "Create Student"
    Then I should see "should be 10 digits"
    And I should not see "Successfully created Zaphod Beeblebrox"
    When I fill in "student_phone" with "724-364-9511"
    And I press "Create Student"
    Then I should see "Successfully created Zaphod Beeblebrox"    
      
  Scenario: Creating a new student fails without rank
    When I go to the new student page
    And I fill in "student_first_name" with "Zaphod"
    And I fill in "student_last_name" with "Beeblebrox"
    And I fill in "student_phone" with "724.364.9511"
    And I select "December" from "student_date_of_birth_2i"
    And I select "31" from "student_date_of_birth_3i"
    And I select "1993" from "student_date_of_birth_1i"
    And I check "student_active"
    And I press "Create Student"
    Then I should not see "Successfully created Zaphod Beeblebrox"

  # UPDATE METHODS
  Scenario: Updating an existing student is successful
    When I go to edit Ed Gruberman page
    And I select "Ninth Gup" from "student_rank"
    And I press "Update Student"
    Then I should see "Successfully updated Ed Gruberman"
    And I should see "Rank: Ninth Gup"
