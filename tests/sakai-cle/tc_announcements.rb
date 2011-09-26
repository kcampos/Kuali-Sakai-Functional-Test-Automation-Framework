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

class }}name{{ < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # This is an instructor test case
    @user_name = config.directory['']['username']
    @password = config.directory['']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_))casename((
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to test site
    
    # Go to Announcements page
    
    # Add an announcement
    
    # TEST CASE: Verify required fields
    
    
    
    # Add a second announcement
    
    # Add an attachment
    
    # Restrict announcement to a Group
    
    # Add an announcement
    
    # set Hidden?
    
    # TEST CASE: Verify announcements created
    
    # Add an announcement
    
    # Attach a copy?
    
    # Verify alert message
    
    # Log out
    
    # Search public courses
    
    # Verify Announcement 5 is viewable
    
    # Log in as instructor
    
    # Edit Announcement 3
    
    # See Selenium script for further details
    
    
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
