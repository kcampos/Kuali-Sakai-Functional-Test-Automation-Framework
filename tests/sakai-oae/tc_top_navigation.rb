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
# == Prerequisites:
#
# One user (see lines 32-33)
#
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Header Menu Navigation" do
  
  include Utilities
  
  let(:home) { LoginPage.new @browser }
  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
  end
 
  it "Explore menu present when logged out" do
    home.explore_element.should be_visible
  end
  
  it "Explore menu appears when hovering over Explore link" do
    home.explore_element.hover
    
    # TEST CASE: 
    home.browse_all_categories_element.should be_visible
  end
  
  it "Help menu present when logged out" do
    # TEST CASE: 
    home.help_element.should be_visible
  end
  
  it "Sign-in menu present when logged out" do 
    # TEST CASE: 
    home.sign_in_menu_element.should be_visible
  end
  
  it "Search field present when logged out" do 
    # TEST CASE: 
    home.header_search_element.should be_visible
  end
  
  it "Collector button not present when logged out" do  
    # TEST CASE: 
    home.collector_element.should_not be_visible
  end
  
  it "Username and password fields appear when hovering over Sign In" do  
    home.sign_in_menu_element.hover
    
    # TEST CASE: 
    home.username_element.should be_visible
    home.password_element.should be_visible
  end
  
  it "'Browse all categories' takes user to 'All categories' page" do  
    categories = home.explore_all_categories
    
    # TEST CASE:
    categories.page_title.should == "All categories"
  end
  
  it "Explore => People takes user to the Search People page" do
    categories = ExploreAll.new @browser
    people = categories.explore_people

    # TEST CASE: 
    people.results_header.should == "People"
  end
  
  it "Explore => Content takes user to the Search Content page" do
    people = ExplorePeople.new @browser
    content = people.explore_content

    # TEST CASE: 
    content.results_header.should == "Content"
  end
  
  it "Explore => Groups takes user to the Search Groups page" do
    content = ExploreContent.new @browser
    groups = content.explore_groups
    
    # TEST CASE: 
    groups.results_header.should == "Groups"
  end
  
  it "Explore => Courses takes user to the Search Courses page" do
    groups = ExploreGroups.new @browser
    courses = groups.explore_courses
    
    # TEST CASE: 
    courses.results_header.should == "Courses"
  end
  
  it "Explore => Research projects takes user to the Search Research projects page" do
    courses = ExploreCourses.new @browser
    projects = courses.explore_research
    
    # TEST CASE: 
    projects.results_header.should == "Research projects"
  end
  
  it "'See all' button visible when text entered in Header Search" do
    projects = ExploreResearch.new @browser
    projects.header_search="*"
    sleep 1 # Need to wait for the menu to appear
    
    projects.see_all_element.should be_visible
  end
  
  it "Explore menu present when logged in" do  
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
    
    # TEST CASE: 
    dashboard.explore_element.should be_visible
  end
  
  it "Explore menu appears when logged in and hovering over Explore link" do  
    dashboard.explore_element.hover
    
    # TEST CASE: 
    dashboard.browse_all_categories_element.should be_visible
  end
  
  it "Help menu present when logged in" do  
    # TEST CASE: 
    dashboard.help_element.visible?
  end
  
  it "Search field present when logged in" do  
    # TEST CASE: 
    dashboard.header_search_element.should be_visible
  end
  
  it "Collector button present when logged in" do  
    # TEST CASE: 
    dashboard.collector_element.should be_visible
  end
  
  it "You menu present when logged in" do  
    # TEST CASE: 
    dashboard.you_element.visible?
  end
  
  it "Mailbox menu item present when logged in" do  
    # TEST CASE: 
    dashboard.messages_container_button_element.should be_visible
  end
  
  it "Create + Collect menu option is present when logged in" do  
    # TEST CASE: 
    dashboard.create_collect_element.should be_visible
  end
  
  it "You => My messages takes user to the Inbox" do  
    inbox = dashboard.my_messages
    
    # TEST CASE: 
    inbox.page_title.should == "INBOX"
  end
  
  it "You => My profile takes user to the Basic Information page" do
    inbox = MyMessages.new @browser
    profile = inbox.my_profile
    
    # TEST CASE: 
    profile.given_name_element.should be_visible
  end
  
  it "You => My library takes user to their library page" do
    profile = MyProfileBasicInfo.new @browser
    library = profile.my_library
    
    # TEST CASE: 
    library.page_title.should == "My library"
  end
  
  it "You => My memberships takes user to My Memberships page" do
    library = MyLibrary.new @browser
    memberships = library.my_memberships
    
    # TEST CASE: 
    memberships.page_title.should == "My memberships"
  end
  
  it "You => My contacts takes user to My contacts page" do
    memberships = MyMemberships.new @browser
    contacts = memberships.my_contacts
    
    # TEST CASE: 
    contacts.page_title.should == "My contacts"
  end
 
  after :all do
    # Close the browser window
    @browser.close
  end
   
end
