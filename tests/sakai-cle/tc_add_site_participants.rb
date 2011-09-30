# 
# == Synopsis
#
# Tests the adding of students, instructors, and Guests to an existing Site.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class AddSiteParticipants < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Must log in as admin
    @site_name = @config.directory['course_site']
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_adding_participants
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to Site Setup
    home = Home.new(@browser)
    home.site_setup
    
    # Define the frame for ease of code writing (and reading)
    def frm
      @browser.frame(:index=>0)
    end
    
    # Narrow down and sort the list to easily
    # find the test site
    site_setup = SiteSetup.new(@browser)
    site_setup.view="course Sites"
    2.times{site_setup.sort_by_creation_date}
    
    # Get the site id so that we can check the right checkbox
    frm.link(:text, @site_name).href =~ /(?<=\/site\/).+/
    site_id = $~.to_s
    
    # Check the checkbox
    frm.checkbox(:value, site_id).set
    
    # Edit the site
    site_setup.edit
    
    
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
