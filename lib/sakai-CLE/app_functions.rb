#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

require 'watir-webdriver'
require File.dirname(__FILE__) + '/page_elements.rb'

class SakaiCLE
  
  def initialize(browser)
    @browser = browser
  end
  
  # Log in
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
    MyWorkspace.new(@browser)
  end
  
  # Log out
  def logout
    @browser.link(:text, "Logout").click
  end
  
  # Format a date string Sakai-style.
  # Useful for verifying creation dates and such.
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
module ToolsMenu
  
  include PageObject
  
  # Opens "My Sites" box and then clicks on the link
  # that matches the specified id.
  #
  # Errors out if nothing matches.
  def open_my_site_by_id(id)
    @browser.link(:text, "My Sites").click
    @browser.link(:href, /#{id}/).click
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
    Home.new(@browser)
  end
  
  link(:account, :text=>"Account")
  link(:aliases, :text=>"Aliases")
  
  def administration_workspace
    @browser.link(:text, "Administration Workspace").click
    MyWorkspace.new(@browser)
  end
  
  link(:announcements, :class => 'icon-sakai-announcements')
  
  def assignments
    @browser.link(:class=>"icon-sakai-assignment-grades").click
    AssignmentsList.new(@browser)
  end
  
  link(:basic_lti, :text=>"Basic LTI")
  link(:blogs, :text=>"Blogs")
  
  def calendar
    @browser.link(:text=>"Calendar").click
    Calendar.new(@browser)
  end
  
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
  
  def forums
    @browser.link(:text=>"Forums").click
    Forums.new(@browser)
  end
  
  link(:gradebook, :text=>"Gradebook")
  link(:gradebook2, :text=>"Gradebook2")
  link(:help, :text=>"Help")
  
  def home
    @browser.link(:text, "Home").click
    Home.new(@browser)
  end
  
  def job_scheduler
    @browser.link(:text=>"Job Scheduler").click
    JobScheduler.new(@browser)
  end
  
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
  link(:messages, :text=>"Messages")
  link(:my_sites, :text=>"My Sites")
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
  
  def resources
    # Will eventually need logic here
    # to determine whether to load the class for
    # the Resources page in a particular site or the page
    # while in the Admin workspace.
    
    # For now, though, this only works to go to
    # the page within a given Site.
    @browser.link(:text, "Resources").click
    Resources.new(@browser)
  end
  
  link(:roster, :text=>"Roster")
  link(:rsmart_support, :text=>"rSmart Support")
  link(:search, :text=>"Search")
  link(:sections, :text=>"Sections")
  link(:site_archive, :text=>"Site Archive")
  
  def site_editor
    @browser.link(:text=>"Site Editor").click
    SiteEditor.new(@browser)
  end
  
  def site_setup
    @browser.link(:text=>"Site Setup").click
    SiteSetup.new(@browser)
  end
  
  link(:site_statistics, :text=>"Site Statistics")
  
  def sites
    @browser.link(:class=>"icon-sakai-sites").click
    Sites.new(@browser)
  end
  
  link(:skin_manager, :text=>"Skin Manager")
  link(:super_user, :text=>"Super User")
  
  def syllabus
    @browser.link(:text=>"Syllabus").click
    Syllabus.new(@browser)
  end
  
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
  def frm(index)
    @browser.frame(:index=>index)
  end
  
end

# This is a module containing methods that are
# common to all the question pages
module QuestionHelpers
  
  include PageObject
  
  def save
    
    quiz = frm(1).div(:class=>"portletBody").div(:index=>0).text
    pool = frm(1).div(:class=>"portletBody").div(:index=>1).text
    
    frm(1).button(:value=>"Save").click
    
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
