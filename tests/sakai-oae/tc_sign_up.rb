#!/usr/bin/env ruby
# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestSignUp < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_sign_up
    
    # Can't do this test case while the page contains a CAPTCHA box.
    
    
  end
  
end
