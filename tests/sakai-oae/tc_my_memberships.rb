#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests the My Memberships page for basic UI functionality.
#
# == Prerequisites:
#
# See lines 28-35 for required user information
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae-test-api'

describe "My Memberships" do
  
  include Utilities

  let(:memberships) { MyMemberships.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user information from directory.yml...
    @user1 = @config.directory['person10']['id']
    @pass1 = @config.directory['person10']['password']
    @user1_name = "#{@config.directory['person10']['firstname']} #{@config.directory['person10']['lastname']}"
    @user2 = @config.directory['person1']['id']
    @pass2 = @config.directory['person1']['password']
    @user2_name = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @user3 = @config.directory['person5']['id']
    @pass3 = @config.directory['person5']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @group1_name = random_alphanums(10, "Group ")
    @group1_description = "This is radio clash on pirate satellite\n" + random_multiline
    @group1_tag = random_alphanums
    @group2_name = random_alphanums(10, "Another Group ")
    @group2_description = "Stranded on a plane that was circling round. I carry my heart like a soldier with a hand grenade"
    @group2_tag = "Awesome"

    @last_manager_error = "Group membership\nYou are unable to remove your membership from #{@group2_name} because you are the only manager"

  end

  it "With Zero memberships, blue 'quote bubble' displays" do
    dash = @sakai.login(@user1, @pass1)
    memberships = dash.my_memberships
    memberships.quote_bubble.should be_present
  end

  it "Sorting options not present when no memberships are present" do
    memberships.sort_by_list_element.should_not be_visible
  end

  it "'Create one' link opens the Create Group page" do
    create_group = memberships.create_one
    create_group.title=@group1_name
    create_group.description=@group1_description
    create_group.tags=@group1_tag
    create_group.create_simple_group
  end

  it "Sorting membership list works as expected" do
    @sakai.log_out
    dash = @sakai.login(@user2, @pass2)
    explore = dash.explore_groups
    explore.join_group @group1_name
    create_group = explore.create_a_group
    create_group.title=@group2_name
    create_group.description=@group2_description
    create_group.tags=@group2_tag
    library = create_group.create_simple_group
    memberships = library.my_memberships
    @list = memberships.memberships
    @alphabetical = @list.alphabetize
    @reverse = @alphabetical.reverse
    memberships.sort_by="Z-A"
    memberships.memberships.should == @reverse
    memberships.sort_by="A-Z"
    memberships.memberships.should == @alphabetical
    memberships.sort_by="Recently changed"
    memberships.memberships.should == @list
  end
  
  xit "List displays expected group profile icon" do
    # TODO - Fix when https://jira.rsmart.com/browse/ACAD-979 is resolved
  end
  
  it "Clicking membership title takes user to Group/Course page" do
    library = memberships.open_group @group1_name
    library.page_title.should == @group1_name + "'s library"
  end
  
  it "Group listing displays the type of group" do
    memberships.my_memberships
    memberships.group_type(@group1_name).should == "GROUP"
    memberships.group_type(@group2_name).should == "GROUP"
  end

  it "Messaging a group brings up Send Message dialog, with Group name in To: field" do
    memberships.message_group @group1_name
    memberships.message_recipients.should include @group1_name
    memberships.dont_send
  end

  it "Group listing displays when it was last updated" do
    memberships.last_updated(@group1_name).should =~ /^Changed.+ago$/
  end
  
  it "Group listing displays the number of content items in the group" do
    explore = memberships.explore_content
    content_list = explore.results_list
    count = content_list.length
    content_list.each do |file|
      explore.add_to_library(file)
      explore.saving_to=(@group1_name + "'s library")
      explore.add
    end
    memberships = explore.my_memberships
    memberships.content_item_count(@group1_name).should == count
  end
  
  it "Group listing displays the number of participants in the group" do
    memberships.participants_count(@group1_name).should == 2
  end
  
  xit "Group listing displays the group's description" do
    # TODO: Fix when https://jira.rsmart.com/browse/ACAD-991 is closed
  end
  
  xit "Group listing displays the group's tags" do
    # TODO: Fix when https://jira.rsmart.com/browse/ACAD-991 is closed
  end

  xit "Clicking on a group's tag searches by that tag" do
    # TODO: Fix when https://jira.rsmart.com/browse/ACAD-991 is closed
  end
  
  it "'Leave group' button removes user from the given group" do
    memberships.leave_group @group1_name
    memberships.yes_apply
    memberships.close_notification
    memberships.memberships.should_not include @group1_name
  end
  
  it "The last manager of a group is not allowed to leave it" do
    memberships.leave_group @group2_name
    memberships.notification.should == @last_manager_error
  end

  it "'Add to' button is disabled when no items are selected" do
    memberships.add_selected_button_element.should be_disabled
  end

  it "'Message' button is disabled when no items are selected" do
    memberships.message_selected_button_element.should be_disabled
  end

  it "Clicking the 'X participants' link navigates to Group's Participants page" do
    participants = memberships.view_group_participants @group2_name
    participants.search_participants_element.should be_visible
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
