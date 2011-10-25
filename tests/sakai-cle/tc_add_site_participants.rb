# 
# == Synopsis
#
# Tests the adding of students, instructors, and Guests to an existing Site.
#
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class AddSiteParticipants < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Must log in as admin
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
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
    
    site_setup = SiteSetup.new(@browser)

    site_setup.edit(@site_name)

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
  
end
