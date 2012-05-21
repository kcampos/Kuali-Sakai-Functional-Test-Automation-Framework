Feature: Password Logic
  As a user
  I want to be able to update my password
  So that I can keep secure access to my account

Scenario:
  Given I have an active user in the system
  When I log in
  Then I should see my dashboard

Scenario:
  Given I am logged in
  When I click "My Account"
  Then I should see the "My Account" Pop-up

Scenario:
  When I click the Password tab
  Then I should see the password fields

Scenario: Cancel button prevents changing the password
  Given I have entered my current password
  And I have a valid new password
  And I enter the new password
  And I enter the same confirmation password
  When I click the Cancel button
  Then The password is not changed

Scenario: Unable to change password using incorrect password
  Given I click "My Account"
  And I click the Password tab
  And I enter the wrong current password
  And I have a valid new password
  And I enter the new password
  And I enter the same confirmation password
  When I save the changes
  Then I should see a message about the password being wrong

Scenario: New passwords must match
  Given I have entered my current password
  And I have a valid new password
  And I enter the new password
  And I have entered a different confirmation password
  When I save the changes
  Then I should see a message about the passwords not being equal

Scenario: Blank password not allowed
  Given I have entered my current password
  And I have a blank new password
  And I enter the same confirmation password
  When I save the changes
  Then I should see a message about the password being blank

Scenario: New password can't be the same as the old
  Given I have entered my current password
  And I have entered the same new password
  And I enter the same confirmation password
  When I save the changes
  Then I should see a message about the new password being the old

Scenario: New password can't be less than 4 characters long
  Given I have entered my current password
  And I have a 3-char new password
  And I enter the new password
  And I enter the same confirmation password
  When I save the changes
  Then I should see an error about the password being too short

#Scenario: Valid new password accepted
#  Given I have entered my current password
#  And I have a valid new password
#  And I enter the new password
#  And I enter the same confirmation password
#  When I save the changes
#  Then I should see a message about the password being changed
#
#Scenario: Old password cannot be used to log in
#  Given I am logged out
#  And I am on the welcome page
#  When I log in with old password
#  Then I should see a message about an invalid login
#
#Scenario: New password works to log in
#  Given I am logged out
#  And I am on the welcome page
#  When I log in with the new password
#  Then I should see my dashboard