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

# The topmost page for the Announcements tool
class Announcements
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:merge, :text=>"Merge", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
    
  end

end

# Adding a new Announcement
class AnnouncementsAdd
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    
    # Going to define the WYSIWYG text editor at some later time
    
    text_field(:title, :id=>"subject", :frame=>frame)
    radio_button(:show, :id=>"hidden_false", :frame=>frame)
    radio_button(:hide, :id=>"hidden_true", :frame=>frame)
    radio_button(:specify_dates, :id=>"hidden_specify", :frame=>frame)
    button(:add_attachments, :name=>"attach", :frame=>frame)
    button(:add_announcement, :name=>"post", :frame=>frame)
    button(:preview, :name=>"preview", :frame=>frame)
    button(:clear, :name=>"cancel", :frame=>frame)
    
  end

end

# Page for merging announcements from other sites
class AnnouncementsMerge
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # This page can have an arbitrary number of site checkboxes.
    # Only the first 5 are defined here.
    # The rest will have to be called explicitly in any
    # test case that needs to access those elements
    checkbox(:site1, :id=>"site1", :frame=>frame)
    checkbox(:site2, :id=>"site2", :frame=>frame)
    checkbox(:site3, :id=>"site3", :frame=>frame)
    checkbox(:site4, :id=>"site4", :frame=>frame)
    checkbox(:site5, :id=>"site5", :frame=>frame)
    button(:save, :name=>"eventSubmit_doUpdate", :frame=>frame)
    button(:clear, :name=>"eventSubmit_doCancel", :frame=>frame)
  end

end

# Page for setting up options for announcements
class AnnouncementsOptions
  
  include PageObject
  include ToolsMenu
=begin  
  in_frame(:index=>$frame_index) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end
=end
end

# Page containing permissions options for announcements
class AnnouncementsPermissions
  
  include PageObject
  include ToolsMenu
=begin  
  in_frame(:index=>$frame_index) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end
=end
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
  
  in_frame(:index=>0) do |frame| #FIXME!
    select_list(:view, :id=>"view", :frame=>frame)
    select_list(:show_events, :id=>"timeFilterOption", :frame=>frame)
    select_list(:start_month, :id=>"customStartMonth", :frame=>frame)
    select_list(:start_day, :id=>"customStartDay", :frame=>frame)
    select_list(:start_year, :id=>"customStartYear", :frame=>frame)
    select_list(:end_month, :id=>"customEndMonth", :frame=>frame)
    select_list(:end_day, :id=>"customEndDay", :frame=>frame)
    select_list(:end_year, :id=>"customEndYear", :frame=>frame)
    button(:filter_events, :name=>"eventSubmit_doCustomdate", :frame=>frame)
    button(:go_to_today, :name=>"eventSubmit_doToday", :frame=>frame)
    
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
  end
  
  # The Home class should be instantiated whenever the user
  # context is a given Site or the Administration Workspace.
  # In that context, the frame index is 1.
  $frame_index=1
  
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
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  #
  # It then instantiates the ResourcesUploadFiles class.
  def upload_files_to_folder(folder_name)
    index = folder_names.index(folder_name)
    frm.link(:text=>"Start Add Menu", :index=>index).fire_event("onfocus")
    frm.link(:text=>"Upload Files", :index=>index).click
    ResourcesUploadFiles.new(@browser)
  end
  
  def open_folder(name)
    frm.link(:text=>name).click
    Resources.new(@browser)
  end
  
  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder, then
  # instantiates the CreateFolders class.
  def create_subfolders_in(folder_name)
    index = folder_names.index(folder_name)
    frm.link(:text=>"Start Add Menu", :index=>index).fire_event("onfocus")
    frm.link(:text=>"Create Folders", :index=>index).click
    CreateFolders.new(@browser)
  end
  
  def edit_details(name)
    menus = resource_names.compact
    index=menus.index(name)
    frm.li(:text=>/Action/, :class=>"menuOpen", :index=>index).fire_event("onclick")
    frm.link(:text=>"Edit Details", :index=>index).click
    EditFileDetails.new(@browser)
  end
 
  # This method returns folder names only
  def folder_names
    names = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if (resources_table[x][2].h3.exist? || resources_table[x][2].h4.exist?) && resources_table[x][2].a.title=="Folder"
        names << resources_table[x][2].text
      end
    end
    return names
  end
  
  # This method returns an array of the file names currently listed
  # on the Resources page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    resources_table = frm.table(:class=>"listHier lines centerLines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].h4.exist? && resources_table[x][2].a(:index=>1).title=="Unknown"
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

  def access_level(filename)
    index = resource_names.index(filename)
    frm.table(:class=>"listHier lines centerLines")[index+1][6].text
  end

  in_frame(:index=>1) do |frame|
    button(:remove, :value=>"Remove", :frame=>frame)
    button(:move, :value=>"Move", :frame=>frame)
  end

end

# New class template. For quick class creation...
class ResourcesUploadFiles
  
  include PageObject
  include ToolsMenu
  
  @@filex=0
  
  # Note that the file_to_upload method can be used
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload=(file_name)
    frm.file_field(:id, "content_#{@@filex}").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
    @@filex+=1
  end
  
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    @@filex=0
    Resources.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    link(:add_another_file, :text=>"Add Another File", :frame=>frame)
    
  end

end

class EditFileDetails
  
  include PageObject
  include ToolsMenu
  
  def update    
    frm.button(:value=>"Update").click
    Resources.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"displayName_0", :frame=>frame)
    text_area(:description, :id=>"description_0", :frame=>frame)
    radio_button(:publicly_viewable, :id=>"access_mode_public_0", :frame=>frame)
    checkbox(:show_only_if_condition, :id=>"cbCondition_0", :frame=>frame)
    select_list(:gradebook_item, :id=>"selectResource_0", :frame=>frame)
    select_list(:item_condition, :id=>"selectCondition_0", :frame=>frame)
    text_field(:assignment_grade, :id=>"assignment_grade_0", :frame=>frame)
  end
end

class CreateFolders #FIXME - Need to add functions for adding multiple folders
  
  include PageObject
  include ToolsMenu
  
  def create_folders_now
    frm.button(:value=>"Create Folders Now").click
    Resources.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:folder_name, :id=>"content_0", :frame=>frame)
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
