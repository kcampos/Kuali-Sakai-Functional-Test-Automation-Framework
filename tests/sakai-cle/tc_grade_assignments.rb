# 
# == Synopsis
#
# Test case for grading submitted assignments. Verifies that
# an assignment can be graded, that the student can see
# the grade when it's released, and vice versa.
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
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
    @assignment1id = @config.directory["site1"]["assignment4"]
    @assignment2id = @config.directory["site1"]["assignment2"]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_grade_assignments
    
    # Log in to Sakai as the instructor
    workspace = @sakai.login(@instructor_id, @instructor_pw)
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>$frame_index)
    end
    
    # Go to test site
    home = workspace.open_my_site_by_id @site_id
    
    # Go to assignments page
    assignments = home.assignments

    # Click to Grade the first assignment
    frm.link(:xpath=>"//a[contains(@onclick, '#{assignment1id}')]").click
    
    # Find the right student for grading
    submissions = assignments.grade()
    
    index = submissions.student_table.find_index { |row| row[2] =~ /#{@student_id}/ }

    # Click the Grade button
    frm.link(:text=>"Grade", :index=>(index)).click
    
    grade_assignment = AssignmentSubmission.new(@browser)
    # Add comments
    instructor_comments = "Aliquam in eros felis. Quisque et pharetra nisl! Nunc eget arcu quam. Integer vehicula lectus quis est ullamcorper vel condimentum lectus semper. Proin vitae justo ligula, feugiat congue orci. Duis ut sem quis mauris fermentum facilisis id et sapien. Donec eros est, eleifend sit amet molestie eget, pharetra ut orci? Sed scelerisque varius erat quis fringilla! Nam venenatis venenatis nibh, eget bibendum nulla accumsan vitae. Integer in mi augue, et ultrices lectus. Nulla facilisi. Donec gravida ullamcorper dui, et pellentesque arcu viverra in. Vivamus nisi nunc; euismod vel aliquam ac; tristique nec velit. Etiam fermentum nisl sit amet augue vulputate in mattis lacus lobortis. Pellentesque in molestie ante! Phasellus adipiscing cursus iaculis. Vivamus mattis tristique dui, nec iaculis nulla molestie non. Suspendisse potenti. Donec venenatis ultrices blandit. Duis urna tellus, convallis ac consectetur sed, ullamcorper vitae augue. Sed fringilla ligula ut turpis scelerisque ullamcorper! Aliquam erat volutpat. Nunc blandit convallis scelerisque. Cras facilisis molestie nulla. Mauris faucibus, est sed egestas pellentesque, enim quam tempus ante, et vehicula lacus massa id massa. Aliquam sodales odio eget quam laoreet quis rutrum justo consequat. Nunc sed egestas velit? Duis suscipit tempor libero sit amet volutpat. Vestibulum nibh mauris, bibendum ut sagittis a, suscipit at leo. Maecenas ullamcorper sem et sapien malesuada in cursus odio eleifend. Fusce volutpat, mauris a faucibus pretium, nibh risus posuere orci, quis congue nunc arcu sed nunc. Aenean sed odio in nisl scelerisque egestas at euismod nulla. Aliquam metus nisi, rhoncus vitae ornare at, tempus porta tellus. Donec bibendum sem non tellus cursus consectetur. Proin quis lacus nulla. Pellentesque mi tellus, condimentum eu hendrerit ut, semper ut nunc. Donec vel viverra nisi. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ligula sapien, bibendum a imperdiet ut, dapibus at nibh. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque at nisi risus. Praesent sed ultricies tellus. Nulla pretium, est in pellentesque consequat, augue odio hendrerit ipsum, eget suscipit sapien lorem adipiscing felis. Etiam auctor metus a nulla vehicula id elementum lacus laoreet. Nunc quis nibh nulla! Nullam mauris elit, pulvinar at euismod ut, sollicitudin id ante amet. Fasda."
    grade_assignment.student_assignment_text.send_keys("{{Try again please.}}")
    grade_assignment.set_instructor_comments(instructor_comments)
    
    # Set failing grade
    grade_assignment.select_default_grade="Fail"
    
    # Allow resubmission
    grade_assignment.check_allow_resubmission
    
    # Add attachment
    grade_assignment.add_attachments
    frm.text_field(:id, "url").set "www.rsmart.com"
    frm.button(:id, "add_url").click
    frm.button(:id, "attachButton").click
    
    # Save and release to student
    frm.button(:name, "return").click
    
    # Go back to the assignments list
    frm.link(:text, "Assignment List").click
 
    # Ensure the page is fully loaded
    frm.button(:name, "eventSubmit_doDelete_confirm_assignment").wait_until_present
   
    # Grade Assignment 2...
    frm.link(:xpath, "//a[contains(@onclick, '#{assignment2id}')]").click
    
    # Find the right student for grading
    submissions = AssignmentSubmissionList.new(@browser)
    
    index = submissions.student_table.find_index { |row| row[2] =~ /#{@student_id}/ }

    # Click the Grade button
    frm.link(:text=>"Grade", :index=>(index)).click
    
    # Select a default grade
    grade_assignment = AssignmentSubmission.new(@browser)
    
    grade_assignment.select_default_grade="A-"
    
    # Save and don't release
    grade_assignment.save_dont_release

    # Log out and log back in as student user
    @sakai.logout
    @sakai.login(@student_id, @student_pw)
  
    # Go to the test site
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    
    # Go to assignments page
    home.assignments

    name1 = frm.link(:href, /#{assignment1id}/).text
    frm.link(:href, /#{assignment1id}/).click
    info_table = frm.table(:class, "itemSummary").to_a
    
    # TEST CASE: Verify that the assignment grade is "Fail"
    assert_equal("Fail", info_table[-1][-1])
    
    # TEST CASE: Verify assignment 1 shows "returned"
    assert_equal( frm.div(:class=>"portletBody").h3(:index=>0).text, "#{name1} - Resubmit" )
    
    frm.button(:name=>"cancel").click
  
    name2 = frm.link(:href, /#{assignment2id}/).text
    frm.link(:href, /#{assignment2id}/).click
    
    frm.div(:class=>"textPanel", :index=>1).wait_until_present
    
    # TEST CASE: Verify assignment 2 still shows "submitted"
    assert_equal( frm.div(:class=>"portletBody").h3(:index=>0).text, "#{name2} - Submitted" )
    # TEST CASE: Verify the "Back to list" button is present
    assert frm.button(:name=>"eventSubmit_doCancel_view_grade").exist?
    
  end
  
end
