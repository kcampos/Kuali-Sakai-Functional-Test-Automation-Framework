# 
# == Synopsis
#
# This case sets up users in the test site.
#
# Author: Abe Heward (aheward@rSmart.com)

require 'yaml'
require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class CreateUsers < Test::Unit::TestCase

  include Utilities
  
  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @user_name = config.directory['admin']['username']
    @password = config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_create_users
 
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    my_workspace = MyWorkspace.new(@browser)
    
    # TEST CASE: Verify you're on the My Workspace page
    assert my_workspace.my_workspace_information_options_element.exist?
    
    # Go to Users page in Sakai
    my_workspace.users
    
    #Hash of user information to use
    people = YAML.load_file("#{File.dirname(__FILE__)}/../../config/directory.yml")
    
    users_page = Users.new(@browser)
    # Add each user to the workspace
    1.upto(13) do |x|
      
      # Create a new user
      users_page.new_user
      create = CreateNewUser.new(@browser)
      create.user_id=people["person#{x}"]['id']
      create.first_name=people["person#{x}"]['firstname']
      create.last_name=people["person#{x}"]['lastname']
      create.email=people["person#{x}"]['email']
      create.create_new_password=people["person#{x}"]['password']
      create.verify_new_password=people["person#{x}"]['password']
      create.type=people["person#{x}"]['type']
      create.save_details
      users_page = Users.new(@browser)
      
      # TEST CASE: Verify that the user has been created
      users_page.search_field=people["person#{x}"]['id']
      users_page.search_button
      assert @browser.frame(:index=>0).link(:text, people["person#{x}"]['id']).exist?
    end 
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end  
  
end
