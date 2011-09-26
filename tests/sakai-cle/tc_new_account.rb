# 
# == Synopsis
#
# This is the Sakai-CLE test case template file. Use it as the starting
# point for a new test case.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class NewUserSignUp < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @user_name = config.directory['']['username']
    @password = config.directory['']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_new_sakai_user
    
    # Click New User
    
    # Enter user information
    
    # TEST CASES: Verify errors
    
    # Submit
    
    # TEST CASE: Verify user creation
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
