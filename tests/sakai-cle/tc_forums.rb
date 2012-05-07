# 
# == Synopsis
#
# Tests of Discussion Forums
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestForums < Test::Unit::TestCase
  
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
    
    # Test case variables
    @groups = [ random_alphanums, random_alphanums ]
    
    @forums = [
      {:title=>random_alphanums(10, "Forum 1 "), :short_description=>"Test Forum", :description=>"Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo." },
      {:title=>"Forum 2 " + random_alphanums, :short_description=>"Test Forum", :description=>"Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo." },
      {}
    ]
    
    @topics = [
      {:title=>"Topic 1", :short_description=>"Test Topic", :file=>"documents/resources.doc", :description=>"Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo." },
      {:title=>"Thread for Group 1 " + random_alphanums, :permission_level=>"None", :short_description=>"Test Topic", :description=>"Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo." },
      {:title=>"Topic for Group 2", :permission_level=>"None", :short_description=>"Test Topic", :description=>"Sed eget lacus sed orci rutrum porttitor. Donec pellentesque leo in diam? Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo." }
    ]
    
    @messages = [
      {:title=>"Thread for Topic 1", :text=> "Praesent vel augue? Nulla vel nulla. Praesent tempus suscipit tellus. Mauris ac massa eleifend pede sagittis sollicitudin. Aenean nunc. Fusce nulla! Vivamus et quam rutrum diam molestie lobortis! Suspendisse quis ligula at lectus aliquam egestas."},
      {:title=>"Thread for Topic for Group 2", :text=>"Integer nulla ipsum, congue eu, blandit ac, commodo vitae, erat. Curabitur sit amet tortor. Nullam hendrerit. Morbi dui. Morbi vitae nunc. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos." }
    ]
    
    @reply_text = "In tincidunt varius neque. Maecenas vehicula. Praesent rutrum? Proin lacinia, neque vel consequat malesuada, diam diam scelerisque massa, fermentum accumsan est tortor in libero. Morbi tempus vestibulum tellus! Mauris sit amet purus? Sed eros. Phasellus ornare lectus eget quam. Etiam lorem? Integer molestie. Vivamus erat."
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_forums

    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)

    # Set up the test groups
    site_editor = home.site_editor
    groups = site_editor.manage_groups
    new_group = groups.create_new_group
    new_group.title=@groups[0]
    1.upto(3) do |x|
      if x == 3
        x = 5 # Need this because of the way the Directory.yml list is made
      end
      person = @config.directory["person#{x}"]['id']
      new_group.site_member_list=/#{person}/
    end
    new_group.right
    groups = new_group.add
    new_group = groups.create_new_group
    new_group.title=@groups[1]
    6.upto(10) do |x|
      person = @config.directory["person#{x}"]['id']
      new_group.site_member_list=/#{person}/
    end
    new_group.right
    groups = new_group.add
    
    # Go to the Discussion Forums page
    forums = groups.forums

    # Create a new forum
    add_forum = forums.new_forum
    add_forum.title=@forums[0][:title]
    add_forum.short_description=@forums[0][:short_description]
    sleep 5 #FIXME - Takes a while for FCKEditor to load on VPN
    add_forum.editor.wait_until_present
    add_forum.description=@forums[0][:description]
    
    # Add a topic to the forum
    add_topic = add_forum.save_and_add
    add_topic.title=@topics[0][:title]
    add_topic.short_description=@topics[0][:short_description]
    add_topic.description=@topics[0][:description]
    
    # Add a file to the topic
    attach_file = add_topic.add_attachments
    attach_file.upload_file @topics[0][:file]
    
    add_topic = attach_file.continue
    
    forums = add_topic.save
    
    # TEST CASE: Verify forum and topic saved
    assert forums.forum_titles.include?(@forums[0][:title])
    assert forums.topic_titles.include?(@topics[0][:title])
    
    add_forum2 = forums.new_forum
    add_forum2.editor.wait_until_present(25)
    add_forum2.title=@forums[1][:title]
    add_forum2.short_description=@forums[1][:short_description]
    add_forum2.description=@forums[1][:description]
    
    add_topic2 = add_forum2.save_and_add
    add_topic2.title=@topics[1][:title]
    add_topic2.short_description=@topics[1][:short_description]
    add_topic2.description=@topics[1][:description]
    
    add_topic2.site_role=/#{Regexp.escape(@groups[0])}/
    add_topic2.permission_level="Contributor"
    
    add_topic2.site_role="Student (Contributor)"
    add_topic2.permission_level=@topics[1][:permission_level]
    
    forums = add_topic2.save

    organize = forums.organize
    organize.forum(2).select("1")
    
    forums = organize.save
    
    edit_forum = forums.forum_settings @forums[0][:title]
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
    sleep 30
    # TEST CASE: Verify the student can seen the right stuff
    assert forums.forum_titles.include? @forums[0][:title]
    assert forums.topic_titles.include? @topics[0][:title]
    # What about a link to the uploaded file???
    assert_equal false, forums.forum_titles.include?(@forums[1][:title])
    assert_equal false, forums.topic_titles.include?(@topics[1][:title])
  
    # Open topic 1
    topic_page = forums.open_topic @topics[0][:title]
  
    # Post a message
    new_message = topic_page.post_new_thread
    new_message.editor.wait_until_present
    new_message.message=@messages[0][:text]
    new_message.title=@messages[0][:title]
    
    topic_page = new_message.post_message

    # TEST CASE: Verify message posted
    assert @browser.frame(:index=>$frame_index).table(:id=>"msgForum:messagesInHierDataTable").text.include? @messages[0][:title]
   
    message = topic_page.open_message @messages[0][:title]
    
    # TEST CASE: Verify user can read the text
    assert @browser.frame(:index=>$frame_index).table(:id=>"msgForum:expandedThreadedMessages").text.include? @messages[0][:text]
    
    @sakai.logout
    
    # Log in with a student who IS in Group 1
    @sakai.login(@config.directory["person5"]["id"], @config.directory["person5"]["password"])
    
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    # TEST CASE: Verify the student can seen the forums
    assert forums.forum_titles.include? @forums[0][:title]
    assert forums.topic_titles.include? @topics[0][:title]
    assert forums.forum_titles.include? @forums[1][:title]
    assert forums.topic_titles.include? @topics[1][:title]
    
    # TEST CASE: Verify something about the student access to the Group 1 thread.
    
    topic = forums.open_topic @topics[0][:title]

    # TEST CASE: Verify the post new thread link is available
    assert @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Post New Thread").exist?
    
    @sakai.logout
   
    @sakai.login(@instructor, @ipassword)
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    
    forums = home.forums
    
    # TEST CASE: Verify the instructor can seen the forums
    assert forums.forum_titles.include? @forums[0][:title]
    assert forums.topic_titles.include? @topics[0][:title]
    assert forums.forum_titles.include? @forums[1][:title]
    assert forums.topic_titles.include? @topics[1][:title] 
    
    # TEST CASE: Verify the instructor see the "unread message" notifications
    assert forums.forums_table.text.include? "1 message - 1 unread"
    
    topic_page = forums.open_topic @topics[0][:title]
    message = topic_page.open_message @messages[0][:title]
    
    # TEST CASE: Verify user can read the text
    assert @browser.frame(:index=>$frame_index).table(:id=>"msgForum:expandedThreadedMessages").text.include? @messages[0][:text]
    
    compose = message.reply_to_thread
    
    # TEST CASE: Reply screen contains original message text
    assert compose.reply_text.include? @messages[0][:text]
    
    thread = compose.cancel
    
    compose = thread.reply_to_message(1)
    
    # TEST CASE: Reply screen contains original message text
    assert compose.reply_text.include? @messages[0][:text]
    
    compose.message= @reply_text
    
    topic_page = compose.post_message
    
    # TEST CASE: Verify the message appears in the thread list
    assert @browser.frame(:index=>1).div(:class=>"portletBody").link(:text=>"Re: #{@messages[0][:title]}").exist?
    
    topic_page.reset

    forums = Forums.new(@browser)
    
    # Add a new topic that is visible to Group 2
    topic = forums.new_topic_for_forum @forums[1][:title]
    topic.editor.wait_until_present
    topic.description=@topics[2][:description]
    topic.title=@topics[2][:title]
    topic.short_description=@topics[2][:short_description]
    topic.site_role=/#{Regexp.escape(@groups[1])}/
    topic.permission_level="Contributor"
    topic.site_role=/Student/
    topic.permission_level=@topics[2][:permission_level]
    
    forums = topic.save
    
    # TEST CASE: Number of messages has updated
    assert forums.forums_table.text.include? "2 messages - 0 unread"
    
    # Log out and log back in as a student in Group 1
    @sakai.logout
    @sakai.login(@config.directory["person2"]["id"], @config.directory["person2"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    # TEST CASE: Student in group 1 can't see topic for group 2
    assert forums.forum_titles.include?(@forums[1][:title])
    assert_equal forums.topic_titles.include?(@topics[2][:title]), false
    
    # Log out and log back in with a student from Group 2
    @sakai.logout
  
    @sakai.login(@config.directory["person8"]["id"], @config.directory["person8"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums

    # TEST CASE: Student in group 2 can see the group 2 topic
    assert forums.topic_titles.include?(@topics[2][:title])
    
    topic_page = forums.open_topic @topics[2][:title]
    
    compose_new = topic_page.post_new_thread
    compose_new.message=@messages[1][:text]
    compose_new.title=@messages[1][:title]
    topic_page = compose_new.post_message
    
    # TEST CASE: Student in group 2 can post a new thread in the Group 2 topic
    assert @browser.frame(:index=>1).table(:id=>"msgForum:messagesInHierDataTable").text.include? @messages[1][:title]
    
    # Log out and log back in as the instructor, to change the permissions
    # of a topic...
    @sakai.logout
    
    @sakai.login(@instructor, @ipassword)
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    # In Topic for Group 2, update Group 1 permission to "Reviewer"
    topic_settings = forums.topic_settings @topics[2][:title]
    topic_settings.site_role= /#{Regexp.escape(@groups[0])}/
    topic_settings.permission_level="Reviewer"
    topic_settings.save
    
    @sakai.logout
    
    # Log in with a student from Group 1
    @sakai.login(@config.directory["person5"]["id"], @config.directory["person5"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    topic_page = forums.open_topic @topics[2][:title]
    
    # TEST CASE: Verify student in group 1 can see but not edit Group 2 thread items.
    assert topic_page.thread_titles.include? @messages[1][:title]
    assert_equal @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Post New Thread").exist?, false
    assert_equal @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Topic Settings").exist?, false
    assert_equal @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Delete").exist?, false
    
    @sakai.logout
    
    # Log in with a student from Group 2
    @sakai.login(@config.directory["person6"]["id"], @config.directory["person6"]["password"])
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    forums = home.forums
    
    topic_page = forums.open_topic @topics[2][:title]
    
    # Verify student in group 2's permissions have not changed
    assert topic_page.thread_titles.include? @messages[1][:title]
    assert @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Post New Thread").exist?
    assert_equal @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Topic Settings").exist?, false
    assert_equal @browser.frame(:index=>1).table(:class=>/topicBloc/).link(:text=>"Delete").exist?, false
    
    #FIXME ADD TEST CASE for saving a group in DRAFT mode
    #FIXME ADD TEST CASE for clicking to view full descriptions and attachments
  end
  
end
