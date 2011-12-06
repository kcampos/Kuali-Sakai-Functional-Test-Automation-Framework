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
    frm.frame(:id, "body___Frame").td(:id, "xEditingArea").frame(:index=>0).wait_until_present(60)
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
  
  #
  def import
    frm.link(:text=>"Import").click
    ImportStepOne.new(@browser)
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

# 
class ImportStepOne
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    ImportStepTwo.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    radio_button(:microsoft_outlook, :id=>"importType_Outlook", :frame=>frame)
    radio_button(:meeting_maker, :id=>"importType_MeetingMaker", :frame=>frame)
    radio_button(:generic_calendar_import, :id=>"importType_Generic", :frame=>frame)
  end
end

# 
class ImportStepTwo
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    ImportStepThree.new(@browser)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def import_file(filename)
    frm.file_field(:name=>"importFile").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end
  
end

# The page for reviewing activities and confirming them for import.
class ImportStepThree
  
  include PageObject
  include ToolsMenu
  
  def import_events
    frm.button(:value=>"Import Events").click
    Calendar.new(@browser)
  end
  
  # Returns an array containing the list of Activity names on the page.
  def events
    list = []
    frm.table(:class=>/listHier lines/).rows.each do |row|
      if row.label(:for=>/eventSelected/).exist?
        list << row.label.text
      end
    end
    names = []
    list.uniq!
    list.each do | item |
      name = item[/(?<=\s).+(?=\s\s\()/]
      names << name
    end
    return names
  end
  
  # Returns the date of the specified event
  def event_date(event_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(event_name)}/)[0].text
  end
  
  # Unchecks the checkbox for the specified event
  def uncheck_event(event_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(event_name)}/)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    radio_button(:import_events_for_site, :id=>"site", :frame=>frame)
    radio_button(:import_events_for_selected_groups, :id=>"groups", :frame=>frame)
  end
end


#================
# Evaluation System Pages
#================

