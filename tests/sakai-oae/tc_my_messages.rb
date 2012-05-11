#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Test of the My Messages pages.
#
# == Prerequisites
#
# Four existing test users (see lines 29-43). Except for users 3 and 4, these users should be
# in each others' Contacts lists. User 5 should have zero messages in any boxes.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae-test-api'

describe "My Messages" do
  
  include Utilities

  let(:home) { LoginPage.new @browser }
  let(:inbox) { MyMessages.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @user1 = @config.directory['person1']['id']
    @pass1 = @config.directory['person1']['password']
    @name1 = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @user2 = @config.directory['person2']['id']
    @pass2 = @config.directory['person2']['password']
    @name2 = "#{@config.directory['person2']['firstname']} #{@config.directory['person2']['lastname']}"
    @user3 = @config.directory['person5']['id']
    @pass3 = @config.directory['person5']['password']
    @name3 = "#{@config.directory['person5']['firstname']} #{@config.directory['person5']['lastname']}"
    @user4 = @config.directory['person6']['id']
    @pass4 = @config.directory['person6']['password']
    @name4 = "#{@config.directory['person6']['firstname']} #{@config.directory['person6']['lastname']}"
    @user5 = @config.directory['person11']['id']
    @pass5 = @config.directory['person11']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @my_inbox_url = "#{@config.url}/me#l=messages/inbox"
    @message1 = {:subject=>"message1"+random_alphanums,
      :body=>"body1"#random_multiline(100, 5)
      }
    @message2 = {:subject=>"message2"+random_alphanums,
      :body=>"body2"+random_multiline(30, 3)
      }
    @message3 = {:subject=>"message3"+random_alphanums,
      :body=>"body3"+random_multiline(100, 5)
      }
    @message4 = {:subject=>"message4"+random_alphanums,
      :body=>"body4"+random_multiline(100, 5)
      }
    @message5 = {:subject=>"message6"+random_alphanums,
      :body=>"me you do it "+random_multiline(100, 5)
      }
    @group_message = {:subject=>"Group Message"+random_alphanums,
      :body=>"Group Body"+random_multiline(100, 5)
      }
    
    @group = "Group Of Fun1"+random_alphanums
    @content = "Text File"
    
    @thumbnail = "Jupiter.gif"
    
    @connection_invitation = "#{@name4} has invited you to become a connection"
    @group_invitation = %|#{@name4} has added you as a Member to the group "#{@group}"|
    @join_request = %|#{@name2} has requested to join your group #{@group}|
    @content_share = %|I want to share "#{@content}"|
    
  end

  it "Inbox not directly accessible when not logged in" do
    
    @browser.goto @my_inbox_url
    @browser.text_field(:id=>"topnavigation_user_options_login_fields_password").wait_until_present
    
    # TEST CASE: User was not taken to the inbox
    home.expand_categories_element.should exist
    
    # TEST CASE: Sign-in box is visible
    home.username_element.should be_visible
  end
  
  it "Use of inbox link will take user directly there after login" do
    @sakai.login(@user5, @pass5)
    
    # TEST CASE: When user signs in, taken directly to inbox
    inbox.page_title.should == "INBOX"
  end
    
  it "My messages menu item is locked down" do
    inbox.my_messages_lock_icon.should be_visible
  end
  
  it "user can collapse My Messages page tree" do
    inbox.show_hide_my_messages_tree
    
    # TEST CASE: User can collapse the My Messages tree
    inbox.trash_link_element.should_not be_visible
  end
    
  it "user can expand a collapsed My Messages page tree" do
    inbox.show_hide_my_messages_tree
    
    # TEST CASE: User can expand a collapsed My Messages tree
    inbox.trash_link_element.should be_visible
    @sakai.logout
  end
  
  it "Compose message button is present on Inbox page" do
    dash = @sakai.login(@user1, @pass1)
    inbox = dash.my_messages
    inbox.compose_message
    
    # Send a message to another user
    inbox.send_this_message_to=@name2
    inbox.subject=@message1[:subject]
    inbox.body=@message1[:body]
    inbox.send_message
  end
  
  it "Clicking 'compose' opens New Message page" do
    inbox.compose_message
    inbox.send_this_message_to=@name4
    inbox.subject=@message1[:subject]
    inbox.body=@message1[:body]
  end
  
  it "Can cancel the sending of a message" do
    lambda { inbox.dont_send }.should_not raise_error
  end
  
  it "Compose Message button present on Invitations" do
    inbox.invitations
    inbox.compose_message
    inbox.send_this_message_to=@name4
    inbox.subject=@message2[:subject]
    inbox.body=@message2[:body]
    $message2_date = Time.now.strftime("%-m/%-d/%Y %-l:%M %p")
    inbox.send_message
  end
  
  it "Compose Message button present on Sent" do
    inbox.sent
    inbox.compose_message
    inbox.send_this_message_to=@name4
    inbox.subject=@message3[:subject]
    inbox.body=@message3[:body]
    inbox.send_message
  end

  it "Compose Message button present on Trash" do
    inbox.trash
    inbox.compose_message
    inbox.send_this_message_to=@name2
    inbox.subject=@message4[:subject]
    inbox.body=@message4[:body]
    inbox.send_message
  end

  it "Only people in users contact list can be searched via the Send field" do
    inbox.compose_message
    inbox.send_this_message_to=@name3
    inbox.no_results_element.should be_visible
  end

  it "Sent: Contains all sent messages" do
    inbox.sent
    inbox.message_subjects.should include @message1[:subject]
    inbox.message_subjects.should include @message2[:subject]
    inbox.message_subjects.should include @message3[:subject]
    inbox.message_subjects.should include @message4[:subject]
  end

  it "All Sent messages are displayed in the 'Read' style" do
    inbox.message_status(@message1[:subject]).should == "read"
    inbox.message_status(@message2[:subject]).should == "read"
    inbox.message_status(@message3[:subject]).should == "read"
    inbox.message_status(@message4[:subject]).should == "read"
  end

  it "Sent messages are populated to the Sent message box within seconds of sending" do
    inbox.compose_message
    inbox.send_this_message_to=@name4
    inbox.subject=@message5[:subject]
    inbox.body=@message5[:body]
    inbox.send_message
    inbox.message_subjects.should include @message5[:subject]
  end

  it "Clicking 'Delete selected' button in Sent box moves checked message to Trash" do
    inbox.select_message @message2[:subject]
    inbox.delete_selected
    inbox.trash
    inbox.message_subjects.should include @message2[:subject]
  end
  
  # Commenting out this test because there's a strange problem with
  # uploading image files with Watir-Webdriver. TODO - Fix when ACAD-979 is resolved
  xit "Profile picture of sender is displayed next to each message (when available)" do
    inbox.change_picture
    inbox.upload_a_new_picture @thumbnail
    $usr1thumb = inbox.thumbnail_source
    inbox.save_new_selection
    @sakai.logout
    dash = @sakai.login(@user4, @pass4)
    inbox = dash.my_messages
    inbox.preview_profile_pic(@message2[:subject]).should == $usr1thumb
  end

  it "The Inbox () count in the left nav reflects the current number of unread messages" do
    @sakai.logout # TODO - This must be removed if/when the above test becomes workable.
    dash = @sakai.login(@user4, @pass4)
    inbox = dash.my_messages
    inbox.message_counts[:unread].should == inbox.unread_inbox_count
  end

  it "Inbox: Contains messages sent directly to you" do
    inbox.message_subjects.should_not include @message1[:subject]
    inbox.message_subjects.should include @message2[:subject]
    inbox.message_subjects.should include @message3[:subject]
    inbox.message_subjects.should include @message5[:subject]
    inbox.message_subjects.should_not include @message4[:subject]
  end

  it "Submitting a search narrows the results of the current Messages box when matching Subject" do
    inbox.inbox
    inbox.search_messages=@message3[:subject]
    inbox.message_subjects.should_not include @message2[:subject]
    inbox.message_subjects.should include @message3[:subject]
    inbox.message_subjects.should_not include @message5[:subject]
  end

  # TODO - Add this and next back when ACAD-971 is resolved
  xit "Submitting a search narrows the results of the current Messages box when matching Body" do
    inbox.search_messages=@message5[:body][0..20]
    inbox.message_subjects.should_not include @message2[:subject]
    inbox.message_subjects.should_not include @message3[:subject]
    inbox.message_subjects.should include @message5[:subject]
  end
  
  xit "Results can be broadened back to all results by removing the search term and clicking enter" do
    inbox.search_messages=" "
    inbox.message_subjects.should include @message2[:subject]
    inbox.message_subjects.should include @message3[:subject]
    inbox.message_subjects.should include @message5[:subject]
  end

  it "Message preview displays the expected information" do
    inbox.page_title.should == "INBOX"
    # Sender
    inbox.preview_sender(@message2[:subject]).should == @name1
    #To: (could be individual user or group name)
    inbox.preview_recipient(@message2[:subject]).should ==("to: " + @name4)
    #Date and time sent
    inbox.preview_date(@message2[:subject]).should == $message2_date
    #Message preview
    inbox.preview_body(@message2[:subject]).should == @message2[:body].gsub("\n", " ")
  end
 
  it "Unread messages appear in unread style in Inbox" do
    inbox.message_status(@message2[:subject]).should == "unread"
    inbox.message_status(@message3[:subject]).should == "unread"
    inbox.message_status(@message5[:subject]).should == "unread"
  end

  it "Clicking Reply button opens message with Reply Interface" do
    inbox.reply_to_message @message5[:subject]
    inbox.subject_element.value.should ==("Re: " + @message5[:subject])
  end
  
  it "Reply is addressed to sender" do
    inbox.message_recipients.should include @name1
    inbox.see_all
  end
   
  it "Inbox's 'Delete selected' button is deactivated when no messages are checked" do # Bug
    inbox.delete_selected_element.should be_disabled
  end
  
  it "Inbox's 'Mark as read' button is deactivated when no messages are checked" do # Bug
    inbox.mark_as_read_element.should be_disabled
  end
  
  it "Inbox's 'Mark as read' button activates when at least one message is checked." do
    inbox.select_message(@message2[:subject])
    inbox.mark_as_read_element.should_not be_disabled
  end
  
  it "Inbox's 'Delete' button activates when at least one message is checked." do
    inbox.delete_selected_element.should_not be_disabled
  end
  
  it "Clicking the Inbox's 'Mark as read' button changes background color on checked items to 'read' style" do
    inbox.mark_as_read
    inbox.message_status(@message2[:subject]).should == "read"
  end

  it "Clicking 'Delete selected' button in Inbox moves checked message to Trash" do
    inbox.select_message(@message2[:subject])
    inbox.delete_selected
    inbox.message_subjects.should_not include @message2[:subject]
    inbox.trash
    inbox.message_subjects.should include @message2[:subject]
  end

  it "Clicking 'Delete selected' button in Trash deletes checked message permanently" do
    inbox.select_message(@message2[:subject])
    inbox.delete_selected
    inbox.message_subjects.should_not include @message2[:subject]
  end
  
  it "Creates a 'Request' group and adds users, shares content" do
    group = inbox.create_a_group
    group.title=@group
    group.membership="People request to join"
    group.add_people
    group.add_contact @name1
    group.add_by_search @name3
    group.done_apply_settings
    group.create_simple_group
    explore = group.explore_people
    explore.add_contact @name3
    explore.invite
    explore = explore.explore_content
    explore.search_for @content
    content = explore.open_content @content
    content.share_with_others
    content.share_with=@name3
    content.share
    @sakai.logout
  end
  
  it "Displays notifications of requests to join groups of which you are a manager" do
    dash = @sakai.login(@user2, @pass2)
    explore = dash.explore_groups
    explore.search_for=@group
    group = explore.open_group @group
    group.request_to_join_group
    @sakai.logout
    dash = @sakai.login(@user4, @pass4)
    inbox = dash.my_messages
    inbox.message_subjects.should include @join_request
    @sakai.logout
  end
 
  it "Inbox displays notifications of users adding you as members of groups" do
    dash = @sakai.login(@user3, @pass3)
    inbox = dash.my_messages
    inbox.message_subjects.should include @group_invitation
  end

  it "The Inbox () count in the left nav reflects the current number of unread messages" do
    inbox.message_counts[:unread].should == inbox.unread_inbox_count
  end

  it "Generic profile icon is displayed next to each message when sender has not uploaded a profile picture" do
    inbox.preview_profile_pic(@content_share).should =~ /default_User_icon/
  end
  
  it "Inbox displays notifications of content items being shared with you, not connection invitations" do
    inbox.message_subjects.should include @content_share
    inbox.message_subjects.should_not include @connection_invitation
  end
  
  it "Invitations: Contains invitations to become a connection with users, but not groups, or content shares" do
    inbox.invitations
    inbox.message_subjects.should include @connection_invitation
    inbox.message_subjects.should_not include @group_invitation
    inbox.message_subjects.should_not include @content_share
  end

  it "The Invitations () count in the left nav reflects the current number of unread messages" do
    inbox.message_counts[:unread].should == inbox.unread_invitations_count
  end

  it "Invitations' 'Mark as read' button is deactivated when no messages are checked" do 
    inbox.mark_as_read_element.should be_disabled
  end
  
  it "Invitations' 'Mark as read' button activates when at least one message is checked." do 
    inbox.select_message @connection_invitation
    inbox.mark_as_read_element.should be_enabled
  end
  
  it "Clicking Invitations' 'Mark as read' button changes background color on checked items to 'read' style" do
    $unread_message_count = inbox.unread_message_count
    $unread_inbox_count = inbox.unread_inbox_count
    $unread_invitations_count = inbox.unread_invitations_count
    inbox.message_status(@connection_invitation).should == "unread"
    inbox.mark_as_read
    inbox.message_status(@connection_invitation).should == "read"
  end
  
  it "Clicking 'Mark as read' button updates the total unread message count within 30 seconds" do
    inbox.unread_message_count.should ==($unread_message_count - 1)
    $unread_message_count = inbox.unread_message_count
  end

  it "Clicking 'Mark as read' button updates the invitations unread message count within 30 seconds" do
    inbox.unread_invitations_count.should ==($unread_invitations_count - 1)
    $unread_invitations_count = inbox.unread_invitations_count
  end

  it "The Message count in the left menu does not include messages in the Sent box at any time" do
    inbox.compose_message
    inbox.send_this_message_to=@group
    inbox.subject=@group_message[:subject]
    inbox.body=@group_message[:body]
    inbox.send_message
    inbox.unread_message_count.should == $unread_message_count # Note that this is actually a bug. See ACAD-876
  end

  it "Inbox contains messages sent to a group you are a member of" do
    inbox.inbox
    inbox.message_subjects.should include @group_message[:subject]
  end

  it "Clicking a message's 'X' button removes the message from the current box" do
    inbox.delete_message @group_message[:subject]
    inbox.invitations
    inbox.delete_message @connection_invitation
  end

  # TODO - Add back when count bug is fixed
  xit "Deleting an unread message updates unread message count within 30 seconds" do
    inbox.unread_message_count.should ==($unread_message_count - 2)
  end

  it "Trash contains all messages you have deleted, from any of the other 3 pages" do
    inbox.trash
    inbox.message_subjects.should include @group_message[:subject]
    inbox.message_subjects.should include @connection_invitation
  end

  it "The delete button on the message deletes the message permanently" do
    inbox.delete_message @group_message[:subject]
    inbox.message_subjects.should_not include @group_message[:subject]
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
