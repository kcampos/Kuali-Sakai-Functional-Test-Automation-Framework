#coding:UTF-8
Before "@sign_up_start" do
  @welcome_page.sign_up
end

Before do
  @sign_up = CreateNewAccount.new @browser
end

Given /^I have not entered (a|an) (.*)$/ do |a, arg|
  case(arg)
    when "username" then @sign_up.user_name=""
    when "password" then @sign_up.new_password=""
    when "confirmation password" then @sign_up.retype_password=""
    when "title" then @sign_up.title="-- Please Select --"
    when "first name" then @sign_up.first_name=""
    when "last name" then @sign_up.last_name=""
    when "institution" then @sign_up.institution=""
    when "role" then @sign_up.role="-- Please Select --"
    when "email address" then @sign_up.email=""
    when "confirmation email address" then @sign_up.email_confirm=""
    else
      puts "huh?"
  end
end

Given /^I have entered a valid password$/ do
  @password = random_string(20)
  @sign_up.new_password=@password
end

When /^I click the button to create the account$/ do
  @sign_up.create_account_button
end

Then /^I should see '(.*)'$/ do |error|
  case(error)
    when "This email does not match" then @sign_up.email_confirm_error.should == error
    when "Please enter your username" then @sign_up.username_error.should == error
    when "Please enter your password" then @sign_up.password_error.should == error
    when "Please repeat your password" then @sign_up.password_repeat_error.should == error
    when "Please enter your first name" then @sign_up.firstname_error.should == error
    when "Please enter your last name" then @sign_up.lastname_error.should == error
    when "This is an invalid email address" then @sign_up.email_error.should == error
    when "This username is already taken" then @sign_up.username_error.should == error
    when "Please repeat your password" then @sign_up.password_repeat_error.should == error
    else
      "uh-oh!"
  end
end

Then /^I should see '(.*)' above the (.*) field$/ do |error, field|
  case(field)
    when "Title" then @sign_up.title_error.should == error
    when "Email Confirm" then @sign_up.email_confirm_error.should == error
    when "Institution" then @sign_up.institution_error.should == error
    when "Role" then @sign_up.role_error.should == error
    else
      "huh?"
  end
end

Then /^I should see that the password strength is '(.*)'$/ do |strength|
  @sign_up.password_strength.should == strength
end

Given /^I have entered a confirmation password that matches except for letter case$/ do
  @sign_up.new_password=@password.swapcase
end

Given /^I have a (\d+)\-character password$/ do |length|
  @password = random_alphanums(length.to_i)
end

Given /^I have a (\d+)\-character password that is all the same character$/ do |length|
  string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  letter = string[rand(string.length)]
  password = ""
  length.to_i.times { password << letter }
  @password = password
end

When /^I enter the password$/ do
  @sign_up.new_password=""
  @sign_up.new_password=@password
end

Given /^I have entered a matching confirmation password$/ do
  @sign_up.retype_password=""
  @sign_up.retype_password=@password
end

Then /^I should see a warning that the password is too short$/ do
  @sign_up.password_error.should == "Your password should be at least 4 characters long"
end

When /^I have a (\d+)\-character password with only non\-repeating lower\-case letters$/ do |length|
  string = ('a'..'z').sort_by {rand}[0,length.to_i].join
  @password = string
end

When /^I have a (\d+)\-character password that is a keyboard pattern$/ do |length|
  num = rand(5)
  pattern="qwertyuiopasdfghjkl;zxcvbnm,./123456789qwertyuiopasdfghjkl;zxcvbnm,./123456789"
  @password=pattern[num..(num + length.to_i - 1)]
end

When /^I have a long mixed\-case dictionary word$/ do
  @password="Functionality"
end

When /^I have a password that is non-repeating, random, mixed\-case, (\d+) characters long and only letters and numbers$/ do |length|
  @password=random_alphanums(length.to_i)
end

When /^I have a password containing (\d+) characters, mixed\-case, with letters, numbers, and symbols$/ do |length|
  @password=random_string(length.to_i)
end

When /^I have a (\d+)\-char password containing a high\-ascii character, letters, and numbers$/ do |length|
  @password = "ü6f" + random_alphanums(length.to_i - 3)
end

Given /^I have an invalid email address$/ do
  @entered_address = random_alphanums
end

When /^I enter the email address$/ do
  @sign_up.email=@entered_address
end

Given /^I enter a matching confirmation email address$/ do
  @sign_up.email_confirm = @entered_address
end

Given /^I have a valid email address$/ do
  @entered_address = random_email
end

Given /^I enter a valid confirmation email address that does not match$/ do
  @sign_up.email_confirm=random_email
end

Given /^I enter all required information correctly$/ do
  @user1 = random_alphanums
  @first = random_alphanums
  @last = random_alphanums
  @email = random_email
  @full = %|#{@first} #{@last}|
  @institution = random_alphanums
  @title = "Dr."
  @role = "Student"
  @phone = "2133450987"
  @password = random_string
  @sign_up.user_name=@user1
  @sign_up.first_name=@first
  @sign_up.last_name=@last
  @sign_up.email=@email
  @sign_up.email_confirm=@email
  @sign_up.phone_number=@phone
  @sign_up.role=@role
  @sign_up.title=@title
  @sign_up.new_password=@password
  @sign_up.retype_password=@password
end

Then /^I should see my dashboard$/ do
  on_page MyDashboard do |dash|
    dash.my_name.should == @full
  end
end

Then /^I should see the welcome message$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I enter an existing user name with a different letter case$/ do
  @sign_up.user_name=@user1.swapcase
end


When /^I log in with new username and password$/ do
  @sign_up.log_in(@user1, @pass1)
end