# The "Evaluations Dashboard"
class EvaluationSystem
  
  include PageObject
  include ToolsMenu
  
  def my_templates
    frm.link(:text=>"My Templates").click
    MyTemplates.new(@browser)
  end
  
  def add_template
    frm.link(:text=>"Add Template").click
    AddTemplateTitle.new(@browser)
  end

  def take_evaluation(evaluation_name)
    frm.div(:class=>"summaryBox").table(:text=>/#{Regexp.escape(evaluation_name)}/).link.click
    TakeEvaluation.new(@browser)
  end
  
  def status_of(evaluation_name)
    return frm.div(:class=>"summaryBox").table(:text=>/#{Regexp.escape(evaluation_name)}/)[1][1].text
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddTemplateTitle
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    EditTemplate.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
    text_area(:description, :id=>"description", :frame=>frame)
  end
end

# 
class EditTemplate
  
  include PageObject
  include ToolsMenu
  
  def item_text=(text)
    frm.frame(:id, "item-text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def new_evaluation
    frm.link(:text=>"New evaluation").click
    frm.frame(:id, "instructions:1:input___Frame").td(:id, "xEditingArea").wait_until_present
    NewEvaluation.new(@browser)
  end

  def add
    frm.button(:value=>"Add").click
    frm.frame(:id, "item-text___Frame").td(:id, "xEditingArea").wait_until_present
  end
  
  def save_item
    frm.button(:value=>"Save item").click
    frm.link(:text=>"New evaluation").wait_until_present
    EditTemplate.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    select_list(:item, :id=>"add-item-control::add-item-classification-selection", :frame=>frame)
  end
end

# 
class NewEvaluation
  
  include PageObject
  include ToolsMenu
  
  def continue_to_settings
    frm.button(:value=>"Continue to Settings").click
    EvaluationSettings.new(@browser)
  end
  
  def instructions=(text)
    frm.frame(:id, "instructions:1:input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
  end
end

# 
class EvaluationSettings
  
  include PageObject
  include ToolsMenu

  def continue_to_assign_to_courses
    frm.button(:value=>"Continue to Assign to Courses").click
    EditEvaluationAssignment.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class EditEvaluationAssignment
  
  include PageObject
  include ToolsMenu
  
  def save_assigned_groups
    frm.button(:value=>"Save Assigned Groups").click
    ConfirmEvaluation.new(@browser)
  end

  def check_group(title)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(title)}/).checkbox(:name=>"selectedGroupIDs").set
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

#
class ConfirmEvaluation
  
  include PageObject
  include ToolsMenu
  
  def done
    frm.button(:value=>"Done").click
    MyEvaluations.new(@browser)
  end

end

# 
class MyEvaluations
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class TakeEvaluation
  
  include PageObject
  include ToolsMenu
  
  def submit_evaluation
    frm.button(:value=>"Submit Evaluation").click
    EvaluationSystem.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
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

#================
# Site Setup/Site Editor Pages
#================

# This module contains the methods referring to the menu items
# across the top of all the Site Editor pages.
module SiteEditorMenu
  
  # Clicks the Edit Tools link, then
  # instantiates the EditSiteTools class.
  def edit_tools
    frm.link(:text=>"Edit Tools").click
    EditSiteTools.new(@browser)
  end
  
  # Clicks the Manage Groups link and
  # instantiates the Groups Class.
  def manage_groups
    frm.link(:text=>"Manage Groups").click
    Groups.new(@browser)
  end
  
  # Clicks the Duplicate Site link and instantiates
  # the DuplicateSite class.
  def duplicate_site
    frm.link(:text=>"Duplicate Site").click
    DuplicateSite.new(@browser)
  end
  
  def add_participants
    frm.link(:text=>"Add Participants").click
    SiteSetupAddParticipants.new @browser
  end
  
end

# The Site Setup page - a.k.a., link class=>"icon-sakai-sitesetup"
class SiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "New" link on the Site Setup page.
  # instantiates the SiteType class.
  def new
    frm.div(:class=>"portletBody").link(:text=>"New").click
    SiteType.new(@browser)
  end
  
  # Searches for the specified site, then
  # selects the specified Site's checkbox.
  # Then clicks the Edit button and instantiates
  # The SiteSetupEdit class.
  def edit(site_name)
    frm.text_field(:id, "search").value=Regexp.escape(site_name)
    frm.button(:value=>"Search").click
    frm.div(:class=>"portletBody").checkbox(:name=>"selectedMembers").set
    frm.div(:class=>"portletBody").link(:text, "Edit").click
    SiteEditor.new(@browser)
  end

  # Enters the specified site name string in the search
  # field, clicks the Search button, then reinstantiates
  # the Class due to the page refresh.
  def search(site_name)
    frm.text_field(:id, "search").set site_name
    frm.button(:value, "Search").click
    SiteSetup.new(@browser)
  end

  # Searches for the specified site, then
  # checks the site, clicks the delete button,
  # and instantiates the DeleteSite class.
  def delete(site_name)
    frm.text_field(:id, "Search").value=site_name
    frm.button(:value=>"Search").click
    frm.checkbox(:name=>"selectedMembers").set
    frm.div(:class=>"portletBody").link(:text, "Delete").click
    DeleteSite.new(@browser)
  end
  
  # Returns an Array object containing strings of
  # all Site titles displayed on the web page.
  def site_titles
    titles = []
    sites_table = frm.table(:id=>"siteList")
    1.upto(sites_table.rows.size-1) do |x|
      titles << sites_table[x][1].text
    end
    return titles
  end
  
  in_frame(:class=>"portletMainIframe") do |frame| #FIXME!
    select_list(:view, :id=>"view", :frame=>frame)
    button(:clear_search, :value=>"Clear Search", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    link(:sort_by_title, :text=>"Worksite Title", :frame=>frame)
    link(:sort_by_type, :text=>"Type", :frame=>frame)
    link(:sort_by_creator, :text=>"Creator", :frame=>frame)
    link(:sort_by_status, :text=>"Status", :frame=>frame)
    link(:sort_by_creation_date, :text=>"Creation Date", :frame=>frame)
  end

end

# The topmost "Site Editor" page,
# found in SITE MANAGEMENT
# or else Site Setup after you have
# selected to Edit a particular site.
class SiteEditor
  
  include PageObject
  include ToolsMenu
  include SiteEditorMenu
  
  # Sets the specified role for the specified participant.
  #
  # Because the participant is selected using a regular expression,
  # the "participant" string can be anything that will suffice as a
  # unique match--i.e., last name, first name, or user id, or any combination,
  # as long as it will match a part of the string that appears in the
  # desired row.
  def set_role(participant, role)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(participant)}/).select(:id=>/role/).select(role)
  end
  
  def update_participants
    frm.button(:value=>"Update Participants").click
    SiteEditor.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:previous, :name=>"previous", :frame=>frame)
    button(:return_to_sites_list, :name=>"", :frame=>frame)
    button(:next, :name=>"", :frame=>frame)
    link(:printable_version, :text=>"Printable Version", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# Groups page inside the Site Editor
class Groups
    
  include PageObject
  include ToolsMenu
  include SiteEditorMenu
  
  # Clicks the Create New Group link and
  # instantiates the CreateNewGroup Class.
  def create_new_group
    frm.link(:text=>"Create New Group").click
    CreateNewGroup.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:auto_groups, :text=>"Auto Groups", :frame=>frame)
    button(:remove_checked, :id=>"delete-groups", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The Create New Group page inside the Site Editor
class CreateNewGroup

  include PageObject
  include ToolsMenu
  
  # Clicks the Add button and instantiates the Groups Class.
  def add
    frm.button(:id=>"save").click
    Groups.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"group_title", :frame=>frame)
    text_field(:description, :id=>"group_description", :frame=>frame)
    select_list(:site_member_list, :name=>"siteMembers-selection", :frame=>frame)
    select_list(:group_member_list, :name=>"groupMembers-selection", :frame=>frame)
    button(:right, :name=>"right", :index=>0, :frame=>frame)
    button(:left, :name=>"left", :index=>0, :frame=>frame)
    button(:all_right, :name=>"right", :index=>1, :frame=>frame)
    button(:all_left, :name=>"left",:index=>1, :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The first page of the Duplicate Site pages in the Site Editor.
class DuplicateSite
  
  include PageObject
  include ToolsMenu
   
  def duplicate
    frm.button(:value=>"Duplicate").click
    frm.span(:class=>"submitnotif").wait_while_present(300)
    SiteEditor.new(@browser)
  end

  # Returns the site name in the header, for verification.
  def site_name
    frm.div(:class=>"portletBody").h3.span(:class=>"highlight").text
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:site_title, :id=>"title", :frame=>frame)
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
  end
