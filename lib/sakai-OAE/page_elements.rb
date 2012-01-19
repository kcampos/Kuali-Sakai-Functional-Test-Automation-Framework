#!/usr/bin/env ruby
# 
# == Synopsis
# 
# Sakai-OAE Page Object definitionstext_field(:name, :tag=>"identifier")

#
require 'page-object'
require 'cgi'
#require File.dirname(__FILE__) + "/app_functions.rb"

# ======================
# ======================
# Modules and namespaces
# ======================
# ======================

# # # # # # # # # # # # 
#  Toolbars and Menus #
# # # # # # # # # # # # 

# The Topmost Header menu bar, present on most pages,
# plus the Footer contents, too. This module also contains
# references to the notification pop-ups that appear in the upper
# right.
module HeaderFooterBar
  
  include PageObject
  
  # A generic link-clicking method. It clicks on a page link with text that
  # matches the supplied string. Since it uses Regex to find a match, the
  # string can be a substring of the desired link's full text.
  # This method should be used as a last resort, however, since it does not
  # instantiate a new page class. You will have to instantiate
  # the target page class explicitly in the test script itself, if required.
  def click_link(string)
    @browser.link(:text=>/#{Regexp.escape(string)}/).click
    @browser.wait_for_ajax
  end
  
  link(:help, :id=>"help_tab")
  float_menu(:my_dashboard, "You", "My dashboard", "MyDashboard")
  float_menu(:my_messages, "You", "My messages", "MyMessages")
  float_menu(:my_profile, "You", "My profile", "MyProfileBasicInfo")
  float_menu(:my_library, "You", "My library", "MyLibrary")
  float_menu(:my_memberships, "You", "My memberships", "MyMemberships") 
  float_menu(:my_contacts, "You", "My contacts", "MyContacts")
  float_menu(:add_content, "Create + Collect", "Add content", "AddContent")
  float_menu(:add_collection, "Create + Collect", "Add collection", "AddCollection")
  float_menu(:create_a_group, "Create + Collect", "Create a group", "CreateGroups")
  float_menu(:create_a_course, "Create + Collect", "Create a course", "CreateCourses")
  float_menu(:create_a_research_project, "Create + Collect", "Create a research project", "CreateResearch")  
  float_menu(:explore_all_categories, "Explore", "Browse all categories", "ExploreAll")
  float_menu(:explore_content,"Explore","Content", "ExploreContent")
  float_menu(:explore_people,"Explore","People", "ExplorePeople")
  float_menu(:explore_groups,"Explore","Groups","ExploreGroups")
  float_menu(:explore_courses,"Explore","Courses","ExploreCourses")
  float_menu(:explore_research,"Explore","Research projects","ExploreResearch")
  
  alias explore_research_projects explore_research
  
  # Opens the User Options menu in the header menu bar,
  # clicks the Preferences item, waits for the Account Preferences
  # Pop up dialog to appear, and then includes the AccountPreferencesPopUp
  # module in the currently instantiated Class Object.
  def my_account
    @browser.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    @browser.link(:id=>"subnavigation_preferences_link").click
    @browser.wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end
  
  # Opens the Create + Add menu in the header bar,
  # clicks on the Add Content item, waits for the Pop Up
  # dialog to appear, then includes the AddContentContainer module
  # in the currently instantiated Class Object.
  def add_content
    @browser.link(:title=>"Create + Add").fire_event("onmouseover")
    @browser.link(:title=>"Add content").click
    @browser.wait_until { @browser.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  button(:cancel, :text=>"Cancel")
  # Don't use this button directly when opening the collector. Instead, use the "toggle_collector" method
  # so that the Collector Widget module will be included in the object's Class.
  # You *can* use this, however, to close the collector.
  button(:collector, :class=>"topnavigation_menuitem_counts_container collector_toggle")
  button(:save, :text=>"Save")
  
  div(:notification, :class=>"gritter-with-image")
  
  def close_notification
    notification_element.fire_event "onmouseover"
    @browser.div(:class=>"gritter-close").fire_event "onclick"
  end
  
  def toggle_collector
    collector
    @browser.wait_for_ajax
    self.class.class_eval { include CollectorWidget }
  end
  
  # Define global search later
  
  # Define footer items later
  
end

# This is the Header that appears in the Worlds context,
# So it appears for Courses, Groups, and Research
module HeaderBar
  
  include PageObject
  
  button(:join_group_button, :id=>/joinrequestbuttons_join_.*/)
  button(:request_to_join_group_button, :id=>/joinrequestbuttons_request_.*/)
  button(:request_pending_button, :id=>/joinrequestbuttons_pending_.*/)
  button(:message_button, :text=>"Message")
  
  def join_group
    join_group_button
    @browser.wait_until { notification_element.exists? }
  end
  
  def request_to_join_group
    request_to_join_group_button
    @browser.wait_until { notification_element.exists? }
  end
  
  # Clicks the Message button in the page header (not the
  # Header bar, but just below that), waits for the Message Pop Up
  # dialog to load, and then includes the SendMessagePopUp
  # module in the currently instantiated Class Object.
  def message
    message_button
    @browser.wait_until { @browser.text.include? "Send Message" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  # Clicks the Permissions button in the page header (below the
  # Header bar, though), clicks "Add Content", then waits for the
  # Add Content stuff to load, then includes the
  # AddContentContainer module in the object's Class.
  def add_content
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Add content").click
    @browser.wait_until { @browser.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Manage participants",
  # waits for the Contacts and Memberships stuff to load, then
  # includes the ManageParticipants module in the Class of the object
  # calling the method.
  def manage_participants
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Manage participants").click
    @browser.wait_until { @browser.text.include? "My contacts and memberships" }
    self.class.class_eval { include ManageParticipants }
  end
  
  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Settings",
  # waits for the Settings stuff to load, then
  # includes the SettingsPopUp module in the Class of the object
  # calling the method.
  def settings
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Settings").click
    @browser.wait_until { @browser.text.include? "Apply Settings" }
    self.class.class_eval { include SettingsPopUp }
  end

  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Categories",
  # waits for the Categories Pop Up to load, then
  # includes the AddRemoveCategories module in the Class of the object
  # calling the method.
  def categories
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Categories").click
    @browser.wait_until { @browser.text.include? "Assign a category" }
    self.class.class_eval { include AddRemoveCategories }
  end
  
  # Clicks the down arrow next to the Avatar picture in the Page Header
  # (not the Header bar), clicks the option to change the picture,
  # then includes the ChangePicturePopup in the Class of the object
  # calling the method.
  def change_picture
    @browser.div(:class=>"entity_profile_picture_down_arrow").fire_event("onclick")
    @browser.link(:id=>"changepic_container_trigger").click
    self.class.class_eval { include ChangePicturePopup }
  end
  
end

# The generic Left Menu Bar.
# Methods here are specifically geared toward menu
# items that are customized/customizable
module LeftMenuBar
  
  include PageObject
  
  # Clicks the specified link in the left menu
  # list, then, based on the supplied page type,
  # instantiates the appropriate page Class.
  def open_page(name, type)
    @browser.div(:id=>"lhnavigation_container").link(:text=>name).click
    case(type.downcase)
    when "document"
      instantiate_class("Documents")
    when "remote content"
      instantiate_class("Documents") # 
    when "library"
      instantiate_class("Library") #
    when "participants"
      instantiate_class("Participants") #
    when "discussion"
      instantiate_class("Discussions") #
    when "inline content"
      instantiate_class("InlineContent") 
    when "tests and quizzes"
      instantiate_class("Tests") #
    when "calendar"
      instantiate_class("Calendar") #
    when "google maps"
      instantiate_class("GoogleMaps") #
    when "files and documents"
      instantiate_class("Files") #
    when "comments"
      instantiate_class("Comments") #
    when "jisc content"
      instantiate_class("JISC") #
    when "assignments"
      instantiate_class("Tasks") #
    when "rss feed reader"
      instantiate_class("RSS") #
    when "basic lti"
      instantiate_class("LTI") #
    when "google gadget"
      instantiate_class("Gadget") #
    when "gradebook"
      instantiate_class("Gradebook") #
    when "read_only"
      instantiate_class("ViewDocument") #
    end
  end
  
  # Use this to click left menu items that refer to multi-paged documents.
  # It expands the menu to display the document's pages.
  def expand(name)
    @browser.div(:id=>"lhnavigation_container").link(:text=>name).click
  end
  
  # Changes the title of the specified page ("from_string")
  # to the string value specified by to_string.
  def change_title_of(from_string, to_string)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).hover
    @browser.wait_for_ajax #.wait_until { @browser.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    @browser.div(:class=>"lhnavigation_selected_submenu_image").hover
    @browser.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    @browser.wait_for_ajax #.wait_until { @browser.link(:id=>"lhavigation_submenu_edittitle").visible? }
    @browser.link(:id=>"lhavigation_submenu_edittitle").click
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.text_field(:class=>"lhnavigation_change_title").set("#{to_string}\n")
  end
  
  alias change_title change_title_of
  
  # Deletes the page specified by page_name.
  def delete_page(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.wait_for_ajax #.wait_until { @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    @browser.div(:class=>"lhnavigation_selected_submenu_image").hover
    @browser.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    @browser.wait_for_ajax #.wait_until { @browser.link(:id=>"lhavigation_submenu_edittitle").visible? }
    @browser.link(:id=>"lhavigation_submenu_deletepage").click
  end
  
  # Opens the Permissions Pop Up for the specified Page.
  def permissions_for(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.wait_until { @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    @browser.div(:class=>"lhnavigation_selected_submenu_image").hover
    @browser.execute_script("$('#lhnavigation_submenu').css({left:'328px', top:'349px', display: 'block'})")
    @browser.wait_until { @browser.link(:id=>"lhavigation_submenu_edittitle").visible? }
    @browser.link(:id=>"lhnavigation_submenu_permissions").click
    @browser.wait_until { @browser.button(:id=>"entity_content_permissions").exist? }
    self.class.class_eval { include AreaPermissionsPopUp }
  end
  
  alias permissions_of permissions_for
  alias permissions permissions_for
  
  # Opens the Profile Details for the specified Page.
  def view_profile_of(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.wait_for_ajax #.wait_until { @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    @browser.div(:class=>"lhnavigation_selected_submenu_image").hover
    @browser.execute_script("$('#lhnavigation_submenu').css({left:'328px', top:'349px', display: 'block'})")
    @browser.wait_for_ajax #.wait_until { @browser.link(:id=>"lhavigation_submenu_edittitle").visible? }
    @browser.link(:id=>"lhnavigation_submenu_profile").click
    @browser.wait_for_ajax #.button(:title=>"Show debug info").wait_until_present
    @browser.window(:title=>"rSmart | Content Profile").use
    ContentDetailsPage.new @browser
  end
  
  alias view_profile_for view_profile_of
  alias view_profile view_profile_of
  
  # Clicks the "Add a new area" button.
  def add_new_area
    @browser.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").click
    @browser.wait_for_ajax(6)
    self.class.class_eval { include AddAreasPopUp }
  end
  
  alias add_a_new_area add_new_area
  alias add_new_page add_new_area
  alias add add_new_area
  
  # Returns an array containing the Course/Group area/page titles.
  def public_pages
    list = []
    @browser.div(:id=>"lhnavigation_public_pages").links.each do |link|
      list << link.text
    end
    return list
  end
  
  private
  
  def instantiate_class(clash)
    @browser.wait_for_ajax
    @browser.return_to_top
    eval(clash).new @browser
  end
  
end

#
module SearchBar
  
  include PageObject
  
  def search_for=(text)
    @browser.text_field(:id=>"search_text").set("#{text}\n")
    @browser.wait_for_ajax(10)
  end
  
  alias search= search_for=
  alias search search_for=
  alias search_for search_for=
  alias find search_for=
  alias find= search_for=
  
end

# The Left Menu Bar when in the context of the "You" pages
module YouPagesLeftMenu
  
  include PageObject
  
  navigating_link(:basic_information, "Basic Information", "MyProfileBasicInfo")
  navigating_link(:about_me, "About Me", "MyProfileAboutMe")
  navigating_link(:online, "Online", "MyProfileOnline")
  navigating_link(:contact_information, "Contact Information", "MyProfileContactInfo")
  navigating_link(:publications, "Publications", "MyProfilePublications")
  
  permissions_menu(:about_me_permissions, "About Me")
  permissions_menu(:online_permissions, "Online")
  permissions_menu(:contact_information_permissions, "Contact Information")
  permissions_menu(:publications_permissions, "Publications")
  
  div(:profile_pic_arrow, :class=>"s3d-dropdown-menu-arrow entity_profile_picture_down_arrow")
  
  # Opens the Pop Up dialog for changing the Avatar image for the
  # current page.
  def change_picture
    profile_pic_arrow_element.fire_event("onclick")
    @browser.link(:id=>"changepic_container_trigger").click
    self.class.class_eval { include ChangePicturePopUp }
  end

end

# The left menu bar when creating Groups, Courses, or Research
module CreateWorldsLeftMenu
  
  include PageObject
  
  navigating_link(:group, "Group", "CreateGroups")
  navigating_link(:course, "Course", "MyProfileCategories")
  navigating_link(:research, "Research", "MyProfileAboutMe")
  
end

# Methods for the 3 buttons that appear above all Document-type "Areas" in
# Groups/Courses.
module DocButtons

  include PageObject
  
  # Clicks the Edit Page button.
  def edit_page
    @browser.back_to_top
    @browser.button(:text=>"Edit page").click
    @browser.wait_for_ajax
    self.class.class_eval { include DocumentWidget }
  end
  
  # Clicks the Add Page button.
  def add_page
    @browser.back_to_top
    
  end
  
  # Clicks the Page Revisions button.
  def page_revisions
    @browser.back_to_top
    
  end
  
  private
  
  # The generic method for editing widget settings.
  def widget_settings
    # jQuery
    click_settings=%|$("#context_settings").trigger("mousedown");|
    
    # watir-webdriver
    edit_page
    open_widget_menu
    @browser.execute_script(click_settings)
    @browser.wait_for_ajax(1)
  end
  
  # The generic method for removing widgets.
  def remove_widget
    # JQuery
    jq_remove = %|$("#context_remove").trigger("mousedown");|
    
    # watir-webdriver
    edit_page
    open_widget_menu
    @browser.execute_script(jq_remove)
    @browser.wait_for_ajax(1)
  end
  
  # The generic method for editing widget wrappings.
  def widget_wrapping
    #jQuery
    jq_wrapping = %|$("#context_appearance_trigger").trigger("mousedown");|
    
    #watir-webdriver
    edit_page
    open_widget_menu
    @browser.execute_script(jq_wrapping)
    @browser.wait_for_ajax(1)
    self.class.class_eval { include AppearancePopUp }
  end
  
  def open_widget_menu(number=0)
    # jQuery commands
    click_widget=%|tinyMCE.get("elm1").selection.select(tinyMCE.get("elm1").dom.select('.widget_inline')[#{number}]);|
    node_change=%|tinyMCE.get("elm1").nodeChanged();|
    
    # watir-webdriver
    @browser.wait_for_ajax
    @browser.execute_script(click_widget)
    @browser.wait_for_ajax(1)
    @browser.execute_script(node_change)
    @browser.wait_for_ajax(1)
  end
  
end

# # # # # # # # # # # # 
#    Pop-Up Dialogs   #
# # # # # # # # # # # # 

# Methods related to the My Account Pop Up dialog.
module AccountPreferencesPopUp
  
  include PageObject
  
  button(:preferences, :id=>"accountpreferences_preferences_tab")
  button(:privacy_settings, :id=>"accountpreferences_privacy_tab")
  button(:password, :id=>"accountpreferences_password_tab")
  
  text_field(:current_password, :id=>"curr_pass")
  text_field(:new_password, :id=>"new_pass")
  text_field(:retype_password, :id=>"retype_pass")
  
  button(:save_new_password, :text=>"Save new password")
  button(:cancel, :class=>"s3d-link-button s3d-bold accountpreferences_cancel")
  
  span(:new_password_error, :id=>"new_pass_error")
  span(:retype_password_error, :id=>"retype_pass_error")

end

#
module AddAreasPopUp
  
  include PageObject
  
  # Common elements...
  def list_categories
    list_categories_button
    @browser.wait_for_ajax
    self.class.class_eval { include AddRemoveCategories }
  end
  
  button(:done_add_button, :id=>"addarea_create_doc_button" )
  button(:cancel, :class=>"s3d-link-button jqmClose s3d-bold", :text=>"Cancel")
  
  # New...
  button(:new_container, :text=>"New", :class=>"s3d-button s3d-link-button")
  text_field(:new_doc_name, :name=>"addarea_new_name", :class=>"addarea_name_field")
  select_list(:new_doc_permissions, :id=>"addarea_new_permissions")
  select_list(:number_of_pages, :id=>"addarea_new_numberofpages")
  text_area(:new_doc_tags_and_categories, :name=>"addarea_new_tagsandcategories")
  button(:list_categories_button, :text=>"List categories")
  
  # Currently viewing...
  button(:currently_viewing, :text=>"Currently viewing")
  
  # My library...
  button(:from_my_library, :class=>"s3d-button s3d-link-button subnav_button", :text=>"My library")
  
  # Everywhere...
  button(:everywhere, :text=>"Everywhere")
  
  def search_everywhere
    @browser.text_field(:id=>"addarea_existing_everywhere_search")
  end
  
  def existing_doc_name
    a = "addarea_existing_mylibrary_container"
    b = "addarea_existing_everywhere_container"
    c = "addarea_existing_currentlyviewing_container"
    case
    when @browser.div(:id=>a).visible?
      return @browser.div(:id=>a).text_field(:name=>"addarea_existing_name")
    when @browser.div(:id=>b).visible?
      return @browser.div(:id=>b).text_field(:name=>"addarea_existing_name")
    when @browser.div(:id=>c).visible?
      return @browser.div(:id=>c).text_field(:name=>"addarea_existing_name")
    end
  end
  
  def existing_doc_permissions
    a = "addarea_existing_mylibrary_container"
    b = "addarea_existing_everywhere_container"
    c = "addarea_existing_currentlyviewing_container"
    case
    when @browser.div(:id=>a).visible?
      return @browser.div(:id=>a).select(:name=>"addarea_existing_permissions")
    when @browser.div(:id=>b).visible?
      return @browser.div(:id=>b).select(:name=>"addarea_existing_permissions")
    when @browser.div(:id=>c).visible?
      return @browser.div(:id=>c).select(:name=>"addarea_existing_permissions")
    end
  end
  
  def search_results
    @browser.div(:id=>"addarea_existing_everywhere_bottom")
  end
  
  # Content list...
  button(:content_list, :text=>"Content list")
  def content_list_name
    @browser.text_field(:id=>"addarea_contentlist_name")
  end
  def content_list_permissions
    @browser.select(:id=>"addarea_contentlist_permissions")
  end
  
  # Participants list...
  button(:participants_list, :text=>"Participants list")
  def participants_list_name
    @browser.text_field(:id=>"addarea_participants_name")
  end
  def participants_list_permissions
    @browser.select(:id=>"addarea_participants_permissions")
  end
  
  # Widgets...
  button(:widgets, :text=>"Widgets")
  def widget_name
    @browser.text_field(:id=>"addarea_widgets_name")
  end
  def select_widget
    @browser.select(:id=>"addarea_widgets_widget")
  end
  def widget_permissions
    @browser.select(:id=>"addarea_widgets_permissions")
  end
  
  # Clicks the "Done, add" button in the Add Area flyout dialog, then
  # waits for the Ajax calls to drop to zero.
  def create
    done_add_button
    @browser.wait_for_ajax(3)
  end
  
  alias done_add create
  
  # This method expects to be passed a hash object like this:
  # { :name=>"The name of the target document",
  #   :title=>"The placement title string",
  #   :visible=>"Who can see it" }
  # The method adds an existing document using the specified hash contents.
  def add_from_existing(document)
    everywhere
    search_everywhere.set(document[:name] + "\n")
    @browser.wait_for_ajax #
    search_results.li(:text=>/#{Regexp.escape(document[:name])}/).fire_event("onclick")
    existing_doc_name.set document[:title]
    existing_doc_permissions.select document[:visible]
    
    create
  end
  
  alias add_existing_document add_from_existing
  alias add_existing_doc add_from_existing
  alias add_an_existing_document add_from_existing
  
  # Adds a Participant List Area to the Group/Course. The passed
  # object needs to be a hash with :name and :visible keys and values.
  def add_participant_list(list)
    participants_list
    participants_list_name.set list[:name]
    participants_list_permissions.select list[:visible]
    
    create
  end
  
  alias add_participants_list add_participant_list
  
  # Adds a new Content Library area to a Group/Course.
  # The method requires a hash for the variable, with :name and :visible keys and values.
  def add_content_list(document)
    content_list
    content_list_name.set document[:name]
    content_list_permissions.select document[:visible]
    create
  end
  
  alias add_a_content_library add_content_list
  alias add_content_library add_content_list
  
  # Adds a new Widget Area to a Group/Course. The method
  # requires that the passed variable be a hash, with :name,
  # :widget, and :visible keys and values.
  def add_widget_page(document)
    widgets
    select_widget.select document[:widget]
    widget_name.set document[:name]
    widget_permissions.select document[:visible]
    create
  end
  
  alias add_widget add_widget_page
  alias add_a_widget add_widget_page
  alias add_a_widget_page add_widget_page
  
end

# Page objects in the Add content dialog box
module AddContentContainer
  
  include PageObject
  
  # Upload content tab...
  link(:upload_content, :text=>"Upload content")

  # Enters the specified filename in the file field.
  def upload_file=(file_name)
    @browser.file_field(:id=>"multifile_upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
  end
  
  text_field(:file_title, :id=>"newaddcontent_upload_content_title")
  text_area(:file_description, :id=>"newaddcontent_upload_content_description")
  text_field(:file_tags, :id=>"newaddcontent_upload_content_tags")
  select_list(:who_can_see_file, :id=>"newaddcontent_upload_content_permissions")
  select_list(:file_copyright, :id=>"newaddcontent_upload_content_copyright")
  
  # Create new document tab...
  link(:create_new_document, :text=>"Create new document")
  
  text_field(:name_document, :id=>"newaddcontent_add_document_title")
  text_area(:document_description, :id=>"newaddcontent_add_document_description")
  text_field(:document_tags, :id=>"newaddcontent_add_document_tags")
  select_list(:who_can_see_document, :id=>"newaddcontent_add_document_permissions")
  
  # Use existing content tab...
  link(:all_content, :text=>"All content")
  link(:add_content_my_library, :text=>"My Library")
  
  # Enters the specified text in the Search field.
  # Note that the method appends a line feed on the string, so the search will
  # happen immediately when it is invoked.
  def search_for_content=(text)
    @browser.text_field(:class=>"newaddcontent_existingitems_search").set("#{text}\n")
  end
  
  # Checks the checkbox for the specified item.
  def check_content(item)
    @browser.li(:text=>item).checkbox.set
  end
  
  alias check_item check_content
  alias check_document check_content
  
  # Add link tab...
  link(:add_link, :text=>"Add link")
  
  text_field(:paste_link_address, :id=>"newaddcontent_add_link_url")
  text_field(:link_title, :id=>"newaddcontent_add_link_title")
  text_area(:link_description, :id=>"newaddcontent_add_link_description")
  text_field(:link_tags, :id=>"newaddcontent_add_link_tags")
  
  button(:add, :text=>"Add")
  
  # Collected items column...
  select_list(:save_all_to, :id=>"newaddcontent_saveto")
  
  # Removes the item from the selected list.
  def remove(item)
    @browser.link(:title=>"Remove #{item}").click
  end
  
  button(:list_categories, :text=>"List categories")
  
  button(:done_add_collected, :class=>"s3d-button s3d-overlay-button newaddcontent_container_start_upload")
  
end

# Methods related to the Pop Up for Categories.
module AddRemoveCategories
  
  include PageObject
  
  # Opens the specified category tree.
  def open_tree(text)
    @browser.link(:title=>text).parent.ins.fire_event("onclick")
  end
  
  # Checks the specified category.
  def check_category(text)
    if @browser.link(:title=>text).exists? == false
      puts "\nCategory...\n#{text}\n...not found in list!\n\nPlease check for typos in your test data.\n"
    end
    if @browser.link(:title=>text).visible? == false
      @browser.link(:title=>text).parent.parent.parent.ins.click
    end
    if @browser.link(:title=>text).parent.class_name=="jstree-leaf jstree-unchecked"
      @browser.link(:title=>text).click
    end
  end
  
  # Returns an array of the categories selected in the pop-up container.
  def selected_categories
    list = []
    @browser.div(:id=>"assignlocation_jstree_selected_container").lis.each do |li|
      list << li.text
    end
    return list
  end
  
  button(:save_categories, :text=>"Assign and save")
  button(:dont_save, :text=>"Don't save")
  
end

# Methods related to the "Add widgets" pop-up on the Dashboard
module AddRemoveWidgets
  
  include PageObject
  
  # Clicks the Close button on the dialog for adding/removing widgets
  # to/from the Dashboard.
  def close_add_widget
    @browser.div(:class=>"s3d-dialog-close jqmClose").fire_event("onclick")
    @browser.wait_for_ajax(1)
    MyDashboard.new @browser
  end
  
  # Adds all widgets to the dashboard
  def add_all_widgets
    array = @browser.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "add" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Add").click
      @browser.wait_for_ajax(1)
    end
    close_add_widget
  end
  
  # Removes all widgets from the dashboard
  def remove_all_widgets
    array = @browser.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "remove" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Remove").click
      @browser.wait_for_ajax(1)
    end
    close_add_widget
  end
  
  # Clicks the "Add" button for the specified widget
  def add_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/).button.click
  end
  
  # Unchecks the checkbox for the specified widget.
  def remove_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_remove_/).button.click
  end
  
end

# Methods related to the Pop Up Dialog for Contacts
module AddToContactsPopUp

  include PageObject
  
  button(:invite, :text=>"Invite")
  button(:dont_invite, :text=>"Don't Invite")
  
  text_area(:personal_note, :id=>"addtocontacts_form_personalnote")
  
  checkbox(:is_my_classmate, :value=>"Classmate")
  checkbox(:is_my_supervisor, :value=>"Supervisor")
  checkbox(:is_being_supervised_by_me, :value=>"Supervised")
  checkbox(:is_my_lecturer, :value=>"Lecturer")
  checkbox(:is_my_student, :value=>"Student")
  checkbox(:is_my_colleague, :value=>"Colleague")
  checkbox(:is_my_college_mate, :value=>"College Mate")
  checkbox(:shares_an_interest_with_me, :value=>"Shares Interests")
  
end

#
module AppearancePopUp
  
  include PageObject
  
end

# The Permissions Pop Up dialog for World Area pages
module AreaPermissionsPopUp
  
  include PageObject
  
  select_list(:can_be_seen_by, :id=>"areapermissions_area_general_visibility")
  select_list(:selected_roles, :id=>"areapermissions_change_selected")
  button(:apply_permissions, :text=>"Apply permissions")
  checkbox(:all_roles, "areapermissions_check_uncheck_all")
  
  #
  def check_student
    @browser.div(:text=>/Student/).checkbox.set
  end
  
  #
  def check_teaching_assistant
    @browser.div(:text=>/Teaching Assistant/).checkbox.set
  end

  #
  def check_lecturer
    @browser.div(:text=>/Lecturer/).checkbox.set
  end

  #
  def student_permissions=(perm)
    @browser.div(:text=>/Student/).select(:class=>"areapermissions_role_select").select perm
  end
  
  #
  def teaching_assistant_permissions=(perm)
    @browser.div(:text=>/Teaching Assistant/).select(:class=>"areapermissions_role_select").select perm
  end
  
  #
  def lecturer_permissions=(perm)
    @browser.div(:text=>/Lecturer/).select(:class=>"areapermissions_role_select").select perm
  end
  
end

# Objects contained in the "Select your profile picture" pop-up dialog
module ChangePicturePopUp
  
  include PageObject
  
  h1(:pop_up_title, :class=>"s3d-dialog-header")
  file_field(:pic_file, :id=>"profilepicture")
  button(:upload, :id=>"profile_upload")
  button(:save, :id=>"save_new_selection")
  button(:cancel, :text=>"Cancel")
  div(:error_message, :id=>"changepic_nofile_error")
  image(:thumbnail, :id=>"thumbnail_img")
  
  # Uploads the specified file name for the Avatar photo
  def upload_a_new_picture(file_name)
    @browser.back_to_top
    #puts(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
    pic_file_element.when_visible { @browser.file_field(:id=>"profilepicture").set("/Users/abrahamheward/Work/Kuali-Sakai-Functional-Test-Automation-Framework/data/sakai-oae/Mercury.gif") }#File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name) }
    upload
    sleep 5 
  end
  
  # Clicks the Save button for the Change Picture Pop Up.
  def save_new_selection
    save_element.when_visible { save }
    @browser.wait_for_ajax
  end
  
  def thumbnail_source
    thumbnail_element.src
  end
  
end

#
module CommentsPopUp
  
  include PageObject
  
end

# Objects in the Pop Up dialog for setting viewing permissions for Content
module ContentPermissionsPopUp
  
  include PageObject
  
  
  
end

#
module DiscussionPopUp
  
  include PageObject
  
end

#
module ExportAsTemplate
  
  include PageObject
  
end
#
module FilesAndDocsPopUp
  
  include PageObject
  
  link(:display_settings, :id=>"embedcontent_tab_display")
  
end

#
module GoogleGadgetPopUp
  
  include PageObject
  
end

# Methods related to the Pop Up that appears for modifying
# the settings for the Google Maps Widget.
module GoogleMapsPopUp
  
  include PageObject
  
  text_field(:location, :id=>"googlemaps_input_text_location")
  button(:search_button, :id=>"googlemaps_button_search")
  button(:dont_add, :id=>"googlemaps_cancel")
  button(:add_map, :id=>"googlemaps_save")
  radio_button(:large, :id=>"googlemaps_radio_large")
  radio_button(:small, :id=>"googlemaps_radio_small")
  
  def search
    search_button
    sleep 2
  end
  
end

#
module InlineContentPopUp
  
  include PageObject
  
end

# Methods related to the Pop Up that allows modifying a
# Group's/Course's participants.
module ManageParticipants
  
  include PageObject
  
  checkbox(:add_all_contacts, :id=>"addpeople_select_all_contacts")
  
  # Checks the specified contact for adding.
  def add_contact(contact)
    @browser.li(:text=>contact).checkbox(:class=>"addpeople_checkbox").set
  end
  
  alias check_contact add_contact
  alias add_participant add_contact
  
  # Adds the specified contact to the members list (does not save, though).
  # This method assumes the specified name will be found in the search.
  # It makes no allowances for failing to find the target user/member.
  def add_by_search(name)
    name.split("", 2).each do |letter|
      @browser.text_field(:id=>/addpeople/, :class=>"as-input").focus
      @browser.text_field(:id=>/addpeople/, :class=>"as-input").send_keys(letter)
      @browser.text_field(:id=>/addpeople/, :class=>"as-input").focus
      begin
        @browser.wait_until(0.4) { @browser.ul(:class=>"as-list").visible? }
      rescue
        @browser.execute_script("$('.as-results').css({display: 'block'});")
      end
      if @browser.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).present?
        @browser.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
        break
      end
    end
  end
  
  alias add_contact_by_search add_by_search
  alias add_participant_by_search add_by_search
  alias search_and_add_participant add_by_search
  alias add_by_search= add_by_search
  
  checkbox(:remove_all_contacts, :id=>"addpeople_select_all_selected_contacts")
  button(:remove_selected, :text=>"Remove selected")
  
  button(:save, :class=>"s3d-button s3d-overlay-action-button addpeople_finish_adding")

  alias done_apply_settings save
  alias apply_and_save save
  
  button(:cancel, :class=>"s3d-link-button jqmClose s3d-bold")
  
  alias dont_apply cancel
  
  # Checks to remove the specified contact.
  def check_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.set
  end
  
  # Unchecks the remove checkbox for the specified contact
  def uncheck_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.clear
  end
  
  select_list(:role_for_selected_members, :id=>"addpeople_selected_all_permissions")
  
  # For the specified contact, updates to the specified role.fd
  def set_role_for(contact, role)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.select(:class=>"addpeople_selected_permissions").select(role)
  end
  
end

#
module OwnerInfoPopUp
  
  include PageObject
  
  button(:close_owner_info, :id=>"personinfo_close_button")
  
  def message_owner
    @browser.button(:text=>"Message").click
    self.class.class_eval { include SendMessagePopUp }
  end
  
  def add_to_contacts
    @browser.button(:text=>"Add to contacts").click
    self.class.class_eval { include AddToContactsPopUp }
  end
  
  def view_owner_profile
    @browser.span(:id=>"personinfo_user_name").link.click
    ViewPerson.new @browser
  end
  
end

#
module RemoteContentPopUp
  
  include PageObject
  
end

#
module RSSFeedPopUp
  
  include PageObject
  
end

# Methods related to the Save Content Pop Up dialog.
module SaveContentPopUp
  
  include PageObject
  
  select_list(:saving_to, :id=>"savecontent_select")
  button(:add, :text=>"Add")
  button(:cancel, :class=>"savecontent_close s3d-link-button s3d-bold")
  
end

# The Email message pop up dialog that appears when in the Worlds context
# (or when you click the little envelop icon )
module SendMessagePopUp
  
  include PageObject
  
  text_field(:send_this_message_to, :id=>"sendmessage_to_autoSuggest")
  text_field(:subject, :id=>"comp-subject")
  text_area(:body, :id=>"comp-body")
  
  # Removes the recipient from the To list for the email.
  def remove_recipient(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).link(:text=>"x").click
  end
  
  button(:send_message, :id=>"send_message")
  button(:dont_send, :id=>"send_message_cancel")
  
end

# 
module SettingsPopUp

  include PageObject
  
  text_field(:title, :id=>"worldsettings_title")
  text_area(:description, :id=>"worldsettings_description")
  text_area(:tags, :id=>"worldsettings_tags")
  select_list(:can_be_discovered_by, :id=>"worldsettings_can_be_found_in")
  select_list(:membership, :id=>"worldsettings_membership")
  
  button(:apply_settings, :text=>"Apply Settings")
  
end

# Methods related to the Pop Up for Sharing Content with others.
module ShareWithPopUp
  
  include PageObject
  
  text_field(:share_with, :id=>/newsharecontentcontainer\d+/)
  
  # Clicks the arrow for adding a custom message to the share.
  def add_a_message
    @browser.span(:id=>"newsharecontent_message_arrow").fire_event('onclick')
  end
  
  text_area(:message_text, :id=>"newsharecontent_message")
  
  button(:share, :id=>"sharecontent_send_button")
  button(:cancel, :id=>"newsharecontent_cancel")
  
  # Gonna add the social network validations later
  
end

# # # # # # # # # # # # 
#       Widgets       #
# # # # # # # # # # # # 

#
module CollectorWidget
  
  include PageObject
  
end

#
module DocumentWidget
  
  include PageObject
  
  button(:dont_save, :id=>"sakaidocs_edit_cancel_button")
  button(:save_button, :id=>"sakaidocs_edit_save_button")
  button(:insert, :id=>"sakaidocs_insert_dropdown_button")
  
  def save
    save_button
    sleep 1
    @browser.wait_for_ajax
  end
  
  # Erases the entire contents of the TinyMCE Editor, then
  # enters the specified string into the Editor.
  def set_content=(text)
    @browser.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    @browser.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
    @browser.frame(:id=>"elm1_ifr").send_keys(text)
  end
  
  # Appends the specified string to the contents of the TinyMCE Editor.
  def add_content=(text)
    @browser.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    @browser.frame(:id=>"elm1_ifr").send_keys(text)
  end
  
  # Selects all the contents of the TinyMCE Editor
  def select_all
    @browser.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
  end
  
  # Clicks the Text Box of the TinyMCE Editor so that the edit cursor
  # will become active in the Editor.
  def insert_text
    @browser.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
  end
  
  select_list(:format, :id=>/formatselect/)
  select_list(:font, :id=>/fontselect/)
  select_list(:font_size, :id=>/fontsizeselect/)
  link(:bold, :id=>/_bold/)
  link(:italic, :id=>/_italic/)
  link(:underline, :id=>/_underline/)
  
  # These methods click the Insert button (you must be editing the document first),
  # then select the specified menu item, to bring up the Widget settings dialog.
  # The first argument is the method name, the second is the id of the target
  # button in the Insert menu, and the last argument is the name of the module
  # to be included in the current Class object.
  insert_button(:insert_files_and_documents, "embedcontent", "FilesAndDocsPopUp")
  insert_button(:insert_discussion, "discussion", "Discussion")
  insert_button(:insert_remote_content, "remotecontent", "RemoteContentPopUp" )
  insert_button(:insert_inline_content, "inlinecontent", "InlineContentPopUp" )
  insert_button(:insert_google_maps, "googlemaps", "GoogleMapsPopUp" )
  insert_button(:insert_comments, "comments", "CommentsPopUp" )
  insert_button(:insert_rss_feed_reader, "rss", "RSSFeedPopUp" )
  insert_button(:insert_google_gadget, "ggadget", "GoogleGadgetPopUp" )

  # Other MCE Objects TBD later, though we're not in the business of testing TinyMCE...
  
end

# Methods related to the Library List page.
module LibraryWidget
  
  include PageObject
  
  # Enters the specified string in the search field.
  # Note that it appends a line feed on the string, so the
  # search occurs immediately.
  def search_library_for=(text)
    @browser.text_field(:id=>"mylibrary_livefilter").set("#{text}\n")
  end
  
  checkbox(:add, :id=>"mylibrary_check_all")
  
  # Checks the specified Library item.
  def check_content(item)
    @browser.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.set
  end
  
  # Unchecks the specified library item.
  def uncheck_content(item)
    @browser.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.clear
  end
  
  checkbox(:remove_all_library_items, :id=>"mylibrary_check_all")
  
end

# Inclusive of all methods having to do with lists of Content,
# Groups, Contacts, etc.
module ListWidget
  
  include PageObject
  
  select_list(:sort_by, :id=>/sortby/)
  select_list(:filter_by, :id=>"facted_select")
  
  def join_button_for(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).div(:class=>/searchgroups_result_left_filler/)
  end
  
  # Clicks on the plus sign image for the specified group in the list.
  def add_group(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).div(:class=>/searchgroups_result_left_filler/).fire_event("onclick")
  end
  
  alias add_course add_group
  alias add_research add_group
  alias join_course add_group
  alias join_group add_group
  
  # Clicks the specified Contact name. Obviously the name must exist in the list.
  def add_contact(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).div(:class=>/sakai_addtocontacts_overlay/).fire_event("onclick")
    @browser.wait_until { @browser.button(:text=>"Invite").visible? }
    self.class.eval_class { include AddToContactsPopUp }
  end
  
  alias request_contact add_contact
  alias request_connection add_contact
  
  # Adds the specified (listed) content to the library.
  def add_content_to_library(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"Save content").click
    @browser.wait_until { @browser.text.include? "Save to" }
    self.class.eval_class { include SaveContentPopUp }
  end
  
  alias add_document add_content_to_library
  alias save_content add_content_to_library
  
  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Group listed on
  # the page because it will instantiate the GroupLibrary class).
  def open_group(name)
    @browser.link(:text=>/#{Regexp.escape(name)}/i).click
    sleep 1
    @browser.wait_for_ajax
    @browser.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    Library.new(@browser)
  end
  
  alias view_group open_group
  alias view_course open_group
  alias open_course open_group

  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Research item listed on
  # the page because it will instantiate the ResearchIntro class).
  def open_research(name)
    @browser.link(:text=>/#{Regexp.escape(name)}/i).click
    sleep 1
    @browser.wait_for_ajax
    @browser.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    ResearchIntro.new @browser
  end
  
  alias view_research open_research
  
  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Document item listed on
  # the page because it will instantiate the ContentDetailsPage class). 
  def open_document(name)
    @browser.link(:text=>name).click
    ContentDetailsPage.new @browser
    #@browser.wait_for_ajax
  end
  
  alias open_content open_document
  
  # Clicks the Message button for the specified listed item.
  def message_course(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:class=>/sakai_sendmessage_overlay/).click
    self.class.class_eval { include SendMessagePopUp }
  end
  
  alias message_group message_course
  alias message_person message_course
  alias message_research message_course

  # Clicks to view the owner information of the specified item.
  def view_owner_information(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"View owner information").click
    @browser.wait_until { @browser.text.include? "Add to contacts" }
    self.class.eval_class { include OwnerInfoPopUp }
  end
  
  alias view_owner_info view_owner_information
  
  # Clicks to share the specified item.
  def share(item)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"Share content").click
    @browser.wait_until { @browser.text.include? "Or, share it on a webservice:" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  alias share_content share
  
  # Clicks the link of the specified name (It will click any link on the page,
  # really, but it should be used for Person links only, because it
  # instantiates the ViewPerson Class)
  def view_person(name)
    @browser.link(:text=>name).click
    ViewPerson.new @browser
  end
  
  # Returns an array containing the text of the links (for Groups, Courses, etc.) listed
  def results_list
    list = []
    target_elements = case
    # My Memberships Page
    when @browser.ul(:id=>"mymemberships_items").exist?
      @browser.ul(:id=>"mymemberships_items").spans(:class=>"s3d-search-result-name")
    # My Library Page
    when @browser.ul(:id=>"mylibrary_items").exist?
      @browser.ul(:id=>"mylibrary_items").spans(:class=>"s3d-search-result-name")
    # My Contacts Page
    when @browser.ul(:id=>"contacts_container_list").exist?
      @browser.ul(:id=>"contacts_container_list").spans(:class=>"s3d-search-result-name")
    # Search Results Page
    when @browser.ul(:id=>"searchgroups_results_container").exist?
      @browser.ul(:id=>"searchgroups_results_container").spans(:class=>"s3d-search-result-name")
    end
    target_elements.each do |element|
      list << element.text
    end
    return list
  end
  
  alias courses results_list
  alias course_list results_list
  
end

# Methods related to the Mail Page.
module MailWidget
  
  include PageObject
  
end

# Methods related to the Participants "Area" or "Page" in
# Groups/Courses. This is not the same thing as the ManageParticipants
# module, which relates to the "Add People" Pop Up.
module ParticipantsWidget
  
  include PageObject
  
end


# ======================
# ======================
# Page Classes
# ======================
# ======================

# The Login page for OAE.
class LoginPage
  
  include PageObject
  include HeaderFooterBar
  
  # Clicks the Sign Up link on the Login Page.
  def sign_up
    link(:id=>"navigation_anon_signup_link").click
    CreateNewAccount.new @browser
  end
  
  button(:sign_in_menu, :id=>"topnavigation_user_options_login")
  text_field(:username, :id=>"topnavigation_user_options_login_fields_username")
  text_field(:password, :id=>"topnavigation_user_options_login_fields_password")
  button(:sign_in, :id=>"topnavigation_user_options_login_button_login")
  span(:login_error, :id=>"topnav_login_username_error")
  
end

# Methods related to the page for creating a new user account
class CreateNewAccount
  
  include PageObject
  
  text_field(:user_name, :id=>"username")
  text_field(:institution, :id=>"institution")
  text_field(:password, :id=>"password")
  text_field(:retype_password, :id=>"password_repeat")
  select_list(:role, :id=>"role")
  text_field(:first_name,:id=>"firstName")
  text_field(:last_name,:id=>"lastName")
  text_field(:email,:id=>"email")
  text_field(:phone_number,:id=>"phone")

end

# Methods related to objects found on the Dashboard
class MyDashboard
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include YouPagesLeftMenu
  include ChangePicturePopUp

  button(:edit_layout, :text=>"Edit Layout")
  radio_button(:one_column, :id=>"layout-picker-onecolumn")
  radio_button(:two_column, :id=>"layout-picker-dev")
  radio_button(:three_column, :id=>"layout-picker-threecolumn")
  button(:save_layout, :id=>"select-layout-finished")
  button(:add_widgets, :text=>"Add Widget")
  image(:profile_pic, :id=>"entity_profile_picture")
  
  def add_widgets
    @browser.button(:text=>"Add widget").click
    @browser.wait_until { @browser.text.include? "Add widgets" }
    self.class.class_eval { include AddRemoveWidgets }
  end
  
  alias add_widget add_widgets
  
  # Returns an array object containing a list of all selected widgets.
  def displayed_widgets
    list = []
    @browser.div(:class=>"fl-container-flex widget-content").divs.each do |div|
      if div.class_name=="s3d-contentpage-title"
        list << div.text
      end
    end
    return list
  end

  # Returns an array containing the list of
  # recent membership items.
  def recent_memberships
    list = []
    @browser.div(:class=>"recentmemberships_widget").links.each do |link|
      if link.class_name=~/recentmemberships_item_link/
        list << link.text
      end
    end
    return list
  end
  
  def go_to_most_recent_membership
    @browser.link(:class=>"recentmemberships_item_link s3d-widget-links s3d-bold").click
    sleep 2 # The next line sometimes throws an "unknown javascript error" without this line.
    @browser.wait_for_ajax(10)
    Library.new @browser
  end

end

#
class MyMessages
  
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  # Returns an Array containing the list of Email subjects.
  def message_subjects
    list = []
    @browser.divs(:class=>"inbox_subject").each do |div|
      list << div.text
    end
    return list
  end
 
end

#
class MyProfileBasicInfo
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  # Basic Information
  text_field(:given_name, :name=>"firstName")
  text_field(:family_name, :id=>"lastName")
  text_field(:preferred_name, :id=>"preferredName")
  text_area(:tags, :name=>"tags")

  def list_categories
    @browser.button(:text=>"List categories").click
    @browser.wait_for_ajax
    self.class.class_eval { include AddRemoveCategories }
  end

  def update
    @browser.form(:id=>"displayprofilesection_form_basic").button(:text=>"Update").click
    @browser.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileAboutMe

  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  text_area(:about_Me, :id=>"aboutme")
  text_area(:academic_interests, :id=>"academicinterests")
  text_area(:personal_interests, :id=>"personalinterests")
  
  def update
    @browser.form(:id=>"displayprofilesection_form_aboutme").button(:text=>"Update").click
    @browser.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileOnline
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  button(:add_another_online, :text=>"Add another Online", :id=>"displayprofilesection_add_online")
  
  text_field(:site, :id=>/siteOnline_\d+/, :index=>-1)
  text_field(:url, :id=>/urlOnline_\d+/, :index=>-1)
  
  def update
    @browser.form(:id=>"displayprofilesection_form_online").button(:text=>"Update").click
  end
  
  # Returns a hash object, where the keys are the site names and the
  # values are the urls.
  def sites_list
    hash = {}
    @browser.div(:id=>"profilesection_generalinfo").divs.each do |div|
      if div.id=~/profilesection_section_\d{2,}/
        hash.store(div.text_field(:title=>"Site").text, div.text_field(:title=>"URL").text)
      end
    end
    return hash
  end
  
  def remove_this_online(text)
    #FIXME
  end
end

# Methods related to the My Profile: Contact Information page
class MyProfileContactInfo
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  #button(:add_another, :text=>"Add another", :id=>/profilesection_add_link_\d/)
  text_field(:institution, :name=>"college")
  text_field(:department, :name=>"Department") 
  text_field(:role, :name=>"role") 
  text_field(:email, :name=>"emailContact") 
  text_field(:instant_messaging, :name=>"imContact") 
  text_field(:phone, :name=>"phoneContact") 
  text_field(:mobile, :name=>"mobileContact") 
  text_field(:fax, :name=>"faxContact") 
  text_field(:address, :name=>"addressContact") 
  text_field(:city, :name=>"cityContact") 
  text_field(:state, :name=>"stateContact")
  text_field(:postal_code, :name=>"postalContact") 
  text_field(:country, :name=>"countryContact")
  
  def update
    @browser.form(:id=>"displayprofilesection_form_contact").button(:text=>"Update").click
  end
end

# Publications
class MyProfilePublications
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  button(:add_another_publication, :text=>"Add another publication", :id=>"displayprofilesection_add_publications")
  
  def update
    @browser.form(:id=>"displayprofilesection_form_publications").button(:text=>"Update").click
  end
  
  text_field(:main_title, :id=>/maintitle_\d+/, :index=>-1)
  text_field(:main_author, :id=>/mainauthor_d+/, :index=>-1)
  text_field(:co_authors, :id=>/coauthor_\d+/, :index=>-1)
  text_field(:publisher, :id=>/publisher_\d+/, :index=>-1)
  text_field(:place_of_publication, :id=>/placeofpublication_\d+/, :index=>-1)
  text_field(:volume_title, :id=>/volumetitle_\d+/, :index=>-1)
  text_field(:volume_information, :id=>/volumeinformation_\d+/, :index=>-1)
  text_field(:year, :id=>/year_\d+/, :index=>-1)
  text_field(:number, :id=>/number_\d+/, :index=>-1)
  text_field(:series_title, :id=>/series.title_\d+/, :index=>-1)
  text_field(:url, :id=>/url_\d+/, :index=>-1)
  
end

#
class MyLibrary
  
  include PageObject
  include HeaderFooterBar
  include ListWidget

end

#
class MyMemberships

  include PageObject
  include HeaderFooterBar
  include ListWidget
  
  # Use for clicking on the name of a "World" whose page you want to navigate to.
  def go_to(item_name)
    @browser.link(:title=>item_name).click
    @browser.button(:id=>"entity_group_permissions").wait_until_present
    @browser.wait_for_ajax #
    Library.new @browser
  end

  alias navigate_to go_to
  
  # Returns the specified item's "type", as shown next to the item name--i.e.,
  # "GROUP", "COURSE", etc.
  def group_type(item)
    @browser.span(:class=>"s3d-search-result-name",:text=>item).parent.span(:class=>"mymemberships_item_grouptype").text
  end

end

#
class MyContacts

  include PageObject
  include HeaderFooterBar
  include ListWidget

end

#
class AddContacts
  
  include PageObject
  include HeaderFooterBar
  include AccountPreferencesPopUp
  
  
end


#
class CreateCourses
  
  include PageObject
  include HeaderFooterBar
  include CreateWorldsLeftMenu
  
  def use_math_template
    @browser.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    # Class goes here
  end
  
  def use_basic_template
    @browser.div(:class=>"selecttemplate_template_small selecttemplate_template_right").button(:text=>"Use this template").click
    @browser.wait_until { @browser.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
end

#
class CreateGroups
  
  include PageObject
  include HeaderFooterBar
  include CreateWorldsLeftMenu
  
  text_field(:title, :id=>"newcreategroup_title")
  text_field(:suggested_url, :id=>"newcreategroup_suggested_url")
  text_area(:description, :id=>"newcreategroup_description")
  text_area(:tags, :name=>"newcreategroup_tags")
  select_list(:can_be_discovered_by, :id=>"newcreategroup_can_be_found_in")
  select_list(:membership, :id=>"newcreategroup_membership")
  
  def add_people
    @browser.button(:text, "Add people").click
    @browser.wait_for_ajax
    self.class.class_eval { include ManageParticipants }
  end
  
  def list_categories
    @browser.button(:text=>"List categories").click
    @browser.wait_for_ajax
    self.class.class_eval { include AddRemoveCategories }
  end
  
  def create_basic_course
    create_thing
    @browser.wait_until(45) { @browser.text.include? "Add content" }
    @browser.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").wait_until_present
    Library.new @browser
  end
  
  alias create_simple_group create_basic_course
  alias create_group create_basic_course
  alias create_research_support_group create_basic_course
  
  def create_research_project
    create_thing
    @browser.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").wait_until_present
    ResearchIntro.new @browser
  end
  
  private
  
  def create_thing
    @browser.button(:class=>"s3d-button s3d-overlay-button newcreategroup_create_simple_group").click
    sleep 0.3
    @browser.div(:id=>"sakai_progressindicator").wait_while_present
    @browser.wait_for_ajax
  end
  
end

#
class CreateResearch
  
  include PageObject
  include HeaderFooterBar
  include CreateWorldsLeftMenu
  
  def use_research_project_template
    @browser.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    @browser.wait_until { @browser.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
  def use_research_support_group_template
    @browser.div(:class=>"selecttemplate_template_small selecttemplate_template_right").button(:text=>"Use this template").click
    @browser.wait_until { @browser.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
end


#
class ViewPerson
  
  include PageObject
  include HeaderFooterBar
  
  def message
    @browser.button(:id=>"entity_user_message").click
    @browser.wait_until { @browser.text.include? "Send this message to:" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  def add_to_contacts
    @browser.button(:id=>"entity_user_add_to_contacts").click
    @browser.wait_until { @browser.text.include? "Add a personal note to the invitation:" }
    self.class.class_eval { include AddToContactsPopUp }
  end
  
  navigating_link(:basic_information, "Basic Information", "ViewPerson")
  navigating_link(:categories, "Categories", "ViewPerson")
  navigating_link(:about_me, "About Me", "ViewPerson")
  navigating_link(:online, "Online", "ViewPerson")
  navigating_link(:contact_information, "Contact Information", "ViewPerson")
  navigating_link(:publications, "Publications", "ViewPerson")
  
  def users_library
    @browser.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Library/).click
    self.class.class_eval { include ListWidget
                            include LibraryWidget }
  end
  
  def users_memberships
    @browser.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Memberships/).click
    self.class.class_eval { include ListWidget }
  end
  
  def users_contacts
    @browser.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Contacts/).click
    self.class.class_eval { include ListWidget }
  end
  
  def basic_info_data
    hash = {}
    @browser.div(:id=>/profilesection-basic-\d+/).divs.each do |div|
      if div.class_name=="profilesection_generalinfo_subcontainer"
        hash.store(div.span(:class=>"profilesection_generalinfo_label").text, div.div(:class=>"profilesection_generalinfo_content").text)
      end
    end
    return hash
  end
  
  def categories_data
    list = []
    @browser.div(:id=>/profilesection-locations-\d+/).links.each do |link|
      list << link.text
    end
    return list
  end
  
  def about_me_data
    hash = {}
    @browser.form(:id=>/profile_form_profilesection-aboutme-\d+/).divs.each do |div|
      if div.class_name=="profilesection_generalinfo_subcontainer"
        hash.store(div.span(:class=>"profilesection_generalinfo_label").text, div.div(:class=>"profilesection_generalinfo_content").text)
      end
    end
    return hash
  end
  
  def online_data
    hash = {}
    @browser.div(:id=>/profilesection-online-\d+/).div(:id=>"profilesection_generalinfo").divs.each do |div|
      if div.id=~/profilesection_section_\d+/
        hash.store(div.div(:class=>"profilesection_generalinfo_subcontainer", :index=>0).div(:class=>"profilesection_generalinfo_content").text, div.div(:class=>"profilesection_generalinfo_subcontainer", :index=>1).div(:class=>"profilesection_generalinfo_content").text)
      end
    end
    return hash
  end
  
  def contact_info_data
    list = []
    @browser.div(:id=>/profilesection-contact-\d+/).div(:id=>"profilesection_generalinfo").divs.each do |div|
      hash = {}
      if div.id=~/profilesection_section_\d+/
        div.divs.each do |subdiv|
          if subdiv.class_name=="profilesection_generalinfo_subcontainer"
            hash.store(subdiv.span.text, subdiv.div.text)
          end
        end
        list << hash if hash != {}
      end
    end
    return list
  end
  
  def publications_data
    list = []
    @browser.div(:id=>/profilesection-publications-\d+/).div(:id=>"profilesection_generalinfo").divs.each do |div|
      hash = {}
      if div.id=~/profilesection_section_\d+/
        div.divs.each do |subdiv|
          if subdiv.class_name=="profilesection_generalinfo_subcontainer"
            hash.store(subdiv.span.text, subdiv.div.text)
          end
        end
        list << hash if hash != {}
      end
      
    end
    return list
  end
  
end

#
class ViewDocument
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  
end

#
class ExploreAll

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar

end

#
class ExploreContent

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar

end

#
class ExplorePeople

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar

end

#
class ExploreGroups

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar

end

# 
class ExploreCourses
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar
  
  def courses_count
    #TBD
  end
  
  def filter_by=(selection)
    @browser.select(:id=>"facted_select").select(selection)
    @browser.wait_for_ajax
  end
  
  def sort_by=(selection)
    @browser.div(:class=>"s3d-search-sort").select().select(selection)
    @browser.wait_for_ajax
  end
  
  
end

#
class ExploreResearch

  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include ListWidget
  include SearchBar
  
end

#
class MyPreferences

  include PageObject

end


# 
class Library
  
  include PageObject
  include HeaderFooterBar
  include HeaderBar
  include LeftMenuBar
  include LibraryWidget
  
end

# 
class Participants
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar

  
end

# Methods related to the Documents "Area" in Groups/Courses.
class Documents
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

# Methods related to the Discussions "Area" in a Group/Course.
class Discussions
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  button(:add_new_topic, :id=>"discussion_add_new_topic")
  text_field(:topic_title, :id=>"discussion_create_new_topic_title")
  text_area(:message_text, :name=>/message.text/i)
  text_area(:reply_text, :id=>"discussion_topic_reply_text")  
  button(:dont_add_topic, :id=>"discussion_dont_add_topic")
  
  # Clicks the "Add topic" button.
  def add_topic
    @browser.button(:id=>"discussion_add_topic").click
    @browser.wait_for_ajax #
    #@browser.wait_until { @browser.h1(:class=>"discussion_topic_subject").parent.button(:text=>"Reply").present? }
    #@browser.wait_for_ajax #
  end
  
  button(:collapse_all, :text=>"Collapse all")
  button(:expand_all, :text=>"Expand all")
  button(:dont_add_reply, :id=>"discussion_dont_add_reply")
  button(:add_reply, :id=>"discussion_add_reply")
  
  # Clicks the "Reply" button for the specified message.
  def reply_to(message_title)
    @browser.h1(:class=>"discussion_topic_subject", :text=>message_title).parent.button(:text=>"Reply").click
    @browser.wait_until { @browser.h1(:class=>"discussion_topic_subject", :text=>message_title).parent.text_field(:id=>"discussion_topic_reply_text").present? }
  end
  
  # Clicks the "Quote" button for the specified message.
  def quote(message_text)
    @browser.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Quote").fire_event "onclick"
    @browser.wait_for_ajax #
    #@browser.wait_until { @browser.textarea(:name=>"quoted_text", :text=>message_text).present? }
  end
  
  # Clicks the "Edit" button for the specified message.
  def edit(message_text)
    @browser.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Edit").click
    @browser.wait_until { @browser.textarea(:name=>"discussion_topic_reply_text", :text=>message_text).present? }
  end
  
  # Clicks the "Delete" button for a specified message.
  def delete(message_text)
    @browser.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Delete").click
  end
  
  button(:restore, :text=>"Restore")

  # Clicks the button that expands the thread to view the replies.
  def view_replies(topic_title)
    @browser.h1(:class=>"discussion_topic_subject", :text=>topic_title).parent.button(:class=>"discussion_show_topic_replies s3d-button s3d-link-button").click
    
  end
  
  # Clicks the button that collapses an expanded message thread.
  def hide_replies(topic_title)
    @browser.h1(:class=>"discussion_topic_subject", :text=>topic_title).parent.button(:class=>"discussion_show_topic_replies s3d-button s3d-link-button").click
    
  end
  
end

# Methods related to the Comments "Area" in a Course/Group.
class Comments
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  button(:add_comment, :text=>"Add comment")
  
  # Clicks the "Submit comment" button.
  def submit_comment
    @browser.button(:text=>"Submit comment").click
    @browser.wait_for_ajax #wait_until { @browser.text.include? "about 0 seconds ago" }
  end
  
  # Clicks the "Edit comment" button.
  def edit_comment
    @browser.button(:text=>"Edit comment").click
    @browser.wait_for_ajax #wait_until { @browser.textarea(:title=>"Edit your comment").present? == false }
  end
  
  button(:cancel, :id=>/comments_editComment_cancel/)
  text_area(:comment, :id=>"comments_txtMessage")
  text_area(:new_comment, :id=>/comments_editComment_txt_/)
  
  # Clicks the "Edit button" for the specified comment.
  def edit(comment)
    @browser.p(:text=>comment).parent.parent.button(:text=>"Edit").click
    @browser.wait_for_ajax #wait_until { @browser.textarea(:title=>"Edit your comment").present? }
  end
  
  # Deletes the specified comment.
  def delete(comment)
    @browser.div(:text=>comment).parent.button(:text=>"Delete").click
    @browser.wait_for_ajax #wait_until { @browser.button(:text=>"Undelete").present? }
  end
  
  button(:undelete, :text=>"Undelete")
  
end

#
class JISC
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  in_frame(:index=>2) do |fr|
    select_list(:choose_a_category, :id=>"themes", :frame=>fr)
  end
  
end

#
class RSS
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  button(:sort_by_source, :text=>"Sort by source")
  button(:sort_by_date, :text=>"Sort by date")
  
  
end

#
class Tasks
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class Tests
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class Calendar
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class Files
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class Gadget
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class Gradebook
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class LTI
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  text_field(:url, :id=>"basiclti_settings_ltiurl")
  text_field(:key, :id=>"basiclti_settings_ltikey")
  text_field(:secret, :id=>"basiclti_settings_ltisecret")
  button(:advanced_settings, :id=>"basiclti_settings_advanced_toggle_settings")
  button(:save, :id=>"basiclti_settings_insert")
  button(:cancel, :id=>"basiclti_settings_cancel")
  
  
end

# Methods related to the Maps "Area" in a Course/Group.
class GoogleMaps
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  # Defines the Google Maps image as an object.
  # Use this for verifying the presence of any text it's supposed to
  # contain (like the specified address it's supposed to be showing).
  def map_frame
    @browser.frame(:id, "googlemaps_iframe_map")
  end
  
  # Edits the page, then opens the Google Maps widget's Settings Dialog.
  def map_settings
    widget_settings
    @browser.text_field(:id=>"googlemaps_input_text_location").when_present { self.class.class_eval { include GoogleMapsPopUp } }
  end
  
  # Edits the page, then removes the widget from it.
  def remove_map
    remove_widget
  end
  
  # Edits the page, then opens the "Appearance" pop-up dialog.
  def map_wrapping
    widget_wrapping
  end

end

#
class InlineContent
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

#
class ResearchIntro
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end

# Methods related to the Content Details page.
class ContentDetailsPage
  
  include PageObject
  include HeaderFooterBar
  
  # Returns an array object containing the items displayed in
  # "Related Content" on the page.
  def related_content
    list = []
    @browser.div(:class=>"relatedcontent_list").links.each do |link|
      list << link.title
    end
    return list
  end
  
  # Clicks on the "Share Content" button.
  def share_content
    @browser.div(:id=>"entity_actions").span(:class=>"entity_share_content").click
    @browser.wait_until { @browser.text.include? "Who do you want to share with?" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  # Clicks on the "Add to library" button.
  def add_to_library
    @browser.button(:text=>"Add to library").click
    @browser.wait_until { @browser.text.include? "Save to" }
    self.class.class_eval { include SaveContentPopUp }
  end
  
  # Opens the description text field for editing.
  def edit_description
    @browser.div(:id=>"contentmetadata_description_container").fire_event "onmouseover"
    @browser.div(:id=>"contentmetadata_description_container").fire_event "onclick"
  end
  
  text_area(:description, :id=>"contentmetadata_description_description")
  
  # Opens the tag field for editing.
  def edit_tags
    @browser.div(:id=>"contentmetadata_tags_container").fire_event "onclick"
  end
  
  # Opens the Copyright field for editing.
  def edit_copyright
    @browser.div(:id=>"contentmetadata_copyright_container").fire_event "onclick"
  end
  
  # Opens the Categories field for editing.
  def edit_categories
    @browser.div(:id=>"contentmetadata_locations_container").fire_event "onclick"
    self.class.class_eval { include AddRemoveCategories }
  end
  
  text_area(:comment_text, :id=>"contentcomments_txtMessage")
  button(:comment, :text=>"Comment")
  button(:see_more, :id=>"contentmetadata_show_more")
  button(:see_less, :id=>"contentmetadata_show_more")
  
end

# 