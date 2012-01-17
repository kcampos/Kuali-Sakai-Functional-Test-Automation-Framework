# 
# == Synopsis
#
# Test case for grading a submitted assignment and
# verifying the student can see the feedback.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-cle/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestGradeAssessment < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test case uses an instructor user and student user
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @student = @config.directory['person1']['id']
    @spassword = @config.directory['person1']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @test1 = @config.directory['site1']['quiz1']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @instructor_comment = "I am very disappointed. :("
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_grade_assessment
    
    # Log in to Sakai as instructor
    workspace = @sakai.login(@instructor, @ipassword)
    
    # Go to test site.
    home = workspace.open_my_site_by_id(@site_id)
    
    # Score the first test
    test_list = home.tests_and_quizzes
    
    score_test1 = test_list.score_test(@test1)
    
    score_test1.sort_by_submit_date
    sleep 0.5 # Need this because of a selenium bug.
    score_test1.sort_by_submit_date
    
    # Enter feedback
    score_test1.comment_in_first_box=@instructor_comment
    
    # Save the feedback
    score_test = score_test1.update
    
    # Go back to the Assessments list
    score_test.assessments
    
    # Log out
    @sakai.logout
    
    # Log in as the student
    workspace = @sakai.login(@student, @spassword)
    
    # Go to the Assessments page
    home = workspace.open_my_site_by_id(@site_id)
    tests = home.tests_and_quizzes
    
    # Click the link to get the feedback
    tests.feedback(@test1)
    
    # TEST CASE: Confirm instructor comment is present on page
    assert_not_equal false, @browser.frame(:index=>1).div(:class=>"portletBody").text=~/#{Regexp.escape(@instructor_comment)}/ 
    
  end
  
end
