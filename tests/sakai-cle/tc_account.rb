# 
# == Synopsis
#
# Tests user account modification, including first and last name
# changes, and updates to the password
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }
require "ci/reporter/rake/test_unit_loader"

class UserAccountUpdate < Test::Unit::TestCase
  
  include Utilities

  def setup
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # This test case requires logging in as a student
    @user_name = config.directory['person10']['id']
    @password = config.directory['person10']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case data
    @first_name = random_string(99)
    @last_name = random_string(99)
    @email_address = "#{random_nicelink(20)}@#{random_nicelink(20)}.com"
    @new_password = random_string(32)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_user_update
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to Account page
    workspace = MyWorkspace.new(@browser)
    
    account = workspace.account
    
    # TEST CASE: Verify user id
    assert_equal account.user_id, @user_name
    
    # Edit User
    edit_account = account.modify_details
    
    # Blank out name and email fields
    edit_account.first_name=""
    edit_account.last_name=""
    edit_account.email=""
    
    account = edit_account.update_details
    
    # TEST CASE: verify can save with null values
    assert_equal account.first_name, ""
    
    # Change email field
    edit_account = account.modify_details
    
    # Test an invalid email address
    edit_account.email="blablabla"
    edit_account.update_details
    
    # TEST CASE: Verify alert about invalid email address
    assert @browser.text.include?("Alert: The email address is invalid"), "No warning about invalid email address"
    
    edit_account.email=@email_address
    
    # Create unmatched passwords (check for case-sensitivity)
    edit_account.create_new_password="Abcd1234$"
    edit_account.verify_new_password="abcd1234$"
    edit_account = edit_account.update_details
    
    # TEST CASE: Verify alert about unmatched passwords
    assert @browser.text.include?("Alert: Please enter the password the same in both fields."), "No warning about unmatched passwords"
    
    # Set names. Set password values the same and save changes
    edit_account.first_name=@first_name
    edit_account.last_name=@last_name
    edit_account.create_new_password=@new_password
    edit_account.verify_new_password=@new_password
    
    account = edit_account.update_details
    
    # TEST CASE: verify successful changes
    assert_equal @last_name, account.last_name, "Problem with last name"
    assert_equal @first_name, account.first_name, "Problem with first name"
    assert_equal @email_address, account.email, "Problem with email address"
    assert_equal account.modified, @sakai.make_date(Time.now)
    
    # Log out and log back in with new password credentials
    @sakai.logout
    
    workspace = @sakai.login(@user_name, @new_password)
    
    # TEST CASE: Verify the user successfully logged in
    assert @browser.link(:text, "Logout").exist?, "User was unable to log in with new password"
    
    # Reset the password to the stored password value for test repeatability...
    account = workspace.account
    
    edit_account = account.modify_details
    edit_account = EditAccount.new(@browser)
    edit_account.create_new_password=@password
    edit_account.verify_new_password=@password
    edit_account.update_details
    
  end
  
end
