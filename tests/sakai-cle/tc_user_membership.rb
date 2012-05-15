# 
# == Synopsis
#
# Tests that the user membership search page returns expected results.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestUserMembership < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @admin = @directory['admin']['username']
    @password = @directory['admin']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @search_name = "joe"
    @full_name = "Joel Instructor"
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
    my_workspace = @sakai.page.login(@admin, @password)
    
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
