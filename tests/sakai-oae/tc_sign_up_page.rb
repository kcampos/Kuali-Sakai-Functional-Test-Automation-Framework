#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Academic Smoke tests. Shallowly tests a broad range of features. This script will
# eventually be deprecated in favor of the more robust ts_smoke_tests.rb test suite.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Sign-Up Page" do
  
  include Utilities
  
  let(:signup) { CreateNewAccount.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    
    # Test user information from directory.yml...
    @user1 = random_alphanums
    @pass1 = random_string(20)
    @first = random_alphanums
    @last = random_alphanums
    @full = %|#{@first} #{@last}|
    @email = random_email
    @institution = random_alphanums
    @title = "Dr."
    @role = "Student"
    @phone = "2133450987"
    
    # Errors
    @pw_error = "Please enter your password"
    @pwr_error1 = "Please repeat your password"
    @pwr_error2 = "Please enter the same value again."
    @name_error = "Please enter your username"
    @firstname_error = "Please enter your first name"
    @lastname_error = "Please enter your last name"
    @dup_error = "* This username is already taken."
    @email_error = "Please enter a valid email address"
    @alt_email_error = "Please enter a valid email address."
    @invalid_error = "This is an invalid email address"
    @confirm_error = "This email does not match."
    
    @error = "This field is required."
    
  end

  it "goes to the sign-up page" do
    
    login = LoginPage.new @browser
    signup_page = login.sign_up
    
    signup_page.user_name_element.should exist
    
  end
  
  it "requires a password" do
    signup.wait_for_ajax
    signup.user_name=@user1
    signup.title=@title
    signup.first_name=@first
    signup.last_name=@last
    signup.institution=@institution
    signup.role=@role
    signup.phone_number=@phone
    signup.uncheck_contact_me_directly
    signup.uncheck_receive_tips
    signup.email=@email
    signup.email_confirm=@email
    signup.create_account_button
    
    signup.password_error.should == @pw_error
    
  end
  
  it "requires a matching password" do
    signup.new_password=@pass1
    signup.create_account_button
    
    signup.password_repeat_error.should == @pwr_error1
    
  end
  
  it "passwords are case-sensitive" do
    signup.retype_password=@pass1.upcase
    signup.create_account_button
    signup.password_repeat_error.should == @pwr_error2
    
  end
  
  it "requires a username" do
    signup.retype_password=@pass1
    signup.user_name=""
    signup.create_account_button
    signup.username_error.should == @name_error
  end
  
  it "requires a title" do
    signup.user_name=@user1
    signup.title="-- Please Select --"
    signup.create_account_button
    signup.title_error.should == @error
  end
  
  it "requires a first name" do
    signup.first_name=''
    signup.title=@title
    signup.create_account_button
    signup.firstname_error.should == @firstname_error
  end
  
  it "requires a last name" do
    signup.first_name=@first
    signup.last_name=''
    signup.create_account_button
    signup.lastname_error.should == @lastname_error
  end
  
  it "requires an institution" do
    signup.last_name=@last
    signup.institution=''
    signup.create_account_button
    signup.institution_error.should == @error
  end
  
  it "requires a role" do
    signup.institution=@institution
    signup.role="-- Please Select --"
    signup.create_account_button
    signup.role_error.should == @error
  end
  
  it "requires an email address" do
    signup.role=@role
    signup.email=''
    signup.email_confirm=''
    signup.create_account_button
    signup.email_error.should == @email_error
    signup.email_confirm_error.should == @error
  end
  
  it "requires a valid email address" do
    signup.email='asdf'
    signup.email_confirm='asdf'
    signup.create_account_button
    signup.email_error.should == @invalid_error
  end
  
  it "requires matching email addresses" do
    signup.email=@email
    signup.email_confirm="goofus@goofus.com"
    signup.create_account_button
    signup.email_confirm_error.should == @confirm_error
  end
  
  it "creates the account and accepts the agreement" do
    signup.role=@role
    agreement = signup.create_account
    dash = agreement.yes_I_accept
    
    dash.my_name.should == @full
    
    login = dash.sign_out
    login.sign_up
  end
  
  it "prevents creation of duplicate usernames" do
    signup.wait_for_ajax
    signup.user_name=@user1
    signup.new_password=@pass1
    signup.retype_password=@pass1
    signup.title=@title
    signup.first_name=@first
    signup.last_name=@last
    signup.institution=@institution
    signup.role=@role
    signup.phone_number=@phone
    signup.uncheck_contact_me_directly
    signup.uncheck_receive_tips
    signup.email=@email
    signup.email_confirm=@email
    signup.create_account_button
    
    signup.username_error.should == @dup_error
  end
  
  it "usernames not case sensitive" do
    signup.user_name=@user1.capitalize
    signup.create_account_button
    signup.username_error.should == @dup_error
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end

end
