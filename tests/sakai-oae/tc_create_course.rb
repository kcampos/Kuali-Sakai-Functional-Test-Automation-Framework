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
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
=begin
    dashboard.add_all_widgets
    
    create_course = dashboard.create_courses
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@course_info[:title]
    new_course_info.description=@course_info[:description]
    new_course_info.tags=@course_info[:tags]
    @suggested_url = new_course_info.suggested_url
    
    library = new_course_info.create_basic_course
    
    library.add_a_new_document @new_document
    library.add_an_existing_document @existing_document
    library.add_a_participant_list @participant_list
    library.add_content_library @content_library
    
    @widgets.each do |widget|
      library.add_widget widget
    end
    
    #dashboard = library.my_dashboard
    
    # TEST CASE: Verify the new course is in recent memberships
    #assert dashboard.recent_memberships.include?(@course_info[:title]), "Expected course title: #{@course_info[:title]}\n\nList in Widget:\n\n#{dashboard.recent_memberships.join("\n")}"
=end
    membership = dashboard.my_memberships
    
    library = membership.go_to @course_info[:title]
    
    # TEST CASE: Verify pages are present
    assert library.public_pages.include? @new_document[:name]
    assert library.public_pages.include? @existing_document[:title]
    assert library.public_pages.include? @participant_list[:name]
    assert library.public_pages.include? @content_library[:name]
    
    @widgets.each do |widget|
      assert library.public_pages.include? widget[:name]
    end
    
    library.open_page("Participants", "participant")
    
    sleep 10
    
  end
  
end
