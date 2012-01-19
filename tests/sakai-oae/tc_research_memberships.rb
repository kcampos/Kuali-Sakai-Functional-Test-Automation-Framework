#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Courses.
#
# Creates 3 Research Projects--one for each Membership setting, then
# tests that a non-manager of those projects has appropriate options
# available for joining, and that those options work as expected.
#
# It does the same set of tests for research groups, as well.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestGroupMemberships < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['id']
    @u2password = @config.directory['person1']['password']
    @student_name = "Student One"
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @auto_res1 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, auto-join",
      :membership=>"People can automatically join"
    }
    @request_res1 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, by-request",
      :membership=>"People request to join"
    }
    @managers_res1 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, managers-only",
      :membership=>"Managers add people"
    }
    @auto_res2 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, auto-join",
      :membership=>"People can automatically join"
    }
    @request_res2 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, by-request",
      :membership=>"People request to join"
    }
    @managers_res2 = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, managers-only",
      :membership=>"Managers add people"
    }

    @join_notification = "Group membership\nYou have successfully been added to the group."
    @request_notification = "Group membership\nYour request has successfully been sent to the group's managers."
    
    @email_subject_prefix = "#{@student_name} has requested to join your group "
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_group_memberships
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    project = dashboard.create_a_research_project
    
    new_project_info = project.use_research_project_template
    new_project_info.title=@auto_res1[:title]
    new_project_info.description=@auto_res1[:description]
    new_project_info.tags=@auto_res1[:tags]
    new_project_info.membership=@auto_res1[:membership]

    library = new_project_info.create_research_project
    
    project = library.create_a_research_project
    new_project_info = project.use_research_project_template
    new_project_info.title=@request_res1[:title]
    new_project_info.description=@request_res1[:description]
    new_project_info.tags=@request_res1[:tags]
    new_project_info.membership=@request_res1[:membership]
    
    library = new_project_info.create_research_project
    
    project = library.create_a_research_project
    new_project_info = project.use_research_project_template
    new_project_info.title=@managers_res1[:title]
    new_project_info.description=@managers_res1[:description]
    new_project_info.tags=@managers_res1[:tags]
    new_project_info.membership=@managers_res1[:membership]

    library = new_project_info.create_research_project
    
    project = library.create_a_research_project
    new_project_info = project.use_research_support_group_template
    new_project_info.title=@auto_res2[:title]
    new_project_info.description=@auto_res2[:description]
    new_project_info.tags=@auto_res2[:tags]
    new_project_info.membership=@auto_res2[:membership]

    library = new_project_info.create_research_support_group
    
    project = library.create_a_research_project
    new_project_info = project.use_research_support_group_template
    new_project_info.title=@request_res2[:title]
    new_project_info.description=@request_res2[:description]
    new_project_info.tags=@request_res2[:tags]
    new_project_info.membership=@request_res2[:membership]
    
    library = new_project_info.create_research_support_group
    
    project = library.create_a_research_project
    new_project_info = project.use_research_support_group_template
    new_project_info.title=@managers_res2[:title]
    new_project_info.description=@managers_res2[:description]
    new_project_info.tags=@managers_res2[:tags]
    new_project_info.membership=@managers_res2[:membership]

    library = new_project_info.create_research_support_group
    
    @sakai.logout
    
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_research
    explore.search=@managers_res1[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    project = explore.open_research @managers_res1[:title]

    # TEST CASE: Verify "Managers Add" Course does not show buttons to join
    assert project.join_group_button_element.exists?
    assert_equal false, project.join_group_button_element.visible?
    assert_equal false, project.request_to_join_group_button_element.visible?
    
    explore = project.explore_research
    explore.search=@managers_res2[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    research_group = explore.open_group @managers_res2[:title]

    # TEST CASE: Verify "Managers Add" Course does not show buttons to join
    assert research_group.join_group_button_element.exists?
    assert_equal false, research_group.join_group_button_element.visible?
    assert_equal false, research_group.request_to_join_group_button_element.visible?
    
    explore = research_group.explore_research
    explore.search=@auto_res1[:title]
    
    project = explore.open_research @auto_res1[:title]
    
    # TEST CASE: Verify button (Join Group) displays for "Automatically joinable" Group
    assert project.join_group_button_element.visible?
    
    project.join_group
    
    # TEST CASE: Verify clicking button adds user as participant
    assert_equal @join_notification, project.notification, "#{project.notification}\ndoesn't match:\n#{@join_notification}"
    
    project.close_notification

    explore = project.explore_research
    explore.search=@auto_res2[:title]
    
    research_group = explore.open_group @auto_res2[:title]
    
    # TEST CASE: Verify button (Join Group) displays for "Automatically joinable" Group
    assert research_group.join_group_button_element.visible?
    
    research_group.join_group
    
    # TEST CASE: Verify clicking button adds user as participant
    assert_equal @join_notification, research_group.notification, "#{research_group.notification}\ndoesn't match:\n#{@join_notification}"
    
    research_group.close_notification

    explore = research_group.explore_research
    explore.search=@request_res1[:title]
    
    project = explore.open_research @request_res1[:title]
    
    # TEST CASE: Verify button (Request to Join) displays for "Request" Group
    assert project.request_to_join_group_button_element.visible?
    
    project.request_to_join_group
    
    # TEST CASE: Verify clicking button sends request to join.
    assert_equal @request_notification, project.notification, "#{project.notification}\ndoesn't match:\n#{@request_notification}"
    
    project.close_notification

    explore = project.explore_research
    explore.search=@request_res2[:title]
    
    research_group = explore.open_group @request_res2[:title]
    
    # TEST CASE: Verify button (Request to Join) displays for "Request" Group
    assert research_group.request_to_join_group_button_element.visible?
    
    research_group.request_to_join_group
    
    # TEST CASE: Verify clicking button sends request to join.
    assert_equal @request_notification, research_group.notification, "#{research_group.notification}\ndoesn't match:\n#{@request_notification}"

    @sakai.logout
    
    dashboard = @sakai.login(@instructor, @ipassword)
    
    inbox = dashboard.my_messages
    
    # TEST CASE: Verify Email sent to Group manager requesting to join
    assert inbox.message_subjects.include?(@email_subject_prefix + @request_res1[:title]), "'#{@email_subject_prefix + @request_res1[:title]}'\nemail not found in list:\n#{inbox.message_subjects.join("\n")}"
    assert inbox.message_subjects.include?(@email_subject_prefix + @request_res2[:title]), "'#{@email_subject_prefix + @request_res2[:title]}'\nemail not found in list:\n#{inbox.message_subjects.join("\n")}"

  end
  
end
