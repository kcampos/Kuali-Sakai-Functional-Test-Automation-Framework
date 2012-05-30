#coding: UTF-8

Before do
  @dashboard = MyDashboard.new @browser
  @dashboard.class.class_eval { include AccountPreferencesPopUp }
  #number = rand(10) + 1
  @username = "funky01"#$directory["person#{number}"]['id']
  @password = @directory["person1"]['password']
  first = "Billy"#$directory["person#{number}"]['firstname']
  last = "Bob"#$directory["person#{number}"]['lastname']
  @full = "#{first} #{last}"
end

Given /^I have an active user in the system$/ do
  name = @username
end

When /^I log in$/ do
  @dashboard = @welcome_page.sign_in(@username, @password)
end

Given /^I am logged in$/ do
  @dashboard.user_options_name_element.text.should =~ /#{@full[0..12]}/
end

When /^I click "My Account"$/ do
  @dashboard.my_account
end

Then /^I should see the "My Account" Pop-up$/ do
  @dashboard.account_preferences_title_element.should be_visible
end

When /^I click the Password tab$/ do
  @dashboard.password_tab
end

Then /^I should see the password fields$/ do
  @dashboard.current_password_element.should be_visible
  @dashboard.new_password_element.should be_visible
  @dashboard.retype_password_element.should be_visible
end

Given /^I have entered my current password$/ do
  @dashboard.current_password=@password
end

Given /^I have (.*) new password$/ do |desc|
  @new_password = case(desc)
    when "a valid"
      random_alphanums(25)
    when "a blank"
      ""
    when "the same"
      @password
    when "a 3-char"
      random_alphanums(3)
    else
      "xx"
      exit
  end
end

And /^I enter the same confirmation password$/ do
 @dashboard.retype_password=@new_password
end

When /^I click the Cancel button$/ do
  @dashboard.cancel
end

Then /^The password is not changed$/ do
  welcome_page = @dashboard.sign_out
  @dashboard = welcome_page.sign_in(@username, @password)
end

Given /^I enter the wrong current password$/ do
  @dashboard.current_password=random_alphanums(30)
end

And /^I enter the new password$/ do
  @dashboard.new_password=@new_password
end

When /^I save the changes$/ do
  @dashboard.save_new_password
end

Then /^I should see a message about the password being wrong$/ do
  @dashboard.notification.should == "Changing password failed.\nA problem occured when trying to change your password. Please make sure that you have entered the correct password."
end

And /^I have entered a different confirmation password$/ do
  @dashboard.retype_password=random_alphanums(12)
end

Then /^I should see a message about the passwords not being equal$/ do
  @dashboard.retype_password_error.should == "Please enter the same password twice."
end

Then /^I should see a message about the password being blank$/ do
  @dashboard.retype_password_error.should == "This field is required."
end

Then /^I should see a message about the new password being the old$/ do
  @dashboard.new_password_error.should == "The new and old passwords are the same. Please enter something different for the new password."
end

Then /^The save button should not be active$/ do
  @dashboard.save_new_password_element.should_not be_enabled
end

Then /^I should see an error about the password being too short$/ do
  @dashboard.new_password_error.should == "Please enter at least 4 characters."
end

Then /^I should see a message about the password being changed$/ do
  @directory["person1"]['password'] = @new_password
  File.open("#{File.dirname(__FILE__)}/directory.yml", "w+") { |out| YAML::dump(@directory, out) }
  @dashboard.notification.should == "Password changed.\nYour password has been successfully changed."
end

Given /^I am logged out$/ do
  @welcome_page.sign_in_menu_element.should_be visible
end