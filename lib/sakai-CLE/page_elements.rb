# Navigation links in Sakai
# 
# == Synopsis
#
# Defines all objects in Sakai Pages. Uses the PageObject gem
# to create methods to interact with those objects.
#
# Author :: Abe Heward (aheward@rsmart.com)

# Page-object is the gem that parses each of the listed objects.
# For details on the page-object gem and how to use it, visit:
# https://github.com/cheezy/page-object/wiki/page-object
#
# Also, see the bottom of this script for a Page Class template for
# copying when you create a new class.

require 'page-object'

# ToolsMenu contains all possible links that could
# be found in the menu along the left side of the Sakai pages.
module ToolsMenu
  
  include PageObject
  
  # The list of left side menu items, formatted according to the
  # PageObject requirements...
  link(:account, :text=>"Account")
  link(:aliases, :text=>"Aliases")
  link(:announcements, :class => 'icon-sakai-announcements')
  link(:assignments, :text=>"Assignments")
  link(:basic_lti, :text=>"Basic LTI")
  link(:blogs, :text=>"Blogs")
  link(:calendar, :text=>"Calendar")
  link(:certification, :text=>"Certification")
  link(:chat_room, :text=>"Chat Room")
  link(:configuration_viewer, :text=>"Configuration Viewer")
  link(:customizer, :text=>"Customizer")
  link(:discussion_forums, :text=>"Discussion Forums")
  link(:drop_box, :text=>"Drop Box")
  link(:email, :text=>"Email")
  link(:email_archive, :text=>"Email Archive")
  link(:email_template_administration, :text=>"Email Template Administration")
  link(:evaluation_system, :text=>"Evaluation System")
  link(:feedback, :text=>"Feedback")
  link(:forums, :text=>"Forums")
  link(:gradebook, :text=>"Gradebook")
  link(:gradebook2, :text=>"Gradebook2")
  link(:help, :text=>"Help")
  link(:home, :text=>"Home")
  link(:job_scheduler, :text=>"Job Scheduler")
  link(:lessons, :text=>"Lessons")
  link(:lesson_builder, :text=>"Lesson Builder")
  link(:link_tool, :text=>"Link Tool")
  link(:live_virtual_classroom, :text=>"Live Virtual Classroom")
  link(:matrices, :text=>"Matrices")
  link(:media_gallery, :text=>"Media Gallery")
  link(:membership, :text=>"Membership")
  link(:memory, :text=>"Memory")
  link(:messages, :text=>"Messages")
  link(:news, :text=>"News")
  link(:online, :text=>"On-Line")
  link(:oauth_providers, :text=>"Oauth Providers")
  link(:oauth_tokens, :text=>"Oauth Tokens")
  link(:openSyllabus, :text=>"OpenSyllabus")
  link(:podcasts, :text=>"Podcasts")
  link(:polls, :text=>"Polls")
  link(:portfolios, :text=>"Portfolios")
  link(:preferences, :text=>"Preferences")
  link(:profile, :text=>"Profile")
  link(:realms, :text=>"Realms")
  link(:resources, :text=>"Resources")
  link(:roster, :text=>"Roster")
  link(:rsmart_support, :text=>"rSmart Support")
  link(:search, :text=>"Search")
  link(:sections, :text=>"Sections")
  link(:site_archive, :text=>"Site Archive")
  link(:site_editor, :text=>"Site Editor")
  link(:site_setup, :text=>"Site Setup")
  link(:site_statistics, :text=>"Site Statistics")
  link(:sites, :text=>"Sites")
  link(:skin_manager, :text=>"Skin Manager")
  link(:super_user, :text=>"Super User")
  link(:syllabus, :text=>"Syllabus")
  link(:tests_and_quizzes, :text=>"Tests & Quizzes")
  link(:user_membership, :text=>"User Membership")
  link(:users, :text=>"Users")
  link(:web_content, :text=>"Web Content")
  link(:wiki, :text=>"Wiki")
  
  # The Page Reset button, found on all Site pages
  link(:reset, :title=>"Reset")
  
end

