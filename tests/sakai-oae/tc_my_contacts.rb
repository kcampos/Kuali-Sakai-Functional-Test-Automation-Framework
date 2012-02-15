#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Academic Smoke tests. Shallowly tests a broad range of features.
# 
# Author: Abe Heward (aheward@rSmart.com)
$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")
gem "test-unit"
["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader",
  "../../config/OAE/config", "utilities", "sakai-OAE/app_functions",
  "sakai-OAE/page_elements" ].each { |item| require item }

class TestMyContacts < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user information from directory.yml...
    @user1 = @config.directory['person1']['id']
    @pass1 = @config.directory['person1']['password']
    @user1_name = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @user2 = @config.directory['person2']['id']
    @pass2 = @config.directory['person2']['password']
    @user2_name = "#{@config.directory['person2']['firstname']} #{@config.directory['person2']['lastname']}"
    @user3 = @config.directory['person5']['id']
    @pass3 = @config.directory['person5']['password']
    @user3_name = "#{@config.directory['person5']['firstname']} #{@config.directory['person5']['lastname']}"
    @user4 = @config.directory['person6']['id']
    @pass4 = @config.directory['person6']['password']
    @user4_name = "#{@config.directory['person6']['firstname']} #{@config.directory['person6']['lastname']}"
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @invite_subject = "#{@user1_name} has invited you to become a connection"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end

  def test_contacts_add1_request
    
    dash = @sakai.login(@user1, @pass1)
    
    my_contacts = dash.my_contacts
    
    # TEST CASE: "Find and add people" link is present on
    # the page when the user has no contacts. (This is an
    # implicit test case, not an explicit assert.)
    search = my_contacts.find_and_add_people

    search.search_for=@user2_name
    search.add_contact @user2_name
    search.invite
    
    search.search_for=@user3_name
    search.add_contact @user3_name
    search.invite
    
    my_contacts = search.my_contacts

    # TEST CASE: "Find and add people" button is still present
    # on the page after having invited people, but who haven't
    # yet accepted the invite.
    search = my_contacts.find_and_add_people

    search.search_for=@user4_name
    
    # Invite from profile page...
    
    profile = search.view_profile @user4_name
    profile.add_to_contacts
    profile.invite
    
    # TEST CASE: The "Add" button now says the invitation
    # has been sent
    assert profile.invitation_sent_button_element.visible?, "Add to Contacts button not updated as expected."
    
    search = profile.explore_people

    search.search_for=@user2_name
    
    # TEST CASE: The "Add contact" button is not
    # present for people already invited to connect
    assert search.not_addable? @user2_name
    
  end

  def test_contacts_add2_pending_invitations
    
    dash = @sakai.login(@user2, @pass2)
    
    my_contacts = dash.my_contacts

    # TEST CASE: Verify there is a pending invitation from
    # the expected person
    assert my_contacts.pending_invites.include? @user1_name
    
    my_contacts.accept_connection @user1_name

    # TEST CASE: Verify the user now appears in the My contacts list
    assert my_contacts.contacts.include? @user1_name
    
    # TEST CASE: Verify the "Pending contacts" heading is gone
    assert_equal false, my_contacts.pending_contacts.present?
    
  end

  def test_contacts_add3_reject_add_request
    
    dash = @sakai.login(@user3, @pass3)
    
    my_messages = dash.my_messages
    
    my_messages.invitations
    
    # TEST CASE: Mailbox contains a connection request from the expected
    # user
    assert my_messages.message_subjects.include? @invite_subject
    
    my_messages.read_message @invite_subject
    
    my_messages.ignore_invitation
    
    my_contacts = my_messages.my_contacts
    
    # TEST CASE: After user rejects request, the pending request is gone
    assert_equal false, my_contacts.pending_contacts.exists?
    
    # TEST CASE: Page includes message that the user does not have any contacts, yet.
    assert @browser.text.include? "You don't have any contacts yet."
    
  end

  def test_contacts_add4_accept_by_profile
    
    dash = @sakai.login(@user4, @pass4)
    
    my_contacts = dash.my_contacts
    
    profile = my_contacts.view_profile @user1_name
    
    # TEST CASE: Profile page has an "Accept invitation" button
    assert_nothing_raised { profile.accept_invitation }
    
    my_contacts = profile.my_contacts
    
    # TEST CASE: User now appears in contacts list
    assert my_contacts.contacts.include? @user1_name
    
  end

  def test_contacts_add5_list
    
    dash = @sakai.login(@user1, @pass1)
    
    my_contacts = dash.my_contacts
    
    # TEST CASE: The contacts list contains expected items
    assert my_contacts.contacts.include? @user2_name
    assert my_contacts.contacts.include? @user4_name
    assert_equal false, my_contacts.contacts.include?(@user3_name)
    
  end

  def test_contacts_remove
  
    dash = @sakai.login(@user1, @pass1)
    
    my_contacts = dash.my_contacts
    
    # TEST CASE: Contacts can be removed from My Contacts
    assert_nothing_raised { my_contacts.remove @user2_name }
    
    my_contacts.remove_contact
    
    # TEST CASE: Contacts list is as expected after removal
    assert my_contacts.contacts.include? @user4_name
    assert_equal false, my_contacts.contacts.include?(@user2_name)
    
    my_contacts.remove @user4_name
    my_contacts.remove_contact
    
    @sakai.sign_out
    
    dash = @sakai.login(@user2, @pass2)
    
    my_contacts = dash.my_contacts
    
    # TEST CASE: User 1 is automatically removed from User 2's list
    assert_equal false, my_contacts.contacts.include?(@user1_name)
  
  end

end
