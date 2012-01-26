# 
# == Synopsis
#
# Tests that the user membership search page returns expected results.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |g| require g }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestUserMembership < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @admin = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @search_name = "joe"
    @full_name = "Joe Instructor"
    @user_id = "instructor1"
    @user_type = "maintain"
    
    @no_results = "No users to display"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_user_membership
    
    # Log in to Sakai
    my_workspace = @sakai.login(@admin, @password)
    
    user_membership = my_workspace.user_membership
    user_membership.search_field=@search_name
    user_membership.search
    
    # TEST CASE: Verify user is displayed in the list.
    assert user_membership.names.include?(@full_name)
    
    # TEST CASE: Verify the user id is correct.
    assert_equal @user_id, user_membership.user_id(@full_name)
    
    # TEST CASE: Verify the user's type is as expected.
    assert_equal @user_type, user_membership.type(@full_name)
    
    user_membership.search_field=random_string(20)
    user_membership.search
    
    # TEST CASE: Verify search page reports no results found
    assert_equal @no_results, user_membership.alert_text
    
  end
  
end
