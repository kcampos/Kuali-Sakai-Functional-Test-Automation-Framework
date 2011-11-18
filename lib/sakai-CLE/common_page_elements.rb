# Page classes that are in some way common to both
# the Site context and the My Workspace context.
# 
# == Synopsis
#
# This script defines the page classes that are
# common to both page contexts--within a Site or within My Workspace.
#
# Author :: Abe Heward (aheward@rsmart.com)

#require File.dirname(__FILE__) + '/app_functions.rb'

#================
# Announcements Pages
#================

# The Announcements list page for a Site.
class Announcements
  
  include ToolsMenu
  
  def add
    frm.div(:class=>"portletBody").link(:title=>"Add").click
    AddEditAnnouncements.new(@browser)
  end

  def edit(subject)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).link(:text=>"Edit").click
    AddEditAnnouncements.new(@browser)
  end

  # Returns an array of the subject strings of the announcements
  # listed on the page.
  def subjects
    links = frm.table(:class=>"listHier").links.find_all { |link| link.title=~/View announcement/ }
    subjects = []
    links.each { |link| subjects << link.text }
    return subjects
  end

  def has_attachment?(subject)
    if frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).exist?
      return frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/).image(:alt=>"attachment").exist?
    else
      puts "Can't find your target row. Your test is faulty."
      return false
    end
  end

  # Returns the text of the "For" column for
  # the specified announcement.
  def for_column(subject)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(subject)}/)[4].text
  end

  def preview_announcement(subject)
    frm.link(:text=>subject).click
    PreviewAnnouncements.new(@browser)
  end

  def view=(list_item)
    frm.select(:id=>"view").set(list_item)
  end

  def merge
    frm.link(:text=>"Merge").click
    AnnouncementsMerge.new(@browser)
  end

end

# Show Announcements from Another Site. On this page you select what announcements
# you want to merge into the current Site.
class AnnouncementsMerge

  include ToolsMenu

  # Checks the checkbox for the specified site name
  def check(site_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(site_name)}/).checkbox(:id=>/site/).set
  end
  
  def save
    frm.button(:value=>"Save").click
    Announcements.new(@browser)
  end
  
end


# This Class does double-duty. It's for the Preview page when editing an
# Announcement, plus for when you just click an Announcement to view it.
class PreviewAnnouncements
  
  include ToolsMenu
  
  def return_to_list
    frm.button(:value=>"Return to List").click
    Announcements.new(@browser)
  end

  def save_changes
    frm.button(:value=>"Save Changes").click
    Announcements.new(@browser)
  end

  def edit
    frm.button(:value=>"Edit").click
    AddEditAnnouncements.new(@browser)
  end

end

