# 
# == Synopsis
#
# Tests various XSS attacks on assignment titles shown in the Calendar.
#
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestXSSAssignmentsOnCalendar < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # Test user is an instructor
    @user_name = @directory['person3']['id']
    @password = @directory['person3']['password']
    # This script requires a second test user (instructor)
    @user_name1 = @directory['person4']['id']
    @password1 = @directory['person4']['password']
    # Test site
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @assignments = [
      {:title=>%|#{random_nicelink}" onload="javascript:alert('XSS');"><|,
        :grade_scale=>"Letter grade",
        :instructions=>%|#{random_nicelink}">| + random_xss_string,
        :open_date=>yesterday,
        :due_date=>tomorrow,
        :due_hour=>last_hour-1},
      {:title=>%|#{random_nicelink}"> | + random_xss_string(30),
        :grade_scale=>"Letter grade",
        :instructions=>random_xss_string,
        :open_date=>yesterday,
        :due_date=>tomorrow,
        :due_hour=>current_hour},
      {:title=>random_string(5) + random_xss_string(45),
        :grade_scale=>"Letter grade",
        :instructions=>random_xss_string,
        :open_date=>yesterday,
        :due_date=>tomorrow,
        :due_hour=>next_hour},
      {:title=>random_string(5) + random_xss_string(60),
        :grade_scale=>"Letter grade",
        :instructions=>random_xss_string,
        :open_date=>yesterday,
        :due_date=>tomorrow,
        :due_hour=>next_hour+1},
      {:title=>random_string(5) + random_xss_string,
        :grade_scale=>"Letter grade",
        :instructions=>random_xss_string,
        :open_date=>yesterday,
        :due_date=>tomorrow,
        :due_hour=>next_hour+2}
      ]
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @revising_alert = "Alert: You are revising an assignment after the open date."
    @missing_instructions = "Alert: This assignment has no instructions. Please make a correction or click the original button to proceed."
    
  end
  
  def teardown
    
    # Close the browser window
    @browser.close
  end
  
  def test_xss_assignments_on_calendar
    
    # Log in to Sakai
    my_workspace = @sakai.page.login(@user_name, @password)

    # Go to test site.
    home = my_workspace.open_my_site_by_id(@site_id)

    # Go to assignments page
    assignments_page = home.assignments
    
    @assignments.each do |asgnmnt|
      
      assignment_page = assignments_page.add
      assignment_page.instructions=asgnmnt[:instructions]
      assignment_page.title=asgnmnt[:title]
      assignment_page.open_day=asgnmnt[:open_date]
      assignment_page.due_day=asgnmnt[:due_date]
      assignment_page.due_hour=asgnmnt[:due_hour]
      assignment_page.grade_scale=asgnmnt[:grade_scale]
      assignment_page.check_add_due_date
      
      assignments_page = assignment_page.post
      
      # TEST CASE: Assignment appears in the list
      assert assignments_page.assignments_titles.include?(asgnmnt[:title]), "#{asgnmnt[:title]} does not appear in the list"
      
      assignment_view = assignments_page.open_assignment asgnmnt[:title]
      
      # TEST CASE: Instructions appear as they should
      assert_equal asgnmnt[:instructions], assignment_view.assignment_instructions, "Instructions aren't the same"
      
      assignments_page = assignment_view.back_to_list
      
    end
    
    # Go to calendar page
    calendar = assignments_page.calendar
    
    # List events on the expected due date for Assignment 2
    calendar.view="List of Events"
    calendar.show_events="All events"
    
    # TEST CASE: Verify assignments appear on calendar
    @assignments.each do |assignment|
      begin
        assert calendar.events_list.include?(assignment[:title])
      rescue Test::Unit::AssertionFailedError
        puts "#{assignment[:title]} is not in the list."
        puts "It's likely that it's because it has messed up the title tag for the anchor HTML."
        puts "Check that there are no XSS alerts showing. If there aren't then this is a Pass."
      end 
    end
    
  end
  
end
