# 
# == Synopsis
#
# Test case for grading submitted assignments. Verifies that
# an assignment can be graded, that the student can see
# the grade when it's released, and vice versa.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestGradingAssignments < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    # Instructor login
    @instructor_id = @directory['person3']['id']
    @instructor_pw = @directory['person3']['password']
    # Student login
    @student_id = @directory['person1']['id']
    @student_pw = @directory['person1']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @assignment1 = @directory["site1"]["assignment4"]
    @assignment2 = @directory["site1"]["assignment2"]
    @student = @directory['person1']['lastname'] + ", " + @directory['person1']['firstname']
    
    @instructor_comments = random_multiline(156, 9, :string)
    @comment_string = "{{Try again please.}}"
    @grade1 = "Fail"
    @grade2 = "A-"
    @url = "www.rsmart.com"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_grade_assignments
    
    # Log in to Sakai as the instructor
    workspace = @sakai.page.login(@instructor_id, @instructor_pw)
    
    # Go to test site
    home = workspace.open_my_site_by_id @site_id
    
    # Go to assignments page
    assignments = home.assignments

    # Click to Grade the first assignment
    submissions = assignments.grade(@assignment1)

    # Grade the student's assignment
    grade_assignment = submissions.grade @student

    # Add comments
    grade_assignment.assignment_text=@comment_string
    grade_assignment.instructor_comments=@instructor_comments
    
    # Set failing grade
    grade_assignment.select_default_grade=@grade1
    
    # Allow resubmission
    grade_assignment.check_allow_resubmission

    # Add attachment
    attach = grade_assignment.add_attachments
    
    attach.url=@url
    attach.add
    
    grade_assignment = attach.continue
    
    # Save and release to student
    grade_assignment.save_and_release
    
    submissions = grade_assignment.return_to_list
    
    # Go back to the assignments list
    assignments = submissions.assignment_list
 
    # Grade Assignment 2...
    submissions = assignments.grade(@assignment2)
    
    # Select the student
    grade_assignment = submissions.grade @student
    
    # Select a default grade
    grade_assignment.select_default_grade=@grade2
    
    # Save and don't release
    grade_assignment.save_and_dont_release

    # Log out and log back in as student user
    grade_assignment.logout
    workspace = @sakai.page.login(@student_id, @student_pw)
  
    # Go to the test site
    home = workspace.open_my_site_by_id @site_id
    
    # Go to assignments page
    assignments = home.assignments

    assignment1 = assignments.open_assignment @assignment1
    
    # TEST CASE: Verify that the assignment grade is "Fail"
    assert_equal("Fail", assignment1.item_summary["Grade"])

    # TEST CASE: Verify assignment 1 shows "returned"
    assert_equal( assignment1.header, "#{@assignment1} - Resubmit" )
    
    assignments = assignment1.cancel
  
    assignment2 = assignments.open_assignment @assignment2
    
    # TEST CASE: Verify assignment 2 still shows "submitted"
    assert_equal( assignment2.header, "#{@assignment2} - Submitted" )
    
    list = assignment2.back_to_list
    
    # TEST CASE: Verify assignment 2 shows as "submitted" in the assignments list.
    assert list.status_of(@assignment2).include?("Submitted")
    
  end
  
end
