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
$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")
["rspec", "watir-webdriver", "../../config/OAE/config.rb",
  "utilities", "sakai-OAE/app_functions",
  "sakai-OAE/page_elements" ].each { |item| require item }

describe "Page Footer" do
  
  include Utilities

  let(:home) { home = LoginPage.new @browser }
  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @username = @config.directory['person1']['id']
    @password = @config.directory['person1']['password']
    
    @sakai = SakaiOAE.new(@browser)
  end

  it "Footer present on top-level public page" do  
    @browser.wait_for_ajax
    # TEST CASE: Footer present on top-level public page
    home.footer_element.visible?.should == true
    # TEST CASE: All expected elements are present in footer
    home.sakai_OAE_logo_element.visible?.should == true
    home.acknowledgements_link_element.visible?.should == true
    home.user_agreement_link_element.visible?.should == true
    home.explore_footer_link.present?.should == true
    home.browse_footer_link.present?.should == true
    # TEST CASE: Footer elements requiring login are not present
    home.location_button_element.visible?.should == false
    home.language_button_element.visible?.should == false
  end
    
  it "Clicking the logo displays DEBUG info" do
    # Click the Sakai logo
    home.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: 
    home.debug_info_element.visible?.should == true
  end
  
  it "Clicking the logo again hides the debug info" do
    home.sakai_OAE_logo
    # TEST CASE: 
    home.debug_info_element.visible?.should == false
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
    acknowledgements.footer_element.visible?.should == true
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    acknowledgements.featured_element.visible?.should == true
    acknowledgements.ui_technologies_element.visible?.should == true
    acknowledgements.back_end_technologies_element.visible?.should == true
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
    categories.footer_element.visible?.should == true
  end
  
  it "Search page has the footer" do
    search = home.explore_content
    
    # TEST CASE: Search page has the footer
    search.footer_element.visible?.should == true
  end
  
  it "The footer is there when user logs in" do
    dashboard = @sakai.login(@username, @password)
    
    # TEST CASE: Dashboard page has the footer
    dashboard.footer_element.visible?.should == true
    
    # TEST CASE: All expected elements are present in footer
    dashboard.sakai_OAE_logo_element.visible?.should == true
    dashboard.acknowledgements_link_element.visible?.should == true
    dashboard.user_agreement_link_element.visible?.should == true
    dashboard.explore_footer_link.present?.should == true
    dashboard.browse_footer_link.present?.should == true
    dashboard.location_button_element.visible?.should == true
    dashboard.language_button_element.visible?.should == true
  end
  
  it "Clicking the logo displays debug info" do
    # Click the Sakai logo
    dashboard.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: Clicking the logo displays DEBUG info
    dashboard.debug_info_element.visible?.should == true
  end
  
  it "Clicking the logo again hides the debug info" do
    dashboard.sakai_OAE_logo
    
    # TEST CASE: Clicking the logo again hides the debug info
    dashboard.debug_info_element.visible?.should == false
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
    acknowledgements.footer_element.visible?.should == true
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    acknowledgements.featured_element.visible?.should == true
    acknowledgements.ui_technologies_element.visible?.should == true
    acknowledgements.back_end_technologies_element.visible?.should == true
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
    categories.footer_element.visible?.should == true
  end
  
  it "Search page has the footer when logged in" do
    search = home.explore_content
    
    # TEST CASE: Search page has the footer
    search.footer_element.visible?.should == true
  end
  
  it "Account preferences appears when location link clicked" do
    search = ExploreContent.new @browser
    search.change_location
    
    # TEST CASE: Account preferences dialog is visible
    search.time_zone_element.visible?.should == true
    search.cancel
  end
  
  it "Account preferences appears when language link clicked" do
    search = ExploreContent.new @browser
    search.change_language
    
    # TEST CASE: Account preferences dialog is visible
    search.language_element.visible?.should == true
    search.cancel
  end
  
  it "Footer present on Create Group page" do
    search = ExploreContent.new @browser
    create = search.create_a_group
    
    # TEST CASE: Footer is present on Create Group page
    create.footer_element.visible?.should == true
    
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end

end
