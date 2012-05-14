# 
# == Synopsis
#
# This case tests the creation of two groups and verifies that
# the group names appear correctly on the Groups List page in the
# Site Editor.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestGroups < Test::Unit::TestCase
  
  include Utilities
  
  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Test user is an instructor
    @site_name = @directory['site1']['name']
    @user_name = @directory['person3']['id']
    @password = @directory['person3']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    
    # Save new groups info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/CLE/directory.yml", "w+") { |out|
      YAML::dump(@directory, out)
    }
    
    # Close the browser window
    @browser.close
    
  end
  
  def test_create_groups
    
    # Log in to Sakai
    @sakai.page.login(@user_name, @password)
    
    # Go to test Site in Sakai
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_name(@site_name)
    
    # Go to the Site Editor page
    site_editor = home.site_editor
    
    # Go to Manage Groups
    group = site_editor.manage_groups
    
    # This test case creates 2 groups
    2.times do |x|
      sleep 1
      #Create a New Group
      new_group = group.create_new_group
      
      # Make a random title for the group
      
      group_title = random_string(84) + " - " + Time.now.strftime("%Y%m%d%H%M")
      
      new_group.title=group_title
      
      # Store the title in the config.yml file
      @directory["site1"]["group#{x}"] = group_title
      
      # Get contents of the Site Member Select list
      # and put those contents into an array
      members = new_group.site_member_list_element.options
      
      # shuffle the array
      members.shuffle!
      
      # Randomly pick the number of group members
      num = rand(members.length)
      if num < 2
        num = 2
      end
      # Add num Site Members to the new group
      num.times do |z|
        # Select the random Site Member
        # The "obsolete element error" problem is forcing the use of naked
        # Watir code here...
        @browser.frame(:class=>"portletMainIframe").select(:name=>"siteMembers-selection").select(members[z].text)
        #new_group.site_member_list=members[z].text
        #new_group = CreateNewGroup.new(@browser)
      end
      
      # Click the "right" button to move the name
      # to the Group Members list
      new_group.right
      
      # Save the new group (Click the Add button)
      group = new_group.add
      
      sleep 1 #FIXME
      # TEST CASE: Check that the Group Name appears in the Groups List
      assert @browser.text.include?(group_title)
      
    end
    
  end

end