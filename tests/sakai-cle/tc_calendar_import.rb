#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the importation of calendar data into a Sakai Site Calendar.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCalendarImport < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @instructor = @directory['person3']['id']
    @ipassword = @directory['person3']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @filename = "documents/master_calendar_import_file.txt"
    @yesterday = (Time.now - (3600*24)).strftime("%x")
    @today = Time.now.strftime("%x")
    @tomorrow = (Time.now + (3600*24)).strftime("%x")
    @end_date = (Time.now + (3600*24*7*8)).strftime("%x")
    
    @events = [
      {:title=>"Event 1", :description=>"This is the description for event #1", :date=>@yesterday, :start=>"11:00 AM", :duration=>"1:00", :type=>"Activity", :location=>"Taubman Library 2919", :frequency=>"", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"", :required=>""},
      {:title=>random_nicelink, :description=>"This is the description for event #2", :date=>@today, :start=>"11:00 AM", :duration=>"1:00", :type=>"Exam", :location=>"Taubman Library 2919", :frequency=>"", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"", :required=>""},
      {:title=>"Event3", :description=>random_nicelink, :date=>@today, :start=>"11:00 AM", :duration=>"30", :type=>"Meeting", :location=>"Taubman Library 2919", :frequency=>"", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"", :required=>""},
      {:title=>"Event with a custom property", :description=>"If the site has a custom property called Test Custom Property, this will set it.", :date=>@tomorrow, :start=>"3:00 PM", :duration=>"45", :type=>"", :location=>"Taubman Library 2919", :frequency=>"", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"Test Value here", :required=>"yes"},
      {:title=>"Repeating Event 1", :description=>"This event should repeat every week with no end", :date=>@tomorrow, :start=>"2:00 PM", :duration=>"1:30", :type=>"", :location=>"", :frequency=>"week", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"", :required=>""},
      {:title=>"Repeating Event 2", :description=>"This event should repeat every other week and end after 2 times", :date=>@yesterday, :start=>"2:00 PM", :duration=>"30", :type=>"Activity", :location=>"location", :frequency=>"week", :interval=>"2", :ends=>"", :repeat=>"2", :test_custom_property=>"", :required=>""},
      {:title=>"Repeating Event 3", :description=>"This event should repeat every other week and end on or before #{@end_date}", :date=>@today, :start=>"2:00 PM", :duration=>"1:30", :type=>"Activity", :location=>"", :frequency=>"week", :interval=>2, :ends=>@end_date, :repeat=>"", :test_custom_property=>"", :required=>""}
      #{:title=>"", :description=>"This event should repeat every other week and end on or before #{@end_date}", :date=>@today, :start=>"", :duration=>"", :type=>"", :location=>"", :frequency=>"", :interval=>"", :ends=>"", :repeat=>"", :test_custom_property=>"", :required=>""}
    ]
    
    @header_row = "Title,Description,Date,Start,Duration,Type,Location,Frequency,Interval,Ends,Repeat,Test Custom Property,Required"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_calendar_import
    
    # Create the test CSV file...
    @csv_file = File.new(%|#{File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + @filename}|, "w")
    @csv_file.puts @header_row
    @events.each do |event|
      string = %|"#{event[:title]}","#{event[:description]}",#{event[:date]},#{event[:start]},#{event[:duration]},#{event[:type]},"#{event[:location]}",#{event[:frequency]},#{event[:interval]},#{event[:ends]},#{event[:repeat]},"#{event[:test_custom_property]}",#{event[:required]}|
      @csv_file.puts(string)
    end
    @csv_file.close
    
    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    calendar = home.calendar
    
    import_1 = calendar.import
    
    # TEST CASE: "Generic" is the selected option.
    assert import_1.generic_calendar_import_selected?
    
    import_2 = import_1.continue
    
    import_2.import_file @filename 
    
    import_3 = import_2.continue
    
    # TEST CASE: Verify event count is correct
    assert @browser.frame(:class=>"portletMainIframe").div(:class=>"portletBody").text.include?("importing #{@events.length} activities") # TODO - Rewrite without using naked Watir syntax
    
    # TEST CASE: Verify expected events are in the list
    @events.each { |event| assert import_3.events.include?(event[:title]) }
    
    # TEST CASE: Verify listed events occur on expected date
    @events.each { |event| assert_equal Time.strptime(event[:date], "%x"), Time.strptime(import_3.event_date(event[:title]), "%b %d, %Y") }
    
    calendar = import_3.import_events
    calendar = calendar.select_view "List of Events"
    calendar.show="Events for this month"
    
    # TEST CASE: Verify events appear in calendar
    @events.each { |event| assert calendar.events_list.include?(event[:title]), "Could not find #{event[:title]} in #{calendar.events_list}" }
    
    # Add checks of events in calendar here (verify repeats, etc.)...
    # Add test of unchecking an event to import...
    # Add test of importing for group instead of site...
    
  end
  
end
