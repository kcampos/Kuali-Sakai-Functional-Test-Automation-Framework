#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

#require 'watir-webdriver'
require 'page-object'

class SakaiCLE
  
  def initialize(browser)
    @browser = browser
  end
  
  # Logs in to Sakai using the
  # specified credentials. Then it
  # instantiates the MyWorkspace class.
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
    $frame_index=0
    MyWorkspace.new(@browser)
  end
  
  # Clicks the "(Logout)" link in the upper right of the page.
  # Instantiates the Login class.
  def logout
    @browser.link(:text, "Logout").click
    Login.new(@browser)
  end
  
  # Formats a date string Sakai-style.
  # Useful for verifying creation dates and such.
  #
  # Supplied variable must of of the Time class.
  def make_date(time_object)
    month = time_object.strftime("%b ")
    day = time_object.strftime("%d").to_i
    year = time_object.strftime(", %Y ")
    mins = time_object.strftime(":%M %P")
    hour = time_object.strftime("%l").to_i
    return month + day.to_s + year + hour.to_s + mins
  end
  
end

#================
# Page Navigation Objects
#================

# ToolsMenu contains all possible links that could
# be found in the menu along the left side of the Sakai pages.
#
# This includes both the Administration Workspace and the
# Menus that appear when in the context of a particular Site.
module ToolsMenu
  
  include PageObject
  
  # Opens the "My Sites" menu box and then clicks on the link
  # that matches the specified id.
  #
  # Errors out if nothing matches.
  def open_my_site_by_id(id)
    @browser.link(:text, "My Sites").click
    @browser.link(:href, /#{id}/).click
    $frame_index=1
    Home.new(@browser)
  end
  
  # Opens "My Sites" and then clicks on the matching
  # Site name. Shortens the name used for search so
  # that truncated names are not a problem.
  #
  # Will error out if there are not matching links.
  def open_my_site_by_name(name)
    short_name = name[0..19]
    @browser.link(:text, "My Sites").click
    @browser.link(:text, /#{Regexp.escape(short_name)}/).click
    $frame_index=1
    Home.new(@browser)
  end
  
  # Clicks the "Account" link in the Adminstration Workspace
  # then instantiates the UserAccount class.
  #
  # Throws an error if the link is not present.
  def account
    @browser.link(:text=>"Account").click
    UserAccount.new(@browser)
  end
  
  # Clicks the "Aliases" link in the Administration Workspace
  # menu, then instantiates the Aliases class.
  def aliases
    @browser.link(:text=>"Aliases").click
    Aliases.new(@browser)
  end
  
  # Clicks the link for the Administration Workspace, then
  # instantiates the MyWorkspace class.
  def administration_workspace
    @browser.link(:text, "Administration Workspace").click
    $frame_index=1
    MyWorkspace.new(@browser)
  end
  
  # Clicks the Announcements link then instantiates
  # the Announcements class.
  def announcements
    @browser.link(:class=>'icon-sakai-announcements').click
    Announcements.new(@browser)
  end
  
  # Clicks the Assignments link, then instantiates
  # the Assignments class.
  def assignments
    @browser.link(:class=>"icon-sakai-assignment-grades").click
    AssignmentsList.new(@browser)
  end
  
  def basic_lti
    @browser.link(:class=>"icon-sakai-basiclti").click
    BasicLTI.new(@browser)
  end
  
  def blogs
    @browser.link(:class=>"icon-sakai-blogwow").click
    Blogs.new(@browser)
  end
  
  # Clicks the Blogger link in the Site menu and
  # instantiates the Blogger Class.
  def blogger
    @browser.link(:class=>"icon-blogger").click
    Blogger.new(@browser)
  end
  
  # Clicks the Calendar link, then instantiates
  # the Calendar class.
  def calendar
    @browser.link(:text=>"Calendar").click
    Calendar.new(@browser)
  end
  
  link(:certification, :text=>"Certification")
  
  def chat_room
    @browser.link(:class=>"icon-sakai-chat").click
    ChatRoom.new(@browser)
  end

  link(:configuration_viewer, :text=>"Configuration Viewer")
  link(:customizer, :text=>"Customizer")
  
  # Clicks the "Discussion Forums" link in the menu,
  # then instantiates the JForum page class.
  def discussion_forums
    @browser.link(:class=>"icon-sakai-jforum-tool").click
    JForums.new(@browser)
  end
  
  def drop_box
    @browser.link(:class=>"icon-sakai-dropbox").click
    DropBox.new(@browser)
  end

  link(:email, :text=>"Email")
  
  def email_archive
    @browser.link(:class=>"icon-sakai-mailbox").click
    EmailArchive.new(@browser)
  end
  
  link(:email_template_administration, :text=>"Email Template Administration")
  
  def evaluation_system
    @browser.link(:class=>"icon-sakai-rsf-evaluation").click
    EvaluationSystem.new(@browser)
  end
  
  def feedback
    @browser.link(:class=>"icon-sakai-postem").click
    Feedback.new(@browser)
  end
  
  # Clicks the Forms link that is found in menus for
  # Portfolio sites.
  def forms
    @browser.link(:text=>"Forms", :class=>"icon-sakai-metaobj").click
    Forms.new(@browser)
  end
  
  # Clicks the Forums link, then instantiates
  # the forums class.
  def forums
    @browser.link(:text=>"Forums").click
    Forums.new(@browser)
  end
  
  # Clicks the Glossary link, then instantiates the Glossary Class.
  def glossary
    @browser.link(:text=>"Glossary").click
    Glossary.new(@browser)
  end
  
  # Clicks the "Gradebook" link, then
  # instantiates the Gradebook Class.
  def gradebook
    @browser.link(:text=>"Gradebook").click
    Gradebook.new(@browser)
  end
  
  def gradebook2
    @browser.link(:text=>"Gradebook2").click
    frm.div(:id=>"borderLayoutContainer").wait_until_present
    Gradebook2.new(@browser)
  end
  
  link(:help, :text=>"Help")
  
  # Clicks the Home link, then instantiates the
  # Home class--unless the target page happens to be
  # My Workspace, in which case the MyWorkspace
  # page is instantiated.
  def home
    @browser.link(:text, "Home").click
    if @browser.div(:id=>"siteTitle").text == "My Workspace"
      MyWorkspace.new(@browser)
    else
      Home.new(@browser)
    end
  end
  
  # Clicks the Job Scheduler link, then
  # instantiates the Job Scheduler class.
  def job_scheduler
    @browser.link(:text=>"Job Scheduler").click
    JobScheduler.new(@browser)
  end
  
  # Clicks the Lessons link, then instantiates
  # the Lessons class.
  def lessons
    @browser.link(:text=>"Lessons").click
    Lessons.new(@browser)
  end
  
  link(:lesson_builder, :text=>"Lesson Builder")
  link(:link_tool, :text=>"Link Tool")
  link(:live_virtual_classroom, :text=>"Live Virtual Classroom")
  
  # Clicks the "Matrices" link, then
  # instantiates the Matrices Class.
  def matrices
    @browser.link(:text=>"Matrices").click
    Matrices.new(@browser)
  end
  
  def media_gallery
    @browser.link(:class=>"icon-sakai-kaltura").click
    MediaGallery.new(@browser)
  end
  
  link(:membership, :text=>"Membership")
  link(:memory, :text=>"Memory")
  
  # Clicks the Messages link, then instantiates the Messages class.
  def messages
    @browser.link(:text=>"Messages").click
    Messages.new(@browser)
  end
  
  link(:my_sites, :text=>"My Sites")
  
  # Clicks the "My Workspace" link, sets the
  # $frame_index global variable to 0, then instantiates
  # the MyWorkspace Class.
  def my_workspace
    @browser.link(:text=>"My Workspace").click
    $frame_index=0
    MyWorkspace.new(@browser)
  end
  
  def news
    @browser.link(:class=>"icon-sakai-news").click
    News.new(@browser)
  end
  
  link(:online, :text=>"On-Line")
  link(:oauth_providers, :text=>"Oauth Providers")
  link(:oauth_tokens, :text=>"Oauth Tokens")
  link(:openSyllabus, :text=>"OpenSyllabus")
  
  def podcasts
    @browser.link(:class=>"icon-sakai-podcasts").click
    Podcasts.new(@browser)
  end

  def polls
    @browser.link(:class=>"icon-sakai-poll").click
    Polls.new(@browser)
  end
  
  def portfolios
    @browser.link(:class=>"icon-osp-presentation").click
    Portfolios.new @browser
  end
  
  # Clicks the Portfolio Templates link, then
  # instantiates the Portfolio 
  def portfolio_templates
    @browser.link(:text=>"Portfolio Templates").click
    PortfolioTemplates.new(@browser)
  end
  
  link(:preferences, :text=>"Preferences")
  
  def profile
    @browser.link(:text=>"Profile").click
    Profile.new @browser
  end
  
  def profile2
    @browser.link(:class=>"icon-sakai-profile2").click
    Profile2.new @browser
  end
  
  link(:realms, :text=>"Realms")
  
  # Clicks the Resources link, then instantiates
  # the Resources class.
  def resources
    @browser.link(:text, "Resources").click
    Resources.new(@browser)
  end
  
  def roster
    @browser.link(:class=>"icon-sakai-site-roster").click
    Roster.new @browser
  end
  
  link(:rsmart_support, :text=>"rSmart Support")
  
  # Because "Search" is used in many pages,
  # The Search button found in the Site Management
  # Menu must be given the more explicit name
  # 
  def site_management_search
    @browser.link(:class=>"icon-sakai-search").click
  end
  
  def sections
    @browser.link(:class=>"icon-sakai-sections").click
    Sections.new(@browser)
  end
  
  link(:site_archive, :text=>"Site Archive")
  
  # Clicks the Site Editor link, then instantiates
  # the Site Editor class.
  def site_editor
    @browser.link(:text=>"Site Editor").click
    SiteEditor.new(@browser)
  end
  
  # Clicks the Site Setup link, then instantiates
  # The SiteEditor class.
  def site_setup
    @browser.link(:text=>"Site Setup").click
    SiteSetup.new(@browser)
  end
  
  link(:site_statistics, :text=>"Site Statistics")
  
  # Clicks the Sites link, then instantiates
  # the Sites class.
  def sites
    @browser.link(:class=>"icon-sakai-sites").click
    Sites.new(@browser)
  end
  
  link(:skin_manager, :text=>"Skin Manager")
  link(:super_user, :text=>"Super User")
  
  def styles
    @browser.link(:text=>"Styles").click
    Styles.new(@browser)
  end
  
  # Clicks the Syllabus link, then instantiates
  # the Syllabus class.
  def syllabus
    @browser.link(:text=>"Syllabus").click
    Syllabus.new(@browser)
  end
  
  # Clicks the Tests & Quizzes link, then
  # instantiates the AssessmentsList class.
  def tests_and_quizzes
    # Need this logic to determine whether user
    # is a student or instructor/admin
    @browser.link(:class, "icon-sakai-siteinfo").exist? ? x=0 : x=1
    @browser.link(:text=>"Tests & Quizzes").click
    x==0 ? AssessmentsList.new(@browser) : TakeAssessmentList.new(@browser)
  end
  
  # Synonym for tests_and_quizzes method.
  def assessments
    tests_and_quizzes
  end
  
  def user_membership
    @browser.link(:class=>"icon-sakai-usermembership").click
    UserMembership.new(@browser)
  end
  
  def users
    @browser.link(:class=>"icon-sakai-users").click
    Users.new(@browser)
  end
  
  def web_content
    @browser.link(:class=>"icon-sakai-iframe").click
    WebContent.new(@browser)
  end
  
  def wiki
    @browser.link(:class=>"icon-sakai-rwiki").click
    Wikis.new(@browser)
  end
  
  # The Page Reset button, found on all Site pages
  def reset
    @browser.link(:href=>/tool-reset/).click
    page_title = @browser.div(:class=>"title").text
    case(page_title)
    when "Lessons"
      Lessons.new(@browser)
    when "Syllabus"
      Syllabus.new(@browser)
    when "Portfolios"
      Portfolios.new @browser
    # Add more cases here, as necessary...
    end
  end
  
  # Shortcut method so you don't have to type out
  # the whole string: @browser.frame(:index=>index)
  def frm
    @browser.frame(:class=>"portletMainIframe")
  end
  
end

# This is a module containing methods that are
# common to all the question pages inside the
# Assessment section of a Site.
module QuestionHelpers
  
  include PageObject
  
  # Saves the question by clicking the Save button, then makes the determination
  # whether to instantiate the EditAssessment class, or the EditQuestionPool class.
  def save
    
    quiz = frm.div(:class=>"portletBody").div(:index=>0).text
    pool = frm.div(:class=>"portletBody").div(:index=>1).text
    
    frm.button(:value=>"Save").click
    
    if quiz =~ /^Assessments/
      EditAssessment.new(@browser)
    elsif pool =~ /^Question Pools/
      EditQuestionPool.new(@browser)
    else
      puts "Unexpected text: "
      p pool
      p quiz
    end
    
  end
  
  in_frame(:index=>1) do |frame|
    link(:assessments, :text=>"Assessments", :frame=>frame)
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    link(:question_pools, :text=>"Question Pools", :frame=>frame)
    link(:questions, :text=>/Questions:/, :frame=>frame)
  end
  
end

# This module consolidates the code that can be shared among all the
# File Upload and Attachment pages.
#
# Not every method in this module will be appropriate for every attachment page.
class AttachPageTools
  
  @@classes = { :this=>"Superclassdummy", :parent=>"Superclassdummy" }
  
  # Use this for debugging purposes only...
  def what_is_parent?
    puts @@classes[:parent]
  end
  
  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    frm.table(:class=>/listHier lines/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist? == false
      names << row.td(:class=>"specialLink").link(:title=>"Folder").text
    end
    return names
  end
  
  # Returns an array of the file names currently listed
  # on the page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    frm.table(:class=>/listHier lines/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist?
      names << row.td(:class=>"specialLink").link(:href=>/access.content/, :index=>1).text
    end
    return names
  end
  
  # Clicks the Select button next to the specified file.
  def select_file(filename)
    frm.table(:class=>/listHier lines/).row(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click
  end

  # Clicks the Remove button.
  def remove
    frm.button(:value=>"Remove").click
  end
  
  # Clicks the remove link for the specified item in the attachment list.
  def remove_item(file_name)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doRemoveitem/).click
  end
  
  # Clicks the Move button.
  def move
    frm.button(:value=>"Move").click
  end
  
  # Clicks the Show Other Sites link.
  def show_other_sites
    frm.link(:text=>"Show other sites").click
  end
  
  # Clicks on the specified folder image, which
  # will open the folder tree and remain on the page.
  def open_folder(foldername)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(foldername)}/).link(:title=>"Open this folder").click
  end
  
  # Clicks on the specified folder name, which should open
  # the folder contents on a refreshed page.
  def go_to_folder(foldername)
    frm.link(:text=>foldername).click
  end
  
  # Sets the URL field to the specified value.
  def url=(url_string)
    frm.text_field(:id=>"url").set(url_string)
  end
  
  # Clicks the Add button next to the URL field.
  def add
    frm.button(:value=>"Add").click
  end
  
  # Gets the value of the access level cell for the specified
  # file.
  def access_level(filename) 
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(filename)}/)[6].text
  end
  
  def edit_details(name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).li(:text=>/Action/, :class=>"menuOpen").fire_event("onclick")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).link(:text=>"Edit Details").click
    instantiate_class(:file_details)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    instantiate_class(:create_folders)
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle folder or a subfolder therein)
  #
  # Does NOT instantiate any class, so use only when no page refresh occurs.
  def upload_file(filename)
    frm.file_field(:id=>"upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_file(filename)
    end
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-cle folder or a subfolder therein)
  #
  # Use this method ONLY for instances where there's a file field on the page
  # with an "upload" id.
  def upload_local_file(filename)
    frm.file_field(:id=>"upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_local_file(filename)
    end
    instantiate_class(:this)
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_file_to_folder(folder_name)
    upload_files_to_folder(folder_name)
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_files_to_folder(folder_name)
    if frm.li(:text=>/A/, :class=>"menuOpen").exist?
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).li(:text=>/A/, :class=>"menuOpen").fire_event("onclick")
    else
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    end
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
    instantiate_class(:upload_files)
  end
  
  # Clicks the "Attach a copy" link for the specified
  # file, then reinstantiates the Class.
  # If an alert box appears, the method will call itself again.
  # Note that this can lead to an infinite loop. Will need to fix later.
  def attach_a_copy(file_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doAttachitem/).click
    if frm.div(:class=>"alertMessage").exist?
      sleep 1
      attach_a_copy(file_name) # FIXME
    end
    instantiate_class(:this)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    instantiate_class(:create_folders)
  end
  
  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it re-instantiates the AnnouncementsAttach page class.
  def upload_multiple_files_to_folder(folder, file_array)
    
    upload = upload_files_to_folder folder
    
    file_array.each do |file|
      upload.file_to_upload=file
      upload.add_another_file
    end
    
    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload=file
        resources = upload_files.upload_files_now
      end
    end
    instantiate_class(:this)
  end

  # Clicks the Continue button then
  # decides which page class to instantiate
  # based on the page that appears. This is going to need to be fixed.
  def continue
    frm.div(:class=>"highlightPanel").span(:id=>"submitnotifxxx").wait_while_present
    frm.button(:value=>"Continue").click
    page_title = @browser.div(:class=>"title").text
    case(page_title)
    when "Lessons"
      instantiate_class(:parent)
    when "Assignments"
      if frm.div(:class=>"portletBody").h3.text=~/In progress/ || frm.div(:class=>"portletBody").h3.text == "Select supporting files"
        instantiate_class(:second)
      elsif frm.div(:class=>"portletBody").h3.text=~/edit/i || frm.div(:class=>"portletBody").h3.text=~/add/i
        instantiate_class(:parent)
      elsif frm.form(:id=>"gradeForm").exist?
        instantiate_class(:third)
      end
    when "Forums"
      if frm.div(:class=>"portletBody").h3.text == "Forum Settings"
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    when "Messages"
      if frm.div(:class=>/breadCrumb/).text =~ /Reply to Message/
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    when "Calendar"
      frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).wait_until_present
      instantiate_class(:parent)
    when "Portfolio Templates"
      if frm.div(:class=>"portletBody").h3.text=="Select supporting files"
        instantiate_class(:second)
      else
        instantiate_class(:parent)
      end
    else
      instantiate_class(:parent)
    end  
  end
  
  private
  
  # This is a private method that is only used inside this superclass.
  def instantiate_class(key)
    eval(@@classes[key]).new(@browser)
  end
  
  # This is another private method--a better way to
  # instantiate the @@classes hash variable.
  def set_classes_hash(hash_object)
    @@classes = hash_object
  end
  
end

# Need this to extend Watir to be able to attach to Sakai's non-standard tags...
module Watir 
  class Element
    # attaches to the "headers" tags inside of the assignments table.
    def headers
      @how = :ole_object 
      return @o.headers
    end
    
    # attaches to the "for" tags in "label" tags.
    def for
      @how = :ole_object 
      return @o.for
    end
    
  end 
end