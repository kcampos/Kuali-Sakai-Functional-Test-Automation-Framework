# 
# == Synopsis
#
# This is a test case for assessment submission by a student user.
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestSubmitAssessment < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Log in with student user
    @user_name = @config.directory['person1']['id']
    @password = @config.directory['person1']['password']
    @test1 = @config.directory['site1']['quiz1']
    @test2 = @config.directory['site1']['quiz2']
    # Test site
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    
  end
  
  def test_submit_assessment
    # Log in to Sakai
    workspace = @sakai.login(@user_name, @password)
    
    # Go to test site.
    home = workspace.open_my_site_by_id(@site_id)
    
    # Defining the frame code for ease of
    # step writing...
    def frm
      @browser.frame(:index=>$frame_index)
    end
    
    # Go to Tests & Quizzes
    quiz_list = home.tests_and_quizzes
    
    # Take the first test
    quiz1 = quiz_list.take_assessment(@test1)
    
    # May want to add some test cases here at some point,
    # matching the overview info with what's expected.
    
    quiz1.begin_assessment
    
    # Answer the questions...
    quiz1.multiple_choice_answer "D"
    quiz1 = quiz1.next
    
    quiz1.true_false_answer "true"
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer("Rhode Island", 1)
    quiz1 = quiz1.next
    
    quiz1.multiple_choice_answer "B"
    quiz1 = quiz1.next
    
    quiz1.short_answer "Vivamus placerat. Duis tincidunt lacus non magna. Nullam faucibus tortor a nisl."
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer("Queen Anne", 1)
    quiz1.fill_in_blank_answer("Britain", 2)
    quiz1 = quiz1.next
    
    quiz1.match_answer("B", 1)
    quiz1.match_answer("A", 2)
    quiz1 = quiz1.next
    
    quiz1.true_false_answer "False"
    quiz1.true_false_rationale "Epistemology is the study of knowledge."
    quiz1 = quiz1.next
    
    quiz1.file_answer "documents/resources.doc"
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer("red", 1)
    quiz1.fill_in_blank_answer("blue", 2)
    
    # Submit for grading
    confirm = quiz1.submit_for_grading
    
    # TEST CASE: Confirm warning screen contents
    assert frm.span(:class=>"validation").text =~ /You are about to submit this assessment for grading./
    
    summary = confirm.submit_for_grading
    
    # TEST CASE: Verify confirmation page contents
    assert frm.div(:class=>"portletBody").div(:class=>"tier1").text =~ /You have completed this assessment./
    
    tests = summary.continue
    
    # TEST CASE: Verify test is listed as submitted
    assert tests.submitted_assessments.include?(@test1), "#{@test1} not found in #{tests.submitted_assessments}"
    
    # Take the second test
    
    quiz2 = tests.take_assessment(@test2)
    quiz2.begin_assessment
    
    quiz2.multiple_choice_answer "c"
    quiz2 = quiz2.next
    
    quiz2.true_false_answer "true"
    
    confirm = quiz2.submit_for_grading
    
    summary = confirm.submit_for_grading
    
    tests_lists = summary.continue
    
    # TEST CASE: Verify test is listed as submitted
    assert tests_lists.submitted_assessments.include?(@test2), "#{@test2} not found in #{tests_lists.submitted_assessments}"

    @sakai.logout
    
  end
  
end
