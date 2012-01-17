#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Courses.
#
# Creates 3 Courses--one for each Permission setting, then
# tests those permission settings by searching for each Course
# while logged out, and while logged in as a participant and non-participant.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCourseVisibility < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['id']
    @u2password = @config.directory['person1']['password']
    @user3 = @config.directory['person2']['id']
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
  
  def test_course_searching
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    create_course = dashboard.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@public_course[:title]
    new_course_info.description=@public_course[:description]
    new_course_info.tags=@public_course[:tags]
    new_course_info.can_be_discovered_by=@public_course[:permission]
    
    library = new_course_info.create_basic_course
    
    create_course = library.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@logged_in_course[:title]
    new_course_info.description=@logged_in_course[:description]
    new_course_info.tags=@logged_in_course[:tags]
    new_course_info.can_be_discovered_by=@logged_in_course[:permission]
    
    library = new_course_info.create_basic_course
    
    create_course = library.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@participant_course[:title]
    new_course_info.description=@participant_course[:description]
    new_course_info.tags=@participant_course[:tags]
    new_course_info.can_be_discovered_by=@participant_course[:permission]
    
    library = new_course_info.create_basic_course
    
    library.manage_participants
    library.add_by_search=@participant_name
    library.apply_and_save
    
    login_page = @sakai.logout
    
    expl_course = login_page.explore_courses
    
    expl_course.search_for=@public_course[:title]
    
    # TEST CASE: Public course displays while logged out
    assert expl_course.results_list.include?(@public_course[:title]), "#{@public_course[:title]} not found in:\n\n#{expl_course.results_list.join("\n")}"
    
    expl_course.search_for=@logged_in_course[:title]
    
    # TEST CASE: Logged in course does not display when logged out
    assert_equal false, expl_course.results_list.include?(@logged_in_course[:title])
    
    expl_course.search_for=@participant_course[:title]
    
    # TEST CASE: Participant Course does not display when logged out
    assert_equal false, expl_course.results_list.include?(@participant_course[:title])
    
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_courses
    
    explore.search_for=@public_course[:title]
    
    # TEST CASE: Public course displays when logged in
    assert explore.results_list.include? @public_course[:title]
    
    explore.search_for=@logged_in_course[:title]
    
    # TEST CASE: Logged in course displays when logged in
    assert explore.results_list.include? @logged_in_course[:title]
    
    explore.search_for=@participant_course[:title]
    
    # TEST CASE: Participant course displays to participant
    assert explore.results_list.include? @participant_course[:title]
    
    login_page = @sakai.logout
    
    dashboard = @sakai.login(@user3, @u3password)
    
    explore = dashboard.explore_courses
    
    explore.search_for=@public_course[:title]
    
    # TEST CASE: Public course displays when logged in
    assert explore.results_list.include? @public_course[:title]
    
    explore.search_for=@logged_in_course[:title]
    
    # TEST CASE: Logged in course displays when logged in
    assert explore.results_list.include? @logged_in_course[:title]
    
    explore.search_for=@participant_course[:title]
    
    # TEST CASE: Participant course does not display to non-participant
    assert_equal false, explore.results_list.include?(@participant_course[:title])
    
  end
  
end
