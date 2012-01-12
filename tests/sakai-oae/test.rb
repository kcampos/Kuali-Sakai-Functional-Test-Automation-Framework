#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Courses.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCreateCourse < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['username']
    @u2password = @config.directory['person1']['password']
    @user3 = @config.directory['person2']['username']
    @u3password = @config.directory['person2']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @public_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Public"
    }
    
    @logged_in_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Logged in users"
    }
    
    @participant_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Participants only"
    }
    
    @participant_name = "Student One"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_course
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
    
    library = dashboard.go_to_most_recent_membership
    
    map = library.open_page("Map", "google maps")
    
    map.map_settings
    
    sleep 20
    
  end
  
end
