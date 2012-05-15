# 
# == Synopsis
#
# Tests creation of several assignments with various properties
#
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreateAssignments < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Test user is an instructor
    @user_name = @directory['person3']['id']
    @password = @directory['person3']['password']
    # This script requires a second test user (instructor)
    @user_name1 = @directory['person4']['id']
    @password1 = @directory['person4']['password']
    # Test site
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @assignments = [
      {:title=>random_string, :grade_scale=>"Letter grade", :instructions=>random_multiline(500, 10, :string), :open_date=>yesterday },
      {:title=>random_nicelink(15), :open_hour=>current_hour, :open_meridian=>"AM", :student_submissions=>"Inline only", :grade_scale=>"Letter grade", :instructions=>random_multiline(750, 13, :string) },
      {:title=>random_xss_string(30), :open_hour=>next_hour, :student_submissions=>"Attachments only", :grade_scale=>"Points", :max_points=>"100", :instructions=>random_multiline(600, 12, :string) },
      {:title=>random_string(25), :open_day=>yesterday, :grade_scale=>"Pass", :instructions=>random_multiline(800, 15, :string)  },
      {:title=>random_string(30), :open_day=>yesterday, :grade_scale=>"Checkmark", :instructions=>random_multiline(500, 20) }
    ]
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @revising_alert = "Alert: You are revising an assignment after the open date."
    @missing_instructions = "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed."
    
  end
  
  def teardown
    
    @directory["site1"]["assignment1"] = @assignments[0][:title]
    @directory["site1"]["assignment2"] = @assignments[1][:title]
    @directory["site1"]["assignment3"] = @assignments[2][:title]
    @directory["site1"]["assignment4"] = @assignments[3][:title]
    @directory["site1"]["assignment5"] = @assignments[4][:title]
    
    # Save new assignment info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/CLE/directory.yml", "w+") { |out|
      YAML::dump(@directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_assignments_creation
    
    # Log in to Sakai
    my_workspace = @sakai.page.login(@user_name, @password)

    # Go to test site.
    home = my_workspace.open_my_site_by_id(@site_id)

    # Go to assignments page
    assignments = home.assignments
    
    # Create a new assignment
    assignment1 = assignments.add
    
    # Store the due date for later verification steps
    month_due1 = assignment1.due_month_element.selected_options[0]
    day_due1 = assignment1.due_day_element.selected_options[0]
    year_due1 = assignment1.due_year_element.selected_options[0]
    
    assignment1.title=@assignments[0][:title]
    
    # Try to post it
    assignment1.post
    
    # TEST CASE: Alert appears when submitting without instructions
    assert_equal(assignment1.alert_text, "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed.")

    # Set the open date day to yesterday
    assignment1.open_day=@assignments[0][:open_date]
    
    # Set the open month to last month if today is the first
    if (Time.now - (3600*24)).strftime("%d").to_i > (Time.now).strftime("%d").to_i
      assignment1.open_month=last_month
    end

    # Click post again
    assignments = assignment1.post
    
    #===========
    # Add a test for trying to save without a title (but with instructions)
    #===========
    
    # TEST CASE: Assignment saves this time
    assert assignments.view_element.exists?
    assert assignments.assignments_list.include?(@assignments[0][:title])
    
    # Create a New Assignment
    assignments.add
    
    assignment2 = AssignmentAdd.new(@browser)
    
    assignment2.title=@assignments[1][:title]

    # Set Open Date
    assignment2.open_hour=@assignments[1][:open_hour]
    assignment2.open_meridian=@assignments[1][:open_meridian]

    # Store the due date for later verification steps
    month_due2 = assignment2.due_month_element.selected_options[0]
    day_due2 = assignment2.due_day_element.selected_options[0]
    year_due2 = assignment2.due_year_element.selected_options[0]
    
    # Set inline submission only
    assignment2.student_submissions=@assignments[1][:student_submissions]
    
    # Set Letter Grade
    assignment2.grade_scale=@assignments[1][:grade_scale]
    
    # Set allow resubmission
    assignment2.check_allow_resubmission
    
    # Enter assignment instructions into the rich text editor
    assignment2.instructions=@assignments[1][:instructions]
     
    # Add due date to schedule
    assignment2.check_add_due_date
    
    # Save
    assignments = assignment2.post
    
    # TEST CASE: Verify save
    assert assignments.assignment_titles.include? @assignments[1][:title]
    
    # Go to calendar page
    calendar = assignments.calendar
    
    # List events on the expected due date for Assignment 2
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
    assert calendar.events_list.include? "Due #{@assignments[1][:title]}"
    
    # List events on the expected due date for Assignment 1
    calendar.start_month=month_due1
    calendar.start_day=day_due1
    calendar.start_year=year_due1
    calendar.end_month=month_due1
    calendar.end_day=day_due1
    calendar.end_year=year_due1
    calendar.filter_events
    
    # TEST CASE: Verify assignment 1 does not appear on calendar
    assert_equal(false, calendar.events_list.include?("Due #{@assignments[0][:title]}"), "#{@assignments[0][:title]} appears in the calendar?")
    
    # Go back to the Assignments List
    assignments = calendar.assignments

    # Add Assignment 3
    assignment3 = assignments.add
    
    #===========
    # Add a test for setting bad due, accept, and resubmission dates here.
    #===========
    
    # Set up Assignment 3
    assignment3.title=@assignments[2][:title]
    assignment3.open_hour=@assignments[2][:open_hour]
    assignment3.student_submissions=@assignments[2][:student_submissions]
    assignment3.grade_scale=@assignments[2][:grade_scale]
    assignment3.max_points=@assignments[2][:max_points]
        
    # Enter assignment instructions into the rich text editor
    assignment3.instructions=@assignments[2][:instructions]
    
    # Setting up the test case by adding Assignment announcement
    assignment3.check_add_open_announcement
    
    #===========
    # Need to add tests here for adding attachments
    # This will need to be done when we have a properly
    # configured test site (where test scripts are not used
    # as "setup" scripts).
    
    # new_assignment.attach
    #===========
    
    assignments = assignment3.save_draft
    
    # TEST CASE: Assignment link shows "draft" mode
    assert assignments.assignment_titles.include?("Draft - #{@assignments[2][:title]}"), "#{@assignments[2][:title]} not found!"
    
    # Go to the Home page for the Site
    home = assignments.home
    
    # Verify that the annoucements frame does not show Assignment 3
    assert_equal @browser.frame(:index=>2).link(:text, "Assignment: Open Date for '#{@assignments[2][:title]}'").exist?, false
    
    # Go back to Assignments List page
    assignments = home.assignments
    
    # Create assignment #4
    assignment4 = assignments.add
    assignment4.title=@assignments[3][:title]
    
    # Cancel assignment creation
    assignments = assignment4.cancel
    
    # TEST CASE: Verify assignment not created
    assert_equal false, assignments.assignment_titles.include?(@assignments[3][:title])
    
    # Add and set up Assignment 4 again
    assignment4 = assignments.add

    assignment4.title=@assignments[3][:title]
    assignment4.open_day=@assignments[3][:open_day]
    
    # Set the open month to last month if today is the first
    if (Time.now - (3600*24)).strftime("%d").to_i > (Time.now).strftime("%d").to_i
      assignment4.open_month=last_month
    end
    
    assignment4.grade_scale=@assignments[3][:grade_scale]

    assignment4.instructions=@assignments[3][:instructions]
    
    # TEST CASE: Verify that the alert message is not showing
    assert_equal false, assignment4.gradebook_warning.visible?
    
    # Select the "Add Assignment to Gradebook" radio button
    assignment4.select_add_to_gradebook
    
    # Wait for the alert message to appear
    sleep 0.1
    
    # TEST CASE: Verify that the alert message appears
    assert assignment4.gradebook_warning.visible?
    
    # Need to clear the assignment radio button explicitly because
    # the radio button was actually selected, even though the UI doesn't show it.
    assignment4.select_do_not_add_to_gradebook
    
    # Preview the new assignment
    assignment4.preview
    preview = AssignmentsPreview.new(@browser)
    
    # TEST CASE: Verify the preview window contents
    assert_equal preview.assignment_instructions, @assignments[3][:instructions]
    assert_equal preview.item_summary["Grade Scale"], @assignments[3][:grade_scale]
    assert_equal preview.item_summary["Add due date to Schedule"], "No"
    
    # Save the Assignment
    assignments = preview.post
    
    # TEST CASE: Verify assignment appears in the list
    assert assignments.assignment_list.include? @assignments[3][:title]
  
    # Log out and log back in as instructor2
    assignments.logout
    workspace = @sakai.page.login(@user_name1, @password1)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to the Assignments page
    assignments = home.assignments
    
    # TEST CASE: Verify all expected assignments appear in list
    assert assignments.assignment_list.include? @assignments[0][:title]
    assert assignments.assignment_list.include? @assignments[1][:title]
    assert assignments.assignment_list.include? "Draft - #{@assignments[2][:title]}"
    assert assignments.assignment_list.include? @assignments[3][:title]
    
    # Go to Assignments Permissions page
    assignments.permissions
    
    permissions = AssignmentsPermissions.new(@browser)
    
    # Uncheck "Instructors share drafts"
    permissions.uncheck_instructors_share_drafts
    
    # An "obsolete element error" bug requires accessing the
    # Save button element explicitly, here, instead of using the
    # AssignmentPermissions class definition. Hopefully this will
    # be fixed in the future.
    @browser.frame(:index=>1).button(:name, "eventSubmit_doSave").click
    
    assignments = AssignmentsList.new(@browser)
    
    # TEST CASE: instructor2 can no longer see the Draft assignment
    assert_equal false, assignments.assignments_list.include?("Draft - #{@assignments[2][:title]}")
    
    # Go to Assignments Permissions page
    permissions = assignments.permissions
    
    # Re-check "Instructors share drafts"
    permissions.check_instructors_share_drafts
    @browser.frame(:index=>1).button(:name, "eventSubmit_doSave").click
    
    assignments = AssignmentsList.new(@browser)
    
    # Edit Assignment 3 and save it so it's no longer in Draft mode
    assignment3 = assignments.edit_assignment "Draft - #{@assignments[2][:title]}"

    assignments = assignment3.post
    
    # Go to Home page of Site
    home = assignments.home
    
    # TEST CASE: Verify assignment 3 appears in announcements
    assert home.announcements_list.include? "Assignment: Open Date for '#{@assignments[2][:title]}'"
    
    # Go to the assignments page and make Assignment 5
    assignments = home.assignments
    
    assignment5 = assignments.add
    
    assignment5.title=@assignments[4][:title]
    assignment5.open_day=@assignments[4][:open_day]
    
    # Set the open month to last month if today is the first
    if (Time.now - (3600*24)).strftime("%d").to_i > (Time.now).strftime("%d").to_i
      assignment5.open_month=last_month
    end
    
    assignment5.grade_scale=@assignments[4][:grade_scale]
   
    # Enter assignment instructions into the rich text editor
    assignment5.instructions=@assignments[4][:instructions]
    
    #==========
    # Add attachment code should go here later
    #==========
    
    # Save assignment 5 as draft
    assignments = assignment5.save_draft
    
    # TEST CASE: Assignment link shows "draft" mode
    assert assignments.assignment_list.include? "Draft - #{@assignments[4][:title]}"
    
    # Log out and log back in as instructor1
    assignments.logout
    workspace = @sakai.page.login(@user_name, @password)
    
    # Go to test site
    home = workspace.open_my_site_by_id(@site_id)

    # Go to assignments page
    assignments = home.assignments

    # TEST CASE: Make sure there's a link to the Assignment 5 draft.
    assert assignments.assignment_list.include? "Draft - #{@assignments[4][:title]}"
    
    # Post assignment 5
    assignment_5 = assignments.edit_assignment("Draft - #{@assignments[4][:title]}")

    assignments = assignment_5.post

    # Edit assignment 1
    assignment_1 = assignments.edit_assignment(@assignments[0][:title])

    # TEST CASE: Verify the alert about revising assignments after the Open Date.
    assert_equal(@revising_alert, assignment_1.alert_text)
    
    # Change letter grade
    assignment_1.grade_scale=@assignments[0][:grade_scale]
    
    # Save
    assignment_1.post
    
    assignment_1 = AssignmentAdd.new(@browser)
    
    # Verify the instructions error message again
    assert_equal @missing_instructions, assignment_1.alert_text
    
    # Add instructions
    assignment_1.instructions=@assignments[0][:instructions]
    
    # Click on Student View
    assignment_1.student_view
    
    # Save assignment
    assignments = assignment_1.post
    
    # Delete Assignment 1
    assignments = assignments.delete_assignment @assignments[0][:title]

    # Verify delete
    assert_equal false, assignments.assignment_titles.include?(@assignments[0][:title])
    
    # Duplicate assignment 2 to assignment 1
    assignments = assignments.duplicate_assignment(@assignments[1][:title])
    
    # TEST CASE: Verify duplication
    assert assignments.assignment_list.include? "Draft - #{@assignments[1][:title]} - Copy"
    
    # Go to Reorder page
    assignments = AssignmentsList.new(@browser)
    assignments.reorder
    
    # Sort assignments by title
    reorder = AssignmentsReorder.new(@browser)
    reorder.sort_by_title
    reorder.save
    
    #=============
    # Add verification of sorts tests later - though this should probably get its own test case
    #=============
    
  end
  
end