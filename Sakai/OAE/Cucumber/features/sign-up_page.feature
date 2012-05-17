Feature: Sign-up page
  In order to allow people secure access to
  Sakai-OAE, there is a sign-up page
  with various requirements for user information.

  Scenario: Required fields left blank
    Given I have not entered a username
    And I have not entered a password
    And I have not entered a confirmation password
    And I have not entered a title
    And I have not entered a first name
    And I have not entered a last name
    And I have not entered an institution
    And I have not entered a role
    And I have not entered an email address
    And I have not entered a confirmation email address
    When I click the button to create the account
    Then I should see 'Please enter your username'
    And I should see 'Please enter your password'
    And I should see 'Please repeat your password'
    And I should see 'This field is required.' above the Title field
    And I should see 'Please enter your first name'
    And I should see 'Please enter your last name'
    And I should see 'Please enter a valid email address'
    And I should see 'This field is required.' above the Email Confirm field
    And I should see 'This field is required.' above the Institution field
    And I should see 'This field is required.' above the Role field

  Scenario: No password confirmation entered
    Given I have entered a valid password
    And I have not entered a confirmation password
    When I click the button to create the account
    Then I should see 'Please repeat your password'

  Scenario: Password cases do not match
    Given I have entered a valid password
    And I have entered a confirmation password that matches except for letter case
    When I click the button to create the account
    Then I should see 'Please enter the same value again'

  Scenario: Password too short
    Given I have entered a 3-character password
    And I have entered a matching confirmation password
    When I click the button to create the account
    Then I should see a warning that the password is too short

  Scenario: Medium-length password entered with all lower-case letters
    When I have entered a 10-character password with only lower-case letters
    Then I should see that the password strength is 'good'

  Scenario: Long password entered that is a keyboard pattern
    When I have entered a 15-character password that is a keyboard pattern
    Then I should see that the password strength is 'weak'

  Scenario: Long mixed-case password entered that is a word from the dictionary
    When I enter a long mixed-case dictionary word into the password field
    Then I should see that the password strength is 'weak'

  Scenario: Random, mixed-case, 8-char, alphanumeric password entered
    When I enter a password that is random, mixed-case, 8 characters long and only letters and numbers
    Then I should see that the password strength is 'very strong'

  Scenario: Random, mixed-case, 7-char password with symbol entered
    When I enter a password containing 7 characters, mixed-case, with letters, numbers, and symbols
    Then I should see that the password strength is 'very strong'

  Scenario: Password entered containing high-ASCII characters
    When I enter a 6-char password containing a high-ascii character, letters, and numbers
    Then I should see that the password strength is 'good'

  Scenario: Entered email address is not valid
    Given I enter an invalid email address
    And I enter a matching confirmation email address
    When I click the button to create the account
    Then I should see 'This is an invalid email address'
    And I should see 'Please enter a valid email address'

  Scenario: Confirmation email address does not match
    Given I enter a valid email address
    And I enter a valid confirmation email address that does not match
    When I click the button to create the account
    Then I should see 'Please enter a matching email address'

  Scenario: New account created
    Given I enter all required information correctly
    When I click the button to create the account
    Then I should see my dashboard
    And I should see the welcome message

  Scenario: Creation of account with case-insensitive duplicate username is prevented
    And I enter all required information correctly
    And I enter an existing user name with a different letter case
    When I click the button to create the account
    Then I should see 'This username is already taken'

  Scenario: User can successfully log in to a newly created account
    When I log in with new username and password
    Then I should see my dashboard