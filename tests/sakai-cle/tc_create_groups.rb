# 
# == Synopsis
#
# This case tests the creation of two groups and verifies that
# the group names appear correctly on the Groups List page in the
# Site Editor.
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestGroups < Test::Unit::TestCase
  
  include Utilities
  
  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user is an instructor
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @user_name = @config.directory['person3']['id']
    @password = @config.directory['person3']['password']
    @sakai = SakaiCLE.new(@browser)
    
    
  end
  
  def teardown
    # Save new groups info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/directory.yml", "w+") { |out|
      YAML::dump(@config.directory, out)
    }
    
    # Close the browser window
    @browser.close
    
  end
  
  def test_create_groups
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to test Site in Sakai
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to the Site Editor page
    site_editor = home.site_editor
    
    # Go to Manage Groups
    group = site_editor.manage_groups
    
    # This test case creates 2 groups
    2.times do |x|
      
      #Create a New Group
      new_group = group.create_new_group
      
      # Make a random title for the group
      
      group_title = random_string(84) + " - " + Time.now.strftime("%Y%m%d%H%M")
      
      new_group.title=group_title
      
      # Store the title in the config.yml file
      @config.directory["site1"]["group#{x}"] = group_title
      
      # Get contents of the Site Member Select list
      # and put those contents into an array
      members = new_group.site_member_list_element.options
      
      # shuffle the array
      members.shuffle!
      
      # Randomly pick the number of group members
      num = rand(members.length)
      
      # Add num Site Members to the new group
      num.times do |z|
        # Select the random Site Member
        new_group.site_member_list=members[z].text
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