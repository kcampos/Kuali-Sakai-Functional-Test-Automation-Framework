#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the creation of a new Course.
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
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @course_info = {
      :title=>"Junk Course",
      :description=>random_string,
      :tags=>random_string
    }
    
    @new_document = {:name=>"stuff", :visible=>"Visible to anyone", :pages=>"3"}
    @existing_document = {:name=>"Syllabus", :title=>"Existing Doc", :visible =>"All participants" }
    @participant_list = {:name=>"party", :visible=>"Visible to anyone"}
    @content_library = {:name=>"content", :visible=>"Visible to anyone"}
    @widgets = [
      {:name=>"Disc",:widget=>"Discussion",:visible=>"Visible to anyone"},
      {:name=>"Remote",:widget=>"Remote Content",:visible=>"Visible to anyone"},
      {:name=>"Inline",:widget=>"Inline Content",:visible=>"Visible to anyone"},
      {:name=>"Tests",:widget=>"Tests and Quizzes",:visible=>"Visible to anyone"},
      {:name=>"Calendar",:widget=>"Calendar",:visible=>"Visible to anyone"},
      {:name=>"Map",:widget=>"Google maps",:visible=>"Visible to anyone"},
      {:name=>"File",:widget=>"Files and documents",:visible=>"Visible to anyone"},
      {:name=>"Comment",:widget=>"Comments",:visible=>"Visible to anyone"},
      {:name=>"JISC",:widget=>"JISC Content",:visible=>"Visible to anyone"},
      {:name=>"Tasks",:widget=>"Assignments",:visible=>"Visible to anyone"},
      {:name=>"RSS",:widget=>"RSS Feed Reader",:visible=>"Visible to anyone"},
      {:name=>"LTI",:widget=>"Basic LTI",:visible=>"Visible to anyone"},
      {:name=>"Gadget",:widget=>"Google Gadget",:visible=>"Visible to anyone"},
      {:name=>"Grades",:widget=>"Gradebook",:visible=>"Visible to anyone"}
    ]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_course
    
    @browser.goto "http://www.tinymce.com/tryit/full.php"
    @browser.frame(:id=>"content_ifr").image(:src=>"img/tlogo.png").click
    sleep 10
    
    
  end
  
end