# Page for adding a new Announcement
class AddAnnouncements
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    
    # Going to define the WYSIWYG text editor at some later time
    
    text_field(:title, :id=>"subject", :frame=>frame)
    radio_button(:show, :id=>"hidden_false", :frame=>frame)
    radio_button(:hide, :id=>"hidden_true", :frame=>frame)
    radio_button(:specify_dates, :id=>"hidden_specify", :frame=>frame)
    button(:add_attachments, :name=>"attach", :frame=>frame)
    button(:add_announcement, :name=>"post", :frame=>frame)
    button(:preview, :name=>"preview", :frame=>frame)
    button(:clear, :name=>"cancel", :frame=>frame)
    
  end

end
# The Add Multiple Tool Instances page that appears during Site creation
# after the Course Site Tools page
class AddMultipleTools
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # Note that the text field definitions included here
    # for the Tools definitions are ONLY for the first
    # instances of each. Since the UI allows for
    # an arbitrary number, if you are writing tests
    # that add more then you're going to have to explicitly
    # reference them or define them in the test case script
    # itself.
    text_field(:site_email_address, :id=>"emailId", :frame=>frame)
    text_field(:basic_lti_title, :id=>"title_sakai.basiclti", :frame=>frame)
    select_list(:more_basic_lti_tools, :id=>"num_sakai.basiclti", :frame=>frame)
    text_field(:lesson_builder_title, :id=>"title_sakai.lessonbuildertool", :frame=>frame)
    select_list(:more_lesson_builder_tools, :id=>"num_sakai.lessonbuildertool", :frame=>frame)
    text_field(:news_title, :id=>"title_sakai.news", :frame=>frame)
    text_field(:news_url_channel, :name=>"channel-url_sakai.news", :frame=>frame)
    select_list(:more_news_tools, :id=>"num_sakai.news", :frame=>frame)
    text_field(:web_content_title, :id=>"title_sakai.iframe", :frame=>frame)
    text_field(:web_content_source, :id=>"source_sakai.iframe", :frame=>frame)
    select_list(:more_web_content_tools, :id=>"num_sakai.iframe", :frame=>frame)
    button(:continue, :id=>"addButton", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end
# The Add Sections Page in Site Management
class AddSections
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:overview, :id=>"addSectionsForm:_idJsp3", :frame=>frame)
    link(:student_memberships, :id=>"addSectionsForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"addSectionsForm:_idJsp17", :frame=>frame)
    select_list(:num_to_add, :id=>"addSectionsForm:numToAdd", :frame=>frame)
    select_list(:category, :id=>"addSectionsForm:category", :frame=>frame)
    button(:add_sections, :id=>"addSectionsForm:_idJsp89", :frame=>frame)
    button(:cancel, :id=>"addSectionsForm:_idJsp90", :frame=>frame)
    
    # Note that the following field definitions are appropriate for
    # ONLY THE FIRST instance of each of the fields. The Add Sections page
    # allows for an arbitrary number of these fields to exist.
    # If you are going to test the addition of multiple sections
    # and/or meetings, then their elements will have to be
    # explicitly called or defined in the test scripts themselves.
    text_field(:name, :id=>"addSectionsForm:sectionTable:0:titleInput", :frame=>frame)
    radio_button(:unlimited_size, :name=>"addSectionsForm:sectionTable:0:limit", :index=>0, :frame=>frame)
    radio_button(:limited_size, :name=>"addSectionsForm:sectionTable:0:limit", :index=>1, :frame=>frame)
    text_field(:max_enrollment, :id=>"addSectionsForm:sectionTable:0:maxEnrollmentInput", :frame=>frame)
    checkbox(:monday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:monday", :frame=>frame)
    checkbox(:tuesday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:tuesday", :frame=>frame)
    checkbox(:wednesday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:wednesday", :frame=>frame)
    checkbox(:thursday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:thursday", :frame=>frame)
    checkbox(:friday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:friday", :frame=>frame)
    checkbox(:saturday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:saturday", :frame=>frame)
    checkbox(:sunday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:sunday", :frame=>frame)
    text_field(:start_time, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTime", :frame=>frame)
    radio_button(:start_am, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>0, :frame=>frame)
    radio_button(:start_pm, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>1, :frame=>frame)
    text_field(:end_time, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTime", :frame=>frame)
    radio_button(:end_am, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>0, :frame=>frame)
    radio_button(:end_pm, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>1, :frame=>frame)
    text_field(:location, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:location", :frame=>frame)
    link(:add_days, :id=>"addSectionsForm:sectionTable:0:addMeeting", :frame=>frame)
    
  end

end

# The Aliases page
class Aliases
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:new_alias, :text=>"New Alias", :frame=>frame)
    text_field(:search_field, :id=>"search", :frame=>frame)
    link(:search_button, :text=>"Search", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# Announcements page
class Announcements
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:merge, :text=>"Merge", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
    
  end

end

# Page for merging announcements from other sites
class AnnouncementsMerge
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # This page can have an arbitrary number of site checkboxes.
    # Only the first 5 are defined here.
    # The rest will have to be called explicitly in any
    # test case that needs to access those elements
    checkbox(:site1, :id=>"site1", :frame=>frame)
    checkbox(:site2, :id=>"site2", :frame=>frame)
    checkbox(:site3, :id=>"site3", :frame=>frame)
    checkbox(:site4, :id=>"site4", :frame=>frame)
    checkbox(:site5, :id=>"site5", :frame=>frame)
    button(:save, :name=>"eventSubmit_doUpdate", :frame=>frame)
    button(:clear, :name=>"eventSubmit_doCancel", :frame=>frame)
  end

end

# Page for setting up options for announcements
class AnnouncementsOptions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end

end

# Page containing permissions options for announcements
class AnnouncementsPermissions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end

end
# The Course/Section Information page that appears when creating a new Site
class CourseSectionInfo
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # Note that ONLY THE FIRST instances of the
    # subject, course, and section fields
    # are included in the page elements definitions here,
    # because their identifiers are dependent on how
    # many instances exist on the page.
    # This means that if you need to access the second
    # or subsequent of these elements, you'll need to
    # explicitly identify/define them in the test case
    # itself.
    text_field(:subject, :name=>"Subject:0", :frame=>frame)
    text_field(:course, :name=>"Course:0", :frame=>frame)
    text_field(:section, :name=>"Section:0", :frame=>frame)
    text_field(:authorizers_username, :id=>"uniqname", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    select_list(:add_more_rosters, :id=>"number", :frame=>frame)
    button(:continue, :id=>"addButton", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Course Site Access Page that appears during Site creation
# immediately following the Add Multiple Tools page.
class CourseSiteAccess
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    radio_button(:publish_site, :id=>"publish", :frame=>frame)
    radio_button(:leave_as_draft, :id=>"unpublish", :frame=>frame)
    radio_button(:limited, :id=>"unjoinable", :frame=>frame)
    radio_button(:allow, :id=>"joinable", :frame=>frame)
    button(:continue, :name=>"eventSubmit_doUpdate_site_access", :frame=>frame)
    button(:back, :name=>"eventSubmit_doBack", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel_create", :frame=>frame)
    select_list(:joiner_role, :id=>"joinerRole", :frame=>frame)
  end

end

# The Course Site Information page that appears when creating a new Site
# immediately after the Course/Section Information page
class CourseSiteInfo
  
  include PageObject
  include ToolsMenu
  
  # The WYSIWYG FCKEditor on this page will have to be
  # set up carefully, but later. The time for doing this is TBD.
  
  in_frame(:index=>0) do |frame|
    text_field(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
    button(:continue, :name=>"continue", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Course Site Tools page that appears when creating a new Site
# immediately after the Course Site Information page
class CourseSiteTools
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # Note the naming convention used here for the checkboxes:
    # "<checkbox_name>_cb"
    # It's in order that the checkboxes have method names
    # that do not conflict with the method names created
    # in the ToolsMenu for the links that these checkboxes
    # refer to.
    checkbox(:all_tools_cb, :id=>"all", :frame=>frame)
    checkbox(:home_cb, :id=>"home", :frame=>frame)
    checkbox(:announcements_cb, :id=>"sakai.announcements", :frame=>frame)
    checkbox(:assignments_cb, :id=>"sakai.assignment.grades", :frame=>frame)
    checkbox(:basic_lti_cb, :id=>"sakai.basiclti", :frame=>frame)
    checkbox(:blogger_cb, :id=>"blogger", :frame=>frame)
    checkbox(:blogs_cb, :id=>"sakai.blogwow", :frame=>frame)
    checkbox(:calendar_cb, :id=>"sakai.schedule", :frame=>frame)
    checkbox(:certification_cb, :id=>"com.rsmart.certification", :frame=>frame)
    checkbox(:chat_room_cb, :id=>"sakai.chat", :frame=>frame)
    checkbox(:discussion_forums_cb, :id=>"sakai.jforum.tool", :frame=>frame)
    checkbox(:drop_box_cb, :id=>"sakai.dropbox", :frame=>frame)
    checkbox(:email_cb, :id=>"sakai.mailtool", :frame=>frame)
    checkbox(:email_archive_cb, :id=>"sakai.mailbox", :frame=>frame)
    checkbox(:feedback_cb, :id=>"sakai.postem", :frame=>frame)
    checkbox(:forums_cb, :id=>"sakai.forums", :frame=>frame)
    checkbox(:gradebook_cb, :id=>"sakai.gradebook.tool", :frame=>frame)
    checkbox(:gradebook2_cb, :id=>"sakai.gradebook.gwt.rpc", :frame=>frame)
    checkbox(:lesson_builder_cb, :id=>"sakai.lessonbuildertool", :frame=>frame)
    checkbox(:lessons_cb, :id=>"sakai.melete", :frame=>frame)
    checkbox(:live_virtual_classroom_cb, :id=>"rsmart.virtual_classroom.tool", :frame=>frame)
    checkbox(:media_gallery_cb, :id=>"sakai.kaltura", :frame=>frame)
    checkbox(:messages_cb, :id=>"sakai.messages", :frame=>frame)
    checkbox(:news_cb, :id=>"sakai.news", :frame=>frame)
    checkbox(:opensyllabus_cb, :id=>"sakai.opensyllabus.tool", :frame=>frame)
    checkbox(:podcasts_cb, :id=>"sakai.podcasts", :frame=>frame)
    checkbox(:polls_cb, :id=>"sakai.poll", :frame=>frame)
    checkbox(:resources_cb, :id=>"sakai.resources", :frame=>frame)
    checkbox(:roster_cb, :id=>"sakai.site.roster", :frame=>frame)
    checkbox(:search_cb, :id=>"sakai.search", :frame=>frame)
    checkbox(:sections_cb, :id=>"sakai.sections", :frame=>frame)
    checkbox(:site_editor_cb, :id=>"sakai.siteinfo", :frame=>frame)
    checkbox(:site_statistics_cb, :id=>"sitestats", :frame=>frame)
    checkbox(:syllabus_cb, :id=>"sakai.syllabus", :frame=>frame)
    checkbox(:tests_and_quizzes_cb, :id=>"sakai.samigo", :frame=>frame)
    checkbox(:web_content_cb, :id=>"sakai.iframe", :frame=>frame)
    checkbox(:wiki_cb, :id=>"sakai.rwiki", :frame=>frame)
    radio_button(:no_thanks, :id=>"import_no", :frame=>frame)
    radio_button(:yes, :id=>"import_yes", :frame=>frame)
    select_list(:import_sites, :id=>"importSites", :frame=>frame)
    button(:continue, :name=>"Continue", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Page that appears when you create a New Alias
class CreateNewAlias
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    text_field(:alias_name, :id=>"id", :frame=>frame)
    text_field(:target, :id=>"target", :frame=>frame)
    button(:save, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel", :frame=>frame)
    
  end

end

# The Create New Group page inside the Site Editor
class CreateNewGroup

  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"group_title", :frame=>frame)
    text_field(:description, :id=>"group_description", :frame=>frame)
    select_list(:site_member_list, :id=>"siteMembers-selection", :frame=>frame)
    select_list(:group_member_list, :id=>"groupMembers-selection", :frame=>frame)
    button(:right, :name=>"right", :index=>0, :frame=>frame)
    button(:left, :name=>"left", :index=>0, :frame=>frame)
    button(:all_right, :name=>"right", :index=>1, :frame=>frame)
    button(:all_left, :name=>"left",:index=>1, :frame=>frame)
    button(:add, :id=>"save", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The Create New User page
class CreateNewUser
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    text_field(:user_id, :id=>"eid", :frame=>frame)
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
    select_list(:type, :name=>"type", :frame=>frame)
    button(:save_details, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel_changes, :name=>"eventSubmit_doCancel", :frame=>frame)
  end
  
end

# Exactly like the Add Sections page, but used when editing an existing section
class EditSections
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:overview, :id=>"editSectionsForm:_idJsp3", :frame=>frame)
    link(:student_memberships, :id=>"editSectionsForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"editSectionsForm:_idJsp17", :frame=>frame)
    select_list(:num_to_add, :id=>"editSectionsForm:numToAdd", :frame=>frame)
    select_list(:category, :id=>"editSectionsForm:category", :frame=>frame)
    button(:add_sections, :id=>"editSectionsForm:_idJsp89", :frame=>frame)
    button(:cancel, :id=>"editSectionsForm:_idJsp90", :frame=>frame)
    
    # Note that the following field definitions are appropriate for
    # ONLY THE FIRST instance of each of the fields. The Edit Sections page
    # allows for an arbitrary number of these fields to exist.
    # If you are going to test the editing of multiple sections
    # and/or meetings, then their elements will have to be
    # explicitly called or defined in the test scripts themselves.
    text_field(:name, :id=>"editSectionsForm:sectionTable:0:titleInput", :frame=>frame)
    radio_button(:unlimited_size, :name=>"editSectionsForm:sectionTable:0:limit", :index=>0, :frame=>frame)
    radio_button(:limited_size, :name=>"editSectionsForm:sectionTable:0:limit", :index=>1, :frame=>frame)
    text_field(:max_enrollment, :id=>"editSectionsForm:sectionTable:0:maxEnrollmentInput", :frame=>frame)
    checkbox(:monday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:monday", :frame=>frame)
    checkbox(:tuesday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:tuesday", :frame=>frame)
    checkbox(:wednesday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:wednesday", :frame=>frame)
    checkbox(:thursday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:thursday", :frame=>frame)
    checkbox(:friday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:friday", :frame=>frame)
    checkbox(:saturday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:saturday", :frame=>frame)
    checkbox(:sunday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:sunday", :frame=>frame)
    text_field(:start_time, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTime", :frame=>frame)
    radio_button(:start_am, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>0, :frame=>frame)
    radio_button(:start_pm, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>1, :frame=>frame)
    text_field(:end_time, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTime", :frame=>frame)
    radio_button(:end_am, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>0, :frame=>frame)
    radio_button(:end_pm, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>1, :frame=>frame)
    text_field(:location, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:location", :frame=>frame)
    link(:add_days, :id=>"editSectionsForm:sectionTable:0:addMeeting", :frame=>frame)
    
  end

end

# Page for editing an existing Alias record
class EditAlias
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:remove_alias, :text=>"Remove Alias", :frame=>frame)
    text_field(:target, :id=>"target", :frame=>frame)
    button(:save, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel", :frame=>frame)
    
  end

end

# Groups page inside the Site Editor
class Groups
    
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    link(:create_new_group, :text=>"Create New Group", :frame=>frame)
    link(:auto_groups, :text=>"Auto Groups", :frame=>frame)
    button(:remove_checked, :id=>"delete-groups", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# Topmost page for a Site in Sakai
class Home
  
  include PageObject
  include ToolsMenu
  
  # Because the links below are contained within iframes
  # we need the in_frame method in place so that the
  # links can be properly parsed in the PageObject
  # methods for them.
  # Note that the iframes are being identified by their
  # index values on the page. This is a very brittle
  # method for identifying them, but for now it's our
  # only option because both the <id> and <name>
  # tags are unique for every site.
  in_frame(:index=>1) do |frame|
    # Site Information Display, Options button
    link(:site_info_display_options, :text=>"Options", :frame=>frame)
    
  end
  
  in_frame(:index=>2) do |frame|
    # Recent Announcements Options button
    link(:recent_announcements_options, :text=>"Options", :frame=>frame)
  
  end
  
  in_frame(:index=>2) do |frame|
    # Link for New In Forms
    link(:new_in_forums, :text=>"New Messages", :frame=>frame)
  end
end

# The Page that appears when you are not in a particular Site
class MyWorkspace
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end
end

# Realms page
class Realms
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:new_realm, :text=>"New Realm", :frame=>frame)
    link(:search, :text=>"Search", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    
  end

end

# The Search page
class Search
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:admin, :text=>"Admin", :frame=>frame)
    text_field(:search_field, :id=>"search", :frame=>frame)
    button(:search_button, :name=>"sb", :frame=>frame)
    radio_button(:this_site, :id=>"searchSite", :frame=>frame)
    radio_button(:all_my_sites, :id=>"searchMine", :frame=>frame)
    
  end

end

# The Search Admin page
class SearchAdmin
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:search, :text=>"Search", :frame=>frame)
    link(:rebuild_site_index, :text=>"Rebuild Site Index", :frame=>frame)
    link(:refresh_site_index, :text=>"Refresh Site Index", :frame=>frame)
    link(:rebuild_whole_index, :text=>"Rebuild Whole Index", :frame=>frame)
    link(:refresh_whole_index, :text=>"Refresh Whole Index", :frame=>frame)
    link(:remove_lock, :text=>"Remove Lock", :frame=>frame)
    link(:reload_index, :text=>"Reload Index", :frame=>frame)
    link(:enable_diagnostics, :text=>"Enable Diagnostics", :frame=>frame)
    link(:disable_diagnostics, :text=>"Disable Diagnostics", :frame=>frame)
  end

end

# Sections Options page in the Site Management section
class SectionsOptions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    checkbox(:students_can_sign_up, :id=>"optionsForm:selfRegister", :frame=>frame)
    checkbox(:students_can_switch_sections, :id=>"optionsForm:selfSwitch", :frame=>frame)
    button(:update, :id=>"optionsForm:_idJsp50", :frame=>frame)
    button(:cancel, :id=>"optionsForm:_idJsp51", :frame=>frame)
    link(:overview, :id=>"optionsForm:_idJsp3", :frame=>frame)
    link(:add_sections, :id=>"optionsForm:_idJsp8", :frame=>frame)
    link(:student_memberships, :id=>"optionsForm:_idJsp12", :frame=>frame)
    
  end

end

# The Sections page in Site Management
class SectionsOverview
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:add_sections, :id=>"overviewForm:_idJsp8", :frame=>frame)
    link(:student_memberships, :id=>"overviewForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"overviewForm:_idJsp17", :frame=>frame)
    link(:sort_name, :id=>"overviewForm:sectionsTable:_idJsp54", :frame=>frame)
    link(:sort_ta, :id=>"overviewForm:sectionsTable:_idJsp73", :frame=>frame)
    link(:sort_day, :id=>"overviewForm:sectionsTable:_idJsp78", :frame=>frame)
    link(:sort_time, :id=>"overviewForm:sectionsTable:_idJsp83", :frame=>frame)
    link(:sort_location, :id=>"overviewForm:sectionsTable:_idJsp88", :frame=>frame)
    link(:sort_current_size, :id=>"overviewForm:sectionsTable:_idJsp93", :frame=>frame)
    link(:sort_avail, :id=>"overviewForm:sectionsTable:_idJsp97", :frame=>frame)
    
  end

end

# Sites page
class Sites
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:new_site, :text=>"New Site", :frame=>frame)
    text_field(:search_field, :id=>"search", :frame=>frame)
    link(:search_button, :text=>"Search", :frame=>frame)
    text_field(:search_site_id, :id=>"search_site", :frame=>frame)
    link(:search_site_id_button, :text=>"Site ID", :frame=>frame)
    text_field(:search_user_id, :id=>"search_user", :frame=>frame)
    link(:search_user_id_button, :text=>"User ID", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# The Site Editor page
class SiteEditor
  
  include PageObject
  include ToolsMenu
  
  # Again we are defining the page <iframe> by its index.
  # This is a bad way to do it, but unless there's a
  # persistent and consistent <id> or <name> tag for the
  # iframe then this is our best option.
  in_frame(:index=>1) do |frame|
    link(:edit_site_information, :text=>"Edit Site Information", :frame=>frame)
    link(:edit_tools, :text=>"Edit Tools", :frame=>frame)
    link(:add_participants, :text=>"Add Participants", :frame=>frame)
    link(:edit_class_rosters, :text=>"Edit Class Roster(s)", :frame=>frame)
    link(:manage_groups, :text=>"Manage Groups", :frame=>frame)
    link(:link_to_parent_site, :text=>"Link to Parent Site", :frame=>frame)
    link(:manage_access, :text=> "Manage Access", :frame=>frame)
  end

end

# The Site Setup page
class SiteSetup
  
  include PageObject
  include ToolsMenu

  in_frame(:index=>0) do |frame|
    link(:new, :text=>"New", :frame=>frame)
    link(:edit, :text=>"Edit", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
    text_field(:search, :id=>"search", :frame=>frame)
    button(:search, :value=>"Search", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    link(:sort_by_title, :text=>"Worksite Title", :frame=>frame)
    link(:sort_by_type, :text=>"Type", :frame=>frame)
    link(:sort_by_creator, :text=>"Creator", :frame=>frame)
    link(:sort_by_status, :text=>"Status", :frame=>frame)
    link(:sort_by_date, :text=>"Creation Date", :frame=>frame)
  end

end

# Site Setup Review page -- appears at the end of the Site creation process
class SiteSetupReview
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    button(:request_site, :id=>"addSite", :frame=>frame)
    button(:back, :id=>"back", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end

end

#The Site Type page that appears when creating a new site
class SiteType
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    radio_button(:course_site, :id=>"course", :frame=>frame)
    radio_button(:project_site, :id=>"project", :frame=>frame)
    radio_button(:portfolio_site, :id=>"portfolio", :frame=>frame)
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
    button(:continue, :id=>"submitBuildOwn", :frame=>frame)
    button(:cancel, :id=>"cancelCreate", :frame=>frame)
  end
  
  
end

# The Users page
class Users
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:new_user, :text=>"New User", :frame=>frame)
    link(:search, :text=>"Search", :frame=>frame)
    text_field(:search, :id=>"search", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end
  
end

# User Membership page for admin users
class UserMembership
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    select_list(:user_type, :id=>"userlistForm:selectType", :frame=>frame)
    select_list(:user_authority, :id=>"userlistForm:selectAuthority", :frame=>frame)
    text_field(:search_field, :id=>"userlistForm:inputSearchBox", :frame=>frame)
    button(:search_button, :id=>"userlistForm:searchButton", :frame=>frame)
    button(:clear_search, :id=>"userlistForm:clearSearchButton", :frame=>frame)
    select_list(:page_size, :id=>"userlistForm:pager_pageSize", :frame=>frame)
    button(:export_csv, :id=>"userlistForm:exportCsv", :frame=>frame)
    button(:export_excel, :id=>"userlistForm:exportXls", :frame=>frame)
    link(:sort_user_id, =>"userlistForm:_idJsp13:_idJsp14", :frame=>frame)
    link(:sort_internal_user_id, :id=>"userlistForm:_idJsp13:_idJsp18", :frame=>frame)
    link(:sort_name, :id=>"userlistForm:_idJsp13:_idJsp21", :frame=>frame)
    link(:sort_email, :id=>"userlistForm:_idJsp13:_idJsp24", :frame=>frame)
    link(:sort_type, :id=>"userlistForm:_idJsp13:_idJsp28", :frame=>frame)
    link(:sort_authority, :id=>"userlistForm:_idJsp13:_idJsp31", :frame=>frame)
    link(:sort_created_on, :id=>"userlistForm:_idJsp13:_idJsp34", :frame=>frame)
    link(:sort_modified_on, :id=>"userlistForm:_idJsp13:_idJsp37", :frame=>frame)
    #(:, =>"", :frame=>frame)
    
  end

end

=begin

# New class template. For quick class creation...
class Template
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end

end
=end