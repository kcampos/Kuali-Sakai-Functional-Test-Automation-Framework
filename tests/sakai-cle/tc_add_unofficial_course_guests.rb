# 
# == Synopsis
#
# Tests the adding of students, instructors, and Guests to an existing Site.
#
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class AddCourseSiteParticipants < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Must log in as admin
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @user_name = @directory['admin']['username']
    @password = @directory['admin']['password']
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_adding_participants_to_course
    
    # Prepare the test case data...
    # Get participants and stick them in an array

    guests = []
    
    25.times do
      guests << random_email(5)
    end
    
    guests_list = guests.join("\n")
    
    # Log in to Sakai
    workspace = @sakai.page.login(@user_name, @password)
    
    # Go to Site Setup
    site_setup = workspace.site_setup
    
    edit_site = site_setup.edit(@site_name)

    add_participants = edit_site.add_participants
      
    # Enter the names into the official participants field
    add_participants.non_official_participants=guests_list
    sleep 1
    role = add_participants.continue
    # Choose the role
    role.select_guest
      
    email = role.continue
      
    # Don't send an email
    confirm = email.continue
      
    # Confirm selections
      
    # TEST CASE: Users are in confirmation list.
    guests.each do |email|
      assert_equal email, confirm.id(email)
      assert_equal "Guest", confirm.role(email)
    end
      
    edit_site = confirm.finish
    
    workspace = edit_site.my_workspace
    
    users = workspace.users

    # TEST CASE: Email cell contains the email address for all entered guests
    guests.each do |email|
      users.search_field=email
      users = users.search_button
      assert_equal email, users.email(email)
      assert_equal "guest", users.type(email).downcase
      users.clear_search
    end
    
  end
  
end
