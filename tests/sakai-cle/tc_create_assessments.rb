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
    home.tests_and_quizzes
    
    make_new_quiz = AssessmentsList.new(@browser)
    
    # Create a new quiz...
    make_new_quiz.title=random_string
    
    make_new_quiz.select_create_using_text
    
    sleep 10
    
    make_new_quiz.create
    
    # Select multiple choice question type
    quiz = EditAssessment.new(@browser)
    quiz.select_question_type="Multiple Choice"
    
    # Create the multiple choice question
    question1 = MultipleChoice.new(@browser)
    
    # Set up the question info...
    #question1.answer_point_value="5"
    
    sleep 10
    
  end
  
end
