# 
# == Synopsis
#
# Tests creation of several assignments with various properties
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCreateAssignments < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # Test user is an instructor
    @user_name = config.directory['instructor']['username']
    @password = config.directory['instructor']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_assignments_creation
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to test site.
    # Note that this test site is current hard-coded.
    # This should be corrected as soon as possible.
    @browser.link(:text, "1 2 3 F11").click
    home = Home.new(@browser)
      
    # Go to assignments page
    home.assignments
=begin    
    assignments = AssignmentsList.new(@browser)
    
    # Create a new assignment
    assignments.add
    new_assignment = AddAssignment.new(@browser)
    
    # Store the title for later verification steps
    title1 = random_string
    
    # Store the due date for later verification steps
    month_due1 = new_assignment.due_month_element.selected_options[0]
    day_due1 = new_assignment.due_day_element.selected_options[0]
    year_due1 = new_assignment.due_year_element.selected_options[0]
    
    new_assignment.title=title1
    
    # Try to post it
    new_assignment.post
    
    # TEST CASE: Alert appears when submitting without instructions
    assert_equal @browser.frame(:index=>1).div(:class=>"portletBody").div(:class=>"alertMessage").text, "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed."
    
    # Click post again
    new_assignment.post
    
    assignments = AssignmentsList.new(@browser)
    
    # TEST CASE: Assignment saves this time
    assert assignments.view_element.exist?
    assert @browser.frame(:index=>1).link(:text, title1).exist?
    
    # Create a New Assignment
    assignments.add
    
    new_assignment = AddAssignment.new(@browser)
    
    title2 = random_string(15)
    new_assignment.title=title2
    
    # Set Open Date
    new_assignment.open_hour=current_hour
    
    # Store the due date for later verification steps
    month_due2 = new_assignment.due_month_element.selected_options[0]
    day_due2 = new_assignment.due_day_element.selected_options[0]
    year_due2 = new_assignment.due_year_element.selected_options[0]
    
    # Set inline submission only
    new_assignment.student_submissions="Inline only"
    
    # Set Letter Grade
    new_assignment.grade_scale="Letter grade"
    
    # Set allow resubmission
    new_assignment.check_allow_resubmission
    
    instructions = "Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."
    
    # Enter assignment instructions into the rich text editor
    @browser.frame(:index=>1).frame(:id, "new_assignment_instructions___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
     
    # Add due date to schedule
    new_assignment.check_add_due_date
    
    # Save
    new_assignment.post
    
    # TEST CASE: Verify save
    assert @browser.frame(:index=>1).link(:text, title2).exist?
    
    # Go to calendar page
    assignments = AssignmentsList.new(@browser)
    assignments.calendar
    
    # List events on the expected due date for Assignment 2
    calendar = Calendar.new(@browser)
    calendar.view="List of Events"
    calendar.show_events="Custom date range"
    calendar.start_month=month_due2
    calendar.start_day=day_due2
    calendar.start_year=year_due2
    calendar.end_month=month_due2
    calendar.end_day=day_due2
    calendar.end_year=year_due2
    calendar.filter_events
    
    # TEST CASE: Verify assignment 2 appears on calendar
    assert @browser.frame(:index=>1).link(:title, "Due #{title2}").exist?
    
    # List events on the expected due date for Assignment 1
    calendar.start_month=month_due1
    calendar.start_day=day_due1
    calendar.start_year=year_due1
    calendar.end_month=month_due1
    calendar.end_day=day_due1
    calendar.end_year=year_due1
    calendar.filter_events
    
    # TEST CASE: Verify assignment 1 does not appear on calendar
    assert @browser.frame(:index=>1).link(:title, "Due #{title2}").exist? = false
    
    # Go back to the Assignments List
    calendar.assignments
=end
    # Add Assignment 3
    assignments = AssignmentsList.new(@browser)
    assignments.add
    
    title3 = random_string(20)
    
    new_assignment = AddAssignment.new(@browser)
    
    # Set up Assignment 3
    new_assignment.title=title3
    new_assignment.open_hour=next_hour
    new_assignment.student_submissions="Attachments only"
    new_assignment.grade_scale="Points"
    new_assignment.max_points="100"
    
    instructions = "Fusce mollis massa nec nisi. Aliquam turpis libero, consequat quis, fringilla eget, fermentum ut, velit? Integer velit nisl, placerat non, fringilla at, pellentesque ut, odio? Cras magna ligula, tincidunt ac, iaculis in, hendrerit eu, justo. Vivamus porta. Suspendisse lorem! Donec nec libero in leo lobortis consectetuer. Vivamus quis enim? Proin viverra condimentum purus. Sed commodo.\n\nCurabitur eget velit. Curabitur eleifend libero et nisi aliquet facilisis. Integer ultricies commodo purus. Praesent velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus pretium. Suspendisse gravida diam. Nulla justo nulla, facilisis ut, sagittis ut, fermentum ac, elit. Morbi accumsan. Maecenas id tellus. Fusce ornare ullamcorper felis. Etiam fringilla. Maecenas in nunc nec sem sollicitudin condimentum? Nullam metus nunc, varius sit amet, consectetuer sed, vestibulum quis, est. Quisque in sapien a justo elementum iaculis?"
    # Enter assignment instructions into the rich text editor
    @browser.frame(:index=>1).frame(:id, "new_assignment_instructions___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
    
    new_assignment.check_add_open_announcement
    
    # Need to add tests here for adding attachments
    # This will need to be done when we have a properly
    # configured test site (where test scripts are not used
    # as "setup" scripts).
    
    # new_assignment.attach
    
    new_assignment.save_draft
    
    assignments = AssignmentsList.new(@browser)
    
    # TEST CASE: Assignment link shows "draft" mode
    assert @browser.frame(:index=>1).link(:text, "Draft - #{title3}").exist?
    
    # Go to the Home page for the Site
    assignments.home
    
    
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
