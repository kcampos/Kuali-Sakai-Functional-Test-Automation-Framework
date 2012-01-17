#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Groups.
#
# Creates 3 Groups--one for each Permission setting, then
# tests those permission settings by searching for each Group
# while logged out, and while logged in as a participant and non-participant.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestGroupVisibility < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['id']
    @u2password = @config.directory['person1']['password']
    @user3 = @config.directory['person2']['id']
    @u3password = @config.directory['person2']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @public_group = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Public"
    }
    
    @logged_in_group = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Logged in users"
    }
    
    @participant_group = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Participants only"
    }
    
    @participant_name = "Student One"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_group_searching
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    new_group_info = dashboard.create_a_group
    
    new_group_info.title=@public_group[:title]
    new_group_info.description=@public_group[:description]
    new_group_info.tags=@public_group[:tags]
    new_group_info.can_be_discovered_by=@public_group[:permission]
    
    library = new_group_info.create_simple_group
    
    new_group_info = library.create_a_group
    
    new_group_info.title=@logged_in_group[:title]
    new_group_info.description=@logged_in_group[:description]
    new_group_info.tags=@logged_in_group[:tags]
    new_group_info.can_be_discovered_by=@logged_in_group[:permission]
    
    library = new_group_info.create_simple_group
    
    new_group_info = library.create_a_group

    new_group_info.title=@participant_group[:title]
    new_group_info.description=@participant_group[:description]
    new_group_info.tags=@participant_group[:tags]
    new_group_info.can_be_discovered_by=@participant_group[:permission]
    
    library = new_group_info.create_simple_group
    
    library.manage_participants
    library.add_by_search=@participant_name
    library.apply_and_save
    
    login_page = @sakai.logout
    
    expl_group = login_page.explore_groups
    
    expl_group.search_for=@public_group[:title]
    
    # TEST CASE: Public group displays while logged out
    assert expl_group.results_list.include?(@public_group[:title]), "#{@public_group[:title]} not found in:\n\n#{expl_group.results_list.join("\n")}"
    
    expl_group.search_for=@logged_in_group[:title]
    
    # TEST CASE: Logged in group does not display when logged out
    assert_equal false, expl_group.results_list.include?(@logged_in_group[:title])
    
    expl_group.search_for=@participant_group[:title]
    
    # TEST CASE: Participant Course does not display when logged out
    assert_equal false, expl_group.results_list.include?(@participant_group[:title])
    
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@public_group[:title]
    
    # TEST CASE: Public group displays when logged in
    assert explore.results_list.include? @public_group[:title]
    
    explore.search_for=@logged_in_group[:title]
    
    # TEST CASE: Logged in group displays when logged in
    assert explore.results_list.include? @logged_in_group[:title]
    
    explore.search_for=@participant_group[:title]
    
    # TEST CASE: Participant group displays to participant
    assert explore.results_list.include? @participant_group[:title]
    
    login_page = @sakai.logout
    
    dashboard = @sakai.login(@user3, @u3password)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@public_group[:title]
    
    # TEST CASE: Public group displays when logged in
    assert explore.results_list.include? @public_group[:title]
    
    explore.search_for=@logged_in_group[:title]
    
    # TEST CASE: Logged in group displays when logged in
    assert explore.results_list.include? @logged_in_group[:title]
    
    explore.search_for=@participant_group[:title]
    
    # TEST CASE: Participant group does not display to non-participant
    assert_equal false, explore.results_list.include?(@participant_group[:title])
    
  end
  
end
