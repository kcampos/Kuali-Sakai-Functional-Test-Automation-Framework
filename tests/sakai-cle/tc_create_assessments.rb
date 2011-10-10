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
    
    # Go to Tests & Quizzes
    assessments = home.tests_and_quizzes
    
    # Create a new quiz...
    title1 = random_string
    assessments.title=title1
    quiz = assessments.create
    
    # Store the quiz title in the directory.yml for later use
    @config.directory['site1']['quiz1'] = title1 
  
    # Select multiple choice question type
    question1 = quiz.select_question_type "Multiple Choice"
    
    # Set up the question info...
    question1.answer_point_value="5"
    question1.question_text="Who was the first US president?"
    question1.answer_a="Jefferson"
    question1.answer_b="Lincoln"
    question1.answer_c="Grant"
    question1.answer_d="Washington"
    question1.select_d_correct
    question1.feedback_for_correct="Good!"
    question1.feedback_for_incorrect="Bad!"
    
    # Save the question
    quiz = question1.save
    
    # TEST CASE: Verify the question appears on the Edit Assessment page
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:0:number").exist?
    assert quiz.get_question_text(1, 1) =~ /Who was the first US president/
    
    # Add a True/False question
    question2 = quiz.select_question_type "True False"
    
    question2.answer_point_value="5"
    question2.question_text="The sky is blue."
    question2.select_answer_true
    quiz = question2.save
    
    # TEST CASE: Verify the question appears
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:1:number").exist?
    
    # Select fill-in-the-blank question type
    question3 = quiz.select_question_type "Fill in the Blank"
    
    question3.answer_point_value="5"
    question3.question_text="The largest state in the US according to land mass is {Alaska}."
    quiz = question3.save
    
    # Preview the assessment
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
    quiz = question4.save
    
    # Select Short Answer question type
    question5 = quiz.select_question_type "Short Answer/Essay"
    
    question5.answer_point_value="5"
    question5.question_text="Write an essay about something."
    quiz = question5.save
    
    # Add another fill-in-the-blank question
    question6 = quiz.select_question_type "Fill in the Blank"
    
    question6.question_text="After Queen Anne's War, French residents of Acadia were given one year to declare allegiance to {Britain} or leave {Nova Scotia}."
    question6.answer_point_value="5"
    quiz = question6.save
    
    # Select a Matching question type
    question7 = quiz.select_question_type "Matching"
    
    question7.answer_point_value="5"
    question7.question_text="This is a matching question"
    question7.choice="1"
    question7.match="one"
    question7.save_pairing
    question7.choice="2"
    question7.match="two"
    question7.save_pairing
    quiz = question7.save
    
    # Select another True/False question type
    question8 = quiz.select_question_type "True False"
    
    question8.answer_point_value="5"
    question8.question_text="Epistemology is the study of rocks."
    question8.select_answer_false
    question8.select_required_rationale_yes
    question8.feedback_for_correct="Fantastic work!"
    quiz = question8.save
   
    # Add a File Upload question
    question9 = quiz.select_question_type "File Upload"
    
    question9.answer_point_value="5"
    question9.question_text="Upload a file..."
    quiz = question9.save
    
    # Add a part 2 to the assessment
    part = quiz.add_part
    
    part.title="This is Part 2"
    part.information="This is the information for Part 2"
    
    quiz = part.save
    
    # TEST CASE: Verify part 2 appears
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:1:number").exist?
    
    # Add questions to Part 2
    question10 = quiz.insert_question_after(2, 0, "Fill in the Blank")
    
    # New fill-in-the-blank question
    question10.answer_point_value="5"
    question10.question_text="Roses are {red} and violets are {blue}."
    quiz = question10.save
    
    # Go to the Settings page of the Assessment
    settings_page = quiz.settings
    
    settings_page.open
    # Set assessment dates
    settings_page.available_date=((Time.now - 60).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.due_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.retract_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    
    # Set feedback options
    settings_page.select_immediate_feedback
    settings_page.select_both_feedback_levels
    settings_page.select_release_questions_and
    settings_page.check_release_student_response
    settings_page.check_release_correct_response
    settings_page.check_release_students_assessment_scores
    settings_page.check_release_students_question_and_part_scores
    settings_page.check_release_question_level_feedback
    settings_page.check_release_selection_level_feedback
    settings_page.check_release_graders_comments
    settings_page.check_release_statistics
    
    # Set Grading options
    settings_page.select_student_ids_seen
    
    # Set only one submission allowed
    settings_page.select_only_x_submissions
    settings_page.allowed_submissions="1"
    
    # Save and publish the assessment
    assessment = settings_page.save_and_publish
    list_page = assessment.publish

    # TEST CASE: Verify the assessment is published
    assert list_page.get_published_titles.include?(title1), "Can't find #{title1} in published list: #{list_page.get_published_titles}"
    
    # Create a Question Pool
    pools_list = list_page.question_pools
    new_pool = pools_list.add_new_pool
    
    pool_title=random_string
    
    new_pool.pool_name=pool_title
    new_pool.description="Sample Question Pool"
    pools_list = new_pool.save
    
    # TEST CASE: the new pool saved properly
    assert @browser.frame(:index=>1).link(:text=>pool_title).exist?
    
    # Open the Pool to add questions
    pool = pools_list.edit_pool(pool_title)
    
    # Add a multiple choice question
    select_qt = pool.add_question
    
    mc_question = select_qt.select_question_type "Multiple Choice"
    
    mc_question.answer_point_value="5"
    mc_question.question_text="How many licks does it take to get to the center of a Tootsie Roll Pop?"
    mc_question.answer_a="3"
    mc_question.answer_b="20"
    mc_question.answer_c="500"
    mc_question.answer_d="10,000"
    mc_question.select_a_correct
    pool = mc_question.save
    
    # TEST CASE: The new question saved properly
    assert @browser.frame(:index=>1).link(:text=>"How many licks does it take to get to the center of a Tootsie Roll Pop?").exist?
    
    # Add a True/False question
    select_qt = pool.add_question
    
    tfq = select_qt.select_question_type "True False"
    tfq.answer_point_value="10"
    tfq.question_text="The United States of America is in the Northern hemisphere."
    tfq.select_answer_true
    tfq.select_required_rationale_yes
    tfq.feedback_for_correct="Good!"
    pool = tfq.save
    
    pools_list = pool.question_pools
    
    # Import a Question Pool
    import_page = pools_list.import
    import_page.choose_file(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/documents/Exam1.xml")
    pools_list = import_page.import

    # TEST CASE: Verify import worked
    assert @browser.frame(:index=>1).span(:text=>"Exam 1").exist?
    
    # Go to the Assessments page
    assessments = pools_list.assessments
    
    # Create a new Assessment
    title2 = random_string(15)
    assessments.title=title2
    quiz2 = assessments.create
    
    # Store the quiz title in the directory.yml for later use
    @config.directory['site1']['quiz2'] = title2
    
    # Add a multiple-choice question
    mcq = quiz2.select_question_type "Multiple Choice"
    mcq.answer_point_value="5"
    mcq.question_text="Who was the first US President?"
    mcq.answer_a="Jefferson"
    mcq.answer_b="Lincoln"
    mcq.answer_c="Grant"
    mcq.answer_d="Washington"
    mcq.select_d_correct
    mcq.select_randomize_answers_yes
    
    quiz2 = mcq.save
    
    # TEST CASE: Verify question saved...
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:0:number").exist?
    assert(quiz2.get_question_text(1, 1) =~ /^Who was the first US President/, quiz2.get_question_text(1, 1))
    
    # Add a True/False question
    q2 = quiz2.select_question_type "True False"
    q2.question_text="Birds can fly."
    q2.select_answer_true
    
    quiz2 = q2.save
    
    # TEST CASE: Verify the question saved...
    assert quiz2.get_question_text(1, 2) =~ /Birds can fly./
    
    settings_page = quiz2.settings
    settings_page.open
    settings_page.select_student_ids_seen
    settings_page.available_date=((Time.now - 60).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.due_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.retract_date=((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    settings_page.select_only_x_submissions
    settings_page.allowed_submissions="1"
    assessment = settings_page.save_and_publish
    list_page = assessment.publish

    # TEST CASE: Verify assessment published
    assert list_page.get_published_titles.include?(title2), "Can't find #{title2} in published list: #{list_page.get_published_titles}"
    
  end
  
end
