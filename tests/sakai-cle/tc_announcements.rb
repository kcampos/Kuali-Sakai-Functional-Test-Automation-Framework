# 
# == Synopsis
#
# 
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

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
