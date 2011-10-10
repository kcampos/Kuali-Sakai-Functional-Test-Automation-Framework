# 
# == Synopsis
#
# Test case for grading a submitted assignment and
# verifying the student can see the feedback.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

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
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_grade_assessment
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Log in to Sakai as instructor
    @sakai.login(@instructor, @ipassword)
    
    # Go to test site.
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    
    # Score the first test
    test_list = home.tests_and_quizzes
    
    score_test = test_list.score_test(@test1)
    
    # Enter feedback
    score_test.comment_for_student(@student, "I am very disappointed. :(")
    
    # Save the feedback
    score_test = score_test.update
    
    # Go back to the Assessments list
    score_test.assessments
    
    # Log out
    @sakai.logout
    
    # Log in as the student
    @sakai.login(@student, @spassword)
    
    # Go to the Assessments page
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    tests = home.tests_and_quizzes
    
    # Click the link to get the feedback
    tests.feedback(@test1)
    
    # TEST CASE: Confirm instructor comment is present on page
    assert frm.div(:class=>"portletBody").text =~ /I am very disappointed/
    
  end
  
end
