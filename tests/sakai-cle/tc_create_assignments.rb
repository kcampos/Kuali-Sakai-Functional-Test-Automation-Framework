# 
# == Synopsis
#
# Tests creation of several assignments with various properties
#
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
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user is an instructor
    @user_name = @config.directory['person3']['id']
    @password = @config.directory['person3']['password']
    # This script requires a second test user (instructor)
    @user_name1 = @config.directory['person4']['id']
    @password1 = @config.directory['person4']['password']
    # Test site
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Save new assignment info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/directory.yml", "w+") { |out|
      YAML::dump(@config.directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_assignments_creation
    
    # Log in to Sakai
    my_workspace = @sakai.login(@user_name, @password)

    # Go to test site.
    home = my_workspace.open_my_site_by_id(@site_id)
    
    # Define the frame for ease of code writing (and reading)
    def frm
      @browser.frame(:index=>1)
    end

    # Go to assignments page
    assignments = home.assignments
    
    # Create a new assignment
    assignment1 = assignments.add
    
    # Store the title for later verification steps
    title1 = random_string
    
    # Store the due date for later verification steps
    month_due1 = assignment1.due_month_element.selected_options[0]
    day_due1 = assignment1.due_day_element.selected_options[0]
    year_due1 = assignment1.due_year_element.selected_options[0]
    
    assignment1.title=title1
    
    # Try to post it
    assignment1.post
    
    # TEST CASE: Alert appears when submitting without instructions
    assert_equal(assignment1.alert_text, "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed.")
    
    yesterdays_date = (Time.now - 86400).strftime("%d").to_i
    # Set the open date day to yesterday
    assignment1.open_day=yesterdays_date

    # Click post again
    assignments = assignment1.post
    
    #===========
    # Add a test for trying to save without a title (but with instructions)
    #===========
    
    # TEST CASE: Assignment saves this time
    assert assignments.view_element.exist?
    assert frm.link(:text, title1).exist?
    
    # Get the assignment id for use later in the script
    assignment1_id = assignments.get_assignment_id(title1)
    
    # Create a New Assignment
    assignments.add
    
    assignment2 = AssignmentAdd.new(@browser)
    
    title2 = random_string(15)
    assignment2.title=title2

    # Set Open Date
    assignment2.open_hour=current_hour
    assignment2.open_meridian="AM"

    # Store the due date for later verification steps
    month_due2 = assignment2.due_month_element.selected_options[0]
    day_due2 = assignment2.due_day_element.selected_options[0]
    year_due2 = assignment2.due_year_element.selected_options[0]
    
    # Set inline submission only
    assignment2.student_submissions="Inline only"
    
    # Set Letter Grade
    assignment2.grade_scale="Letter grade"
    
    # Set allow resubmission
    assignment2.check_allow_resubmission
    
    # Fix these instructions when all debugging is completed.
    instructions1 = "Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."
    
    # Enter assignment instructions into the rich text editor
    assignment2.instructions=instructions1
     
    # Add due date to schedule
    assignment2.check_add_due_date
    
    # Save
    assignments = assignment2.post
    
    # TEST CASE: Verify save
    assert frm.link(:text, title2).exist?
    
    # Get the assignment id for use later in the script
    assignment2_id = assignments.get_assignment_id(title2)
    @config.directory["site1"]["assignment2"] = assignment2_id
    
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
    assert frm.link(:title, "Due #{title2}").exist?
    
    # List events on the expected due date for Assignment 1
    calendar.start_month=month_due1
    calendar.start_day=day_due1
    calendar.start_year=year_due1
    calendar.end_month=month_due1
    calendar.end_day=day_due1
    calendar.end_year=year_due1
    calendar.filter_events
    
    # TEST CASE: Verify assignment 1 does not appear on calendar
    assert_equal(frm.link(:title, "Due #{title1}").exist?, false, "#{title1} appears in the calendar?")
    assert_equal(frm.link(:href, /#{assignment1_id}/).exist?, false, "#{title1} appears in the calendar?")
    
    # Go back to the Assignments List
    assignments = calendar.assignments

    # Add Assignment 3
    assignment3 = assignments.add
    
    # Using "nicelink" here because of potential problems validating
    # the draft mode link, etc.
    title3 = random_nicelink(20)
    
    #===========
    # Add a test for setting bad due, accept, and resubmission dates here.
    #===========
    
    # Set up Assignment 3
    assignment3.title=title3
    assignment3.open_hour=next_hour
    assignment3.student_submissions="Attachments only"
    assignment3.grade_scale="Points"
    assignment3.max_points="100"
    
    # Fix these instructions when all debugging is completed.
    instructions2 = "Fusce mollis massa nec nisi. Aliquam turpis libero, consequat quis, fringilla eget, fermentum ut, velit? Integer velit nisl, placerat non, fringilla at, pellentesque ut, odio? Cras magna ligula, tincidunt ac, iaculis in, hendrerit eu, justo. Vivamus porta. Suspendisse lorem! Donec nec libero in leo lobortis consectetuer. Vivamus quis enim? Proin viverra condimentum purus. Sed commodo.\n\nCurabitur eget velit. Curabitur eleifend libero et nisi aliquet facilisis. Integer ultricies commodo purus. Praesent velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus pretium. Suspendisse gravida diam. Nulla justo nulla, facilisis ut, sagittis ut, fermentum ac, elit. Morbi accumsan. Maecenas id tellus. Fusce ornare ullamcorper felis. Etiam fringilla. Maecenas in nunc nec sem sollicitudin condimentum? Nullam metus nunc, varius sit amet, consectetuer sed, vestibulum quis, est. Quisque in sapien a justo elementum iaculis?"
    
    # Enter assignment instructions into the rich text editor
    assignment3.instructions=(instructions2)
    
    # Setting up the test case by adding Assignment announcement
    assignment3.check_add_open_announcement
    
    #===========
    # Need to add tests here for adding attachments
    # This will need to be done when we have a properly
    # configured test site (where test scripts are not used
    # as "setup" scripts).
    
    # new_assignment.attach
    #===========
    
    assignment3.save_draft
    
    # TEST CASE: Assignment link shows "draft" mode
    assert frm.link(:text, "Draft - #{title3}").exist?
    
    # Get the assignment id
    frm.link(:text, "Draft - #{title3}").click
    
    edit = AssignmentAdd.new(@browser)
    edit.assignment_id_element.value =~ /(?<=\/a\/\S{36}\/).+/
    assignment3_id = $~.to_s
    @config.directory["site1"]["assignment3"] = assignment3_id
    
    # Go to the Home page for the Site
    edit.cancel
    assignments = AssignmentsList.new(@browser)
    assignments.home
    home = Home.new(@browser)
    
    # Verify that the annoucements frame does not show Assignment 3
    assert_equal @browser.frame(:index=>2).link(:text, "Assignment: Open Date for '#{title3}'").exist?, false
    
    # Go back to Assignments List page
    home.assignments
 
    assignments = AssignmentsList.new(@browser)
    
    # Create assignment #4
    assignments.add
    
    title4 = random_string(25)
    
    assignment4 = AssignmentAdd.new(@browser)
    assignment4.title=title4
    
    # Cancel assignment creation
    assignment4.cancel
    assignments = AssignmentsList.new(@browser)
    
    # TEST CASE: Verify assignment not created
    assert_equal(frm.link(:text, title4).exist?, false)
    
    # Add and set up Assignment 4 again
    assignments.add
    
    assignment4 = AssignmentAdd.new(@browser)
    assignment4.title=title4
    assignment4.open_day=yesterdays_date
    assignment4.grade_scale="Pass"
    
    # Fix these instructions when all debugging is completed.
    instructions3 = "Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.\n\nMorbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed." 
    
    assignment4.instructions=(instructions3)
    
    # TEST CASE: Verify that the alert message is not showing
    assert_equal(frm.div(:class, "portletBody").span(:id, "gradebookListWarnAssoc").visible?, false)
    
    # Select the "Add Assignment to Gradebook" radio button
    assignment4.select_add_assignment
    
    # Wait for the alert message to appear
    sleep 0.1
    
    # TEST CASE: Verify that the alert message appears
    assert frm.div(:class, "portletBody").span(:id, "gradebookListWarnAssoc").visible?
    
    # Need to clear the assignment radio button explicitly because
    # the radio button was actually selected, even though the UI doesn't show it.
    assignment4.select_do_not_add_assignment
    
    # Preview the new assignment
    assignment4.preview
    preview = AssignmentsPreview.new(@browser)
    
    # TEST CASE: Verify the preview window contents
    assert_equal preview.assignment_instructions, instructions3
    assert_equal preview.grade_scale, "Pass"
    assert_equal preview.add_due_date, "No"
    
    # Save the Assignment
    assignments = preview.post
    
    # TEST CASE: Verify assignment appears in the list
    assert frm.link(:text, title4).exist?
    
    # Get the assignment id for use later in the script
    assignment4_id = assignments.get_assignment_id(title4)
    @config.directory["site1"]["assignment4"] = assignment4_id
  
    # Log out and log back in as instructor2
    @sakai.logout
    workspace = @sakai.login(@user_name1, @password1)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to the Assignments page
    assignments = home.assignments
    
    # TEST CASE: Verify all expected assignments appear in list
    assert frm.link(:text, title1).exist?
    assert frm.link(:href, /#{assignment1_id}/).exist?
    assert frm.link(:text, title2).exist?
    assert frm.link(:href, /#{assignment2_id}/).exist?
    assert frm.link(:href, /#{assignment3_id}/).exist?
    assert frm.link(:text, title4).exist?
    assert frm.link(:href, /#{assignment4_id}/).exist?
    
    # Go to Assignments Permissions page
    assignments.permissions
    
    permissions = AssignmentsPermissions.new(@browser)
    
    # Uncheck "Instructors share drafts"
    permissions.uncheck_instructors_share_drafts
    
    # An "obsolete element error" bug requires accessing the
    # Save button element explicitly, here, instead of using the
    # AssignmentPermissions class definition. Hopefully this will
    # be fixed in the future.
    frm.button(:name, "eventSubmit_doSave").click
    
    # TEST CASE: instructor2 can no longer see the Draft assignment
    assert_equal(frm.link(:href, /#{assignment3_id}/).exist?, false)
    
    # Go to Assignments Permissions page
    assignments = AssignmentsList.new(@browser)
    permissions = assignments.permissions
    
    # Re-check "Instructors share drafts"
    permissions.check_instructors_share_drafts
    frm.button(:name, "eventSubmit_doSave").click
    
    # Edit Assignment 3 and save it so it's no longer in Draft mode
    frm.link(:href, /#{assignment3_id}/).click
    edit = AssignmentAdd.new(@browser)
    edit.post
    
    # Go to Home page of Site
    assignments = AssignmentsList.new(@browser)
    home = assignments.home
    
    # TEST CASE: Verify assignment 3 appears in announcements
    assert @browser.frame(:index=>2).link(:text, "Assignment: Open Date for '#{title3}'").exist?
    
    # Go to the assignments page and make Assignment 5
    assignments = home.assignments
    
    assignment5 = assignments.add
    
    title5 = random_nicelink(30)
    
    assignment5.title=title5
    assignment5.open_day=yesterdays_date
    assignment5.grade_scale="Checkmark"
    
    # Fix these instructions when debugging is completed.
    instructions4 = "Integer pulvinar facilisis purus. Quisque placerat! Maecenas risus. Nam vitae lacus. Quisque euismod imperdiet ipsum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam vitae nulla! Duis tincidunt. Nulla id felis. Duis accumsan, est ut volutpat mollis, tellus lorem venenatis justo, eu accumsan lorem neque sit amet ante. Sed dictum. Donec nulla mi, lacinia nec; viverra nec, commodo sed, justo. Praesent fermentum vehicula dui. Sed molestie eleifend leo. Nulla et risus! Nullam ut lacus. Etiam faucibus; eros sit amet tempus consectetuer, urna est hendrerit mi, eget molestie sapien lorem non tellus. In vitae nisl. Vivamus ac lectus id pede viverra placerat.\n\nMorbi nec dui eget pede dapibus mollis. Mauris nisl. Donec tempor blandit diam. In hac habitasse platea dictumst. Sed vulputate ornare urna. Nulla sed."
    
    # Enter assignment instructions into the rich text editor
    assignment5.instructions=(instructions4)
    
    #==========
    # Add attachment code should go here later
    #==========
    
    # Save assignment 5 as draft
    assignments = assignment5.save_draft
    
    # TEST CASE: Assignment link shows "draft" mode
    assert frm.link(:text, "Draft - #{title5}").exist?
    
    # Get the assignment id
    assignment5_id = assignments.get_assignment_id(title5)
    @config.directory["site1"]["assignment5"] = assignment5_id
    
    # Log out and log back in as instructor1
    @sakai.logout
    workspace = @sakai.login(@user_name, @password)
    
    # Go to test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to assignments page
    assignments = home.assignments
    
    # TEST CASE: Make sure there's a link to the Assignment 5 draft.
    assert frm.link(:href, /#{assignment5_id}/).exist?
    
    # Post assignment 5
    assignment5 = assignments.edit_assignment_id(assignment5_id)
    
    assignments = assignment_5.post
    
    # Edit assignment 1
    assignment1 = assignments.edit_assignment_id(assignment1_id)
    
    # TEST CASE: Verify the alert about revising assignments after the Open Date.
    assert_equal(assignment_1.alert_text, "Alert: You are revising an assignment after the open date.")
    
    # Change letter grade
    assignment_1.grade_scale="Letter grade"
    
    # Save
    assignment_1.post
    
    assignment_1 = AssignmentAdd.new(@browser)
    
    # Verify the instructions error message again
    assert_equal assignment_1.alert_text, "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed."
    
    # Add instructions
    # Fix these when all debugging done
    instructions5 = "Phasellus molestie. Sed in pede. Sed augue. Vestibulum lacus lectus, pulvinar nec, condimentum eu, sodales et, risus. Aenean dolor nisl, tristique at, vulputate nec, blandit in, mi. Fusce elementum ante. Maecenas rhoncus tincidunt sem. Sed leo dolor, faucibus hendrerit, tincidunt nec, elementum in, arcu. Donec et nulla. Vestibulum mauris nunc, consectetuer at, ultricies a, rutrum at, felis. Integer a nulla. Aliquam tincidunt nunc. Curabitur non purus. Nulla vel augue ac magna porttitor pretium.\n\nAenean fringilla enim. Vivamus nisi. Integer eleifend pharetra elit. Nulla scelerisque accumsan lectus. Morbi accumsan dui non velit. Suspendisse consequat mauris vitae neque. Etiam sit amet urna ut eros feugiat imperdiet? Nunc ut dolor. Nulla laoreet, nisi quis egestas condimentum, sapien nulla rutrum quam, quis auctor lorem justo at lectus. Integer in lacus eu nunc molestie pharetra. Curabitur dictum justo non eros. Nullam pellentesque ante rutrum mauris."
    assignment_1.add_instructions(instructions5)
    
    # Click on Student View
    assignment_1.student_view
    
    # Save assignment
    assignments = assignment_1.post
    
    # Delete Assignment 1
    assignments.check_assignment(assignment1_id)
    assignments.update
    
    # TEST CASE: Verify user is asked if they want to delete
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"alertMessage").text, "Are you sure you want to delete this assignment?")
    
    frm.button(:name, "eventSubmit_doDelete_assignment").click
    
    # Verify delete
    assert_equal(frm.link(:text, title1).exist?, false)
    
    # Duplicate assignment 2 to assignment 1
    frm.link(:text=>"Duplicate", :href=>/#{assignment2_id}/).click #FIXME
    
    # TEST CASE: Verify duplication
    assert frm.link(:text, "Draft - #{title2} - Copy").exist?
    
    frm.link(:text, "Draft - #{title2} - Copy").href =~ /(?<=\/a\/\S{36}\/).+(?=&pan)/ #FIXME
    assignment1_id = $~.to_s 
    @config.directory["site1"]["assignment1"] = assignment1_id
    
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
