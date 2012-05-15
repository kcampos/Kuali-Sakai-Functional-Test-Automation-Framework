# 
# == Synopsis
#
# This case sets up users in the test site.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class CreateUsers < Test::Unit::TestCase

  include Utilities
  
  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @user_name = @directory['admin']['username']
    @password = @directory['admin']['password']
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_users
 
    # Log in to Sakai
    my_workspace = @sakai.page.login(@user_name, @password)
    
    # TEST CASE: Verify you're on the My Workspace page
    assert my_workspace.my_workspace_information_options_element.exists?
    
    # Go to Users page in Sakai
    my_workspace.users
    
    # Get a count of how many users will be added
    count = 1
    while @directory["person#{count}"] != nil do
      count+=1
    end
    count = count-1
    
    users_page = Users.new(@browser)
    # Add each user to the workspace
    1.upto(count) do |x|
      
      # Create a new user
      users_page.new_user
      create = CreateNewUser.new(@browser)
      create.user_id=@directory["person#{x}"]['id']
      create.first_name=@directory["person#{x}"]['firstname']
      create.last_name=@directory["person#{x}"]['lastname']
      create.email=@directory["person#{x}"]['email']
      create.create_new_password=@directory["person#{x}"]['password']
      create.verify_new_password=@directory["person#{x}"]['password']
      create.type=@directory["person#{x}"]['type']
      create.save_details
      users_page = Users.new(@browser)
      
      # TEST CASE: Verify that the user has been created
      users_page.search_field=people["person#{x}"]['id']
      users_page.search_button
      assert @browser.frame(:index=>0).link(:text, people["person#{x}"]['id']).exist?
    end 
  end
  
end
