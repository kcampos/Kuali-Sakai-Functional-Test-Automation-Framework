#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests focusing on the Footer element;
# on what different elements should be in the Footer, and how they should behave.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestFooter < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @username = @config.directory['person1']['id']
    @password = @config.directory['person1']['password']
    
    @@sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end

  def test_footer_not_logged_in
    
    @browser.wait_for_ajax
    home = LoginPage.new @browser
    
    # TEST CASE: Footer present on top-level public page
    assert home.footer_element.visible?
    
    # TEST CASE: All expected elements are present in footer
    assert home.sakai_OAE_logo_element.visible?
    assert home.acknowledgements_link_element.visible?
    assert home.user_agreement_link_element.visible?
    assert home.explore_footer_link.present?
    assert home.browse_footer_link.present?
    
    # TEST CASE: Footer elements requiring login are not present
    assert_equal false, home.location_button_element.visible?
    assert_equal false, home.language_button_element.visible?
    
    # Click the Sakai logo
    home.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: Clicking the logo displays DEBUG info
    assert home.debug_info_element.visible?
    
    home.sakai_OAE_logo
    
    # TEST CASE: Clicking the logo again hides the debug info
    assert_equal false, home.debug_info_element.visible?
    
    home.user_agreement
    
    # TEST CASE: Clicking the User Agreement link takes the user
    # to the rSmart User Agreement page. 
    assert_nothing_raised { @browser.window(:title=>"rSmart User Agreement").close }
    
    acknowledgements = home.acknowledgements
    
    # TEST CASE: Clicking the acknowledgements link takes user to acknowledgements page
    assert_equal "Acknowledgements", acknowledgements.page_title
    
    # TEST CASE: Footer present on acknowledgements page
    assert acknowledgements.footer_element.visible?
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    assert acknowledgements.featured_element.visible?
    assert acknowledgements.ui_technologies_element.visible?
    assert acknowledgements.back_end_technologies_element.visible?
    
    home = acknowledgements.explore_footer
    
    # TEST CASE: Footer's Explore button takes user to main landing page
    assert_equal "rSmart | Explore", @browser.title
    
    categories = home.browse_footer
    
    # TEST CASE: Footer's Browse button takes user to the All Categories page
    assert_equal "All categories", categories.page_title
    
    # TEST CASE: Categories page has the footer
    assert categories.footer_element.visible?
    
    search = categories.explore_content
    
    # TEST CASE: Search page has the footer
    assert search.footer_element.visible?

  end
  
  def test_footer_logged_in
    
    dashboard = @@sakai.login(@username, @password)
    
    # TEST CASE: Dashboard page has the footer
    assert dashboard.footer_element.visible?
    
    # TEST CASE: All expected elements are present in footer
    assert dashboard.sakai_OAE_logo_element.visible?
    assert dashboard.acknowledgements_link_element.visible?
    assert dashboard.user_agreement_link_element.visible?
    assert dashboard.explore_footer_link.present?
    assert dashboard.browse_footer_link.present?
    assert dashboard.location_button_element.visible?
    assert dashboard.language_button_element.visible?
    
    # Click the Sakai logo
    dashboard.sakai_OAE_logo
    @browser.wait_for_ajax
    
    # TEST CASE: Clicking the logo displays DEBUG info
    assert dashboard.debug_info_element.visible?
    
    dashboard.sakai_OAE_logo
    
    # TEST CASE: Clicking the logo again hides the debug info
    assert_equal false, dashboard.debug_info_element.visible?
    
    dashboard.user_agreement
    
    # TEST CASE: Clicking the User Agreement link takes the user
    # to the rSmart User Agreement page. 
    assert_nothing_raised { @browser.window(:title=>"rSmart User Agreement").close }
    
    acknowledgements = dashboard.acknowledgements
    
    # TEST CASE: Clicking the acknowledgements link takes user to acknowledgements page
    assert_equal "Acknowledgements", acknowledgements.page_title
    
    # TEST CASE: Footer present on acknowledgements page
    assert acknowledgements.footer_element.visible?
    
    # TEST CASE: Acknowledgements page's left menu has expected contents
    assert acknowledgements.featured_element.visible?
    assert acknowledgements.ui_technologies_element.visible?
    assert acknowledgements.back_end_technologies_element.visible?
    
    home = acknowledgements.explore_footer
    
    # TEST CASE: Footer's Explore button takes user to main landing page
    assert_equal "rSmart | Explore", @browser.title
    
    categories = home.browse_footer
    
    # TEST CASE: Footer's Browse button takes user to the All Categories page
    assert_equal "All categories", categories.page_title
    
    # TEST CASE: Categories page has the footer
    assert categories.footer_element.visible?
    
    search = categories.explore_content
    
    # TEST CASE: Search page has the footer
    assert search.footer_element.visible?
    
    search.change_location
    
    # TEST CASE: Account preferences dialog is visible
    assert search.time_zone_element.visible?
    
    search.cancel
    
    search.change_language
    
    # TEST CASE: Account preferences dialog is visible
    assert search.language_element.visible?
    
    search.cancel
    
    create = search.create_a_group
    
    # TEST CASE: Footer is present on Create Group page
    assert create.footer_element.visible?
    
  end

end
