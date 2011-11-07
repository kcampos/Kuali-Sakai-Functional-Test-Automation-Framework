# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
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
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_messages
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>$frame_index)
    end
 
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify we are on the Messages Received page
    assert_equal "Messages / Received", frm.div(:class=>"breadCrumb specialLink").text, "Received Messages page did not load"
    
    received.reset
    
    messages = Messages.new(@browser) #FIXME
    
    sent = messages.sent
    
    # TEST CASE: Verify we are on the Messages Sent page
    assert_equal "Messages / Sent", frm.div(:class=>"breadCrumb specialLink").text, "Sent Messages page did not load"
    
    sent.reset
    
    messages = Messages.new(@browser) #FIXME
    
    deleted = messages.deleted
    
    # TEST CASE: Verify we are on the Messages Sent page
    assert_equal "Messages / Deleted", frm.div(:class=>"breadCrumb specialLink").text, "Sent Messages page did not load"
    
    deleted.reset
    
    messages = Messages.new(@browser) #FIXME
    
    personal_message = messages.compose_message
    
    personal_message.send_to="Bob, Billy"
    personal_message.subject="Personal Message"
    personal_message.message_text="This is a personal message"
    
    attach = personal_message.add_attachments
    
    attach.attach_a_copy "resources.JPG" 
    
    personal_message = attach.continue
    
    messages = personal_message.send
    
    all_participants = messages.compose_message
    
    all_participants.send_to="All Participants"
    all_participants.subject="Everyone Message"
    all_participants.message_text="This message is for everyone."
    
    messages = all_participants.send
    
    access_message = messages.compose_message
    access_message.send_to="All Participants"
    access_message.subject="Access Message"
    access_message.message_text="This message is for participants only."
    
    messages = access_message.send
    
    maintain_message = messages.compose_message
    maintain_message.send_to="Instructor Role"
    maintain_message.subject="Maintain Message"
    maintain_message.message_text="This message is for instructors only."
    
    messages = maintain_message.send
    
    sent = messages.sent
    
    # TEST CASE: Verify Sent messages are present in the list
    assert frm.link(:text, "Maintain Message").exist? #FIXME
    assert frm.link(:text, "Access Message").exist?
    assert frm.link(:text, "Everyone Message").exist?
    assert frm.link(:text, "Personal Message").exist?
    assert frm.image(:alt, "Has attachment(s)").exist?
    
    @sakai.logout

    workspace = @sakai.login(@student, @spassword)
    home = workspace.open_my_site_by_id(@site_id)
    messages = home.messages
 
    received = messages.received
    
    # TEST CASE: Verify we are on the Messages Received page
    assert_equal "Messages / Received", frm.div(:class=>"breadCrumb specialLink").text, "Received Messages page did not load"
    # TEST CASE: Verify the list of messages is as expected
    assert received.subjects.include? "Access Message"
    assert received.subjects.include? "Everyone Message"
    assert_equal received.subjects.include?("Maintain Message"), false
    assert_equal received.subjects.include?("Personal Message"), false
    
    view = received.open_message "Access Message"
    
    # TEST CASE: Verify the student can read the message text
    assert_equal "This message is for participants only.", frm.div(:class=>"textPanel").text #FIXME
    
    received = view.received
    
    view = received.open_message "Everyone Message"
    
    # TEST CASE: Verify the student can read the message
    assert_equal "This message is for everyone.", frm.div(:class=>"textPanel").text #FIXME
    
    reply = view.reply
    
    reply.message_text="Reply to access message"
    
    received = reply.send
    
    received.reset #FIXME
    
    messages = Messages.new(@browser) #FIXME
    
    sent = messages.sent
    
    # TEST CASE: Sent box has the newly sent message in it
    assert_equal "Re: Everyone Message", frm.link(:text, "Re: Everyone Message").text

    frm.link(:text, "Messages").click #FIXME
    messages = Messages.new(@browser)

    received = messages.received
    received.check_message "Access Message"

    received.delete
    
    # TEST CASE: Verify successful deletion
    assert_equal "The message(s) you selected have been successfully moved to the Deleted folder.", received.alert_message_text
    
    received.check_message "Everyone Message"
    
    move = received.move
    move.select_deleted
    
    messages = move.move_messages
 
    received = messages.received
    
    # TEST CASE: Verify messages are no longer present.
    assert_equal received.subjects.include?("Access Message"), false
    assert_equal received.subjects.include?("Everyone Message"), false
    
    messages = received.messages
    deleted = messages.deleted
    
    # TEST CASE: Verify expected messages appear here
    assert deleted.subjects.include? "Access Message"
    assert deleted.subjects.include? "Everyone Message"
    
    deleted.check_message "Access Message"
    deleted.check_message "Everyone Message"
    
    confirm = deleted.delete
    
    # TEST CASE: Verify the deletion confirmation message
    assert_equal confirm.alert_message_text, "Alert: Are you sure you want to permanently delete the following message(s)?"
    
    delete = confirm.delete_messages
    
    # TEST CASE: Verify delete page alert message appears
    assert_equal delete.alert_message_text, "The message(s) you selected have been successfully deleted."
    
    # TEST CASE: Verify messages are gone from the list
    assert_equal delete.subjects.include?("Access Message"), false
    assert_equal delete.subjects.include?("Everyone Message"), false

    @sakai.logout
    workspace = @sakai.login(@instructor2, @ipassword2)
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    # TEST CASE: User has unread messages
    assert_equal "3", messages.unread_messages_in_folder("Received")
    
    received = messages.received
    
    # TEST CASE: Expected messages are present in the list
    assert received.subjects.include?("Access Message")
    assert received.subjects.include?("Everyone Message")
    assert received.subjects.include?("Maintain Message")
    
    received.check_message "Access Message"
    received.check_message "Everyone Message"
    received = received.mark_read
    
    frm.link(:text, "Messages").click #FIXME
    
    messages = Messages.new(@browser)
    
    # TEST CASE: Verify the count of unread messages has updated
    assert_equal "1", messages.unread_messages_in_folder("Received")

    @sakai.logout

    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify expected message is there
    assert received.subjects.include? "Re: Access Message"
    assert received.subjects.include? "Everyone Message"
    assert received.subjects.include? "Maintain Message"

    view = received.open_message "Re: Access Message"

    forward = view.forward
    
    forward.select_forward_recipients="SuperNinja, Anand"
    forward.message_text="forwarded access message\n\n"
    
    received = forward.send 
    
    @sakai.logout
 
    workspace = @sakai.login(@student2, @spassword2)
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages
    
    received = messages.received
    
    # TEST CASE: Verify presence of expected messages
    assert received.subjects.include? "FW: Re: Access Message"
    assert received.subjects.include? "Everyone Message"
    assert received.subjects.include? "Access Message"
    # TEST CASE: Ensure the personal message does not appear
    assert_equal received.subjects.include?("Personal Message"), false

    @sakai.logout

    workspace = @sakai.login(@student3, @spassword3)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    messages = home.messages

    received = messages.received
    
    # TEST CASE: Ensure the personal message appears
    assert received.subjects.include? "Personal Message"
    assert received.subjects.include? "Everyone Message"
    assert received.subjects.include? "Access Message"
    assert frm.image(:alt, "Has attachment(s)").exist?
    
    view_message = received.open_message "Personal Message"
    
    # TEST CASE: Verify the message can be read
    assert_equal "This is a personal message", frm.div(:class=>"textPanel").text #FIXME
    assert frm.link(:text, "resources.JPG").exist?
    
    frm.link(:text, "Messages").click #FIXME
    
    messages = Messages.new(@browser)
    
    new_folder = messages.new_folder
    new_folder.title="Test Folder"
    
    messages = new_folder.add

    # TEST CASE: Ensure Folder appears in the list
    assert messages.folders.include? "Test Folder"
    
    folder_settings = messages.folder_settings "Test Folder"
    
    add_folder = folder_settings.add
    add_folder.title="Another Test Folder"
    
    messages = add_folder.add
    
    # TEST CASE: Ensure folder appears in the list
    assert messages.folders.include? "Another Test Folder"

    received = messages.received
    received.check_message "Everyone Message"
    
    move = received.move
    
    move.select_custom_folder_num(1)
    
    messages = move.move_messages
    
    received = messages.received
    received.check_message "Access Message"
    
    move = received.move
    move.select_custom_folder_num(2)
    
    messages = move.move_messages
    
    # TEST CASE: Verify message counts for the folders are updated
    assert_equal messages.total_messages_in_folder("Test Folder"), "1"
    assert_equal messages.total_messages_in_folder("Another Test Folder"), "1"
    
    test_folder_settings = messages.folder_settings "Test Folder"
    
    confirm = test_folder_settings.delete
    
    messages = confirm.delete
    
    # TEST CASE: Confirm the folder was deleted
    assert_equal messages.folders.include?("Test Folder"), false
    assert messages.folders.include?("Another Test Folder")
    
  end
  
end
