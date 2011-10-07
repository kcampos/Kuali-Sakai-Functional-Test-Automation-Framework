# 
# == Synopsis
#
# Test and Quizzes. This script tests creation of new tests.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCreateNewAssessments < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test case uses an instructor user
    @user_name = @config.directory['person3']['id']
    @password = @config.directory['person3']['password']
    # Test site
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Save new assessment info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/directory.yml", "w+") { |out|
      YAML::dump(@config.directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_create_assessments
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to test site.
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    
    # Define the frame for ease of code writing (and reading)
    def frm
      @browser.frame(:index=>1)
    end
    
    # Go to Tests & Quizzes
    assessments = home.tests_and_quizzes
    
    # Create a new quiz...
    assessments.title=random_string
    assessments.create
    
    # Select multiple choice question type
    quiz = EditAssessment.new(@browser)
    question1 = quiz.select_question_type "Multiple Choice"
    
    # Set up the question info...
    question1.answer_point_value="5"
    question1.question_text="Who was the first US president?"
    question1.a_text="Jefferson"
    question1.b_text="Lincoln"
    question1.c_text="Grant"
    question1.d_text="Washington"
    question1.select_d_correct
    question1.feedback_for_correct="Good!"
    question1.feedback_for_incorrect="Bad!"
    
    # Save the question
    # Note this is an explicit call to the object due to
    # a bug causing the page cache to fail on this button
    # inexplicably
    frm.button(:value=>"Save").click
    
    # TEST CASE: Verify the question appears on the Edit Assessment page
    # assert()
    
    # Add a True/False question
    quiz = EditAssessment.new(@browser)
    question2 = quiz.select_question_type "True False"
    
    question2.answer_point_value="5"
    question2.question_text="The sky is blue."
    question2.select_answer_true
    frm.button(:value=>"Save").click
    
    # TEST CASE: Verify the question appears
    # assert()
    
    # Select fill-in-the-blank question type
    quiz = EditAssessment.new(@browser)
    question3 = quiz.select_question_type "Fill in the Blank"
    
    question3.answer_point_value="5"
    question3.question_text="The largest state in the US according to land mass is {Alaska}."
    frm.button(:value=>"Save").click
    
    # Preview the assessment
    quiz = EditAssessment.new(@browser)
    
    overview = quiz.preview
    
    #TEST CASE: Verify the preview overview contents
    assert_equal("There is no due date for this assessment.", overview.due_date)
    assert_equal("There is no time limit.", overview.time_limit)
    assert_equal("You can submit this assessment an unlimited number of times. Your highest score will be recorded.", overview.submission_limit)
    assert_equal("No feedback will be provided.", overview.feedback)
    
    quiz = overview.done
    
    # Add a Survey question
    question4 = quiz.select_question_type "Survey"
    
    question4.question_text="Do you find this CLE instance usable?"
    question4.select_below_above
    question4.feedback="Thanks!"
    frm.button(:value=>"Save").click
    
    # Select Short Answer question type
    quiz = EditAssessment.new(@browser)
    question5 = quiz.select_question_type "Short Answer/Essay"
    
    question5.answer_point_value="5"
    question5.question_text="Write an essay about something."
    frm.button(:value=>"Save").click
    
    # Add another fill-in-the-blank question
    quiz = EditAssessment.new(@browser)
    question6 = quiz.select_question_type "Fill in the Blank"
    
    question6.question_text="After Queen Anne's War, French residents of Acadia were given one year to declare allegiance to {Britain} or leave {Nova Scotia}."
    question6.answer_point_value="5"
    frm.button(:value=>"Save").click
    
    # Select a Matching question type
    quiz = EditAssessment.new(@browser)
    question7 = quiz.select_question_type "Matching"
    
    question7.answer_point_value="5"
    question7.question_text="This is a matching question"
    question7.choice="1"
    question7.match="one"
    question7.save_pairing
    question7.choice="2"
    question7.match="two"
    question7.save_pairing
    frm.button(:value=>"Save").click
    
    # Select another True/False question type
    quiz = EditAssessment.new(@browser)
    question8 = quiz.select_question_type "True False"
    
    question8.answer_point_value="5"
    question8.question_text="Epistemology is the study of rocks."
    question8.select_answer_false
    question8.select_required_rationale_yes
    question8.feedback_for_correct="Fantastic work!"
    frm.button(:value=>"Save").click
    
    # Add a File Upload question
    quiz = EditAssessment.new(@browser)
    question9 = quiz.select_question_type "File Upload"
    
    question9.answer_point_value="5"
    question9.question_text="Upload a file..."
    frm.button(:value=>"Save").click
    
    # Add a part 2 to the assessment
    quiz = EditAssessment.new(@browser)
    part = quiz.add_part
    
    part.title="This is Part 2"
    part.information="This is the information for Part 2"
    
    quiz = part.save
    
    # Add questions to Part 2
    question10 = quiz.insert_question_after(2, 0, "Fill in the Blank")
    
    # New fill-in-the-blank question
    question10.answer_point_value="5"
    question10.question_text="Roses are {red} and violets are {blue}."
    frm.button(:value=>"Save").click
    
    # Go to the Settings page of the Assessment
    quiz = EditAssessment.new(@browser)
    settings_page = quiz.settings
    
    sleep 10
    
    settings_page.open
    # Set assessment dates
    settings_page.available_date=(Time.now.strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.due_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.retract_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    
    # Set Grading options
    settings_page.select_anonymous_grading
    
    # Set only one submission allowed
    settings_page.select_only_x_submissions
    settings_page.allowed_submissions="1"
    
    # Save and publish the assessment
    assessment = settings_page.save_and_publish
    list_page = assessment.publish
    
    # Create a Question Pool
    list_page.question_pools
    
    pools_list = QuestionPoolsList.new(@browser)
    pools_list.add_new_pool
    
    new_pool = AddQuestionPool.new(@browser)
    
    pool_title=random_string
    
    new_pool.pool_name=pool_title
    new_pool.description="Sample Question Pool"
    pools_list = new_pool.save
    
    # Open the Pool to add questions
    
    pool_1 = pools_list.edit_pool(pool_title)
    
    # Add a multiple choice question
    select_qt = pool_1.add_question
    mc_question = select_qt.select_question_type "Multiple Choice"
    
    mc_question.answer_point_value="5"
    mc_question.question_text="How many licks does it take to get to the center of a Tootsie Roll Pop?"
    mc_question.a_text="3"
    mc_question.b_text="20"
    mc_question.c_text="500"
    mc_question.d_text="10,000"
    mc_question.select_a_correct
    mc_question.save
    
    
    
    sleep 10
    
  end
  
end
