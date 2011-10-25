# 
# == Synopsis
#
# Tests user account modification, including first and last name
# changes, and updates to the password
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

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
    workspace.account
    account = Account.new(@browser)
    
    # TEST CASE: Verify user id
    assert_equal account.user_id, @user_name
    
    # Edit User
    account.modify_details
    
    # Blank out name and email fields
    edit_account = EditAccount.new(@browser)
    edit_account.first_name=""
    edit_account.last_name=""
    edit_account.email=""
    edit_account.update_details
    
    # TEST CASE: verify can save with null values
    account = Account.new(@browser)
    assert_equal account.first_name, ""
    
    # Change email field
    account.modify_details
    
    fname = random_string(99)
    lname = random_string(99)
    email_addr = "#{random_nicelink(20)}@#{random_nicelink(20)}.com"
    new_password = random_string(32)
    
    edit_account = EditAccount.new(@browser)
    
    edit_account.email="blablabla"
    edit_account.update_details
    
    # TEST CASE: Verify alert about invalid email address
    assert @browser.text.include?("Alert: The email address is invalid"), "No warning about invalid email address"
    
    edit_account.email=email_addr
    
    # Create unmatched passwords
    edit_account.create_new_password="Abcd1234$"
    edit_account.verify_new_password="abcd1234$"
    edit_account.update_details
    
    # TEST CASE: Verify alert about unmatched passwords
    assert @browser.text.include?("Alert: Please enter the password the same in both fields."), "No warning about unmatched passwords"
    
    # Set names. Set password values the same and save changes
    edit_account.first_name=fname
    edit_account.last_name=lname
    edit_account.create_new_password=new_password
    edit_account.verify_new_password=new_password
    edit_account.update_details
    
    # TEST CASE: verify successful changes
    account = Account.new(@browser)
    assert_equal account.last_name, lname, "Problem with last name"
    assert_equal account.first_name, fname, "Problem with first name"
    assert_equal account.email, email_addr, "Problem with email address"
    assert_equal account.modified, @sakai.make_date(Time.now)
    
    # Log out and log back in with new password credentials
    @sakai.logout
    @sakai.login(@user_name, new_password)
    
    # TEST CASE: Verify the user successfully logged in
    assert @browser.link(:text, "Logout").exist?, "User was unable to log in with new password"
    
    # Reset the password to "password" for test repeatability...
    workspace = MyWorkspace.new(@browser)
    workspace.account
    account = Account.new(@browser)
    account.modify_details
    edit_account = EditAccount.new(@browser)
    edit_account.create_new_password="password"
    edit_account.verify_new_password="password"
    edit_account.update_details
    
  end
  
end
