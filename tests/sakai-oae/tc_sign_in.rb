#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests signing in. It focuses on what you should see when logging in, or when using an 
# invalid username or password
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestSignIn < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @username = @config.directory['person1']['id']
    @password = @config.directory['person1']['password']
    
    @@sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @login_error = "Invalid username or password"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end

  def test_sign_in
    
    # Defining the initial page class
    main_page = LoginPage.new @browser
    
    # TEST CASE: The Sign in button exists on the "top" public page.
    assert main_page.sign_in_menu_element.exists?
    
    # TEST CASE: Sign-in Box not visible if not being hovered over
    assert_equal false, main_page.username_element.visible?
    
    main_page.sign_in_menu_element.hover
    
    # TEST CASE: Hovering over the Sign In menu button shows the sign-in box
    assert main_page.username_element.visible?
    
    @featured_content = main_page.featured_content_list
    
    main_page.click_link(@featured_content[0])
    
    content_page = LoginPage.new @browser
    
    # TEST CASE: Sign-in button is visible on Content pages...
    assert content_page.sign_in_menu_element.exists?
    
    categories = content_page.explore_all_categories
    
    # TEST CASE: Sign-in button is present on Browse all categories page...
    assert categories.sign_in_menu_element.exists?
    
    search = categories.explore_courses
    
    # TEST CASE: Sign-in button is present on Search page...
    assert search.sign_in_menu_element.exists?
    
    signup = search.sign_up
    
    # TEST CASE:  Sign-in button is present on Sign up page...
    assert signup.sign_in_menu_element.exists?
    
    signup.sign_in_menu_element.hover
    signup.username=random_alphanums
    signup.password=@password
    signup.sign_in
    
    # TEST CASE: Login with invalid username fails
    assert_equal @login_error, signup.login_error
    
    signup.username=@username
    signup.password=random_alphanums
    signup.sign_in
    @browser.wait_for_ajax
    
    # TEST CASE: Login with invalid password fails
    assert_equal @login_error, signup.login_error
    
    dashboard = @@sakai.login(@username, @password)

    # TEST CASE: Logging in from the main page takes user to the My Dashboard page
    assert_equal "My dashboard", dashboard.page_title
    
    public = @@sakai.sign_out
    
    explore = public.explore_people
    
    @people = explore.results
    @random_person = @people[rand(@people.length)]
    
    person = explore.view_person @random_person
    
    # TEST CASE: Clicking a person's name in the results list
    # takes user to that person's public profile page
    assert_equal @random_person, person.contact_name
    
    @@sakai.login(@username, @password)
    sleep 2
    person_again = ViewPerson.new @browser

    # TEST CASE: Logging in while viewing a profile, user
    # remains on that Profile page...
    assert_equal @random_person, person_again.contact_name
    
    public = @@sakai.sign_out
    
    explore = public.explore_content
    
    @content = explore.results
    @random_content = @content[rand(@content.length)]
    
    content = explore.open_content @random_content
    
    # TEST CASE: Clicking the name of a content item in the
    # public search results list takes the user to the public
    # Content Details page.
    assert_equal @random_content, content.name
    
    @@sakai.login(@username, @password)
    sleep 2
    content_again = ContentDetailsPage.new @browser
    
    # TEST CASE: Logging in while viewing content, the user
    # remains on that content detail page...
    assert_equal @random_content, content_again.name
    
  end

end
