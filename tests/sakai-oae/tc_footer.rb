#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests focusing on the Footer element;
# on what different elements should be in the Footer, and how they should behave.
#
# == Prerequisites
#
# There must be a valid user for logging in to the system.
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Page Footer" do
  
  include Utilities

  let(:home) { home = LoginPage.new @browser }
  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @directory = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    @username = @directory['person1']['id']
    @password = @directory['person1']['password']
    
    @sakai = SakaiOAE.new(@browser)
  end

  it "Footer present on top-level public page" do  
    @browser.wait_for_ajax
    # TEST CASE: Footer present on top-level public page
    home.footer_element.should be_visible
    # TEST CASE: All expected elements are present in footer
    home.sakai_OAE_logo_element.should be_visible
    home.acknowledgements_link_element.should be_visible
    home.user_agreement_link_element.should be_visible
    home.explore_footer_link.should be_present
    home.browse_footer_link.should be_present
    # TEST CASE: Footer elements requiring login are not present
    home.location_button_element.should_not be_visible
    home.language_button_element.should_not be_visible
  end
    
  it "Clicking the logo displays DEBUG info" do
    # Click the Sakai logo
    home.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: 
    home.debug_info_element.should be_visible
  end
  
  it "Clicking the logo again hides the debug info" do
    home.sakai_OAE_logo
    # TEST CASE: 
    home.debug_info_element.should_not be_visible
  end
  
  it "Agreement link works" do
    home.user_agreement
    
    # TEST CASE: Clicking the User Agreement link takes the user
    # to the rSmart User Agreement page. 
    lambda { @browser.window(:title=>"rSmart User Agreement").close }.should_not raise_error
  end
  
  it "Acknowledgements link works" do
    acknowledgements = home.acknowledgements
    # TEST CASE: Clicking the acknowledgements link takes user to acknowledgements page
    acknowledgements.page_title.should == "Acknowledgements"
    
    # TEST CASE: Footer present on acknowledgements page
    acknowledgements.footer_element.should be_visible
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    acknowledgements.featured_element.should be_visible
    acknowledgements.ui_technologies_element.should be_visible
    acknowledgements.back_end_technologies_element.should be_visible
  end
  
  it "Footer's Explore button takes user to main landing page" do
    home.explore_footer
    
    # TEST CASE: Footer's Explore button takes user to main landing page
    @browser.title.should == "rSmart | Explore"
  end
  
  it "Footer's Browse button takes user to the All Categories page" do
    categories = home.browse_footer
    
    # TEST CASE: Footer's Browse button takes user to the All Categories page
    categories.page_title.should == "All categories"

    # TEST CASE: Categories page has the footer
    categories.footer_element.should be_visible
  end
  
  it "Search page has the footer" do
    search = home.explore_content
    
    # TEST CASE: Search page has the footer
    search.footer_element.should be_visible
  end
  
  it "The footer is there when user logs in" do
    dashboard = @sakai.page.login(@username, @password)
    
    # TEST CASE: Dashboard page has the footer
    dashboard.footer_element.should be_visible
    
    # TEST CASE: All expected elements are present in footer
    dashboard.sakai_OAE_logo_element.should be_visible
    dashboard.acknowledgements_link_element.should be_visible
    dashboard.user_agreement_link_element.should be_visible
    dashboard.explore_footer_link.should be_present
    dashboard.browse_footer_link.should be_present
    dashboard.location_button_element.should be_visible
    dashboard.language_button_element.should be_visible
  end
  
  it "Clicking the logo displays debug info" do
    # Click the Sakai logo
    dashboard.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: Clicking the logo displays DEBUG info
    dashboard.debug_info_element.should be_visible
  end
  
  it "Clicking the logo again hides the debug info" do
    dashboard.sakai_OAE_logo
    
    # TEST CASE: Clicking the logo again hides the debug info
    dashboard.debug_info_element.should_not be_visible
  end
  
  it "User Agreement link works when logged in" do
    dashboard.user_agreement
    
    # TEST CASE: Clicking the User Agreement link takes the user
    # to the rSmart User Agreement page. 
    lambda { @browser.window(:title=>"rSmart User Agreement").close }.should_not raise_error
  end
  
  it "Acknowledgements link works when logged in" do
    acknowledgements = dashboard.acknowledgements
    
    # TEST CASE: Clicking the acknowledgements link takes user to acknowledgements page
    acknowledgements.page_title.should == "Acknowledgements"
    
    # TEST CASE: Footer present on acknowledgements page
    acknowledgements.footer_element.should be_visible
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    acknowledgements.featured_element.should be_visible
    acknowledgements.ui_technologies_element.should be_visible
    acknowledgements.back_end_technologies_element.should be_visible
  end
  
  it "Explore button takes logged in user to landing page" do
    home.explore_footer
    
    # TEST CASE: Footer's Explore button takes user to main landing page
    @browser.title.should == "rSmart | Explore"
  end
    
  it "Footer's Browse button takes user to the All Categories page when logged in" do
    categories = home.browse_footer
    # TEST CASE: 
    categories.page_title.should == "All categories"
    # TEST CASE: Categories page has the footer
    categories.footer_element.should be_visible
  end
  
  it "Search page has the footer when logged in" do
    search = home.explore_content
    
    # TEST CASE: Search page has the footer
    search.footer_element.should be_visible
  end
  
  it "Account preferences appears when location link clicked" do
    search = ExploreContent.new @browser
    search.change_location
    
    # TEST CASE: Account preferences dialog is visible
    search.time_zone_element.should be_visible
    search.cancel
  end
  
  it "Account preferences appears when language link clicked" do
    search = ExploreContent.new @browser
    search.change_language
    
    # TEST CASE: Account preferences dialog is visible
    search.language_element.should be_visible
    search.cancel
  end
  
  it "Footer present on Create Group page" do
    search = ExploreContent.new @browser
    create = search.create_a_group
    
    # TEST CASE: Footer is present on Create Group page
    create.footer_element.should be_visible
    
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end

end
