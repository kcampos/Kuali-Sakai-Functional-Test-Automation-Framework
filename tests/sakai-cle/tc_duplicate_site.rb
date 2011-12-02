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

class TestDuplicateSite < Test::Unit::TestCase
  
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
    @new_site_title = "1111" + random_alphanums
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_duplicate_site
     
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)

    # Gather info about the current contents for verification
    # after duplication...
    
    # Announcements
    announcements = home.announcements
    
    @announcements = announcements.subjects
    
    #p @announcements
    
    # Calendar
    calendar = announcements.calendar
    calendar.view="List of Events"
    calendar.show_events="Events for this month"
    
    @events = calendar.events_list
    
    # Need to clean up the events list to get rid of
    # list items that aren't actual event titles.
    # Also need to remove entries for
    # Assignments...
    @events.delete_if { |event| event =~ /^http.+Description$/ || event =~ /^Due\s/ }
    
    #p @events
   
    # Discussion Forums
    discussion_forums = home.discussion_forums #calendar.discussion_forums
    
    # Get the list of forums
    @forum_list = discussion_forums.forum_list
    
    # Messages
    messages = discussion_forums.messages
    
    @message_folders = messages.folders
    
    received = messages.received
    
    @messages = received.subjects
    
    #p @messages
    
    # Forums
    forums = received.forums
    
    @forum_titles = forums.forum_titles
    @topic_titles = forums.topic_titles
    
    # Email Archive
    email = forums.email_archive

    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Chat Room
    chat_room = email.chat_room
    
    @total_messages = chat_room.total_messages_shown
    
    #p @total_messages
    
    # Blogs
    blogs = chat_room.blogs
    
    @bloggers = blogs.blogger_list
    
    #p @bloggers
    
    # Blogger
    blogger = blogs.blogger
    
    @blogger_titles = blogger.post_titles
    
    #p @blogger_titles
    
    # Polls
    polls = blogger.polls
    
    @poll_questions = polls.questions
    
    #p @poll_questions
    
    # Syllabus
    syllabus = polls.syllabus
    edit = syllabus.create_edit
    
    @syllabus_items = edit.syllabus_titles
    
    #p @syllabus_items
    
    # Lessons
    lessons = edit.lessons
    
    @lessons = lessons.lessons_list
    
    #p @lessons
    
    @sections = []
    @lessons.each do |lesson|
      @sections << lessons.sections_list(lesson)
    end
    
    #p @sections
    
    # Resources
    resources = lessons.resources
    
    @file_folders = resources.folder_names
    
    #p @file_folders
    
    # Remove the "root" folder from the list...
    @file_folders.delete_at(0)
    
    @file_folders.each { |folder| resources.open_folder(folder) }
    
    @file_names = resources.file_names

    #p @file_names
    
    # Assignments
    assignments = resources.assignments
    
    @assignments = assignments.assignment_titles
    
    # Have to add "Draft - " to all assignment titles that don't
    # already have that, since the new site will put all
    # assignments into Draft status.
    @assignments.map! do |assignment|
      unless assignment =~ /^Draft\s-\s/
        "Draft - " + assignment
      else
        assignment
      end
    end
    
    #p @assignments
    
    # Tests & Quizzes
    assessments = assignments.tests_and_quizzes
    
    @pending_assessments = assessments.pending_assessment_titles
    
    #p @pending_assessments 
    
    # Drop Box
    drop_box = assessments.drop_box
    
    @drop_box_folders = drop_box.folder_names
    
    #p @drop_box_folders
    
    # Gradebook
    gradebook = drop_box.gradebook
    
    @gradebook_items = gradebook.items_titles
    
    #p @gradebook_items

    # Gradebook 2
    gradebook2 = home.gradebook2
    
    @gradebook2_items = gradebook2.gradebook_items
    
    #p @gradebook2_items
    
    # Feedback
    feedback = gradebook2.feedback
    
    @feedback_items = feedback.feedback_items
    
    #p @feedback_items
    
    # Podcasts
    podcasts = feedback.podcasts
    
    @podcasts = podcasts.podcast_titles

    #p @podcasts
    
    # Go to Site Editor
    site_editor = podcasts.site_editor
    
    # Duplicate the Site
    duplicate = site_editor.duplicate_site
    
    # TEST CASE: Verify site name in the header is correct
    assert_equal @site_name, duplicate.site_name
    
    # Get the term value for later...
    @term = duplicate.academic_term
    
    duplicate.site_title=@new_site_title
    
    site_editor = duplicate.duplicate
    
    # Go to the new Site
    home = site_editor.open_my_site_by_name @new_site_title
    
    # Verify that the new Site has all the expected content
    
    # Announcements
    announcements = home.announcements
    
    # TEST CASE: All announcements are present as expected
    assert_equal @announcements, announcements.subjects
    
    # Calendar
    calendar = announcements.calendar
    calendar.view="List of Events"
    calendar.show_events="Events for this month"
    
    @new_events = calendar.events_list
    
    @new_events.delete_if { |event| event =~ /^http.+Description$/}
    
    # TEST CASE: All calendar items copied as expected
    assert_equal @events, @new_events
    
    # Discussion Forums
    discussion_forums = calendar.discussion_forums
    
    # TEST CASE: The discussion forums are there (including any added ones)
    assert_equal @forum_list, discussion_forums.forum_list
    
    @forum_list.each do |forum|
      # TEST CASE: There are no topics in the Forums
      assert_equal "0", discussion_forums.topic_count(forum)
    end
    
    # Messages
    messages = discussion_forums.messages
    
    # TEST CASE: All Folders copied
    assert_equal @message_folders, messages.folders
    
    received = messages.received
    
    # TEST CASE: No messages copied
    assert_not_equal @messages, received.subjects
    
    # Forums
    forums = received.forums
    
    # TEST CASE: Forums copied
    assert_equal @forum_titles, forums.forum_titles
    
    # TEST CASE: Topics copied
    assert_equal @topic_titles, forums.topic_titles
    
    # TEST CASE: Forums have "DRAFT" in front of them.
    @forum_titles.each do |title|
      assert forums.draft?(title)
    end
    
    # Email Archive
    email = forums.email_archive
    
    # TEST CASE: No emails copied
    
    # Chat Room
    chat = email.chat_room
    
    # TEST CASE: No chat messages copied
    assert_not_equal @total_messages, chat.total_messages_shown
    
    # Blogs
    blogs = chat.blogs
    
    # TEST CASE: Blogs did not copy
    assert_not_equal @bloggers, blogs.blogger_list
    
    # Blogger
    blogger = blogs.blogger
    
    # TEST CASE: Blog titles are not copied
    assert_not_equal @blogger_titles, blogger.post_titles
    
    # Polls
    polls = blogger.polls
    
    # TEST CASE: Polls did copy?
    assert_equal @poll_questions, polls.questions
    
    # Syllabus
    syllabus = polls.syllabus
    edit = syllabus.create_edit
    
    # TEST CASE: Syllabus items appear as expected
    assert_equal @syllabus_items, edit.syllabus_titles
    
    # Lessons
    lessons = edit.lessons
    
    # TEST CASE: Lessons appear as expected
    assert_equal @lessons, lessons.lessons_list
    
    @lessons.each_with_index do | lesson, index |
      
      # TEST CASE: Sections appear as expected
      assert_equal @sections[index], lessons.sections_list(lesson)
      
    end
    
    # Resources
    resources = lessons.resources
    
    @new_site_folders = resources.folder_names
    @new_site_folders.delete_at(0)
    
    # TEST CASE: Folder names appear as expected
    assert_equal @file_folders, @new_site_folders
    
    @file_folders.each { |folder| resources.open_folder(folder) }
    
    # TEST CASE: File names appear as expected
    assert_equal @file_names, resources.file_names
    
    # Assignments
    assignments = resources.assignments
    
    # TEST CASE: Check assignments appear as expected
    assert_equal @assignments, assignments.assignment_titles
    
    # Tests & Quizzes
    assessments = assignments.tests_and_quizzes
    
    # TEST CASE: Pending Assessments appear in the list as expected
    assert_equal @pending_assessments, assessments.pending_assessment_titles
    
    # TEST CASE: There are no published or Inactive Assessments listed.
    assert_equal [], assessments.published_assessment_titles
    assert_equal [], assessments.inactive_assessment_titles
    
    # Drop Box
    drop_box = assessments.drop_box
    
    # TEST CASE: Verify student folders didn't copy
    assert_not_equal @drop_box_folders, drop_box.folder_names
    
    # Gradebook
    gradebook = drop_box.gradebook
    
    # TEST CASE: Expected Assignments appear in the list
    assert_equal @gradebook_items, gradebook.items_titles
    
    @gradebook_items.each do |assignment|
      
      # TEST CASE: The Assignment is not released to students
      assert_equal "No", gradebook.released_to_students(assignment)
      
      # TEST CASE: There is no due date for the assignments
      assert_equal "-", gradebook.due_date(assignment) #FIXME - this will break if there are future due dates. Need to make this smarter.
      
    end
    
    # Gradebook 2
    gradebook2 = gradebook.gradebook2
    
    # TEST CASE: Verify gradebook items appear as expected
    assert_equal @gradebook2_items, gradebook2.gradebook_items
    
    # Feedback
    feedback = gradebook2.feedback
    
    # TEST CASE: Feedback items do not appear
    assert_not_equal @feedback_items, feedback.feedback_items
    
    # Podcasts
    podcasts = feedback.podcasts
    
    # TEST CASE: Verify podcasts appear
    assert_equal @podcasts, podcasts.podcast_titles
    
  end
  
end
