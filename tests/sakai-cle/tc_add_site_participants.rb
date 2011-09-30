# 
# == Synopsis
#
# Tests the adding of students, instructors, and Guests to an existing Site.
#
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class AddSiteParticipants < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Must log in as admin
    @site_name = @config.directory['course_site']
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_adding_participants
    
    # This test case needs to check error paths.
    # Currently it does not do any error checking.
    
    # Prepare the test case data...
    # Get participants and stick them in an array
    students = []
    instructors = []
    guests = []
    
    x = 1
    
    while @config.directory["person#{x}"] != nil do
      
      type = @config.directory["person#{x}"]["type"]
      id = @config.directory["person#{x}"]["id"]
      case(type)
      when "registered" then students << id
      when "guest" then guests << id
      when "maintain" then instructors << id
      end
      
      x+=1
      
    end
    
    # Now put the names into a string that can be
    # entered into the appropriate text
    # field later
    students_list = students.join("\n")
    instructors_list = instructors.join("\n")
    guests_list = guests.join("\n")
    
    # Now, the strings go into a hash for iteration through the tests.
    users = { :students=>students_list, :instructors=>instructors_list, :guests=>guests_list }
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to Site Setup
    home = Home.new(@browser)
    home.site_setup
   
    # Define the frame for ease of code writing (and reading)
    def frm
      @browser.frame(:index=>0)
    end

    # Narrow down and sort the list to easily
    # find the test site
    frm.select(:id, "view").select("course Sites")
    
    site_setup = SiteSetup.new(@browser)

    2.times{site_setup.sort_by_creation_date}
      
    # Get the site id so that we can check the right checkbox
    frm.link(:text, @site_name).href =~ /(?<=\/site\/).+/
    site_id = $~.to_s
      
    # Check the checkbox
    frm.checkbox(:value, site_id).set
      
    # Edit the site
    site_setup.edit

    users.each do | user_type, user_list |
      
      next if user_list==""
      
      edit_site = SiteSetupEdit.new(@browser)
      
      # Add the participants
      edit_site.add_participants
      add_participants = SiteSetupAddParticipants.new(@browser)
      
      # Enter the names into the official participants field
      add_participants.official_participants=user_list
      add_participants.continue
      
      # Choose the role
      role = SiteSetupChooseRole.new(@browser)
      
      case(user_type)
      when :guests then role.select_guest
      when :instructors then role.select_instructor
      when :students then role.select_student
      else
        p user_type
        role.select_teaching_assistant
      end
      
      role.continue
      
      # Don't send an email
      email = SiteSetupParticipantEmail.new(@browser)
      email.continue
      
      # Confirm selections
      confirm = SiteSetupParticipantConfirmation.new(@browser)
      
      #===================
      # Need to add verification steps here!
      #===================
      
      confirm.finish
      
      #===================
      # Need to add verification steps here!
      #===================
      
    end
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