end


# Page for Adding Participants to a Site in Site Setup
class SiteSetupAddParticipants
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupChooseRole.new @browser
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_area(:official_participants, :id=>"content::officialAccountParticipant", :frame=>frame)
    text_area(:non_official_participants, :id=>"content::nonOfficialAccountParticipant", :frame=>frame)
    radio_button(:assign_all_to_same_role, :id=>"content::role-row:0:role-select", :frame=>frame)
    radio_button(:assign_each_individually, :id=>"content::role-row:1:role-select", :frame=>frame)
    radio_button(:active_status, :id=>"content::status-row:0:status-select", :frame=>frame)
    radio_button(:inactive_status, :id=>"content::status-row:1:status-select", :frame=>frame)
    button(:cancel, :id=>"content::cancel", :frame=>frame)
    
  end

end

# Page for selecting Participant roles individually
class SiteSetupChooseRolesIndiv
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    #SiteSetupParticipantEmail.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processDifferentRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    select_list(:user_role, :id=>"content::user-row:0:role-select-selection", :frame=>frame)
  end

end

# Page for selecting the same role for All. This class is used for
# both Course and Portfolio sites.
class SiteSetupChooseRole
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupParticipantEmail.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processSameRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    radio_button(:guest, :value=>"Guest", :frame=>frame)
    radio_button(:instructor, :value=>"Instructor", :frame=>frame)
    radio_button(:student, :value=>"Student", :frame=>frame)
    radio_button(:evaluator, :value=>"Evaluator", :frame=>frame)
    radio_button(:organizer, :value=>"Organizer", :frame=>frame)
    radio_button(:participant, :value=>"Participant", :frame=>frame)
    radio_button(:reviewer, :value=>"Reviewer", :frame=>frame)
    radio_button(:teaching_assistant, :id=>"content::role-row:3:role-select", :frame=>frame)
  end

