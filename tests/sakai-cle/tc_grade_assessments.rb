# 
# == Synopsis
#
# Test case for grading a submitted assignment and
# verifying the student can see the feedback.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestGradeAssessment < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Test case uses an instructor user and student user
    @instructor = @directory['person3']['id']
    @ipassword = @directory['person3']['password']
    @student = @directory['person1']['id']
    @spassword = @directory['person1']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @test1 = @directory['site1']['quiz1']
    
    # Test case variables
    @instructor_comment = "I am very disappointed. :("
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_grade_assessment
    
    # Log in to Sakai as instructor
    workspace = @sakai.page.login(@instructor, @ipassword)
    
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
    score_test.logout
    
    # Log in as the student
    workspace = @sakai.page.login(@student, @spassword)
    
    # Go to the Assessments page
    home = workspace.open_my_site_by_id(@site_id)
    tests = home.tests_and_quizzes
    
    # Click the link to get the feedback
    tests.feedback(@test1)
    
    # TEST CASE: Confirm instructor comment is present on page
    assert_not_equal false, @browser.frame(:index=>1).div(:class=>"portletBody").text=~/#{Regexp.escape(@instructor_comment)}/ 
    
  end
  
end
