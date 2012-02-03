#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Focuses on the Top navigation; on the different links before and after signing in,
# what should be visible in the dropdown of each of those links
#
# This test case is a VERY basic "smoke check" of the Academic Top Menu UI. More involved
# automated testing of the navigation interface happens naturally in the course of
# the other functional test scripts.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestTopNavigation < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end

  def test_top_navigation
    
    # Need to define the page object class
    home = LoginPage.new @browser
    
    # TEST CASE: Explore menu present when logged out
    assert home.explore_element.visible?
    
    home.explore_element.hover
    
    # TEST CASE: Explore menu appears when hovering over Explore link
    assert home.browse_all_categories_element.visible?
    
    # TEST CASE: Help menu present when logged out
    assert home.help_element.visible?
    
    # TEST CASE: Sign-in menu present when logged out
    assert home.sign_in_menu_element.visible?
    
    # TEST CASE: Search field present when logged out
    assert home.header_search_element.visible?
    
    # TEST CASE: Collector button not present when logged out
    assert_equal false, home.collector_element.visible?
    
    home.sign_in_menu_element.hover
    
    # TEST CASE: Username and password fields appear when hovering over Sign In
    assert home.username_element.visible?
    assert home.password_element.visible?
    
    categories = home.explore_all_categories
    
    # TEST CASE: "Browse all categories" takes user to "All categories" page
    assert_equal "All categories", categories.page_title
    
    people = categories.explore_people

    # TEST CASE: Explore => People takes user to the Search People page
    assert_equal "People", people.results_header
    
    content = people.explore_content

    # TEST CASE: Explore => Content takes user to the Search Content page
    assert_equal "Content", content.results_header
    
    groups = content.explore_groups
    
    # TEST CASE: Explore => Groups takes user to the Search Groups page
    assert_equal "Groups", groups.results_header
    
    courses = groups.explore_courses
    
    # TEST CASE: Explore => Courses takes user to the Search Courses page
    assert_equal "Courses", courses.results_header
    
    projects = courses.explore_research
    
    # TEST CASE: Explore => Research projects takes user to the Search Research projects page
    assert_equal "Research projects", projects.results_header
    
    projects.header_search="*"
    sleep 1 # Need to wait for the menu to appear
    
    # TEST CASE: The "See all" button is visible when text is entered into the Header
    # bar's Search field
    assert projects.see_all_element.visible?
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
    
    # TEST CASE: Explore menu present when logged in
    assert dashboard.explore_element.visible?
    
    dashboard.explore_element.hover
    
    # TEST CASE: Explore menu appears when hovering over Explore link
    assert dashboard.browse_all_categories_element.visible?
    
    # TEST CASE: Help menu present when logged in
    assert dashboard.help_element.visible?
    
    # TEST CASE: Search field present when logged in
    assert dashboard.header_search_element.visible?
    
    # TEST CASE: Collector button present when logged in
    assert dashboard.collector_element.visible?
    
    # TEST CASE: You menu present when logged in
    assert dashboard.you_element.visible?
    
    # TEST CASE: Mailbox menu item present when logged in
    assert dashboard.messages_container_button_element.visible?
    
    # TEST CASE: Create + Collect menu option is present when logged in
    assert dashboard.create_collect_element.visible?
    
    inbox = dashboard.my_messages
    
    # TEST CASE: You => My messages takes user to the Inbox
    assert_equal "Inbox", inbox.page_title
    
    profile = inbox.my_profile
    
    # TEST CASE: You => My profile takes user to the Basic Information page
    assert profile.given_name_element.visible?
    
    library = profile.my_library
    
    # TEST CASE: You => My library takes user to their library page
    assert_equal "My library", library.page_title
    
    memberships = library.my_memberships
    
    # TEST CASE: You => My memberships takes user to My Memberships page
    assert_equal "My memberships", memberships.page_title
    
    contacts = memberships.my_contacts
    
    # TEST CASE: You => My contacts takes user to My contacts page
    assert_equal "My contacts", contacts.page_title
    
  end

end
