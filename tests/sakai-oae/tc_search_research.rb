#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Research Projects and Support Groups.
#
# Creates 3 Research Projects--one for each Permission Setting, then
# tests those permission settings by searching for each Project
# while logged out, and while logged in as a participant and non-participant.
#
# Does the same set of tests for 3 Research Support Groups, as well.
# 
# == Prerequisites:
#
# Three test users (see lines 35-41)
#
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Research Project/Group Membership" do
  
  include Utilities

  let(:explore) { ExploreResearch.new @browser }

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
    @public_res1 = { # Research Project
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Public" }
    @public_res2 = { # Research Support Group
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Public" }
    @logged_in_res1 = {
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Logged in users" }
    @logged_in_res2 = {
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Logged in users" }
    @participant_res1 = {
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Participants only" }
    @participant_res2 = {
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Participants only" }
  end
 
  it "creates 3 research projects and 3 research groups with different join settings" do
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    create_research = dashboard.create_a_research_project
    
    new_research_info = create_research.use_research_project_template

    new_research_info.title=@public_res1[:title]
    new_research_info.description=@public_res1[:description]
    new_research_info.tags=@public_res1[:tags]
    new_research_info.can_be_discovered_by=@public_res1[:permission]
    
    intro = new_research_info.create_research_project
    
    create_research = intro.create_a_research_project
    
    new_research_info = create_research.use_research_project_template
    
    new_research_info.title=@logged_in_res1[:title]
    new_research_info.description=@logged_in_res1[:description]
    new_research_info.tags=@logged_in_res1[:tags]
    new_research_info.can_be_discovered_by=@logged_in_res1[:permission]
    
    intro = new_research_info.create_research_project
    
    create_research = intro.create_a_research_project
    
    new_research_info = create_research.use_research_project_template
    
    new_research_info.title=@participant_res1[:title]
    new_research_info.description=@participant_res1[:description]
    new_research_info.tags=@participant_res1[:tags]
    new_research_info.can_be_discovered_by=@participant_res1[:permission]
    new_research_info.add_people
    new_research_info.add_by_search=@participant_name
    new_research_info.save
    
    intro = new_research_info.create_research_project
    
    create_research = intro.create_a_research_project
    
    new_research_info = create_research.use_research_support_group_template
    
    new_research_info.title=@public_res2[:title]
    new_research_info.description=@public_res2[:description]
    new_research_info.tags=@public_res2[:tags]
    new_research_info.can_be_discovered_by=@public_res2[:permission]
    
    library = new_research_info.create_research_support_group
    
    create_research = library.create_a_research_project
    
    new_research_info = create_research.use_research_support_group_template
    
    new_research_info.title=@logged_in_res2[:title]
    new_research_info.description=@logged_in_res2[:description]
    new_research_info.tags=@logged_in_res2[:tags]
    new_research_info.can_be_discovered_by=@logged_in_res2[:permission]
    
    library = new_research_info.create_research_support_group
    
    create_research = library.create_a_research_project
    
    new_research_info = create_research.use_research_support_group_template
    
    new_research_info.title=@participant_res2[:title]
    new_research_info.description=@participant_res2[:description]
    new_research_info.tags=@participant_res2[:tags]
    new_research_info.can_be_discovered_by=@participant_res2[:permission]
    new_research_info.add_people
    new_research_info.add_by_search=@participant_name
    new_research_info.save
    
    library = new_research_info.create_research_support_group
    
    @sakai.logout
  end
  
  it "Public Research Project can be searched while logged out" do
    login_page = LoginPage.new @browser
    explore = login_page.explore_research
    explore.search_for=@public_res1[:title]
    # TEST CASE: Public research project displays while logged out
    explore.results_list.should include @public_res1[:title]
  end
  
  it "Public Research Group can be searched while logged out" do
    explore.search_for=@public_res2[:title]
    # TEST CASE: Public research support group displays while logged out
    explore.results_list.should include @public_res2[:title]
  end
  
  it "Users-only Research Project can't be searched while logged out" do
    explore.search_for=@logged_in_res1[:title]
    # TEST CASE: Logged in research project does not display when logged out
    explore.results_list.should_not include @logged_in_res1[:title]
  end
  
  it "Users-only Research Group can't be searched while logged out" do
    explore.search_for=@logged_in_res2[:title]
    # TEST CASE: Logged in research support group does not display when logged out
    explore.results_list.should_not include @logged_in_res2[:title]
  end
  
  it "Participants-only Research Project can't be searched while logged out" do
    explore.search_for=@participant_res1[:title]
    # TEST CASE: Participant research project does not display when logged out
    explore.results_list.should_not include @participant_res1[:title]
  end
  
  it "Participants-only Research Group can't be searched while logged out" do
    explore.search_for=@participant_res2[:title]
    # TEST CASE: Participant research support group does not display when logged out
    explore.results_list.include?(@participant_res2[:title])
  end
  
  it "Public Research Project can be searched by non-participant, logged-in user" do
    dashboard = @sakai.login(@participant, @participant_pw)
    explore = dashboard.explore_research
    explore.search_for=@public_res1[:title]
    # TEST CASE: Public research project displays when logged in
    explore.results_list.should include @public_res1[:title]
  end
  
  it "Public Research Group can be searched by non-participant, logged-in user" do
    explore.search_for=@public_res2[:title]
    # TEST CASE: Public research support group displays when logged in
    explore.results_list.should include @public_res2[:title]
  end
  
  it "Users-only Research Project can be searched while logged in" do
    explore.search_for=@logged_in_res1[:title]
    # TEST CASE: Logged in research project displays when logged in
    explore.results_list.should include @logged_in_res1[:title]
  end
  
  it "Users-only Research Group searchable by logged-in non-participant" do
    explore.search_for=@logged_in_res2[:title]
    # TEST CASE: Logged in research support group displays when logged in
    explore.results_list.should include @logged_in_res2[:title]
  end
  
  it "Participants-only Research Project searchable by participant" do
    explore.search_for=@participant_res1[:title]
    # TEST CASE: Participant research project displays to participant
    explore.results_list.should include @participant_res1[:title]
  end
  
  it "Participants-only Research Group searchable by participant" do
    explore.search_for=@participant_res2[:title]
    # TEST CASE: Participant research project displays to participant
    explore.results_list.should include @participant_res2[:title]
    @sakai.logout
  end
  
  it "Participants-only Research Project not searchable by logged-in non-participant" do
    dashboard = @sakai.login(@non_participant, @non_participant_pw)
    explore = dashboard.explore_research
    explore.search_for=@participant_res1[:title]
    # TEST CASE: Participant research project does not display to non-participant
    explore.results_list.should_not include @participant_res1[:title]
  end
  
  it "Participants-only Research Group not searchable by logged-in non-participant" do
    explore.search_for=@participant_res2[:title]
    # TEST CASE: Participant research support group does not display to non-participant
    explore.results_list.should_not include @participant_res2[:title]
  end
 
  after :all do
    # Close the browser window
    @browser.close
  end
   
end
