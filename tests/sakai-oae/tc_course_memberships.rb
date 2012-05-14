#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Courses.
#
# Creates 3 Courses--one for each Membership setting, then
# tests that a non-manager of those courses has appropriate options
# available for joining, and that those options work as expected.
#
# == Prerequisites
#
# Two existing users.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae-test-api'

describe "Course Membership Rules" do
  
  include Utilities

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['id']
    @u2password = @config.directory['person1']['password']
    @student_name = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @auto_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, auto-join",
      :membership=>"People can automatically join"
    }
    
    @request_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, by-request",
      :membership=>"People request to join"
    }
    
    @managers_course = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, managers-only",
      :membership=>"Managers add people"
    }
    
    @join_notification = "Group membership\nYou have successfully been added to the group."
    @request_notification = "Group membership\nYour request has successfully been sent to the group's managers."
    
    @email_subject_prefix = "#{@student_name} has requested to join your group "
    
  end

  it "creates three courses with different membership settings" do
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    create_course = dashboard.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@auto_course[:title]
    new_course_info.description=@auto_course[:description]
    new_course_info.tags=@auto_course[:tags]
    new_course_info.membership=@auto_course[:membership]

    library = new_course_info.create_basic_course
    
    create_course = library.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@request_course[:title]
    new_course_info.description=@request_course[:description]
    new_course_info.tags=@request_course[:tags]
    new_course_info.membership=@request_course[:membership]
    
    library = new_course_info.create_basic_course
    
    create_course = library.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@managers_course[:title]
    new_course_info.description=@managers_course[:description]
    new_course_info.tags=@managers_course[:tags]
    new_course_info.membership=@managers_course[:membership]

    library = new_course_info.create_basic_course
    
    @sakai.logout
  end
  
  it "'Student' tries to join 'Manager add' course" do
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_courses
    explore.search=@managers_course[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    course = explore.open_course @managers_course[:title]

    # TEST CASE: Verify "Managers Add" Course does not show buttons to join
    course.join_group_button_element.should exist
    course.join_group_button_element.should_not be_visible
    course.request_to_join_group_button_element.should_not be_visible
  end
    
  it "'Join' button displays for 'Joinable' course" do
    course = Library.new @browser
    explore = course.explore_courses
    explore.search=@auto_course[:title]
    
    course = explore.open_course @auto_course[:title]
    
    # TEST CASE: Verify button (Join Group) displays for "Automatically joinable" Course
    course.join_group_button_element.should be_visible
    
    course.join_group
    sleep 0.2
    
    # TEST CASE: Verify clicking button adds user as participant
    course.notification.should == @join_notification
    
    course.close_notification
  end
  
  it "'Request' button appears for 'Request' course" do
    course = Library.new @browser
    explore = course.explore_courses
    explore.search=@request_course[:title]
    
    course = explore.open_course @request_course[:title]
    
    # TEST CASE: Verify button (Request to Join) displays for "Request" Course
    course.request_to_join_group_button_element.should be_visible
    
    course.request_to_join_group
    sleep 0.2
    
    # TEST CASE: Verify clicking button sends request to join.
    course.notification.should == @request_notification
    
    @sakai.logout
  end
  
  it "Request email sent to course manager" do
    dashboard = @sakai.login(@instructor, @ipassword)
    
    inbox = dashboard.my_messages
    
    # TEST CASE: Verify Email sent to Course manager requesting to join
    inbox.message_subjects.should include(@email_subject_prefix + @request_course[:title])

  end

  after :all do
    # Close the browser window
    @browser.close
  end
 
end
