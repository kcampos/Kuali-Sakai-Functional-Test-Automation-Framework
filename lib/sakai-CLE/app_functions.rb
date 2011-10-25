#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

require 'watir-webdriver'
require 'page-object'
require File.dirname(__FILE__) + '/site_page_elements.rb'
require File.dirname(__FILE__) + '/admin_page_elements.rb'
require File.dirname(__FILE__) + '/common_page_elements.rb'

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
    MyWorkspace.new(@browser)
  end
  
  # Clicks the "(Logout)" link in the upper right of the page.
  def logout
    @browser.link(:text, "Logout").click
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
    short_name = name[0..20]
    @browser.link(:text, "My Sites").click
    @browser.link(:text, /#{Regexp.escape(short_name)}/).click
    $frame_index=1
    Home.new(@browser)
  end
  
  # Clicks the "Account" link in the Adminstration Workspace
  # then instantiates the Account class.
  #
  # Throws an error if the link is not present.
  def account
    @browser.link(:text=>"Account").click
    Account.new(@browser)
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
  
  link(:basic_lti, :text=>"Basic LTI")
  link(:blogs, :text=>"Blogs")
  
  # Clicks the Calendar link, then instantiates
  # the Calendar class.
  def calendar
    @browser.link(:text=>"Calendar").click
    Calendar.new(@browser)
  end
  
  link(:certification, :text=>"Certification")
  link(:chat_room, :text=>"Chat Room")
  link(:configuration_viewer, :text=>"Configuration Viewer")
  link(:customizer, :text=>"Customizer")
  
  # Clicks the "Discussion Forums" link in the menu,
  # then instantiates the JForum page class.
  def discussion_forums
    @browser.link(:class=>"icon-sakai-jforum-tool").click
    JForums.new(@browser)
  end
  
  link(:drop_box, :text=>"Drop Box")
  link(:email, :text=>"Email")
  link(:email_archive, :text=>"Email Archive")
  link(:email_template_administration, :text=>"Email Template Administration")
  link(:evaluation_system, :text=>"Evaluation System")
  link(:feedback, :text=>"Feedback")
  
  # Clicks the Forums link, then instantiates
  # the forums class.
  def forums
    @browser.link(:text=>"Forums").click
    Forums.new(@browser)
  end
  
  def name
    @browser.link(:text=>"Gradebook").click
    Gradebook.new(@browser)
  end
  
  link(:gradebook2, :text=>"Gradebook2")
  link(:help, :text=>"Help")
  
  # Clicks the Home link, then instantiates the
  # Home class.
  def home
    @browser.link(:text, "Home").click
    Home.new(@browser)
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
  link(:matrices, :text=>"Matrices")
  link(:media_gallery, :text=>"Media Gallery")
  link(:membership, :text=>"Membership")
  link(:memory, :text=>"Memory")
  
  # Clicks the Messages link, then instantiates the Messages class.
  def messages
    @browser.link(:text=>"Messages").click
    Messages.new(@browser)
  end
  
  link(:my_sites, :text=>"My Sites")
  
  def my_workspace
    @browser.link(:text=>"My Workspace").click
    $frame_index=0
    MyWorkspace.new(@browser)
  end
  
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
  
  # Clicks the Resources link, then instantiates
  # the Resources class.
  def resources
    @browser.link(:text, "Resources").click
    Resources.new(@browser)
  end
  
  link(:roster, :text=>"Roster")
  link(:rsmart_support, :text=>"rSmart Support")
  
  # Because "Search" is used in many pages,
  # The Search button found in the Site Management
  # Menu must be given the more explicit name
  # 
  def site_management_search
    @browser.link(:class=>"icon-sakai-search").click
    
  end
  
  link(:sections, :text=>"Sections")
  link(:site_archive, :text=>"Site Archive")
  
  # Clicks the Site Editor link, then instantiates
  # the Site Editor class.
  def site_editor
    @browser.link(:text=>"Site Editor").click
    SiteEditor.new(@browser)
  end
  
  # Clicks the Site Setup link, then instantiates
  # The SiteSetup class.
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
  
  link(:user_membership, :text=>"User Membership")
  link(:users, :text=>"Users")
  link(:web_content, :text=>"Web Content")
  link(:wiki, :text=>"Wiki")
  
  # The Page Reset button, found on all Site pages
  link(:reset, :href=>/tool-reset/)
  
  # Shortcut method so you don't have to type out
  # the whole string: @browser.frame(:index=>index)
  def frm
    @browser.frame(:index=>$frame_index)
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
