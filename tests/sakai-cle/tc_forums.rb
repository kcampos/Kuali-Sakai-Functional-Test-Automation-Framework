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
=begin  
    # Log in to Sakai
    @sakai.login(@instructor, @ipassword)
    
    # Go to the test site
    workspace = MyWorkspace.new(@browser)
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to the Discussion Forums page
    forums = home.forums
  
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
    
    forums = add_topic.save
    
    forum_names = forums.forum_titles
    topic_names = forums.topic_titles
    
    # TEST CASE: Verify forum and topic saved
    assert forum_names.include?("Forum 1")
    assert topic_names.include?("Topic 1")
    
    add_forum2 = forums.new_forum
    add_forum2.title="Forum 2 " + random_alphanums
    add_forum2.short_description="Test Forum"
    add_forum2.editor.wait_until_present(45)
    add_forum2.description="Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    add_topic2 = add_forum2.save_and_add
    add_topic2.title="Topic For Group 1 " + random_alphanums
    add_topic2.short_description="Test Topic"
    add_topic2.description="Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    
    add_topic2.site_role=/\(None\)/
    add_topic2.permission_level="Contributor"
    
    add_topic2.site_role="Student (Contributor)"
    add_topic2.permission_level="None"
    
    forums = add_topic2.save
  
    organize = forums.organize
    organize.forum(2).select("1")
    
    forums = organize.save
    
    edit_forum = forums.forum_settings(1)
    forums = edit_forum.save
    
    template = forums.template
    template.cancel
    
    @sakai.logout
=end    
    @sakai.login(@config.directory['person7']['id'], @config.directory['person7']['password'])
    
    workspace = MyWorkspace.new(@browser)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    forums = home.forums
    
    forum_names = forums.forum_titles
    topic_names = forums.topic_titles
    
    # TEST CASE: Verify the student can seen the forums
    assert forum_names.include?("Forum 1")
    assert topic_names.include?("Topic 1")
    
  end
  
end
