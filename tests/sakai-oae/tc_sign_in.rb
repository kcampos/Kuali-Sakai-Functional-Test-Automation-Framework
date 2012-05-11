#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests signing in. It focuses on what you should see when logging in, or when using an 
# invalid username or password
#
# == Pre-requisites:
#
# This test requires multiple valid users with public profiles and
# multiple content items that are also publically viewable. Hence, it
# cannot be run against a build with an empty DB.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae-test-api'

describe "Signing In" do
  
  include Utilities

  let(:login_page) { LoginPage.new @browser }
  let(:signup) { CreateNewAccount.new @browser }

  before :all do
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @username = @config.directory['person1']['id']
    @password = @config.directory['person1']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @login_error = "Invalid username or password"
  end

  it "The Sign in button exists on the 'top' public page" do
    login_page.sign_in_menu_element.should exist
  end
    
  it "Sign-in Box not visible if not being hovered over" do
    login_page.username_element.should_not be_visible
  end
  
  it "Hovering over the Sign In menu button shows the sign-in box" do
    login_page.sign_in_menu_element.hover
    login_page.username_element.should be_visible
  end
    
  it "Sign-in button is visible on Content pages..." do
    @featured_content = login_page.featured_content_list
    login_page.click_link(@featured_content[0])
    login_page.sign_in_menu_element.exists?.should == true
  end
  
  it "Sign-in button is present on various pages" do
    categories = login_page.explore_all_categories
    categories.sign_in_menu_element.exists?.should == true
    search = categories.explore_courses
    search.sign_in_menu_element.exists?.should == true
    signup = search.sign_up
    signup.sign_in_menu_element.exists?.should == true
  end
  
  it "Login with invalid username fails" do
    signup.sign_in_menu_element.hover
    signup.username=random_alphanums
    signup.password=@password
    signup.sign_in
    signup.login_error.should == @login_error
  end
  
  it "Login with invalid password fails" do
    signup.username=@username
    signup.password=random_alphanums
    signup.sign_in
    @browser.wait_for_ajax
    signup.login_error.should == @login_error
  end
  
  it "Logging in from the main page takes user to the My Dashboard page" do
    dashboard = @sakai.login(@username, @password)
    dashboard.page_title.should == "My dashboard"
  end
  
  it "Clicking a name takes user to that person's public profile page" do
    public = @sakai.sign_out
    explore = public.explore_people
    @people = explore.results
    $random_person = @people[rand(@people.length)]
    person = explore.view_person $random_person
    person.contact_name.should == $random_person
  end
  
  it "Logins viewing profile, user stays on profile page" do
    @sakai.login(@username, @password)
    sleep 2
    person = ViewPerson.new @browser
    person.contact_name.should == $random_person
  end
  
  it "Clicking public content shows content details" do
    public = @sakai.sign_out
    explore = public.explore_content
    @content = explore.results
    $random_content = @content[rand(@content.length)]
    content = explore.open_content $random_content
    content.name.should == $random_content
  end
  
  it "Logging in from content page, user stays on content page" do
    @sakai.login(@username, @password)
    sleep 2
    content_again = ContentDetailsPage.new @browser
    content_again.name.should == $random_content
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end

end
