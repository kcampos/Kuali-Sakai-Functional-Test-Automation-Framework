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
# == Prerequisites:
#
# Three test users (see lines 30-36)
#
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Course Memberships" do
  
  include Utilities

  let(:expl_course) { ExploreCourses.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @participant = @config.directory['person1']['id']
    @participant_pw = @config.directory['person1']['password']
    @participant_name = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @non_participant = @config.directory['person2']['id']
    @non_participant_pw = @config.directory['person2']['password']
    
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
    
    
  end
 
  it "creates 3 courses with different join settings" do
    
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
  end
  
  it "Public Course can be found while logged out" do
    login_page = @sakai.logout
    expl_course = login_page.explore_courses
    expl_course.search_for=@public_course[:title]
    # TEST CASE: Public course displays while logged out
    expl_course.results_list.should include @public_course[:title]
  end
  
  it "'Users only' course can't be seen while logged out" do
    expl_course.search_for=@logged_in_course[:title]
    
    # TEST CASE: Logged in course does not display when logged out
    expl_course.results_list.should_not include @logged_in_course[:title]
  end
  
  it "'Participants only' course can't be seen while logged out" do
    expl_course.search_for=@participant_course[:title]
    
    # TEST CASE: Participant Course does not display when logged out
    expl_course.results_list.should_not include @participant_course[:title]
  end
  
  it "Public course can be found while logged in" do
    dashboard = @sakai.login(@participant, @participant_pw)
    explore = dashboard.explore_courses
    explore.search_for=@public_course[:title]
    # TEST CASE: Public course displays when logged in
    explore.results_list.should include @public_course[:title]
  end
  
  it "Users-only course can be found by non-participant while logged in" do
    expl_course.search_for=@logged_in_course[:title]
    
    # TEST CASE: Logged in course displays when logged in
    expl_course.results_list.should include @logged_in_course[:title]
  end
  
  it "Participants-only course can be found by a participant" do
    expl_course.search_for=@participant_course[:title]
    # TEST CASE: Participant course displays to participant
    expl_course.results_list.should include @participant_course[:title]
  end
  
  it "Participants-only course does not appear for a non-participant" do
    @sakai.logout
    dashboard = @sakai.login(@non_participant, @non_participant_pw)
    explore = dashboard.explore_courses
    explore.search_for=@participant_course[:title]
    # TEST CASE: Participant course does not display to non-participant
    explore.results_list.should_not include @participant_course[:title]
  end
 
  after :all do
    # Close the browser window
    @browser.close
  end
    
end
