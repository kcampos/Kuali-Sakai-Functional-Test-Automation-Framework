# 
# == Synopsis
#
# This case sets up users in the test site.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-cle/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class CreateUsers < Test::Unit::TestCase

  include Utilities
  
  def setup
    
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
    
    # Get a count of how many users will be added
    count = 1
    while people["person#{count}"] != nil do
      count+=1
    end
    count = count-1
    
    users_page = Users.new(@browser)
    # Add each user to the workspace
    1.upto(count) do |x|
      
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
  
end
