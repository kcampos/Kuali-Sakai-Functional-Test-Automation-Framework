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
    discussion_forums = calendar.discussion_forums
    
    # ======================
    # FIXME - Add steps for getting Discussions and Topic names here
    # ======================
    
    # Messages
    messages = discussion_forums.messages
    
    @message_folders = messages.folders
    
    #p @folders
    
    received = messages.received
    
    @messages = received.subjects
    
    #p @messages
    
    # Forums
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Email Archive
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    # Chat Room
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Blogs
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Blogger
    blogger = received.blogger
    
    @blogger_titles = blogger.post_titles
    
    #p @blogger_titles
    
    # Polls
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Syllabus
    syllabus = blogger.syllabus
    edit = syllabus.create_edit
    
    @syllabus_items = edit.syllabus_titles
    
    #p @syllabus_items
    
    # Lessons
    lessons = edit.lessons
    
    @lessons = lessons.lessons_list
    
    @sections = []
    @lessons.each do |lesson|
      @sections << lessons.sections_list(lesson)
    end
    
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
    assignments = home.assignments #resources.assignments
    
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
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Gradebook
    gradebook = assessments.gradebook
    
    @gradebook_items = gradebook.items_titles
    
    #p @gradebook_items
    
    # Gradebook 2
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Feedback
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Podcasts
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Wiki
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # News
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Web Content
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Basic LTI
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================

    
    # Media Gallery
    
    # ======================
    # FIXME - Need to add data gathering steps here.
    # ======================
    
    # Go to Site Editor
    site_editor = gradebook.site_editor
    
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
    
    # TEST CASE: All Forums copied
    #assert_equal
    
    # TEST CASE: All Topics copied
    #assert_equal
    
    # Messages
    messages = discussion_forums.messages
    
    # TEST CASE: All Folders copied
    assert_equal @message_folders, messages.folders
    
    received = messages.received
    
    # TEST CASE: No messages copied
    assert_not_equal @messages, received.subjects
    
    # Forums
    
    # Email Archive
    
    # Chat Room
    
    # Blogs
    
    # Blogger
    blogger = received.blogger
    
    # TEST CASE: Blog titles are not copied
    assert_not_equal @blogger_titles, blogger.post_titles
    
    # Polls
    
    # Syllabus
    syllabus = blogger.syllabus
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
    
    # Gradebook
    gradebook = assessments.gradebook
    
    # TEST CASE: Expected Assignments appear in the list
    assert_equal @gradebook_items, gradebook.items_titles
    
    @gradebook_items.each do |assignment|
      
      # TEST CASE: The Assignment is not released to students
      assert_equal "No", gradebook.released_to_students(assignment)
      
      # TEST CASE: There is no due date for the assignments
      assert_equal "-", gradebook.due_date(assignment)
      
    end
    
    # Gradebook 2
    
    # Feedback
    
    # Podcasts
    
    # Wiki
    
    # News
    
    # Web Content
    
    # Basic LTI
    
    # Media Gallery
    
  end
  
end
