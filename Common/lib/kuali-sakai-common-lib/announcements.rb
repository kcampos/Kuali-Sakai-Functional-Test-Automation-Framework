#================
# Announcements Pages
#================

# The Announcements list page for a Site.
module AnnouncementsMethods

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
module AnnouncementsMergeMethods

  # Checks the checkbox for the specified site name
  def check(site_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(site_name)}/).checkbox(:id=>/site/).set
  end

  def save
    frm.button(:value=>"Save").click
    Announcements.new(@browser)
  end

end

module PreviewAnnouncementsMethods

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
module AddEditAnnouncementsMethods

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

module AnnouncementsMergeMethods

end

module AnnouncementsOptionsMethods


end

module AnnouncementsPermissionsMethods

end