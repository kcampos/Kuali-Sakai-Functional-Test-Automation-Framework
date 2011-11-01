# Page classes that are in some way common to both
# the Site context and the My Workspace context.
# 
# == Synopsis
#
# This script defines the page classes that are
# common to both page contexts and so require mindful
# handling of page object definition, to ensure
# the objects can always be found regardless of the index
# of the page frame that contains them.
#
# Most classes in this document should NOT use the Page-Object gem.
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
class AnnouncementsAttach

  include ToolsMenu
  
  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  #
  # It then instantiates the AnnouncementsUploadFiles class.
  def upload_files_to_folder(folder_name)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
    AnnouncementsUploadFiles.new(@browser)
  end
  
  # Clicks the specified folder, then re-instantiates the
  # page class.
  def open_folder(name)
    frm.link(:text=>name).click
    AnnouncementsAttach.new(@browser)
  end
  
  # Clicks the "Attach a copy" link for the specified
  # file, then reinstantiates the Class.
  # If an alert box appears, the method will call itself again.
  # Note that this can lead to an infinite loop. Will need to fix later.
  def attach_a_copy(file_name)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doAttachitem/).click
    
    if frm.div(:class=>"alertMessage").exist?
      sleep 1
      attach_a_copy(file_name) # FIXME
    end
    
    AnnouncementsAttach.new(@browser)
  end
  
  # Clicks the Show Other Sites link, then
  # re-instantiates the page class.
  def show_other_sites
    frm.link(:text=>"Show other sites").click
    AnnouncementsAttach.new(@browser)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder, then
  # instantiates the AnnouncementsCreateFolders class.
  def create_subfolders_in(folder_name)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    AnnouncementsCreateFolders.new(@browser)
  end
  
  # Selects the menu of the specified resource, then
  # clicks on the Edit Details menu item, then
  # instantiates the AnnouncementsEditFileDetails page class.
  def edit_details(name) #FIXME
    menus = resource_names.compact
    index=menus.index(name)
    frm.li(:text=>/Action/, :class=>"menuOpen", :index=>index).fire_event("onclick")
    frm.link(:text=>"Edit Details", :index=>index).click
    AnnouncementsEditFileDetails.new(@browser)
  end
 
  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].exist? && resources_table[x][0].a.title=="Folder"
        names << resources_table[x][0].text
      end
    end
    return names
  end
  
  # Returns an array of the file names currently listed
  # on the page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].a(:index=>1).exist? && resources_table[x][0].a(:index=>1).title != "Folder"
        names << resources_table[x][0].text
      end
    end
    return names
  end
  
  # This method returns an array of both the file and folder names
  # currently listed on the Resources page.
  #
  # Note that it adds "" entries for any blank lines found
  # so that the row index will still be accurate for the
  # table itself. This is sometimes necessary for being
  # able to find the correct row.
  def resource_names
    titles = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].link.exist?
        titles << resources_table[x][0].text
      else
        titles << ""
      end
    end
    return titles
  end

  # Clicks the Remove button.
  def remove
    frm.button(:value=>"Remove").click
  end
  
  # Clicks the Move button.
  def move
    frm.button(:value=>"Move").click
  end
  
  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it re-instantiates the AnnouncementsAttach page class.
  def upload_multiple_files_to_folder(folder, file_array)
    
    upload = upload_files_to_folder folder
    
    file_array.each do |file|
      upload.file_to_upload=file
      upload.add_another_file
    end
    
    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload=file
        resources = upload_files.upload_files_now
      end
    end
    AnnouncementsAttach.new(@browser)
  end

  # Clicks the Continue button, then
  # instantiates the AddEditAnnouncements Class.
  def continue
    frm.button(:value=>"Continue").click
    AddEditAnnouncements.new(@browser)
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

# Top page of the Calendar
# For now it includes all views, though that probably
# means it will have to be re-instantiated every time
# a new view is selected.
class Calendar
  
  include PageObject
  include ToolsMenu
  
  # Selects the specified item in the View select list.
  def view=(item)
    frm.select(:id=>"view").select(item)
  end
  
  # Selects the specified item in the Show select list.
  def show=(item)
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
  
  # Returns an array of the displayed event descriptions when
  # viewing a list of events.
  def events_list
    list = []
    events_table = frm.table(:class=>"listHier lines nolines")
    links = events_table.links.find_all { |link| link.href=~/Description/ }
    links.each { |link| list << link.text }
    return list
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
  in_frame(:index=>2) do |frame|
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
  
  # The MyWorkspace class should ONLY be instantiated when
  # the user context is NOT a given site or Administration Workspace.
  # Otherwise the frame index will not be 0, and page objects
  # will not be found by Webdriver.
  $frame_index=0
  
end

#================
# Resources Pages 
#================

# Resources page for a given Site, in the Course Tools menu
class Resources

  include ToolsMenu
  
  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  #
  # It then instantiates the ResourcesUploadFiles class.
  def upload_files_to_folder(folder_name)
    frm.table(:class=>"listHier lines centerLines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>"listHier lines centerLines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
    ResourcesUploadFiles.new(@browser)
  end
  
  # Clicks the specified folder, then re-instantiates the
  # page class.
  def open_folder(name)
    frm.link(:text=>name).click
    Resources.new(@browser)
  end
  
  # Clicks the Show Other Sites link, then
  # re-instantiates the page class.
  def show_other_sites
    frm.link(:text=>"Show other sites").click
    Resources.new(@browser)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder, then
  # instantiates the CreateFolders class.
  def create_subfolders_in(folder_name)
    frm.table(:class=>"listHier lines centerLines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>"listHier lines centerLines").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    CreateFolders.new(@browser)
  end
  
  # Selects the menu of the specified resource, then
  # clicks on the Edit Details menu item, then
  # instantiates the EditFileDetails page class.
  def edit_details(name) #FIXME
    menus = resource_names.compact
    index=menus.index(name)
    frm.li(:text=>/Action/, :class=>"menuOpen", :index=>index).fire_event("onclick")
    frm.link(:text=>"Edit Details", :index=>index).click
    EditFileDetails.new(@browser)
  end
 
  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].exist? && resources_table[x][2].a.title=="Folder"
        names << resources_table[x][2].text
      end
    end
    return names
  end
  
  # Returns an array of the file names currently listed
  # on the Resources page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].a(:index=>1).exist? && resources_table[x][2].a(:index=>1).title != "Folder"
        names << resources_table[x][2].text
      end
    end
    return names
  end
  
  # This method returns an array of both the file and folder names
  # currently listed on the Resources page.
  #
  # Note that it adds "" entries for any blank lines found
  # so that the row index will still be accurate for the
  # table itself. This is sometimes necessary for being
  # able to find the correct row.
  def resource_names
    titles = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].link.exist?
        titles << resources_table[x][2].text
      else
        titles << ""
      end
    end
    return titles
  end

  # Gets the value of the access level cell for the specified
  # file.
  def access_level(filename)
    index = resource_names.index(filename)
    frm.table(:class=>"listHier lines centerLines")[index+1][6].text
  end

  # Clicks the Remove button.
  def remove
    frm.button(:value=>"Remove").click
  end
  
  # Clicks the Move button.
  def move
    frm.button(:value=>"Move").click
  end
  
  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it instantiates the Resources page class.
  def upload_multiple_files_to_folder(folder, file_array)
    
    upload = upload_files_to_folder folder
    
    file_array.each do |file|
      upload.file_to_upload=file
      upload.add_another_file
    end
    
    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload=file
        resources = upload_files.upload_files_now
      end
    end
    Resources.new(@browser)
  end

end

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
