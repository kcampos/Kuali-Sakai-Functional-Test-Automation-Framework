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
# == Prerequisites:
#
# Two test users (see lines 32-36)
#
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Research Project/Group Memberships" do
  
  include Utilities

  let(:project) { ResearchIntro.new @browser }
  let(:research_group) { Library.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @user2 = @config.directory['person2']['id']
    @u2password = @config.directory['person2']['password']
    @student_name = "#{@config.directory['person2']['firstname']} #{@config.directory['person2']['lastname']}"
    
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
 
  it "Memberships with different join settings created" do
    
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
  end
  
  it "'Managers' research project does not show 'join' buttons" do
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_research
    explore.search=@managers_res1[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    project = explore.open_research @managers_res1[:title]

    # TEST CASE: Verify "Managers Add"  does not show buttons to join
    project.join_group_button_element.should exist
    project.join_group_button_element.should_not be_visible
    project.request_to_join_group_button_element.should_not be_visible
  end
  
  it "'Managers' research group does not show 'join' buttons" do
    explore = project.explore_research
    explore.search=@managers_res2[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    research_group = explore.open_group @managers_res2[:title]

    # TEST CASE: Verify "Managers Add" Course does not show buttons to join
    research_group.join_group_button_element.should exist
    research_group.join_group_button_element.should_not be_visible
    research_group.request_to_join_group_button_element.should_not be_visible
  end
  
  it "'Auto Join' research project shows 'join' button" do
    explore = research_group.explore_research
    explore.search=@auto_res1[:title]
    project = explore.open_research @auto_res1[:title]
    project.join_group_button_element.should be_visible
  end
  
  it "'Join' notification appears when button clicked" do
    project.join_group
    project.notification.should == @join_notification
    project.close_notification
  end

  it "'Join' button appears for 'auto-join' research group" do
    explore = project.explore_research
    explore.search=@auto_res2[:title]
    research_group = explore.open_group @auto_res2[:title]
    research_group.join_group_button_element.should be_visible
  end
  
  it "Clicking 'join' adds user to research group" do
    research_group.join_group
    research_group.notification.should == @join_notification
    research_group.close_notification
  end

  it "request to join button appears for a 'Request' research project" do
    explore = research_group.explore_research
    explore.search=@request_res1[:title]
    project = explore.open_research @request_res1[:title]
    project.request_to_join_group_button_element.should be_visible
  end
  
  it "clicking the button sends the request to join the project" do
    project.request_to_join_group
    # TEST CASE: Verify clicking button sends request to join.
    project.notification.should == @request_notification
    project.close_notification
  end

  it "'request to join' button appears for a 'Request' research group" do
    explore = project.explore_research
    explore.search=@request_res2[:title]
    research_group = explore.open_group @request_res2[:title]
    # TEST CASE: Verify button (Request to Join) displays for "Request" Group
    research_group.request_to_join_group_button_element.should be_visible
  end
  
  it "clicking the button sends the request to join the group" do
    research_group = Library.new @browser
    research_group.request_to_join_group
    # TEST CASE: Verify clicking button sends request to join.
    research_group.notification.should == @request_notification
    @sakai.logout
  end
  
  it "Request messages are delivered to the appropriate user" do
    dashboard = @sakai.login(@instructor, @ipassword)
    inbox = dashboard.my_messages
    # TEST CASE: Verify Email sent to Group manager requesting to join
    inbox.message_subjects.should include(@email_subject_prefix + @request_res1[:title])
    inbox.message_subjects.should include(@email_subject_prefix + @request_res2[:title])
  end
 
  after :all do
    # Close the browser window
    @browser.close
  end
    
end
