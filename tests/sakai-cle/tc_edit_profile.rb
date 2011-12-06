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
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestUpdatingUserProfile < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @student = @config.directory['person5']['id']
    @password = @config.directory['person5']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables...
    @first_name = random_string
    @last_name = random_string
    @nickname = random_string
    @position = random_string
    @picture_file = "images/pic_1mb.JPG"
    @email = random_nicelink + "@" + random_nicelink + "." + random_alphanums(3)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_updating_user_profile
    
    # Log in to Sakai
    workspace = @sakai.login(@student, @password)
    
    profile = workspace.profile
    
    edit = profile.edit_my_profile
    edit.first_name=@first_name
    edit.last_name=@last_name
    edit.nickname=@nickname
    edit.position=@position
    edit.select_upload_new_picture
    edit.picture_file=@picture_file
    edit.email=@email
    
    profile = edit.save
    
    # TEST CASE: picture uploaded
    assert_equal get_filename(@picture_file).downcase, profile.photo.downcase, "#{profile.photo}"
    
    # TEST CASE: Profile email displays
    assert_equal @email, profile.email
    
  end
  
end
