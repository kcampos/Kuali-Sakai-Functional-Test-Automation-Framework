# 
# == Synopsis
#
# This case tests the creation of two groups and verifies that
# the group names appear correctly on the Groups List page in the
# Site Editor.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestGroups < Test::Unit::TestCase
  
  include Utilities
  
  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @site_name = config.directory['instructor']['site']
    @user_name = config.directory['instructor']['username']
    @password = config.directory['instructor']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_create_groups
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to test Site in Sakai
    @browser.link(:text, @site_name).click
    home = Home.new(@browser)
    
    # Go to the Site Editor page
    home.site_editor
    site_editor = SiteEditor.new(@browser)
    
    # Go to Manage Groups
    site_editor.manage_groups
    
    # This test case creates 2 groups
    2.times do
      #Create a New Group
      group = Groups.new(@browser)
      group.create_new_group
      
      new_group = CreateNewGroup.new(@browser)
      
      # Make a random title for the group
      group_title = random_string(84) + " - " + Time.now.strftime("%Y%m%d%H%M")
      new_group.title=group_title
      
      # Get contents of the Site Member Select list
      # and put those contents into an array
      members = new_group.site_member_list_element.options
      
      # shuffle the array
      members.shuffle!
      
      # Randomly pick the number of group members
      num = rand(members.length)
      
      # Add num Site Members to the new group
      num.times do |x|
        # Select the random Site Member
        new_group.site_member_list=members[x].text
      end
      
      # Click the "right" button to move the name
      # to the Group Members list
      new_group.right
      
      # Save the new group (Click the Add button)
      new_group.add
      sleep 1
      # TEST CASE: Check that the Group Name appears in the Groups List
      assert @browser.text.include?(group_title)
      
    end
    
  end

  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end

end