#!/usr/bin/env ruby
# encoding: UTF-8
# 
# == Synopsis
#
# Tests updating the user's password, including all the restrictions surrounding
# such an update, that ensure it is done correctly and safely.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader", "cgi" ]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestEditProfilePrivacy < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @user = @config.directory['person6']['id']
    @password = @config.directory['person6']['password']
    
    @new_password = random_string(30)
    puts @new_password
    @short = random_string(3)
    
    @wrong_password_message = "Changing password failed.\nA problem occured when trying to change your password. Please make sure that you have entered the correct password." 
    @blank_error = "This field is required."
    @not_equal_error = "Please enter the same password twice."
    @new_is_old = "The new and old passwords are the same. Please enter something different for the new password."
    @too_short = "Please enter at least 4 characters."
    @success = "Password changed.\nYour password has been successfully changed."
    @login_error = "Invalid username or password"
  
    @changed = 0
    
  end
  
  def teardown
    # Change password back to default, if necessary...
#=begin
    if @changed == 1
      @sakai.logout
      dashboard = @sakai.login(@user, @new_password)
      dashboard.my_account
      dashboard.password
      dashboard.current_password=@new_password
      dashboard.new_password=@password
      dashboard.retype_password=@password
      dashboard.save_new_password
    end  
#=end
    # Close the browser window
    @browser.close
  end
  
  def test_edit_profile_privacy

    dashboard = @sakai.login(@user, @password)
    
    dashboard.my_account
    dashboard.password
    
    dashboard.current_password=@password
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    
    # TEST CASE: Cancel prevents change to password
    dashboard.cancel
    
    @sakai.logout

    dashboard = @sakai.login(@user, @password)
    dashboard.my_account
    dashboard.password
    
    # current password not correct
    dashboard.current_password=random_alphanums
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    dashboard.save_new_password
    
    # TEST CASE: Notified that entered current password was not correct
    sleep 0.2 #FIXME
    assert_equal @wrong_password_message, dashboard.notification
    
    dashboard.close_notification
    
    dashboard.current_password=@password
    dashboard.retype_password=@new_password
    dashboard.new_password=random_string
    dashboard.save_new_password
    
    # TEST CASE: Warning about unequal passwords appears
    sleep 0.2
    assert_equal @not_equal_error, dashboard.retype_password_error
    
    dashboard.retype_password=""
    dashboard.new_password=@password
    dashboard.current_password=@password
    
    # TEST CASE: Warning about blank field appears
    sleep 0.2
    assert_equal @blank_error, dashboard.retype_password_error
    
    dashboard.new_password=@password
    dashboard.retype_password=@password
    dashboard.save_new_password
    
    # TEST CASE: Warning about new and old passwords appears
    sleep 0.2
    assert_equal @new_is_old, dashboard.new_password_error
    
    # new pass too short
    dashboard.new_password=@short
    dashboard.retype_password=@short
    dashboard.save_new_password

    # TEST CASE: New password too short
    sleep 0.2
    assert_equal @too_short, dashboard.new_password_error
    
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    dashboard.save_new_password
    
    @changed = 1
    
    # TEST CASE: Password successfully changed
    sleep 0.2
    assert_equal @success, dashboard.notification
    
    login_page = @sakai.logout
    login_page.sign_in_menu
    login_page.username=@user
    login_page.password=@password
    login_page.sign_in
    
    # TEST CASE: Log in with old password fails
    sleep 0.2
    assert @login_error, login_page.login_error
    
    dashboard = @sakai.login(@user, @new_password)
    
    # TEST CASE: Log in with new password works
    assert dashboard.profile_pic_element.exists?
    
  end
  
end
