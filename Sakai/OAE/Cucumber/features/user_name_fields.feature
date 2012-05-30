Feature:
  In order to allow flexibility of user information
  As a user of OAE
  I should be able to update my first and last names as I see fit

Scenario Outline:
  Given the first name is "<first>"
  And the last name is "<last>"
  And I save the info
  And I log out
  And I log in