end

# Page for specifying whether to send an email
# notification to the newly added Site participants
class SiteSetupParticipantEmail
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupParticipantConfirmation.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiCancel", :frame=>frame)
    radio_button(:send_now, :id=>"content::noti-row:0:noti-select", :frame=>frame)
    radio_button(:dont_send, :id=>"content::noti-row:1:noti-select", :frame=>frame)
    
  end

end

# The confirmation page showing site participants and their set roles
class SiteSetupParticipantConfirmation
  
  include PageObject
  include ToolsMenu
  
  def finish
    frm.button(:value=>"Finish").click
    SiteEditor.new(@browser)
  end
  
  # Returns the value of the id field for the specified name.
  def id(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[1].text
  end
  
  # Returns the value of the Role field for the specified name.
  def role(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[2].text
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmCancel", :frame=>frame)
  end
end

# The Edit Tools page (click on "Edit Tools" when editing a site
# in Site Setup in the Admin Workspace)
class EditSiteTools

  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the appropriate class for the page that apears.
  def continue
    frm.button(:value=>"Continue").click
    # Logic for determining the new page class...
    if frm.div(:class=>"portletBody").text =~ /^Add Multiple Tool/
      AddMultipleTools.new(@browser)
    elsif frm.div(:class=>"portletBody").text =~ /^Confirming site tools edits for/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "Something is wrong"
      puts frm.div(:class=>"portletBody").text
    end
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # This is a comprehensive list of all checkboxes and
    # radio buttons for this page, 
    # though not all will appear at one time.
    # The list will depend on the type of site being
    # created/edited.
    checkbox(:all_tools, :id=>"all", :frame=>frame)
    checkbox(:home, :id=>"home", :frame=>frame)
    checkbox(:announcements, :id=>"sakai.announcements", :frame=>frame)
    checkbox(:assignments, :id=>"sakai.assignment.grades", :frame=>frame)
    checkbox(:basic_lti, :id=>"sakai.basiclti", :frame=>frame)
    checkbox(:calendar, :id=>"sakai.schedule", :frame=>frame)
    checkbox(:email_archive, :id=>"sakai.mailbox", :frame=>frame)
    checkbox(:evaluations, :id=>"osp.evaluation", :frame=>frame)
    checkbox(:forms, :id=>"sakai.metaobj", :frame=>frame)
    checkbox(:glossary, :id=>"osp.glossary", :frame=>frame)
    checkbox(:matrices, :id=>"osp.matrix", :frame=>frame)
    checkbox(:news, :id=>"sakai.news", :frame=>frame)
    checkbox(:portfolio_layouts, :id=>"osp.presLayout", :frame=>frame)
    checkbox(:portfolio_showcase, :id=>"sakai.rsn.osp.iframe", :frame=>frame)
    checkbox(:portfolio_templates, :id=>"osp.presTemplate", :frame=>frame)
    checkbox(:portfolios, :id=>"osp.presentation", :frame=>frame)
    checkbox(:resources, :id=>"sakai.resources", :frame=>frame)
    checkbox(:roster, :id=>"sakai.site.roster", :frame=>frame)
    checkbox(:search, :id=>"sakai.search", :frame=>frame)
    checkbox(:styles, :id=>"osp.style", :frame=>frame)
    checkbox(:web_content, :id=>"sakai.iframe", :frame=>frame)
    checkbox(:wizards, :id=>"osp.wizard", :frame=>frame)
    checkbox(:blogger, :id=>"blogger", :frame=>frame)
    checkbox(:blogs, :id=>"sakai.blogwow", :frame=>frame)
    checkbox(:chat_room, :id=>"sakai.chat", :frame=>frame)
    checkbox(:discussion_forums, :id=>"sakai.jforum.tool", :frame=>frame)
    checkbox(:drop_box, :id=>"sakai.dropbox", :frame=>frame)
    checkbox(:email, :id=>"sakai.mailtool", :frame=>frame)
    checkbox(:forums, :id=>"sakai.forums", :frame=>frame)
    checkbox(:certification, :id=>"com.rsmart.certification", :frame=>frame)
    checkbox(:feedback, :id=>"sakai.postem", :frame=>frame)
    checkbox(:gradebook, :id=>"sakai.gradebook.tool", :frame=>frame)
    checkbox(:gradebook2, :id=>"sakai.gradebook.gwt.rpc", :frame=>frame)
    checkbox(:lesson_builder, :id=>"sakai.lessonbuildertool", :frame=>frame)
    checkbox(:lessons, :id=>"sakai.melete", :frame=>frame)
    checkbox(:live_virtual_classroom, :id=>"rsmart.virtual_classroom.tool", :frame=>frame)
    checkbox(:media_gallery, :id=>"sakai.kaltura", :frame=>frame)
    checkbox(:messages, :id=>"sakai.messages", :frame=>frame)
    checkbox(:news, :id=>"sakai.news", :frame=>frame)
    checkbox(:opensyllabus, :id=>"sakai.opensyllabus.tool", :frame=>frame)
    checkbox(:podcasts, :id=>"sakai.podcasts", :frame=>frame)
    checkbox(:polls, :id=>"sakai.poll", :frame=>frame)
    checkbox(:sections, :id=>"sakai.sections", :frame=>frame)
    checkbox(:site_editor, :id=>"sakai.siteinfo", :frame=>frame)
    checkbox(:site_statistics, :id=>"sakai.sitestats", :frame=>frame)
    checkbox(:syllabus, :id=>"sakai.syllabus", :frame=>frame)
    checkbox(:tests_and_quizzes_cb, :id=>"sakai.samigo", :frame=>frame)
    checkbox(:wiki, :id=>"sakai.rwiki", :frame=>frame)
    radio_button(:no_thanks, :id=>"import_no", :frame=>frame)
    radio_button(:yes, :id=>"import_yes", :frame=>frame)
    select_list(:import_sites, :id=>"importSites", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# Confirmation page when editing site tools in Site Setup
class ConfirmSiteToolsEdits
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Finish button, then instantiates
  # the SiteSetupEdit class.
  def finish
    frm.button(:value=>"Finish").click
    SiteEditor.new(@browser)
  end
  
end


# The Delete Confirmation Page for deleting a Site
class DeleteSite
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Remove button, then instantiates
  # the SiteSetup class.
  def remove
    frm.button(:value=>"Remove").click
    SiteSetup.new(@browser)
  end
  
  # Clicks the Cancel button, then instantiates
  # the SiteSetup class.
  def cancel
    frm.button(:value=>"Cancel").click
    SiteSetup.new(@browser)
  end
  
end
#The Site Type page that appears when creating a new site
class SiteType
  
  include PageObject
  include ToolsMenu
  
  # The page's Continue button. Button gets
  # clicked and then the appropriate class
  # gets instantiated, based on the page that
  # appears.
  def continue #FIXME
    if frm.button(:id, "submitBuildOwn").enabled?
      frm.button(:id, "submitBuildOwn").click
    elsif frm.button(:id, "submitFromTemplateCourse").enabled?
      frm.button(:id, "submitFromTemplateCourse").click
    elsif frm.button(:id, "submitFromTemplate").enabled?
      frm.button(:id, "submitFromTemplate").click
=begin
    elsif frm.button(:value=>"Continue", :index=>$frame_index).enabled?
      frm.button(:value=>"Continue", :index=>$frame_index).fire_event("onclick")
    elsif frm.button(:value=>"Continue", :index=>$frame_index).enabled?
      frm.button(:value=>"Continue", :index=>$frame_index).fire_event("onclick")
    elsif frm.button(:value=>"Continue", :index=>2).enabled?
      frm.button(:value=>"Continue", :index=>2).fire_event("onclick")
    else
      frm.button(:value=>"Continue", :index=>2).fire_event("onclick")
=end
    end
    
    if frm.div(:class=>"portletBody").h3.text=="Course/Section Information"
      CourseSectionInfo.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Project Site Information"
      ProjectSiteInfo.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Portfolio Site Information"
      PortfolioSiteInfo.new(@browser)
    else
      puts "Something is wrong on Saturn 3"
    end
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    radio_button(:course_site, :id=>"course", :frame=>frame)
    radio_button(:project_site, :id=>"project", :frame=>frame)
    radio_button(:portfolio_site, :id=>"portfolio", :frame=>frame)
    radio_button(:create_site_from_template, :id=>"copy", :frame=>frame)
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
    select_list(:select_template, :id=>"templateSiteId", :frame=>frame)
    select_list(:select_term, :id=>"selectTermTemplate", :frame=>frame)
    button(:cancel, :id=>"cancelCreate", :frame=>frame)
    checkbox(:copy_users, :id=>"copyUsers", :frame=>frame)
    checkbox(:copy_content, :id=>"copyContent", :frame=>frame)
  end
  
end

# The Add Multiple Tool Instances page that appears during Site creation
# after the Course Site Tools page
class AddMultipleTools
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the appropriate Class, based on the page that
  # appears.
  def continue
    frm.button(:value=>"Continue").click
    # Logic to determine the new page class
    if frm.div(:class=>"portletBody").text =~ /Course Site Access/
      SiteAccess.new(@browser)
    elsif frm.div(:class=>"portletBody").text =~ /^Confirming site tools edits/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "There's another path to define"
    end
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    # Note that the text field definitions included here
    # for the Tools definitions are ONLY for the first
    # instances of each. Since the UI allows for
    # an arbitrary number, if you are writing tests
    # that add more then you're going to have to explicitly
    # reference them or define them in the test case script
    # itself--for now, anyway.
    text_field(:site_email_address, :id=>"emailId", :frame=>frame)
    text_field(:basic_lti_title, :id=>"title_sakai.basiclti", :frame=>frame)
    select_list(:more_basic_lti_tools, :id=>"num_sakai.basiclti", :frame=>frame)
    text_field(:lesson_builder_title, :id=>"title_sakai.lessonbuildertool", :frame=>frame)
    select_list(:more_lesson_builder_tools, :id=>"num_sakai.lessonbuildertool", :frame=>frame)
    text_field(:news_title, :id=>"title_sakai.news", :frame=>frame)
    text_field(:news_url_channel, :name=>"channel-url_sakai.news", :frame=>frame)
    select_list(:more_news_tools, :id=>"num_sakai.news", :frame=>frame)
    text_field(:web_content_title, :id=>"title_sakai.iframe", :frame=>frame)
    text_field(:web_content_source, :id=>"source_sakai.iframe", :frame=>frame)
    select_list(:more_web_content_tools, :id=>"num_sakai.iframe", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
    
  end
  
end

# The Course/Section Information page that appears when creating a new Site
class CourseSectionInfo
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the CourseSiteInfo Class.
  def continue
    frm.button(:value=>"Continue").click
    CourseSiteInfo.new(@browser)
  end
  
  # Clicks the Done button (or the
  # "Done - go to Site" button if it
  # happens to be there), then instantiates
  # the SiteSetup Class.
  def done
    frm.button(:value=>/Done/).click
    SiteSetup.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # Note that ONLY THE FIRST instances of the
    # subject, course, and section fields
    # are included in the page elements definitions here,
    # because their identifiers are dependent on how
    # many instances exist on the page.
    # This means that if you need to access the second
    # or subsequent of these elements, you'll need to
    # explicitly identify/define them in the test case
    # itself.
    text_field(:subject, :name=>"Subject:0", :frame=>frame)
    text_field(:course, :name=>"Course:0", :frame=>frame)
    text_field(:section, :name=>"Section:0", :frame=>frame)
    text_field(:authorizers_username, :id=>"uniqname", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    select_list(:add_more_rosters, :id=>"number", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Site Access Page that appears during Site creation
# immediately following the Add Multiple Tools Options page.
class SiteAccess
  
  include PageObject
  include ToolsMenu
  
  # The page element that displays the joiner role
  # select list. Use this method to validate whether the
  # select list is visible or not.
  #
  # Example: page.joiner_role_div.visible?
  def joiner_role_div
    frm.div(:id=>"joinerrole")
  end
  
  # Clicks the Continue button, then
  # instantiates the ConfirmCourseSiteSetup class.
  def continue
    frm.button(:value=>"Continue").click
    ConfirmSiteSetup.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    radio_button(:publish_site, :id=>"publish", :frame=>frame)
    radio_button(:leave_as_draft, :id=>"unpublish", :frame=>frame)
    radio_button(:limited, :id=>"unjoinable", :frame=>frame)
    radio_button(:allow, :id=>"joinable", :frame=>frame)
    button(:back, :name=>"eventSubmit_doBack", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel_create", :frame=>frame)
    select_list(:joiner_role, :id=>"joinerRole", :frame=>frame)
  end

end

# The Confirmation page at the end of a Course Site Setup
class ConfirmSiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Request Site button, then
  # instantiates the SiteSetup Class.
  def request_site
    frm.button(:value=>"Request Site").click
    SiteSetup.new(@browser)
  end
  
  # For portfolio sites...
  # Clicks the "Create Site" button and
  # instantiates the SiteSetup class.
  def create_site
    frm.button(:value=>"Create Site").click
    SiteSetup.new(@browser)
  end
  
end

# The Course Site Information page that appears when creating a new Site
# immediately after the Course/Section Information page
class CourseSiteInfo
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then
  # instantiates the EditSiteTools Class.
  def continue
    frm.button(:value=>"Continue").click
    EditSiteTools.new(@browser)
  end
  
  # Gets the text contained in the alert box
  # on the web page.
  def alert_box_text
    frm.div(:class=>"portletBody").div(:class=>"alertMessage").text
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# 
class PortfolioSiteInfo
  
  include PageObject
  include ToolsMenu

  def description=(text)
    frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def continue
    frm.button(:value=>"Continue").click
    PortfolioSiteTools.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
    text_field(:url_alias, :id=>"alias_0", :frame=>frame)
    text_area(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:icon_url, :id=>"iconUrl", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
  end
end

# 
class PortfolioSiteTools
  
  include PageObject
  include ToolsMenu

  def continue
    frm.button(:value=>"Continue").click
    PortfolioConfigureToolOptions.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    checkbox(:all_tools, :id=>"all", :frame=>frame)
    
  end
end

# 
class PortfolioConfigureToolOptions
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteAccess.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:email, :id=>"emailId", :frame=>frame)
  end
end


