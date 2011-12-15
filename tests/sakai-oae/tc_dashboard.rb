#!/usr/bin/env ruby
# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestDashboardWidgets < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser

    @sakai = SakaiOAE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_dashboard_widgets
    
    # Log in to Sakai
    dashboard = @sakai.login("admin", "admin")
    
    dashboard.add_widgets
    
    dashboard.remove_all_widgets
    
    dashboard = dashboard.close_add_widget
    
    # TEST CASE: All widgets removed
    assert_equal [], dashboard.displayed_widgets, "#{dashboard.displayed_widgets}"
    
    dashboard.add_widgets
    
    dashboard.add_widget "My recent memberships"
    
    dashboard = dashboard.close_add_widget
    
    # TEST CASE: Widget added
    assert dashboard.displayed_widgets.include?("My recent memberships"), "#{dashboard.displayed_widgets}"
    
  end
  
end
