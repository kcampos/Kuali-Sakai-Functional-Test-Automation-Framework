# 
# == Synopsis
#
# Tests of Discussion Forums
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestDiscussionForums < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_forums

    # Log in to Sakai
    @sakai.login(@instructor, @ipassword)
    
    # Go to the test site
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
=begin 
    # Set up the test groups
    site_editor = home.site_editor
    groups = site_editor.manage_groups
    new_group = groups.create_new_group
    new_group.title="Group 1"
    1.upto(3) do |x|
      new_group.site_member_list=/student0#{x}/
    end
    new_group.right
    groups = new_group.add
    new_group = groups.create_new_group
    new_group.title="Group 2"
    4.upto(7) do |x|
      new_group.site_member_list=/student0#{x}/
    end
    new_group.right
    groups = new_group.add
    
    # Go to the Discussion Forums page
    forums = groups.forums

    # Create a new forum
    add_forum = forums.new_forum
    add_forum.title="Forum 1"
    add_forum.short_description="Test Forum"
    
    add_forum.editor.wait_until_present(45)
    add_forum.description="Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    # Add a topic to the forum
    add_topic = add_forum.save_and_add
    add_topic.title="Topic 1"
    add_topic.short_description="Test Topic"
    add_topic.description="Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    # Add a file to the topic
    attach_file = add_topic.add_attachments
    attach_file.upload_file="documents/resources.doc"
    
    add_topic = attach_file.continue
    
    forums = add_topic.save
    
    # TEST CASE: Verify forum and topic saved
    assert forums.forum_titles.include?("Forum 1")
    assert forums.topic_titles.include?("Topic 1")
   
    forum2_title = "Forum 2 " + random_alphanums
    topic2_title = "Thread for Group 1 " + random_alphanums
    
    add_forum2 = forums.new_forum
    add_forum2.title=forum2_title
    add_forum2.short_description="Test Forum"
    add_forum2.editor.wait_until_present(45)
    add_forum2.description="Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    add_topic2 = add_forum2.save_and_add
    add_topic2.title=topic2_title
    add_topic2.short_description="Test Topic"
    add_topic2.description="Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    add_topic2.site_role=/Group 1/
    add_topic2.permission_level="Contributor"
    
    add_topic2.site_role="Student (Contributor)"
    add_topic2.permission_level="None"
    
    forums = add_topic2.save

    organize = forums.organize
    organize.forum(2).select("1")
    
    forums = organize.save
    
    edit_forum = forums.forum_settings "Forum 1"
    forums = edit_forum.save
    
    template = forums.template_settings
    
    # TEST CASE: Header reads correctly
    assert template.page_title=="Default Settings Template"
    
    template.cancel
    
    @sakai.logout

    # Log in with a student who is NOT in Group 1
    @sakai.login(@config.directory['person7']['id'], @config.directory['person7']['password'])
    
    workspace = MyWorkspace.new(@browser)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    forums = home.forums
   
    forum_names = forums.forum_titles
    topic_names = forums.topic_titles
    
    # TEST CASE: Verify the student can seen the right stuff
    assert forum_names.include? "Forum 1"
    assert topic_names.include? "Topic 1"
    # What about a link to the uploaded file???
    assert_equal forum_names.include?(forum2_title), false #FIXME - Is this supposed to be the case???
    assert_equal topic_names.include?(topic2_title), false
  
    # Open topic 1
    topic_page = forums.open_topic "Topic 1"
  
    # Post a message
    new_message = topic_page.post_new_thread
    new_message.title="Thread for Topic 1"
    new_message.editor.wait_until_present

    msg_text = "Praesent vel augue? Nulla vel nulla. Praesent tempus suscipit tellus. Mauris ac massa eleifend pede sagittis sollicitudin. Aenean nunc. Fusce nulla! Vivamus et quam rutrum diam molestie lobortis! Suspendisse quis ligula at lectus aliquam egestas."

    new_message.message=msg_text
    topic_page = new_message.post_message

    # TEST CASE: Verify message posted
    assert @browser.frame(:index=>1).table(:id=>"msgForum:messagesInHierDataTable").text.include? "Thread for Topic 1"
   
    message = topic_page.open_message "Thread for Topic 1"
    
    # TEST CASE: Verify user can read the text
    assert @browser.frame(:index=>1).table(:id=>"msgForum:expandedThreadedMessages").text.include? msg_text
    
    @sakai.logout
    
    # Log in with a student who IS in Group 1
    @sakai.login(@config.directory["person5"]["id"], @config.directory["person5"]["password"])
    
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    # TEST CASE: Verify the student can seen the forums
    assert forums.forum_titles.include? "Forum 1"
    assert forums.topic_titles.include? "Topic 1"
    assert forums.forum_titles.include? forum2_title
    assert forums.topic_titles.include? topic2_title
    
    # TEST CASE: Verify something about the student access to the Group 1 thread.
    
    topic = forums.open_topic "Topic 1"

    # TEST CASE: Verify the post new thread link is available
    assert @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Post New Thread").exist?
    
    @sakai.logout
   
    @sakai.login(@instructor, @ipassword)
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    
    forums = home.forums
    
    # TEST CASE: Verify the instructor can seen the forums
    assert forums.forum_titles.include? "Forum 1"
    assert forums.topic_titles.include? "Topic 1"
    assert forums.forum_titles.include?(forum2_title)
    assert forums.topic_titles.include?(topic2_title)  
    
    # TEST CASE: Verify the instructor see the "unread message" notifications
    assert forums.forums_table.text.include? "1 message - 1 unread"
    
    topic_page = forums.open_topic "Topic 1"
    message = topic_page.open_message "Thread for Topic 1"
    
    # TEST CASE: Verify user can read the text
    assert @browser.frame(:index=>1).table(:id=>"msgForum:expandedThreadedMessages").text.include? msg_text
    
    compose = message.reply_to_thread
    
    # TEST CASE: Reply screen contains original message text
    assert compose.reply_text.include? msg_text
    
    thread = compose.cancel
    
    compose = thread.reply_to_message(1)
    
    # TEST CASE: Reply screen contains original message text
    assert compose.reply_text.include? msg_text
    
    reply_text = "In tincidunt varius neque. Maecenas vehicula. Praesent rutrum? Proin lacinia, neque vel consequat malesuada, diam diam scelerisque massa, fermentum accumsan est tortor in libero. Morbi tempus vestibulum tellus! Mauris sit amet purus? Sed eros. Phasellus ornare lectus eget quam. Etiam lorem? Integer molestie. Vivamus erat."
    
    compose.message= reply_text
    
    topic_page = compose.post_message
    
    # TEST CASE: Verify the message appears in the thread list
    assert @browser.frame(:index=>1).div(:class=>"portletBody").link(:text=>"Re: Thread for Topic 1").exist?
    
    topic_page.reset

    forums = Forums.new(@browser)
    
    # Add a new topic that is visible to Group 2
    topic = forums.new_topic_for_forum forum2_title
    topic.title="Topic for Group 2"
    topic.short_description="Test Topic"
    topic.editor.wait_until_present
    topic_description_text= "Sed eget lacus sed orci rutrum porttitor. Donec pellentesque leo in diam? Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    topic.description=topic_description_text
    topic.site_role=/Group 2/
    topic.permission_level="Contributor"
    topic.site_role=/Student/
    topic.permission_level="None"
    
    forums = topic.save
