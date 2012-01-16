#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the removal and re-adding of all dashboard widgets.
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
    
    # Test case variables...
    @widgets = ["My recent memberships", "My recent content", "Most popular tags"]
    @user = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_adding_dashboard_widgets
    
    # Log in to Sakai
    dashboard = @sakai.login(@user, @password)
    
    dashboard.add_widgets
    
    dashboard.remove_all_widgets
    
    dashboard = dashboard.close_add_widget
    
    # TEST CASE: All widgets removed
    assert_equal [], dashboard.displayed_widgets, "#{dashboard.displayed_widgets}"
    
    @widgets.each do |widget|
      
      dashboard.add_widgets
      
      dashboard.add_widget widget
      
      dashboard = dashboard.close_add_widget
      
      # TEST CASE: Widget added
      assert dashboard.displayed_widgets.include?(widget), "#{dashboard.displayed_widgets}"
    
    end
    
  end
  
end