# The page where an announcement is created or edited.
class AddEditAnnouncements
  
  include ToolsMenu
  
  def add_announcement
    frm.button(:value=>"Add Announcement").click
    if frm.div(:class=>"portletBody").h3.text=~/Add Announcement/
      AddEditAnnouncements.new(@browser)
    else
      Announcements.new(@browser)
    end
  end
  
  def save_changes
    frm.button(:value=>"Save Changes").click
    Announcements.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    PreviewAnnouncements.new(@browser)
  end

  def body=(text)
    frm.frame(:id, "body___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def add_attachments
    frm.button(:value=>"Add Attachments").click
    AnnouncementsAttach.new(@browser)
  end
  
  # Clicks the checkbox for the specified group name
  # when you've set the announcement access to display
  # to groups.
  def check_group(group_name)
    frm.table(:id=>"groupTable").row(:text=>/#{Regexp.escape(group_name)}/).checkbox(:name=>"selectedGroups").set 
  end
  
  # Sets the Announcement Title field to the specified
  # string value.
  def title=(string)
    frm.text_field(:id=>"subject").set(string)
  end
  
  # Clicks the radio button for "Only members of this site can see this announcement"
  def select_site_members
    frm.radio(:id=>"site").set
  end
  
  # Clicks the radio button for "This announcement is publicly viewable"
  def select_publicly_viewable
    frm.radio(:id=>"pubview").set
  end
  
  # Clicks the radio button for "Displays this announcement to selected groups only."
  def select_groups
    frm.radio(:id=>"groups").set
  end
  
  # Clicks the radio button for "Show - (Post and display this announcement immediately)"
  def select_show
    frm.radio(:id=>"hidden_false").set
  end
  
  # Clicks the radio button for "Hide - (Draft mode - Do not display this announcement at this time)"
  def select_hide
    frm.radio(:id=>"hidden_true").set
  end
  
  # Clicks the radio button for "Specify Dates - (Choose when this announcement will be displayed)"
  def select_specify_dates
    frm.radio(:id=>"hidden_specify").set
  end
  
  # Checks the checkbox for "Beginning"
  def check_beginning
    frm.checkbox(:id=>"use_start_date").set
  end
  
  # Checks the checkbox for "Ending"
  def check_ending
    frm.checkbox(:id=>"use_end_date").set
  end
  
  # Checks the checkbox for selecting all Groups
  def check_all
    frm.checkbox(:id=>"selectall").set
  end
  
  # Sets the Beginning Month selection to the
  # specified string.
  def beginning_month=(string)
    frm.select(:id=>"release_month").select(string)
  end
  
  # Sets the Beginning Day selection to the
  # specified string.
  def beginning_day=(string)
    frm.select(:id=>"release_day").select(string)
  end
  
  # Sets the Beginning Year selection to the
  # specified string.
  def beginning_year=(string)
    frm.select(:id=>"release_year").select(string)
  end
  
  # Sets the Beginning Hour selection to the
  # specified string
  def beginning_hour=(string)
    frm.select(:id=>"release_hour").select(string)
  end
  
  # Sets the Beginning Minute selection to the
  # specified string
  def beginning_minute=(string)
    frm.select(:id=>"release_minute").select(string)
  end
  
  # Sets the AM or PM value to the specified string.
  # Obviously the string should be either "AM" or "PM".
  def beginning_meridian=(string)
    frm.select(:id=>"release_ampm").select(string)
  end

  # Sets the Ending Month selection to the specified
  # string.
  def ending_month=(string)
    frm.select(:id=>"retract_month").select(string)
  end
  
  # Sets the Ending Day selection to the specified
  # string.
  def ending_day=(string)
    frm.select(:id=>"retract_day").select(string)
  end
  
  # Sets the Ending Year selection to the specified
  # string.
  def ending_year=(string)
    frm.select(:id=>"retract_year").select(string)
  end
  
  # Sets the Ending Hour selection to the specified
  # string.
  def ending_hour=(string)
    frm.select(:id=>"retract_hour").select(string)
  end
  
  # Sets the Ending Minute selection to the specified
  # string.
  def ending_minute=(string)
    frm.select(:id=>"retract_minute").select(string)
  end
  
  # Sets the Ending AM/PM selection to the specified
  # value.
  def ending_meridian=(string)
    frm.select(:id=>"retract_ampm").select(string)
  end

  # Gets the text of the alert message when it appears on
  # the page
  def alert_message
    frm.div(:class=>"alertMessage").text
  end

end

# The page for attaching files and links to Announcements.
class AnnouncementsAttach < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes= {
      :this => "AnnouncementsAttach",
      :parent => "AddEditAnnouncements"
    }
  end
  
end

# Page for merging announcements from other sites
class AnnouncementsMerge
  
  include ToolsMenu
  

end

# Page for setting up options for announcements
class AnnouncementsOptions
  
  include ToolsMenu
  
end

# Page containing permissions options for announcements
class AnnouncementsPermissions
  
  include ToolsMenu
  
end


#================
# Calendar Pages
#================

module CalendarTools
  
  #
  def add_event
    frm.link(:text=>"Add").click
    frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).wait_until_present
    AddEditEvent.new(@browser)
  end
  
  #
  def fields
    frm.link(:text=>"Fields").click
    AddEditFields.new(@browser)
  end
  
end

# Top page of the Calendar
# For now it includes all views, though that probably
# means it will have to be re-instantiated every time
# a new view is selected.
class Calendar
  
  include PageObject
  include ToolsMenu
  include CalendarTools
  
  # Selects the specified item in the View select list,
  # then reinstantiates the Class.
  def select_view(item)
    frm.select(:id=>"view").select(item)
    Calendar.new(@browser)
  end
  
  # Selects the specified item in the View select list.
  # This is the same method as the select_view method, except
  # that it does not reinstantiate the class. Use this if you're
  # not concerned about throwing obsolete element errors when
  # the page updates.
  def view=(item)
    frm.select(:id=>"view").select(item)
  end
  
  # Selects the specified item in the Show select list.
  def show=(item)
    frm.select(:id=>"timeFilterOption").select(item)
  end
  
  # Returns the text of the Calendar's header.
  def header
    frm.div(:class=>"portletBody").h3.text
  end
  
  # This is the alert box object. If you want to
  # get the text contents of the alert box, use
  # alert_box.text. That will get you a string object
  # that is the text contents.
  def alert_box
    frm.div(:class=>"alertMessage")
  end
  
  # Clicks the link to the specified event, then
  # instantiates the EventDetail class.
  def open_event(title)
    truncated = title[0..5]
    frm.link(:text=>/#{Regexp.escape(truncated)}/).click
    EventDetail.new(@browser)
  end
  
  # Returns the href value of the target link
  # use for validation when you are testing whether the link
  # will appear again on another screen, since often times
  # validation by title text alone will not work.
  def event_href(title)
    truncated = title[0..5]
    return frm.link(:text=>/#{Regexp.escape(truncated)}/).href
  end
  
  def show_events=(item)
    frm.select(:id=>"timeFilterOption").select(item)
  end
  
  # Selects the specified value in the start month select list.
  def start_month=(item)
    frm.select(:id=>"customStartMonth").select(item)
  end
  
  # Selects the specified value in the start day select list.
  def start_day=(item)
    frm.select(:id=>"customStartDay").select(item)
  end
  
  # Selects the specified value in the start year select list.
  def start_year=(item)
    frm.select(:id=>"customStartYear").select(item)
  end
  
  # Selects the specified value in the end month select list.
  def end_month=(item)
    frm.select(:id=>"customEndMonth").select(item)
  end
  
  # Selects the specified value in the End Day select list.
  def end_day=(item)
    frm.select(:id=>"customEndDay").select(item)
  end
  
  # Selects the specified value in the End Year select list.
  def end_year=(item)
    frm.select(:id=>"customEndYear").select(item)
  end
  
  # Clicks the Filter Events button, then re-instantiates
  # the Calendar class to avoid the possibility of an
  # ObsoleteElement error.
  def filter_events
    frm.button(:name=>"eventSubmit_doCustomdate").click
    Calendar.new(@browser)
  end
  
  # Clicks the Go to Today button, then reinstantiates
  # the Calendar class.
  def go_to_today
    frm.button(:value=>"Go to Today").click
    Calendar.new(@browser)
  end
  
  # Returns an array of the titles of the displayed events.
  def event_list
    events_list
  end
  
  # Returns an array for the listed events.
  # This array contains more than simply strings of the event titles, because
  # often the titles are truncated to fit on the screen. In addition, getting the "title"
  # tag of the link is often problematic because titles can contain double-quotes, which
  # will mess up the HTML of the anchor tag (there is probably an XSS vulnerability to
  # exploit, there. This should be extensively tested.).
  #
  # Because of these issues, the array contains the title tag, the anchor text, and
  # the entire href string for every event listed on the page. Having all three items
  # available should ensure that verification steps don't give false results--especially
  # when you are doing a negative test (checking that an event is NOT present).
  def events_list
    list = []
    if frm.table(:class=>"calendar").exist?
      events_table = frm.table(:class=>"calendar")
    else
      events_table = frm.table(:class=>"listHier lines nolines")
    end
    links = events_table.links.find_all { |link| link.href=~/Description/ }
    if links == []
      links = events_table.links.find_all { |link| link.html=~/action.doDescription/ }
    end
    links.each do |link|
      list << link.title
      list << link.text
      list << link.href
      list << link.html[/(?<="location=').+doDescription/]
    end
    list.compact!
    list.uniq!
    return list
  end
  
  # Clicks the "Previous X" button, where X might be Day, Week, or Month,
  # then reinstantiates the Calendar class to ensure against any obsolete element
  # errors.
  def previous
    frm.button(:name=>"eventSubmit_doPrev").click
    Calendar.new(@browser)
  end
  
  # Clicks the "Next X" button, where X might be Day, Week, or Month,
  # then reinstantiates the Calendar class to ensure against any obsolete element
  # errors.
  def next
    frm.button(:name=>"eventSubmit_doNext").click
    Calendar.new(@browser)
  end
  
  # Clicks the "Today" button and reinstantiates the class.
  def today
    frm.button(:value=>"Today").click
    Calendar.new(@browser)
  end
  
  def earlier
    frm().link(:text=>"Earlier").click
    Calendar.new(@browser)
  end
  
  def later
    frm().link(:text=>"Later").click
    Calendar.new(@browser)
  end
  
  # Clicks the "Set as Default View" button
  def set_as_default_view
    frm.link(:text=>"Set as Default View").click
  end
  
end

# The page that appears when you click on an event in the Calendar
class EventDetail
  
  include PageObject
  include ToolsMenu
  include CalendarTools
  
  # Clicks the Go to Today button, then instantiates
  # the Calendar class.
  def go_to_today
    frm.button(:value=>"Go to Today").click
    Calendar.new(@browser)
  end
    
  def back_to_calendar
    frm.button(:value=>"Back to Calendar").click
    Calendar.new(@browser)
  end

  def last_event
    frm().button(:value=>"< Last Event").click
    EventDetail.new(@browser)
  end
  
  def next_event
    frm().button(:value=>"Next Event >").click
    EventDetail.new(@browser)
  end
  
  def event_title
    frm.div(:class=>"portletBody").h3.text
  end
  
  def edit
    frm.button(:value=>"Edit").click
    AddEditEvent.new(@browser)
  end
  
  def remove_event
    frm.button(:value=>"Remove event").click
    DeleteConfirm.new(@browser)
  end
  
  # Returns a hash object containing the contents of the event details
  # table on the page, with each of the header column items as a Key
  # and the associated data column as the corresponding Value.
  def details
    details = {}
    frm.table(:class=>"itemSummary").rows.each do |row|
      details.store(row.th.text, row.td.text)
    end
    return details
  end
  
end

# 
class AddEditEvent
  
  include PageObject
  include ToolsMenu
  
  #
  def save_event
    frm.button(:value=>"Save Event").click
    Calendar.new(@browser)
  end
  #
  def message=(text)
    frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  # The FCKEditor object. Use this method to set up a "wait_until_present"
  # step, since sometimes it takes a long time for this object to load.
  def message_editor
    frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def frequency
    frm.button(:name=>"eventSubmit_doEditfrequency").click
    EventFrequency.new(@browser)
  end
  
  def add_attachments
    frm.button(:value=>"Add Attachments").click
    EventAttach.new(@browser)
  end
  
  def add_remove_attachments
    frm.button(:value=>"Add/remove attachments").click
    EventAttach.new(@browser)
  end
  
  # Returns true if the page has a link with the
  # specified file name. Use for test case asserts.
  def attachment?(file_name)
    frm.link(:text=>file_name).exist?
  end
  
  # Use this method to enter text into custom fields
  # on the page. The "field" variable is the name of the
  # field, while the "text" is the string you want to put into
  # it.
  def custom_field_text(field, text)
    frm.text_field(:name=>field).set(text)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"activitytitle", :frame=>frame)
    select_list(:month, :id=>"month", :frame=>frame)
    select_list(:day, :id=>"day", :frame=>frame)
    select_list(:year, :id=>"yearSelect", :frame=>frame)
    select_list(:start_hour, :id=>"startHour", :frame=>frame)
    select_list(:start_minute, :id=>"startMinute", :frame=>frame)
    select_list(:start_meridian, :id=>"startAmpm", :frame=>frame)
    select_list(:hours, :id=>"duHour", :frame=>frame)
    select_list(:minutes, :id=>"duMinute", :frame=>frame)
    select_list(:end_hour, :id=>"endHour", :frame=>frame)
    select_list(:end_minute, :id=>"endMinute", :frame=>frame)
    select_list(:end_meridian, :id=>"endAmpm", :frame=>frame)
    radio_button(:display_to_site, :id=>"site", :frame=>frame)
    select_list(:event_type, :id=>"eventType", :frame=>frame)
    text_area(:location, :name=>"location", :frame=>frame)
  end
end

# 
class EventAttach < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this=>"EventAttach",
      :parent=>"AddEditEvent"
    }
  end

end

# The page that appears when the Frequency button is clicked on the Add/Edit
# Event page.
class EventFrequency
  
  include PageObject
  include ToolsMenu
  
  def save_frequency
    frm.button(:value=>"Save Frequency").click
    AddEditEvent.new(@browser)
  end
  
  def cancel
    frm.button(:value=>"Cancel").click
    AddEditEvent.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    select_list(:event_frequency, :id=>"frequencySelect", :frame=>frame)
    select_list(:interval, :id=>"interval", :frame=>frame)
    select_list(:ends_after, :name=>"count", :frame=>frame)
    select_list(:ends_month, :id=>"endMonth", :frame=>frame)
    select_list(:ends_day, :id=>"endDay", :frame=>frame)
    select_list(:ends_year, :id=>"endYear", :frame=>frame)
    radio_button(:after, :id=>"count", :frame=>frame)
    radio_button(:on, :id=>"till", :frame=>frame)
    radio_button(:never, :id=>"never", :frame=>frame)
  end
end

# 
class AddEditFields
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Save Field Changes buton and instantiates
  # The Calendar or EventDetail class--unless the Alert Message box appears,
  # in which case it re-instantiates the class.
  def save_field_changes
    frm.button(:value=>"Save Field Changes").click
    if frm.div(:class=>"alertMessage").exist?
      AddEditFields.new(@browser)
    elsif frm.button(:value=>"Back to Calendar").exist?
      EventDetail.new(@browser)
    else
      Calendar.new(@browser)
    end
  end
  
  # Returns a string of the contents of the Alert box.
  def alert_box
    frm.div(:class=>"alertMessage").text
  end
  
  def create_field
    frm.button(:value=>"Create Field").click
    AddEditFields.new(@browser)
  end

  # Checks the checkbox for the specified field
  def check_remove(field_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(field_name)}/).checkbox.set
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:field_name, :id=>"textfield", :frame=>frame)
  end
end


#================
# Overview-type Pages
#================

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
    # Link for New In Forms
    link(:new_in_forums, :text=>"New Messages", :frame=>frame)
    text_field(:number_of_announcements, :id=>"itemsEntryField", :frame=>frame)
    button(:update_announcements, :name=>"eventSubmit_doUpdate", :frame=>frame)
  end
  
  # The Home class should be instantiated whenever the user
  # context is a given Site or the Administration Workspace.
  # In that context, the frame index is 1.
  $frame_index=1
  
  # Gets the text of the displayed announcements, for
  # test case verification
  def announcements_list
    list = []
    links = @browser.frame(:index=>2).links
    links.each { |link| list << link.text }
    list.delete_if { |item| item=="Options" } # Deletes the Options link if it's there.
    return list
  end
  
end

# The Page that appears when you are not in a particular Site
# Note that this page differs depending on what user is logged in.
# The definitions below include all potential objects. We may
# have to split this class out into user-specific classes.
class MyWorkspace
  
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
  in_frame(:class=>"portletMainIframe") do |frame|
    # Calendar Options button
    link(:calendar_options, :text=>"Options", :frame=>frame)
  end
  
  in_frame(:index=>1) do |frame|
    # My Workspace Information Options
    link(:my_workspace_information_options, :text=>"Options", :frame=>frame)
     # Message of the Day, Options button
    link(:message_of_the_day_options, :text=>"Options", :frame=>frame)
    
  end
  
  in_frame(:index=>0) do |frame|
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end
  
  # Returns an array of strings of the Calendar Events listed below
  # the Calendar
  def calendar_events
    events = []
    @browser.frame(:class=>"portletMainIframe", :index=>2).table(:id=>"calendarForm:datalist_event_list").rows.each do |row|
      events << row.link.text
    end
    return events
  end
  
  # The MyWorkspace class should ONLY be instantiated when
  # the user context is NOT a given site or Administration Workspace.
  # Otherwise the frame index will not be 0, and page objects
  # will not be found by Webdriver.
  $frame_index=0
  
end

#================
# Resources Pages 
#================

# New class template. For quick class creation...
class ResourcesUploadFiles
  
  include ToolsMenu
  
  @@filex=0
  
  # Enters the specified folder/filename value into
  # the file field on the page. Note that files are
  # assumed to be in the relative path ../../data/sakai-cle
  # The method will throw an error if the specified file
  # is not found.
  # 
  # This method is designed to be able to use
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload=(file_name)
    frm.file_field(:id, "content_#{@@filex}").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
    @@filex+=1
  end
  
  # Clicks the Upload Files Now button, resets the
  # @@filex class variable back to zero, and instantiates
  # the Resources page class.
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    @@filex=0
    Resources.new(@browser)
  end
  
  # Clicks the Add Another File link.
  def add_another_file
    frm.link(:text=>"Add Another File").click
  end
  
end

class EditFileDetails
  
  include ToolsMenu
  
  # Clicks the Update button, then instantiates
  # the Resources page class.
  def update    
    frm.button(:value=>"Update").click
    Resources.new(@browser)
  end
  
  # Enters the specified string into the title field.
  def title=(title)
    frm.text_field(:id=>"displayName_0").set(title)
  end
  
  # Enters the specified string into the description field.
  def description=(description)
    frm.text_field(:id=>"description_0").set(description)
  end
  
  # Sets the radio button for publically viewable.
  def select_publicly_viewable
    frm.radio(:id=>"access_mode_public_0").set
  end
  
  # Checks the checkbox for showing only on the specifed
  # condition.
  def check_show_only_if_condition
    frm.checkbox(:id=>"cbCondition_0")
  end
  
  # Selects the specified Gradebook item value in the
  # select list.
  def gradebook_item=(item)
    frm.select(:id=>"selectResource_0").select(item)
  end
  
  # Selects the specified value in the item condition
  # field.
  def item_condition=(condition)
    frm.select(:id=>"selectCondition_0").select(condition)
  end
  
  # Sets the Grade field to the specified value.
  def assignment_grade=(grade)
    frm.text_field(:id=>"assignment_grade_0").set(grade)
  end
end

class CreateFolders #FIXME - Need to add functions for adding multiple folders
  
  include ToolsMenu
  
  # Clicks the Create Folders Now button, then
  # instantiates the Resources page class.
  def create_folders_now
    frm.button(:value=>"Create Folders Now").click
    Resources.new(@browser)
  end

  # Enters the specified string in the Folder Name
  # text field.
  def folder_name=(name)
    frm.text_field(:id=>"content_0").set(name)
  end

end

# Resources page for a given Site, in the Course Tools menu
class Resources < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this=>             "Resources",
      :parent =>          "Resources",
      :file_details =>    "EditFileDetails",
      :create_folders =>  "CreateFolders",
      :upload_files =>    "ResourcesUploadFiles"
    }
  end
  
end


#================
# Administrative Search Pages
#================

# The Search page in the Administration Workspace - "icon-sakai-search"
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

# The Search Admin page within the Search page in the Admin workspace
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