=end
forums = home.forums
    
    # TEST CASE: Number of messages has updated
    assert forums.forums_table.text.include? "2 messages - 0 unread"
    
    # Log out and log back in as a student in Group 1
    @sakai.logout
    @sakai.login(@config.directory["person2"]["id"], @config.directory["person2"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    # TEST CASE: Student in group 1 can't see topic for group 2
    #assert forum_names.include?(forum2_title)
    assert_equal forums.topic_titles.include?("Topic for Group 2"), false
    
    # Log out and log back in with a student from Group 2
    @sakai.logout
    @sakai.login(@config.directory["person8"]["id"], @config.directory["person8"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums

    # TEST CASE: Student in group 2 can see the group 2 topic
    assert forums.topic_titles.include?("Topic for Group 2")
    #assert_equal forums.topic_titles.include?(topic2_title), false
    
    topic_page = forums.open_topic topic2_title
    
    compose_new = topic_page.post_new_thread
    compose_new.title="Thread for Topic for Group 2"
    t2g2_msg="Integer nulla ipsum, congue eu, blandit ac, commodo vitae, erat. Curabitur sit amet tortor. Nullam hendrerit. Morbi dui. Morbi vitae nunc. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos."
    compose_new.message=t2g2_msg
    topic_page = compose_new.post_message
    
    # TEST CASE: Student in group 2 can post a new thread in the Group 2 topic
    assert @browser.frame(:index=>1).table(:id=>"msgForum:messagesInHierDataTable").text.include? "Thread for Topic for Group 2"
    
    # Log out and log back in as the instructor, to change the permissions
    # of a topic...
    @sakai.login(@instructor, @ipassword)
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    
    # TEST CASE:
    # In Topic for Group 2, update Group 1 permission to "Reviewer"
    # Verify student in group 1 can see but not edit Group 2 thread items.
    forums = home.forums
    
    # ADD TEST CASE for saving a group in DRAFT mode
    # ADD TEST CASE for clicking to view full descriptions and attachments
  end
  
end
