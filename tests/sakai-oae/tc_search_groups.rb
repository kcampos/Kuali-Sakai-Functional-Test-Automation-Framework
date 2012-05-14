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
# == Prerequisites:
#
# Three test users (see lines 30-36)
#
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae-test-api'

describe "Group Membership" do
  
  include Utilities
  
  let(:explore) { ExploreGroups.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @participant = @config.directory['person5']['id']
    @participant_pw = @config.directory['person5']['password']
    @participant_name = "#{@config.directory['person5']['firstname']} #{@config.directory['person5']['lastname']}"
    @non_participant = @config.directory['person6']['id']
    @non_participant_pw = @config.directory['person6']['password']
    
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
  end

  it "creates 3 groups with different join settings" do
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
    
    @sakai.logout
  end
  
  it "Public Group can be found while logged out" do
    login_page = LoginPage.new @browser
    expl_group = login_page.explore_groups
    expl_group.search_for=@public_group[:title]
    # TEST CASE: Public group displays while logged out
    expl_group.results_list.should include @public_group[:title]
  end
  
  it "Users-only Group can't be searched while logged out" do
    explore.search_for=@logged_in_group[:title]
    
    # TEST CASE: Logged in group does not display when logged out
    explore.results_list.should_not include @logged_in_group[:title]
  end
  
  it "Participants-only course can't be found in search while logged out" do
    explore.search_for=@participant_group[:title]
    
    # TEST CASE: Participant Course does not display when logged out
    explore.results_list.should_not include @participant_group[:title]
  end
  
  it "Public Group can be found by a logged-in non-participant" do
    dashboard = @sakai.login(@participant, @participant_pw)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@public_group[:title]
    
    # TEST CASE: Public group displays when logged in
    explore.results_list.should include @public_group[:title]
  end
  
  it "Users-only Group can be found by a logged-in, non-participant user" do
    explore.search_for=@logged_in_group[:title]
    
    # TEST CASE: Logged in group displays when logged in
    explore.results_list.should include @logged_in_group[:title]
  end
  
  it "Participants-only Group can be found by a logged-in participant user" do
    explore.search_for=@participant_group[:title]
    
    # TEST CASE: Participant group displays to participant
    explore.results_list.should include @participant_group[:title]
    
    @sakai.logout
  end
  
  it "Participants-only Group cannot be found by a logged-in non-participant user" do
    dashboard = @sakai.login(@non_participant, @non_participant_pw)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@participant_group[:title]
    
    # TEST CASE: Participant group does not display to non-participant
    explore.results_list.should_not include @participant_group[:title]
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end
     
end
