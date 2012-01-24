#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the visibility settings of Courses.
#
# Creates 3 Groups--one for each Membership setting, then
# tests that a non-manager of those groups has appropriate options
# available for joining, and that those options work as expected.
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
    @auto_group = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, auto-join",
      :membership=>"People can automatically join"
    }
    @request_group = {
      :title=>random_alphanums, #
      :description=>random_string,
      :tags=>"Membership Test, by-request",
      :membership=>"People request to join"
    }
    @managers_group = {
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

    new_group_info = dashboard.create_a_group
    
    new_group_info.title=@auto_group[:title]
    new_group_info.description=@auto_group[:description]
    new_group_info.tags=@auto_group[:tags]
    new_group_info.membership=@auto_group[:membership]

    library = new_group_info.create_group
    
    new_group_info = library.create_a_group

    new_group_info.title=@request_group[:title]
    new_group_info.description=@request_group[:description]
    new_group_info.tags=@request_group[:tags]
    new_group_info.membership=@request_group[:membership]
    
    library = new_group_info.create_group
    
    new_group_info = library.create_a_group

    new_group_info.title=@managers_group[:title]
    new_group_info.description=@managers_group[:description]
    new_group_info.tags=@managers_group[:tags]
    new_group_info.membership=@managers_group[:membership]

    library = new_group_info.create_group
    
    @sakai.logout
    
    dashboard = @sakai.login(@user2, @u2password)
    
    explore = dashboard.explore_groups
    explore.search=@managers_group[:title]
    
    # Note that at some point we may want to add tests of the list widget's join buttons.
    
    group = explore.open_group @managers_group[:title]

    # TEST CASE: Verify "Managers Add" Course does not show buttons to join
    assert group.join_group_button_element.exists?
    assert_equal false, group.join_group_button_element.visible?
    assert_equal false, group.request_to_join_group_button_element.visible?
    
    explore = group.explore_groups
    explore.search=@auto_group[:title]
    
    group = explore.open_group @auto_group[:title]
    
    # TEST CASE: Verify button (Join Group) displays for "Automatically joinable" Group
    assert group.join_group_button_element.visible?
    
    group.join_group
    sleep 0.2
    
    # TEST CASE: Verify clicking button adds user as participant
    assert_equal @join_notification, group.notification, "#{group.notification}\ndoesn't match:\n#{@join_notification}"
    
    group.close_notification
    
    explore = group.explore_groups
    explore.search=@request_group[:title]
    
    group = explore.open_group @request_group[:title]
    
    # TEST CASE: Verify button (Request to Join) displays for "Request" Group
    assert group.request_to_join_group_button_element.visible?
    
    group.request_to_join_group
    sleep 0.2
    
    # TEST CASE: Verify clicking button sends request to join.
    assert_equal @request_notification, group.notification, "#{group.notification}\ndoesn't match:\n#{@request_notification}"
    
    @sakai.logout
    
    dashboard = @sakai.login(@instructor, @ipassword)
    
    inbox = dashboard.my_messages
    
    # TEST CASE: Verify Email sent to Group manager requesting to join
    assert inbox.message_subjects.include?(@email_subject_prefix + @request_group[:title]), "'#{@email_subject_prefix + @request_group[:title]}'\nemail not found in list:\n#{inbox.message_subjects.join("\n")}"

  end
  
end
