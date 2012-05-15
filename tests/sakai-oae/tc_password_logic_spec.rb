#!/usr/bin/env ruby
# encoding: UTF-8
# 
# == Synopsis
#
# Tests updating the user's password, including all the restrictions surrounding
# such an update, that ensure it is done correctly and safely.
#
# == Prerequisites:
#
# An existing test user (see lines 31-32)
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Updating the user password" do
  
  include Utilities

  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @directory = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @user = @directory['person1']['id']
    @password = @directory['person1']['password']
    
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
  
  before :each do
    dashboard.class.class_eval { include AccountPreferencesPopUp }
  end

  it "Cancel prevents change to password" do
    dashboard = @sakai.page.login(@user, @password)
    
    dashboard.my_account
    dashboard.password
    
    dashboard.current_password=@password
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    
    # TEST CASE: Cancel prevents change to password
    dashboard.cancel
    @sakai.logout
  end
  
  it "rejects bad current password for change" do
    dashboard = @sakai.page.login(@user, @password)
    dashboard.my_account
    dashboard.password
    
    # current password not correct
    dashboard.current_password=random_alphanums
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    dashboard.save_new_password
    
    # TEST CASE: Notified that entered current password was not correct
    sleep 0.2 #FIXME
    dashboard.notification.should == @wrong_password_message
  end
  
  it "disallows new passwords that don't match" do
    dashboard.close_notification
    
    dashboard.current_password=@password
    dashboard.retype_password=@new_password
    dashboard.new_password=random_string
    dashboard.save_new_password
    
    # TEST CASE: Warning about unequal passwords appears
    sleep 0.2
    dashboard.retype_password_error.should == @not_equal_error
  end
  
  it "doesn't allow blanks" do
    dashboard.retype_password=""
    dashboard.new_password=@password
    dashboard.current_password=@password
    
    # TEST CASE: Warning about blank field appears
    sleep 0.2
    dashboard.retype_password_error.should == @blank_error
  end
  
  it "disallows new password the same as old" do
    dashboard.new_password=@password
    dashboard.retype_password=@password
    dashboard.save_new_password
    
    # TEST CASE: Warning about new and old passwords appears
    sleep 0.2
    dashboard.new_password_error.should == @new_is_old
  end
  
  it "disallows passwords less than 4 chars long" do
    # new pass too short
    dashboard.new_password=@short
    dashboard.retype_password=@short
    dashboard.save_new_password

    # TEST CASE: New password too short
    sleep 0.2
    dashboard.new_password_error.should == @too_short
  end
  
  it "Allows change when all requirements met" do
    dashboard.new_password=@new_password
    dashboard.retype_password=@new_password
    dashboard.save_new_password
    
    @changed = 1
    
    # TEST CASE: Password successfully changed
    sleep 0.2
    dashboard.notification.should == @success
  end
  
  it "Old password fails for logging in" do
    login_page = @sakai.logout
    login_page.sign_in_menu
    login_page.username=@user
    login_page.password=@password
    login_page.sign_in
    
    # TEST CASE: Log in with old password fails
    sleep 0.2
    login_page.login_error.should == @login_error
  end
  
  it "New password works for logging in" do
    dashboard = @sakai.page.login(@user, @new_password)
    # TEST CASE: Log in with new password works
    dashboard.profile_pic_element.should exist
  end
  
  after :all do
    # Change password back to default, if necessary...
    if @changed == 1
      @sakai.logout
      dashboard = @sakai.page.login(@user, @new_password)
      dashboard.my_account
      dashboard.password
      dashboard.current_password=@new_password
      dashboard.new_password=@password
      dashboard.retype_password=@password
      dashboard.save_new_password
    end
    # Close the browser window
    @browser.close
  end

end
