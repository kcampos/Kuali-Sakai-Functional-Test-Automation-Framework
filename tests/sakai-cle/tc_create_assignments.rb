# 
# == Synopsis
#
# Tests creation of several assignments with various properties
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCreateAssignments < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # Test user is an instructor
    @user_name = config.directory['instructor']['username']
    @password = config.directory['instructor']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_assignments_creation
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to assignments page
    
    # Create a new assignment
    
    # Try to post it
    
    # TEST CASE: Alert appears when submitting without instructions
    
    # Click post again
    
    # TEST CASE: Assignment saves this time
    
    # Create a New Assignment
    
    # Set Dates
    
    # Set inline submission only
    
    #Set Letter Grade
    
    # Set allow resubmission
    
    # Set allow resub number to 1
    
    # Enter assignment instructions
    
    # Add due date
    
    # Save
    
    # TEST CASE: Verify save
    
    # Go to schedule page
    
    # TEST CASE: Verify assignments appear
    
    
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
