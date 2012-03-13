# 
# == Synopsis
#
# Test case for grading submitted assignments. Verifies that
# an assignment can be graded, that the student can see
# the grade when it's released, and vice versa.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestGradingAssignments < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    # Instructor login
    @instructor_id = @config.directory['person3']['id']
    @instructor_pw = @config.directory['person3']['password']
    # Student login
    @student_id = @config.directory['person1']['id']
    @student_pw = @config.directory['person1']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @assignment1 = @config.directory["site1"]["assignment4"]
    @assignment2 = @config.directory["site1"]["assignment2"]
    @student = @config.directory['person1']['lastname'] + ", " + @config.directory['person1']['firstname']
    
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
    workspace = @sakai.login(@instructor_id, @instructor_pw)
    
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
    @sakai.logout
    workspace = @sakai.login(@student_id, @student_pw)
  
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
