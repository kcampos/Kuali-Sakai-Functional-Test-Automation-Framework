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
    @public_res1 = {
      :title=>random_alphanums, 
      :description=>random_string,
      :tags=>random_string,
      :permission=>"Public" }
    @public_res2 = {
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
    @participant_name = "Student One"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_group_searching
    
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
    
    login_page = @sakai.logout
    
    expl_res = login_page.explore_research
    
    expl_res.search_for=@public_res1[:title]
    
    # TEST CASE: Public research project displays while logged out
    assert expl_res.results_list.include?(@public_res1[:title]), "Public Research Project #{@public_res1[:title]} not found in search results:\n\n#{expl_res.results_list.join("\n")}"
    
    expl_res.search_for=@public_res2[:title]
    
    # TEST CASE: Public research support group displays while logged out
    assert expl_res.results_list.include?(@public_res2[:title]), "Public Research Group #{@public_res2[:title]} not found in search results:\n\n#{expl_res.results_list.join("\n")}"
    
    expl_res.search_for=@logged_in_res1[:title]
    
    # TEST CASE: Logged in research project does not display when logged out
    assert_equal false, expl_res.results_list.include?(@logged_in_res1[:title])
    
    expl_res.search_for=@logged_in_res2[:title]
    
    # TEST CASE: Logged in research support group does not display when logged out
    assert_equal false, expl_res.results_list.include?(@logged_in_res2[:title])
    
    expl_res.search_for=@participant_res1[:title]
    
    # TEST CASE: Participant research project does not display when logged out
    assert_equal false, expl_res.results_list.include?(@participant_res1[:title]) 
    
    expl_res.search_for=@participant_res2[:title]
    
    # TEST CASE: Participant research support group does not display when logged out
    assert_equal false, expl_res.results_list.include?(@participant_res2[:title])
    
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@public_res1[:title]
    
    p explore.results_list
    # TEST CASE: Public research project displays when logged in
    assert explore.results_list.include?(@public_res1[:title]), "Public Research Project #{@public_res1[:title]} not found in results list:\n\n#{explore.results_list.join("\n")}"
    
    explore.search_for=@public_res2[:title]
    
    # TEST CASE: Public research support group displays when logged in
    assert explore.results_list.include? @public_res2[:title]
    
    explore.search_for=@logged_in_res1[:title]
    
    # TEST CASE: Logged in research project displays when logged in
    assert explore.results_list.include? @logged_in_res1[:title]
    
    explore.search_for=@logged_in_res2[:title]
    
    # TEST CASE: Logged in research support group displays when logged in
    assert explore.results_list.include? @logged_in_res2[:title]
    
    explore.search_for=@participant_res1[:title]
    
    # TEST CASE: Participant research project displays to participant
    assert explore.results_list.include?(@participant_res1[:title]), "Participant Research Project #{@participant_res1[:title]} not found in search results:\n\n#{explore.results_list.join("\n")}"
    
    explore.search_for=@participant_res2[:title]
    
    # TEST CASE: Participant research project displays to participant
    assert explore.results_list.include? @participant_res2[:title]
    
    login_page = @sakai.logout
    
    dashboard = @sakai.login(@user3, @u3password)
    
    explore = dashboard.explore_groups
    
    explore.search_for=@public_res1[:title]
    
    # TEST CASE: Public research project displays when logged in
    assert explore.results_list.include? @public_res1[:title]
    
    explore.search_for=@public_res2[:title]
    
    # TEST CASE: Public research support group displays when logged in
    assert explore.results_list.include? @public_res2[:title]
    
    explore.search_for=@logged_in_res1[:title]
    
    # TEST CASE: Logged in research project displays when logged in
    assert explore.results_list.include? @logged_in_res1[:title]
    
    explore.search_for=@logged_in_res2[:title]
    
    # TEST CASE: Logged in research support group displays when logged in
    assert explore.results_list.include? @logged_in_res2[:title]
    
    explore.search_for=@participant_res1[:title]
    
    # TEST CASE: Participant research project does not display to non-participant
    assert_equal false, explore.results_list.include?(@participant_res1[:title])
    
    explore.search_for=@participant_res2[:title]
    
    # TEST CASE: Participant research support group does not display to non-participant
    assert_equal false, explore.results_list.include?(@participant_res2[:title])
    
  end
  
end
