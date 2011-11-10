# 
# == Synopsis
#
# This is a test case for assessment submission by a student user.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
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
    
    # Test case variables
    @answers = [
      "D",
      "true",
      {:answer=>"Rhode Island", :space=>1},
      "B",
      "Vivamus placerat. Duis tincidunt lacus non magna. Nullam faucibus tortor a nisl.",
      {:answer=>"Queen Anne", :space=>1},
      {:answer=>"Britain", :space=>2},
      {:answer=>"B", :space=>1},
      {:answer=>"A", :space=>2},
      "False",
      "Epistemology is the study of knowledge.",
      "documents/resources.doc",
      {:answer=>"red", :space=>1},
      {:answer=>"blue", :space=>2},
      "c",
      "true"
    ]
    
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
    quiz1.multiple_choice_answer @answers[0]
    quiz1 = quiz1.next
    
    quiz1.true_false_answer @answers[1]
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer(@answers[2][:answer], @answers[2][:space])
    quiz1 = quiz1.next
    
    quiz1.multiple_choice_answer @answers[3]
    quiz1 = quiz1.next
    
    quiz1.short_answer @answers[4]
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer(@answers[5][:answer], @answers[5][:space])
    quiz1.fill_in_blank_answer(@answers[6][:answer], @answers[6][:space])
    quiz1 = quiz1.next
    
    quiz1.match_answer(@answers[7][:answer], @answers[7][:space])
    quiz1.match_answer(@answers[8][:answer], @answers[8][:space])
    quiz1 = quiz1.next
    
    quiz1.true_false_answer @answers[9]
    quiz1.true_false_rationale @answers[10]
    quiz1 = quiz1.next
    
    quiz1.file_answer @answers[11]
    quiz1 = quiz1.next
    
    quiz1.fill_in_blank_answer(@answers[12][:answer], @answers[12][:space])
    quiz1.fill_in_blank_answer(@answers[13][:answer], @answers[13][:space])
    
    # Submit for grading
    confirm = quiz1.submit_for_grading
    
    # TEST CASE: Confirm warning screen contents
    assert_match(/You are about to submit this assessment for grading./, frm.span(:class=>"validation").text)
    
    summary = confirm.submit_for_grading
    
    # TEST CASE: Verify confirmation page contents
    assert_match(/You have completed this assessment./, frm.div(:class=>"portletBody").div(:class=>"tier1").text)
    
    tests = summary.continue
    
    # TEST CASE: Verify test is listed as submitted
    assert tests.submitted_assessments.include?(@test1), "#{@test1} not found in #{tests.submitted_assessments}"
    
    # Take the second test
    
    quiz2 = tests.take_assessment(@test2)
    quiz2.begin_assessment
    
    quiz2.multiple_choice_answer @answers[14]
    quiz2 = quiz2.next
    
    quiz2.true_false_answer @answers[15]
    
    confirm = quiz2.submit_for_grading
    
    summary = confirm.submit_for_grading
    
    tests_lists = summary.continue
    
    # TEST CASE: Verify test is listed as submitted
    assert tests_lists.submitted_assessments.include?(@test2), "#{@test2} not found in #{tests_lists.submitted_assessments}"

    @sakai.logout
    
  end
  
end
