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

module CalendarMethods

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
    events_table.links.each do |link|
      list << link.title
      list << link.text
      list << link.href
      list << link.html[/(?<="location=").+doDescription/]
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

module EventDetailMethods

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

module AddEditEventMethods
  include PageObject
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

# The page that appears when the Frequency button is clicked on the Add/Edit
# Event page.
module EventFrequencyMethods
  include PageObject
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
module AddEditFieldsMethods
  include PageObject
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
module ImportStepOneMethods
  include PageObject
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
module ImportStepTwoMethods

  def continue
    frm.button(:value=>"Continue").click
    ImportStepThree.new(@browser)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file path is an optional second parameter, if you do not want to
  # include the full path in the filename.
  def import_file(filename, filepath="")
    frm.file_field(:name=>"importFile").set(filepath + filename)
  end

end

# The page for reviewing activities and confirming them for import.
module ImportStepThreeMethods
  include PageObject
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