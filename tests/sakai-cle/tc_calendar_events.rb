# 
# == Synopsis
#
# Tests basic creation and editing of a calendar event, as well
# as the various view options of the calendar.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCalendarEvents < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @student1 = @config.directory['person1']['id']
    @spassword = @config.directory['person1']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @assignment_event = "Due #{@config.directory['site1']['assignment2']} - #{@site_name}"
    
    @event_title = random_alphanums # for more robust testing of the title field, see the xss test cases.
    @event_message = %|">| + random_xss_string
    @event_start_month = in_15_minutes[:month_str]
    @event_start_day = in_15_minutes[:day]
    @event_start_year = in_15_minutes[:year]
    @event_start_hour = in_15_minutes[:hour]
    @event_start_min = in_15_minutes[:minute]
    @event_start_meridian = in_15_minutes[:meridian]
    @event_location = random_xss_string
    
    @attach_file = "resources.JPG"
    
    @url = "http://www.rsmart.com"
    
    @frequency = "daily"
    @interval = "10"
    
    @field_name = random_alphanums(16)
    @new_field_text = random_string(256)
    
    @field_alert = "Alert: Are you sure you want to remove the following field(s):#{@field_name}? If yes, click 'Save Field Changes' to continue."
    
    @view_alert = "Alert: This is now the default view"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_calendar_events
    
    # Log in to Sakai
    workspace = @sakai.login(@student1, @spassword)
    
    calendar = workspace.calendar

    calendar = calendar.next
    
    # TEST CASE: Expected event appears on calendar
    assert calendar.events_list.include?(@assignment_event), calendar.events_list.join("\n")
    
    event = calendar.open_event @assignment_event
    
    # TEST CASE: Verify the event lists the expected Site.
    assert_equal @site_name, event.details['Site']
    
    calendar = event.back_to_calendar
    calendar = calendar.select_view "Calendar by Day"
    
    # TEST CASE: Header displays correct view type
    assert_equal "Calendar by Day", calendar.header
    
    # TEST CASE: Calendar is still on the date of the event just viewed.
    assert calendar.events_list.include?(@assignment_event), calendar.events_list.join("\n")
    
    add_event = calendar.add_event
    add_event.message=@event_message
    add_event.title=@event_title
    add_event.month=@event_start_month
    add_event.day=@event_start_day
    add_event.year=@event_start_year
    add_event.start_hour=@event_start_hour
    add_event.start_minute=@event_start_min
    add_event.start_meridian=@event_start_meridian
    
    calendar = add_event.save_event

    # Get the link's href value for verification steps later
    @event_href = calendar.event_href @event_title
    
    # TEST CASE: Verify new event appears
    assert calendar.events_list.include?("#{@event_title} - My Workspace"), calendar.events_list.join("\n")
    assert calendar.events_list.include?(@event_href), calendar.events_list.join("\n")
    
    calendar = calendar.previous
    
    #TEST CASE: Verify the new event is not on this day
    assert_equal false, calendar.events_list.include?(@event_href)
    
    calendar = calendar.next
    
    # TEST CASE: Verify new event is back
    assert calendar.events_list.include?("#{@event_title} - My Workspace"), calendar.events_list.join("\n")
    
    calendar = calendar.select_view "Calendar by Week"
    
    # TEST CASE: Verify the view has switched to week
    assert_equal "Calendar by Week", calendar.header 

    calendar = calendar.previous
    calendar = calendar.earlier
    calendar = calendar.later
    
    #TEST CASE: Verify the new event is not on this week
    assert_equal false, calendar.events_list.include?(@event_href)
    
    calendar = calendar.next
    
    # TEST CASE: Verify new event is back
    begin
      assert calendar.events_list.include?("#{@event_title} - My Workspace"), calendar.events_list.join("\n")
    rescue Test::Unit::AssertionFailedError
      assert calendar.events_list.include?(@event_href), calendar.events_list.join("\n")
    end
    
    calendar = calendar.select_view "Calendar by Month"
    
    # TEST CASE: Verify the view has switched to week
    assert_equal "Calendar by Month", calendar.header 

    calendar = calendar.previous

    #TEST CASE: Verify the new event is not on this month
    begin
      assert_equal(false, calendar.events_list.include?(@event_href), "#{@event_href} appears unexpectedly")
    rescue Test::Unit::AssertionFailedError
      if Time.now.strftime("%d").to_i < 7
        # It must be showing up on the calendar because it's the early
        # part of the month
      else
        assert_equal(false, calendar.events_list.include?(@event_href), "#{@event_href} appears unexpectedly")
      end
    end
      
    calendar = calendar.next
    
    # TEST CASE: Verify new event is back
    begin
      assert calendar.events_list.include?("#{@event_title} - My Workspace"), calendar.events_list.join("\n")
    rescue Test::Unit::AssertionFailedError
      assert calendar.events_list.include?(@event_href), calendar.events_list.join("\n")
    end
    
    calendar = calendar.select_view "Calendar by Year"
    
    # TEST CASE: Verify the view has switched to week
    assert_equal "Calendar by Year", calendar.header

    calendar = calendar.select_view "List of Events"
    calendar.show="All events"
    
    event = calendar.open_event @event_title
    
    # TEST CASE: Contents of the Description field are as expected.
    assert_equal @event_message, event.details['Description']
    
    edit_event = event.edit

    attach = edit_event.add_attachments
    
    attach.show_other_sites
    attach.open_folder "#{@site_name} Resources"
    
    attach = attach.attach_a_copy @attach_file
    
    edit_event = attach.continue
    
    # TEST CASE: Verify the file is attached.
    assert edit_event.attachment? @attach_file

    unattach = edit_event.add_remove_attachments
    unattach.remove_item @attach_file
    
    edit_event = unattach.continue
    
    # TEST CASE: Verify the file is not attached any more
    assert_equal false, edit_event.attachment?(@attach_file)

    attach = edit_event.add_attachments
    attach.url=@url
    attach.add
    
    edit_event = attach.continue
    
    frequency = edit_event.frequency
    
    frequency.event_frequency=@frequency
    frequency.interval=@interval
    
    edit_event = frequency.save_frequency
    
    calendar = edit_event.save_event
    
    # TEST CASE: Verify the event is present on the calendar.
    assert calendar.events_list.include? @event_title
    
    fields = calendar.fields
    fields.field_name=@field_name
    fields = fields.create_field
    
    calendar = fields.save_field_changes
    
    calendar = calendar.select_view "List of Events"
    calendar.show="All events"
    
    event = calendar.open_event @event_title
    
    edit_event = event.edit
    
    edit_event.custom_field_text(@field_name, @new_field_text)
    
    calendar = edit_event.save_event
    
    event = calendar.open_event @event_title
    
    # TEST CASE: Verify custom field contains entered text
    assert_equal @new_field_text, event.details[@field_name]

    fields = event.fields
    fields.check_remove(@field_name)
    
    fields = fields.save_field_changes
    
    # TEST CASE: Verify warning message appears
    assert_equal @field_alert, fields.alert_box
    
    event = fields.save_field_changes
    
    # TEST CASE: The custom field has been removed
    assert_equal nil, event.details[@field_name]
    
    my_workspace = event.home
    
    # TEST CASE: Verify the event appears below the calendar
    assert my_workspace.calendar_events.include?(@event_title)
    
    @sakai.logout
    
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    calendar = home.calendar
    calendar.view="Calendar by Month"
    calendar.set_as_default_view
    
    # TEST CASE: Verify alert message about default view appears.
    assert_equal @view_alert, calendar.alert_box.text
    
    #@sakai.logout #FIXME
    @browser.link(:text=>"Logout").click
    
    workspace = @sakai.login(@student1, @spassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    calendar = home.calendar
    
    # TEST CASE: The default view is now by Month
    assert_equal "Calendar by Month", calendar.header
    
    @sakai.logout
    
  end
  
end
