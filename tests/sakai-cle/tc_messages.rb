# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestMessages < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @instructor2 = @config.directory['person4']['id']
    @ipassword2 = @config.directory['person4']['password']
    @student = @config.directory["person1"]["id"]
    @spassword = @config.directory["person1"]["password"]
    @student2 = @config.directory["person12"]["id"]
    @spassword2 = @config.directory["person12"]["password"]
    @student3 = @config.directory["person2"]["id"]
    @spassword3 = @config.directory["person2"]["password"]
    @site_id = @config.directory["site1"]["id"]
    @sakai = SakaiCLE.new(@browser)
    
    #Test case variables
    @messages = [
      {:send_to=>@config.directory["person2"]["lastname"] + ", " + @config.directory["person2"]["firstname"], :attach=>"resources.JPG", :subject=>"Personal Message", :text=>"This is a personal message" },
      {:send_to=>"All Participants", :subject=>"Everyone Message", :text=>"This message is for everyone." },
      {:send_to=>"All Participants", :subject=>"Access Message", :text=>"This message is for participants only." },
      {:send_to=>"Instructor Role", :subject=>"Maintain Message", :text=>"This message is for instructors only." },
      {:text=>"Reply to access message"},
      {:forward_to=>@config.directory["person12"]["lastname"] + ", " + @config.directory["person12"]["firstname"], :text=>"Forwarded message" }
    ]
    
    @folder1 = "Test Folder"
    @folder2 = "Another Test Folder"
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @received_header = "Messages / Received"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_messages

    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify we are on the Messages Received page
    assert_equal @received_header, received.header, "Received Messages page did not load"
    
    messages = received.messages
    
    sent = messages.sent
    
    # TEST CASE: Verify we are on the Messages Sent page
    assert_equal "Messages / Sent", sent.header, "Sent Messages page did not load"
    
    messages = sent.messages
    
    deleted = messages.deleted
    
    # TEST CASE: Verify we are on the Messages Sent page
    assert_equal "Messages / Deleted", deleted.header, "Deleted Messages page did not load"
    
    messages = deleted.messages
    
    personal_message = messages.compose_message
    
    personal_message.send_to=@messages[0][:send_to]
    personal_message.subject=@messages[0][:subject]
    personal_message.message_text=@messages[0][:text]
    
    attach = personal_message.add_attachments
    
    attach.attach_a_copy @messages[0][:attach]
    
    personal_message = attach.continue
    
    messages = personal_message.send
    
    all_participants = messages.compose_message
    
    all_participants.send_to=@messages[1][:send_to]
    all_participants.subject=@messages[1][:subject]
    all_participants.message_text=@messages[1][:text]
    
    messages = all_participants.send
    
    access_message = messages.compose_message
    access_message.send_to=@messages[2][:send_to]
    access_message.subject=@messages[2][:subject]
    access_message.message_text=@messages[2][:text]
    
    messages = access_message.send
    
    maintain_message = messages.compose_message
    maintain_message.send_to=@messages[3][:send_to]
    maintain_message.subject=@messages[3][:subject]
    maintain_message.message_text=@messages[3][:text]
    
    messages = maintain_message.send
    
    sent = messages.sent
    
    # TEST CASE: Verify Sent messages are present in the list
    assert sent.subjects.include?(@messages[0][:subject])
    assert sent.subjects.include?(@messages[1][:subject])
    assert sent.subjects.include?(@messages[2][:subject])
    assert sent.subjects.include?(@messages[3][:subject])
    assert @browser.frame(:index=>1).image(:alt, "Has attachment(s)").exist? #FIXME
    
    @sakai.logout

    workspace = @sakai.login(@student, @spassword)
    home = workspace.open_my_site_by_id(@site_id)
    messages = home.messages
 
    received = messages.received
    
    # TEST CASE: Verify we are on the Messages Received page
    assert_equal @received_header, received.header, "Received Messages page did not load"
    # TEST CASE: Verify the list of messages is as expected
    assert received.subjects.include? @messages[2][:subject]
    assert received.subjects.include? @messages[1][:subject]
    assert_equal false, received.subjects.include?(@messages[3][:subject])
    assert_equal false, received.subjects.include?(@messages[0][:subject])
    
    view = received.open_message @messages[2][:subject]
    
    # TEST CASE: Verify the student can read the message text
    assert_equal @messages[2][:text], view.message_text #FIXME
    
    received = view.received
    
    view = received.open_message @messages[1][:subject]
    
    # TEST CASE: Verify the student can read the message
    assert_equal @messages[1][:text], view.message_text #FIXME
    
    reply = view.reply
    
    reply.message_text=@messages[4][:text]
    
    received = reply.send
    
    messages = received.messages
    
    sent = messages.sent
    
    # TEST CASE: Sent box has the newly sent message in it
    assert sent.subjects.include?("Re: #{@messages[1][:subject]}")

    messages = sent.messages

    received = messages.received
    received.check_message @messages[2][:subject]

    received.delete
    
    # TEST CASE: Verify successful deletion
    assert_equal "The message(s) you selected have been successfully moved to the Deleted folder.", received.alert_message_text
    
    received.check_message @messages[1][:subject]
    
    move = received.move
    move.select_deleted
    
    messages = move.move_messages
 
    received = messages.received
    
    # TEST CASE: Verify messages are no longer present.
    assert_equal received.subjects.include?(@messages[2][:subject]), false
    assert_equal received.subjects.include?(@messages[1][:subject]), false
    
    messages = received.messages
    deleted = messages.deleted
    
    # TEST CASE: Verify expected messages appear here
    assert deleted.subjects.include? @messages[2][:subject]
    assert deleted.subjects.include? @messages[1][:subject]
    
    deleted.check_message @messages[2][:subject]
    deleted.check_message @messages[1][:subject]
    
    confirm = deleted.delete
    
    # TEST CASE: Verify the deletion confirmation message
    assert_equal "Alert: Are you sure you want to permanently delete the following message(s)?", confirm.alert_message_text
    
    delete = confirm.delete_messages
    
    # TEST CASE: Verify delete page alert message appears
    assert_equal "The message(s) you selected have been successfully deleted.", delete.alert_message_text
    
    # TEST CASE: Verify messages are gone from the list
    assert_equal delete.subjects.include?(@messages[2][:subject]), false
    assert_equal delete.subjects.include?(@messages[1][:subject]), false

    @sakai.logout
    workspace = @sakai.login(@instructor2, @ipassword2)
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    # TEST CASE: User has unread messages
    assert_equal "3", messages.unread_messages_in_folder("Received")
    
    received = messages.received
    
    # TEST CASE: Expected messages are present in the list
    assert received.subjects.include?(@messages[2][:subject])
    assert received.subjects.include?(@messages[1][:subject])
    assert received.subjects.include?(@messages[3][:subject])
    
    received.check_message @messages[2][:subject]
    received.check_message @messages[1][:subject]
    received = received.mark_read
    
    messages = received.messages
    
    # TEST CASE: Verify the count of unread messages has updated
    assert_equal "1", messages.unread_messages_in_folder("Received")

    @sakai.logout

    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify expected message is there
    assert received.subjects.include? "Re: #{@messages[1][:subject]}"
    assert received.subjects.include? @messages[1][:subject]
    assert received.subjects.include? @messages[2][:subject]
    assert received.subjects.include? @messages[3][:subject]

    view = received.open_message "Re: #{@messages[1][:subject]}"

    forward = view.forward
    
    forward.select_forward_recipients=@messages[5][:forward_to]
    forward.message_text=@messages[5][:text]
    
    received = forward.send 
    
    @sakai.logout

    workspace = @sakai.login(@student2, @spassword2)
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify presence of expected messages
    assert received.subjects.include? "FW: Re: #{@messages[1][:subject]}"
    assert received.subjects.include? @messages[1][:subject]
    # TEST CASE: Ensure the personal message does not appear
    assert_equal false, received.subjects.include?(@messages[0][:subject])

    @sakai.logout

    workspace = @sakai.login(@student3, @spassword3)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages

    received = messages.received
    
    # TEST CASE: Ensure the personal message appears
    assert received.subjects.include? @messages[0][:subject]
    assert received.subjects.include? @messages[1][:subject]
    assert received.subjects.include? @messages[2][:subject]
    assert @browser.frame(:index=>1).image(:alt, "Has attachment(s)").exist? #FIXME
    
    view_message = received.open_message @messages[0][:subject]
    
    # TEST CASE: Verify the message can be read
    assert_equal @messages[0][:text], view_message.message_text
    assert @browser.frame(:index=>1).link(:text, @messages[0][:attach]).exist?
    
    messages = view_message.messages
    
    new_folder = messages.new_folder
    new_folder.title=@folder1
    
    messages = new_folder.add

    # TEST CASE: Ensure Folder appears in the list
    assert messages.folders.include? @folder1
    
    folder_settings = messages.folder_settings @folder1
    
    add_folder = folder_settings.add
    add_folder.title=@folder2
    
    messages = add_folder.add
    
    # TEST CASE: Ensure folder appears in the list
    assert messages.folders.include? @folder2

    received = messages.received
    received.check_message @messages[1][:subject]
    
    move = received.move
    
    move.select_custom_folder_num(1)
    
    messages = move.move_messages
    
    received = messages.received
    received.check_message @messages[2][:subject]
    
    move = received.move
    move.select_custom_folder_num(2)
    
    messages = move.move_messages
    
    # TEST CASE: Verify message counts for the folders are updated
    assert_equal "1", messages.total_messages_in_folder(@folder1)
    assert_equal "1", messages.total_messages_in_folder(@folder2)
    
    test_folder_settings = messages.folder_settings @folder1
    
    confirm = test_folder_settings.delete
    
    messages = confirm.delete
    
    # TEST CASE: Confirm the folder was deleted
    assert_equal messages.folders.include?(@folder1), false
    assert messages.folders.include?(@folder2)
    
  end
  
end
