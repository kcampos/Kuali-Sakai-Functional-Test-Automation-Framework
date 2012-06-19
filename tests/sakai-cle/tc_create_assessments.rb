# 
# == Synopsis
#
# Test and Quizzes. This script tests creation of new tests.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreateNewAssessments < Test::Unit::TestCase

  include Utilities

  def setup

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Test case uses an instructor user
    @user_name = @directory['person3']['id']
    @password = @directory['person3']['password']
    # Test site
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']

    @assessments = [
        {:title=>random_string},
        {:title=>random_alphanums}#random_xss_string(20)}
    ]

    @questions = [
        {:type=>"Multiple Choice", :point_value=>"5", :question_text=>"Who was the first US president?", :a=>"Jefferson", :b=>"Lincoln", :c=>"Grant", :d=>"Washington", :feedback_correct=>"Good!", :feedback_incorrect=>"Bad!" },
        {:type=>"True False", :point_value=>"5", :question_text=>"The sky is blue."},
        {:type=>"Fill in the Blank", :point_value=>"5", :question_text=>"The largest state in the US according to land mass is {Alaska}." },
        {:type=>"Survey", :question_text=>"Do you find this CLE instance usable?", :feedback=>"Thanks!" },
        {:type=>"Short Answer/Essay", :point_value=>"5", :question_text=>"Write an essay about something." },
        {:type=>"Fill in the Blank", :point_value=>"5", :question_text=>"After Queen Anne's War, French residents of Acadia were given one year to declare allegiance to {Britain} or leave {Nova Scotia}." },
        {:type=>"Matching", :point_value=>"5", :question_text=>"This is a matching question", :choice_one=>"1", :match_one=>"one", :choice_two=>"2", :match_two=>"two" },
        {:type=>"True False", :point_value=>"5", :question_text=>"Epistemology is the study of rocks.", :feedback=>"Fantastic work!" },
        {:type=>"File Upload", :point_value=>"5", :question_text=>"Upload a file..." },
        {:type=>"Fill in the Blank", :point_value=>"5", :question_text=>"Roses are {red} and violets are {blue}." },
        {:type=>"Multiple Choice", :point_value=>"5", :question_text=>"How many licks does it take to get to the center of a Tootsie Roll Pop?", :a=>"3", :b=>"20", :c=>"500", :d=>"10,000" },
        {:type=>"True False", :point_value=>"10", :question_text=>"The United States of America is in the Northern hemisphere.", :feedback=>"Good!" },
        {:type=>"True False", :question_text=>"Birds can fly." }
    ]

    @part_2_title = "This is Part 2"
    @part_2_info = "This is the information for Part 2"

    @settings = {
        :available_date=>((Time.now - 60).strftime("%m/%d/%Y %I:%M:%S %p")),
        :due_date=>((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p")),
        :retract_date=>((Time.now + (86400*3)).strftime("%m/%d/%Y %I:%M:%S %p"))
    }
    @file_path = @config['data_directory']
    @pool_title = random_alphanums
    @pool_description = "Sample Question Pool"
    @pool_file = "documents/Exam1.xml"
    @imported_pool_name = "Exam 1"

    # Store the quiz titles in the directory.yml for later use
    @directory['site1']['quiz1'] = @assessments[0][:title]
    @directory['site1']['quiz2'] = @assessments[1][:title]

    # Validation text -- These contain page content that will be used for
    # test asserts.
    @due_date = "There is no due date for this assessment."
    @time_limit = "There is no time limit."
    @submission_limit = "You can submit this assessment an unlimited number of times. Your highest score will be recorded."
    @feedback_policy = "No feedback will be provided."

  end

  def teardown
    # Save new assessment info for later scripts to use
    File.open("directory.yml", "w+") { |out|
      YAML::dump(@directory, out)
    }
    # Close the browser window
    @browser.close
  end

  def test_create_assessments

    # Log in to Sakai
    workspace = @sakai.page.login(@user_name, @password)

    # Go to test site.
    home = workspace.open_my_site_by_id(@site_id)

    # Go to Tests & Quizzes
    assessments = home.tests_and_quizzes

    # Create a new quiz...
    assessments.title=@assessments[0][:title]
    quiz = assessments.create

    # Select multiple choice question type
    question1 = quiz.select_question_type @questions[0][:type]

    # Set up the question info...
    question1.answer_point_value=@questions[0][:point_value]
    question1.question_text=@questions[0][:question_text]
    question1.answer_a=@questions[0][:a]
    question1.answer_b=@questions[0][:b]
    question1.answer_c=@questions[0][:c]
    question1.answer_d=@questions[0][:d]
    question1.select_d_correct
    question1.feedback_for_correct=@questions[0][:feedback_correct]
    question1.feedback_for_incorrect=@questions[0][:feedback_incorrect]

    # Save the question
    quiz = question1.save

    # TEST CASE: Verify the question appears on the Edit Assessment page
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:0:number").exist?
    assert_not_equal false, quiz.get_question_text(1, 1)=~/#{Regexp.escape(@questions[0][:question_text])}/

    # Add a True/False question
    question2 = quiz.select_question_type @questions[1][:type]

    question2.answer_point_value=@questions[1][:point_value]
    question2.question_text=@questions[1][:question_text]
    question2.select_answer_true
    quiz = question2.save

    # TEST CASE: Verify the question appears
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:1:number").exist?

    # Select fill-in-the-blank question type
    question3 = quiz.select_question_type @questions[2][:type]

    question3.answer_point_value=@questions[2][:point_value]
    question3.question_text=@questions[2][:question_text]
    quiz = question3.save

    # Preview the assessment
    overview = quiz.preview

    #TEST CASE: Verify the preview overview contents
    assert_equal(@due_date, overview.due_date)
    assert_equal(@time_limit, overview.time_limit)
    assert_equal(@submission_limit, overview.submission_limit)
    assert_equal(@feedback_policy, overview.feedback)

    quiz = overview.done

    # Add a Survey question
    question4 = quiz.select_question_type @questions[3][:type]

    question4.question_text=@questions[3][:question_text]
    question4.select_below_above
    question4.feedback=@questions[3][:feedback]
    quiz = question4.save

    # Select Short Answer question type
    question5 = quiz.select_question_type @questions[4][:type]

    question5.answer_point_value=@questions[4][:point_value]
    question5.question_text=@questions[4][:question_text]
    quiz = question5.save

    # Add another fill-in-the-blank question
    question6 = quiz.select_question_type @questions[5][:type]

    question6.question_text=@questions[5][:question_text]
    question6.answer_point_value=@questions[5][:point_value]
    quiz = question6.save

    # Select a Matching question type
    question7 = quiz.select_question_type @questions[6][:type]

    question7.answer_point_value=@questions[6][:point_value]
    question7.question_text=@questions[6][:question_text]
    question7.choice=@questions[6][:choice_one]
    question7.match=@questions[6][:match_one]
    question7.save_pairing
    question7.choice=@questions[6][:choice_one]
    question7.match=@questions[6][:match_one]
    question7.save_pairing
    quiz = question7.save

    # Select another True/False question type
    question8 = quiz.select_question_type @questions[7][:type]

    question8.answer_point_value=@questions[7][:point_value]
    question8.question_text=@questions[7][:question_text]
    question8.select_answer_false
    question8.select_required_rationale_yes
    question8.feedback_for_correct=@questions[7][:feedback]
    quiz = question8.save

    # Add a File Upload question
    question9 = quiz.select_question_type @questions[8][:type]

    question9.answer_point_value=@questions[8][:point_value]
    question9.question_text=@questions[8][:question_text]
    quiz = question9.save

    # Add a part 2 to the assessment
    part = quiz.add_part

    part.title=@part_2_title
    part.information=@part_2_info

    quiz = part.save

    # TEST CASE: Verify part 2 appears
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:1:number").exist?

    # Add questions to Part 2
    question10 = quiz.insert_question_after(2, 0, @questions[9][:type])

    # New fill-in-the-blank question
    question10.answer_point_value=@questions[9][:point_value]
    question10.question_text=@questions[9][:question_text]
    quiz = question10.save

    # Go to the Settings page of the Assessment
    settings_page = quiz.settings

    settings_page.open
    # Set assessment dates
    settings_page.available_date=@settings[:available_date]
    settings_page.due_date=@settings[:due_date]
    settings_page.retract_date=@settings[:retract_date]

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
    assert list_page.published_assessment_titles.include?(@assessments[0][:title]), "Can't find #{@assessments[0][:title]} in published list: #{list_page.published_assessment_titles}"

    # Create a Question Pool
    pools_list = list_page.question_pools
    new_pool = pools_list.add_new_pool

    new_pool.pool_name=@pool_title
    new_pool.description=@pool_description
    pools_list = new_pool.save

    # TEST CASE: the new pool saved properly
    assert @browser.frame(:index=>1).link(:text=>@pool_title).exist?

    # Open the Pool to add questions
    pool = pools_list.edit_pool(@pool_title)

    # Add a multiple choice question
    select_qt = pool.add_question

    mc_question = select_qt.select_question_type @questions[10][:type]

    mc_question.answer_point_value=@questions[10][:point_value]
    mc_question.question_text=@questions[10][:question_text]
    mc_question.answer_a=@questions[10][:a]
    mc_question.answer_b=@questions[10][:b]
    mc_question.answer_c=@questions[10][:c]
    mc_question.answer_d=@questions[10][:d]
    mc_question.select_a_correct
    pool = mc_question.save

    # TEST CASE: The new question saved properly
    assert @browser.frame(:index=>1).link(:text=>@questions[10][:question_text]).exist?

    # Add a True/False question
    select_qt = pool.add_question

    tfq = select_qt.select_question_type @questions[11][:type]
    tfq.answer_point_value=@questions[11][:point_value]
    tfq.question_text=@questions[11][:question_text]
    tfq.select_answer_true
    tfq.select_required_rationale_yes
    tfq.feedback_for_correct=@questions[11][:feedback]
    pool = tfq.save

    pools_list = pool.question_pools

    # Import a Question Pool
    import_page = pools_list.import
    import_page.choose_file(@pool_file, @file_path)
    pools_list = import_page.import

    # TEST CASE: Verify import worked
    assert @browser.frame(:index=>1).span(:text=>@imported_pool_name).exist?

    # Go to the Assessments page
    assessments = pools_list.assessments

    # Create a new Assessment
    assessments.title=@assessments[1][:title]
    quiz2 = assessments.create

    # Add a multiple-choice question
    mcq = quiz2.select_question_type @questions[0][:type]
    mcq.answer_point_value=@questions[0][:point_value]
    mcq.question_text=@questions[0][:question_text]
    mcq.answer_a=@questions[0][:a]
    mcq.answer_b=@questions[0][:b]
    mcq.answer_c=@questions[0][:c]
    mcq.answer_d=@questions[0][:d]
    mcq.select_d_correct
    mcq.select_randomize_answers_yes

    quiz2 = mcq.save

    # TEST CASE: Verify question saved...
    assert @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:0:parts:0:number").exist?
    assert_not_equal false, quiz2.get_question_text(1, 1)=~/#{Regexp.escape(@questions[0][:question_text])}/

    # Add a True/False question
    q2 = quiz2.select_question_type @questions[12][:type]
    q2.question_text=@questions[12][:question_text]
    q2.select_answer_true

    quiz2 = q2.save

    # TEST CASE: Verify the question saved...
    assert_not_equal false, quiz2.get_question_text(1, 2)=~/#{Regexp.escape(@questions[12][:question_text])}/

    settings_page = quiz2.settings
    settings_page.open
    settings_page.select_student_ids_seen
    settings_page.available_date=@settings[:available_date]
    settings_page.due_date=@settings[:due_date]
    settings_page.retract_date=@settings[:retract_date]
    settings_page.select_only_x_submissions
    settings_page.allowed_submissions="1"
    assessment = settings_page.save_and_publish
    list_page = assessment.publish

    # TEST CASE: Verify assessment published
    assert list_page.published_assessment_titles.include?(@assessments[1][:title]), "Can't find #{@assessments[1][:title]} in published list: #{list_page.published_assessment_titles}"

  end

end