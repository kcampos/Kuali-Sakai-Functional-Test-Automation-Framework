# 
# == Synopsis
#
# This is a test case for assessment submission by a student user.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestSubmitAssessment < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Log in with student user
    @user_name = @config.directory['person13']['id']
    @password = @config.directory['person13']['password']
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
    @sakai.login(@user_name, @password)
    
    # Go to test site.
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    
    # Defining the frame code for ease of
    # step writing...
    def frm
      @browser.frame(:index=>1)
    end
    
    # Go to Tests & Quizzes
    quiz_list = home.tests_and_quizzes
    
    # Take the first test
    quiz1 = quiz_list.take_assessment(@test1)
    
    # May want to add some test cases here at some point,
    # matching the overview info with what's expected.
    
    quiz1.begin_assessment
    
    # Going to have to spend some time thinking about
    # ways to abstract this later. Unfortunately, right
    # now it doesn't look possible--at least in a way
    # that will have flexibility.
    
    # Answer the questions...
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverMultipleChoiceSingleCorrect:_id733:3:_id736").set
    frm.button(:value=>"Next").click
    
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverTrueFalse:_id1075:0:question").set
    frm.button(:value=>"Next").click
    
    frm.text_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFillInTheBlank:_id506:0:_id509").value="Rhode Island"
    frm.button(:value=>"Next").click
    
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverMultipleChoiceSingleCorrect:_id733:1:_id736").set
    frm.button(:value=>"Next").click
    
    frm.text_field(:id=>"takeAssessmentForm:_id48:0:_id105:0:deliverShortAnswer:_id972_textinput").value="Vivamus placerat. Duis tincidunt lacus non magna. Nullam faucibus tortor a nisl."
    frm.button(:value=>"Next").click
    
    frm.text_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFillInTheBlank:_id506:0:_id509").value="Queen Anne"
    frm.text_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFillInTheBlank:_id506:1:_id509").value="Britain"
    frm.button(:value=>"Next").click
    
    frm.select(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverMatching:_id613:0:_id616").select("B")
    frm.select(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverMatching:_id613:1:_id616").select("A")
    frm.button(:value=>"Next").click
    
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverTrueFalse:_id1075:0:question").set
    frm.text_field(:id=>"takeAssessmentForm:_id48:0:_id105:0:deliverTrueFalse:rationale").value="Epistemology is the study of knowledge."
    frm.button(:value=>"Next").click
    
    frm.file_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFileUpload:_id284.upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/documents/resources.doc")
    frm.button(:value=>"Next").click
    
    frm.text_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFillInTheBlank:_id506:0:_id509").set("red")
    frm.text_field(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverFillInTheBlank:_id506:1:_id509").set("blue")
    
    # Submit for grading
    frm.button(:value=>"Submit for Grading").click
    
    # TEST CASE: Confirm warning screen contents
    assert frm.span(:class=>"validation").text =~ /You are about to submit this assessment for grading./
    
    frm.button(:value=>"Submit for Grading").click
    
    # TEST CASE: Verify confirmation page contents
    assert frm.div(:class=>"portletBody").div(:class=>"tier1").text =~ /You have completed this assessment./
    
    frm.button(:value=>"Continue").click
    
    # TEST CASE: Verify test is listed as submitted
    assert frm.table(:id=>"selectIndexForm:reviewTable").text.include?(Regexp.escape(@test1))
    
    # Take the second test
    
    list_page = TakeAssessmentList.new(@browser)
    quiz2 = list_page.take_assessment(@test2)
    quiz2.begin_assessment
    
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverMultipleChoiceSingleCorrect:_id733:2:_id736").set
    frm.button(:value=>"Next").click
    
    frm.radio(:name=>"takeAssessmentForm:_id48:0:_id105:0:deliverTrueFalse:_id1075:0:question").set
    frm.button(:value=>"Submit for Grading").click
    
    frm.button(:value=>"Submit for Grading").click
    
    # TEST CASE: Verify test is listed as submitted
    assert frm.table(:id=>"selectIndexForm:reviewTable").text.include?(Regexp.escape(@test2))
    
    @sakai.logout
    
  end
  
end
