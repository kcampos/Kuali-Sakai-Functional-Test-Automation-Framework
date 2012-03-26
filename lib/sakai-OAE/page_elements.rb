#!/usr/bin/env ruby
# coding: UTF-8
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

# This module contains methods that will be almost
# universally useful, and don't pertain to any specific
# area or widget or pop up on a given page.
module GlobalMethods

  include PageObject
  
  # These create methods of the form
  # open_<name>('target link text')
  # Example usage in a script on a page where there's a calendar link
  # with the text "Moon Phases" ...
  #
  # calendar_page = current_page.open_calendar("Moon Phases")
  #
  # Once the link is clicked, the method
  # returns the specified class object.
  #
  # It's important to note that the methods created
  # assume that the target page will be opened in the
  # same tab. If a new tab is opened, these methods will not work.
  #
  # In addition, the page classes that are instantiated for the
  # target pages assume that the user has editing
  # rights.
  open_link(:document, "ContentDetailsPage")
  open_link(:content, "ContentDetailsPage")
  open_link(:remote_content, "Remote")
  open_link(:library, "Library")
  open_link(:participants, "Participants")
  open_link(:discussions, "Discussions")
  open_link(:inline_content, "InlineContent") 
  open_link(:tests_and_quizzes, "Tests")
  open_link(:assessments, "Tests")
  open_link(:calendar, "Calendar")
  open_link(:map, "GoogleMaps") 
  open_link(:file, "Files") 
  open_link(:comments, "Comments")
  open_link(:jisc, "JISC")
  open_link(:assignments, "Assignments") 
  open_link(:feed, "RSS")
  open_link(:rss_feed, "RSS")
  open_link(:rss, "RSS")
  open_link(:lti, "LTI")
  open_link(:basic_lti, "LTI")
  open_link(:gadget, "Gadget")
  open_link(:gradebook, "Gradebook")
  
  alias open_group open_library
  alias open_course open_library
  alias go_to open_library
  
  # The "gritter" notification that appears to confirm
  # when something has happened (like updating a user profile
  # or sending a message).
  div(:notification, :class=>"gritter-with-image")
  
  # This method is essentially
  # identical with the
  # open_link methods listed above.
  # It opens page/document items that are listed on the page--for example
  # in the Recent activity box.
  # There is an important distinction, however:
  # This method should be used in cases when clicking the
  # link results in a new browser tab/window being generated.
  # May ultimately convert this to open_public_<object>
  # if that seems the best generic way to handle things.
  #
  # THIS METHOD MAY SOON BE DEPRECATED (if so, it
  # will be included as an alias of open_content)
  def open_page(name)
    name_link(name).click 
    wait_for_ajax
    self.window(:title=>"rSmart | Content Profile").use
    ContentDetailsPage.new @browser
  end

  # Clicks the link of the specified name (It will click any link on the page,
  # really, but it should be used for Person links only, because it
  # instantiates the ViewPerson Class)
  def view_person(name)
    name_link(name).click
    self.wait_for_ajax
    ViewPerson.new @browser
  end
  
  alias view_profile view_person

  def close_notification
    self.notification_element.fire_event "onmouseover"
    self.div(:class=>"gritter-close").fire_event "onclick"
  end

  # This method exposes the "draggable" menu items in the left-hand
  # menus, so that you can use Watir's <X>.drag_and_drop_on <Y> method.
  # Note that not all matching menu items are necessarily draggable.
  # Also useful if you just want to see if the menu item is visible
  # on the page
  def menu_item(name)
    self.div(:class=>/lhnavigation(_subnav|)_item_content/, :text=>name)
  end

end

# The Topmost Header menu bar, present on most pages,
# plus the Footer contents, too. This module also contains
# references to the notification pop-ups that appear in the upper
# right.
module HeaderFooterBar
  
  include PageObject
  
  # Page Object Definitions
  link(:help, :id=>"help_tab")
  float_menu(:my_dashboard, "You", "My dashboard", "MyDashboard")
  float_menu(:my_messages, "You", "My messages", "MyMessages")
  float_menu(:my_profile, "You", "My profile", "MyProfileBasicInfo")
  float_menu(:my_library, "You", "My library", "MyLibrary")
  float_menu(:my_memberships, "You", "My memberships", "MyMemberships") 
  float_menu(:my_contacts, "You", "My contacts", "MyContacts")
  float_menu(:create_a_group, "Create + Collect", "Create a group", "CreateGroups")
  float_menu(:create_a_course, "Create + Collect", "Create a course", "CreateCourses")
  float_menu(:create_a_research_project, "Create + Collect", "Create a research project", "CreateResearch")  
  float_menu(:explore_all_categories, "Explore", "Browse all categories", "AllCategoriesPage")
  float_menu(:explore_content,"Explore","Content", "ExploreContent")
  float_menu(:explore_people,"Explore","People", "ExplorePeople")
  float_menu(:explore_groups,"Explore","Groups","ExploreGroups")
  float_menu(:explore_courses,"Explore","Courses","ExploreCourses")
  float_menu(:explore_research,"Explore","Research projects","ExploreResearch")
  alias explore_research_projects explore_research
  
  # Don't use this button directly when opening the collector. Instead, use the "toggle_collector" method
  # so that the Collector Widget module will be included in the object's Class.
  # You *can* use this, however, to close the collector.
  button(:collector, :class=>"topnavigation_menuitem_counts_container collector_toggle")
  button(:save, :text=>"Save")

  link(:explore, :text=>"Explore")
  link(:browse_all_categories, :text=>"Browse all categories")
  text_field(:header_search, :id=>"topnavigation_search_input")
  link(:you, :text=>"You")
  button(:messages_container_button, :id=>"topnavigation_messages_container")
  link(:create_collect, :id=>"navigation_create_and_add_link")
  
  link(:see_all, :id=>"topnavigation_search_see_all")
  
  # Sign-in Menu items...
  button(:sign_in_menu, :id=>"topnavigation_user_options_login")
  text_field(:username, :id=>"topnavigation_user_options_login_fields_username")
  text_field(:password, :id=>"topnavigation_user_options_login_fields_password")
  button(:sign_in, :id=>"topnavigation_user_options_login_button_login")
  span(:login_error, :id=>"topnav_login_username_error")
  link(:sign_up_link, :id=>"navigation_anon_signup_link")
  
  # Footer elements
  div(:footer, :id=>/footercontainer\d+/)
  button(:sakai_OAE_logo, :id=>"footer_logo_button")
  link(:acknowledgements_link, :href=>"/acknowledgements") # :text=>"Created in collaboration with the Sakai Community"
  link(:user_agreement_link, :text=>"User Agreement")
  button(:location_button, :id=>"footer_location")
  button(:language_button, :id=>"footer_language")
  paragraph(:debug_info, :id=>"footer_debug_info")
  
  # Custom Methods
  
  # The page object for the Explore link the footer. Defined as a custom
  # method using Watir-webdriver, because of issues using PageObject to do it.
  def explore_footer_link
    self.span(:id=>"footer_links_right").link(:text=>"Explore")
  end
  
  # Clicks the Explore button in the footer and returns the
  # Page class for the main login page (since that's the page that loads).
  def explore_footer
    explore_footer_link.click
    sleep 1
    wait_for_ajax
    LoginPage.new @browser
  end
  
  # The page object for the Browse link the footer. Defined as a custom
  # method because of issues using PageObject to do it.
  def browse_footer_link
    self.span(:id=>"footer_links_right").link(:text=>"Browse")
  end
  
  # Clicks the Browse button in the footer
  # And returns the AllCategories page class.
  def browse_footer
    browse_footer_link.click
    sleep 1
    wait_for_ajax
    AllCategoriesPage.new @browser
  end
  
  # Clicks the Acknowledgements link in the page Footer.
  def acknowledgements
    self.acknowledgements_link
    sleep 1
    wait_for_ajax
    Acknowledgements.new @browser
  end
  
  # Clicks the User Agreement link in the page footer.
  def user_agreement
    self.user_agreement_link
    sleep 1
    #wait_for_ajax
    # New Class goes here.new @browser
  end
  
  # Clicks the location link in the page footer
  def change_location
    self.location_button
    wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end
  
  # Clicks the language button in the page footer.
  def change_language
    self.language_button
    wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end
  
  # A generic link-clicking method. It clicks on a page link with text that
  # matches the supplied string. Since it uses Regex to find a match, the
  # string can be a substring of the desired link's full text.
  #
  # This method should be used as AN ABSOLUTE LAST RESORT, however, since it does not
  # instantiate a new page class. You will have to instantiate
  # the target page class explicitly in the test script itself, if required.
  def click_link(string)
    name_link(string).click
    wait_for_ajax
  end
  
  # Opens the User Options menu in the header menu bar,
  # clicks the Preferences item, waits for the Account Preferences
  # Pop up dialog to appear, and then includes the AccountPreferencesPopUp
  # module in the currently instantiated Class Object.
  def my_account
    self.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    self.link(:id=>"subnavigation_preferences_link").click
    wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end
  
  def sign_out
    self.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    self.link(:id=>"subnavigation_logout_link").click
    self.wait_for_ajax
    LoginPage.new @browser
  end
  
  # Opens the Create + Add menu in the header bar,
  # clicks on the Add Content item, waits for the Pop Up
  # dialog to appear, then includes the AddContentContainer module
  # in the currently instantiated Class Object.
  def add_content
    self.link(:id=>"navigation_create_and_add_link").fire_event("onmouseover")
    self.link(:text=>"Add content").click
    self.wait_until { @browser.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  def add_collection
    
  end
  
  def toggle_collector
    collector
    wait_for_ajax
    self.class.class_eval { include CollectorWidget }
  end
  
  def messages_container
    messages_container_button
    self.class.class_eval { include MessagesContainerPopUp }
  end
  
  # Clicks the "Sign up" link
  def sign_up
    self.sign_up_link
    CreateNewAccount.new @browser
  end
  
end

# This is the Header that appears in the Worlds context,
# So it appears for Courses, Groups, and Research
module HeaderBar
  
  include PageObject
  
  # Page Object Definitions
  button(:join_group_button, :id=>/joinrequestbuttons_join_.*/)
  button(:request_to_join_group_button, :id=>/joinrequestbuttons_request_.*/)
  button(:request_pending_button, :id=>/joinrequestbuttons_pending_.*/)
  button(:message_button, :text=>"Message")
  
  # Custom Methods
  
  # Returns the text contents of the page title div  
  def page_title
    self.div(:id=>"s3d-page-container").div(:class=>"s3d-contentpage-title").text
  end
  
  def join_group
    self.join_group_button
    self.wait_until { notification_element.exists? }
  end
  
  def request_to_join_group
    self.request_to_join_group_button
    self.wait_until { notification_element.exists? }
  end
  
  # Clicks the Message button in the page header (not the
  # Header bar, but just below that), waits for the Message Pop Up
  # dialog to load, and then includes the SendMessagePopUp
  # module in the currently instantiated Class Object.
  def message
    self.message_button
    self.wait_until { self.text.include? "Send Message" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  # Clicks the Permissions button in the page header (below the
  # Header bar, though), clicks "Add Content", then waits for the
  # Add Content stuff to load, then includes the
  # AddContentContainer module in the object's Class.
  def add_content
    self.button(:id=>"entity_group_permissions").click
    self.button(:text=>"Add content").click
    self.wait_until { self.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Manage participants",
  # waits for the Contacts and Memberships stuff to load, then
  # includes the ManageParticipants module in the Class of the object
  # calling the method.
  def manage_participants
    self.button(:id=>"entity_group_permissions").click
    self.button(:text=>"Manage participants").click
    self.wait_until { self.text.include? "My contacts and memberships" }
    self.class.class_eval { include ManageParticipants }
  end
  
  # Clicks the "Join requests" item in the settings menu.
  def join_requests
    self.button(:id=>"entity_group_permissions").click
    self.button(:id=>"ew_group_join_requests_link").click
    self.wait_until { self.text.include? "Pending requests to join" }
    self.class.class_eval { include PendingRequestsPopUp }
  end
  
  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Settings",
  # waits for the Settings stuff to load, then
  # includes the SettingsPopUp module in the Class of the object
  # calling the method.
  def settings
    self.button(:id=>"entity_group_permissions").click
    self.button(:text=>"Settings").click
    sleep 0.4
    wait_for_ajax
    self.class.class_eval { include SettingsPopUp }
  end

  # Clicks the Permissions button in the page's header (distinct from
  # the black header bar, mind you), clicks "Categories",
  # waits for the Categories Pop Up to load, then
  # includes the AddRemoveCategories module in the Class of the object
  # calling the method.
  def categories
    self.button(:id=>"entity_group_permissions").click
    self.button(:text=>"Categories").click
    self.wait_until { self.text.include? "Assign a category" }
    self.class.class_eval { include AddRemoveCategories }
  end
  
  # Clicks the down arrow next to the Avatar picture in the Page Header
  # (not the Header bar), clicks the option to change the picture,
  # then includes the ChangePicturePopup in the Class of the object
  # calling the method.
  def change_picture
    self.div(:class=>"entity_profile_picture_down_arrow").fire_event("onclick")
    self.link(:id=>"changepic_container_trigger").click
    self.class.class_eval { include ChangePicturePopup }
  end
  
end

# Modules for the most robust Left Menu Bar--the one that has context menus
# attached to each of the bar's items, and is found in the context of a particular
# Course, Group, or Research.
module LeftMenuBar
  
  include PageObject
  
  # Page Object Definitions
  # ...none yet
  
  # Custom Methods
  
  # Use this to click left menu items that refer to multi-paged documents.
  # It expands the menu to display the document's pages.
  def expand(name)
    self.div(:id=>"lhnavigation_container").link(:text=>name).click
  end
  
  # Changes the title of the specified page ("from_string")
  # to the string value specified by to_string.
  def change_title_of(from_string, to_string)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).hover
    wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhavigation_submenu_edittitle").click
    self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.text_field(:class=>"lhnavigation_change_title").set("#{to_string}\n")
  end
  
  alias change_title change_title_of
  
  # Deletes the page specified by page_name.
  def delete_page(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhavigation_submenu_deletepage").click
    wait_for_ajax
    self.class.class_eval { include DeletePagePopUp }
  end
  
  # Opens the Permissions Pop Up for the specified Page.
  def permissions_for_page(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    self.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'328px', top:'349px', display: 'block'})")
    self.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhnavigation_submenu_permissions").click
    sleep 0.2
    wait_for_ajax
    self.class.class_eval { include PermissionsPopUp }
  end
  
  alias permissions_of_page permissions_for_page
  alias page_permissions permissions_for_page
  
  # Opens the Profile Details for the specified Page by
  # opening the page's drop-down menu in the left menu bar,
  # clicking "View Profile", and then switching to the new
  # browser tab/window that gets opened.
  def view_profile_of_page(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'328px', top:'349px', display: 'block'})")
    wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhnavigation_submenu_profile").click
    wait_for_ajax #.button(:title=>"Show debug info").wait_until_present
    self.window(:title=>"rSmart | Content Profile").use
    ContentDetailsPage.new self
  end
  
  alias view_profile_for_page view_profile_of_page
  alias view_page_profile view_profile_of_page
  
  # Clicks the "Add a new area" button.
  def add_new_area
    self.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").click
    wait_for_ajax
    self.class.class_eval { include AddAreasPopUp }
  end
  
  alias add_a_new_area add_new_area
  alias add_new_page add_new_area
  
  # Returns an array containing the Course/Group area/page titles.
  def public_pages
    list = []
    self.div(:id=>"lhnavigation_public_pages").links.each do |link|
      list << link.text
    end
    return list
  end
  
  alias pages public_pages
  alias areas public_pages
  
  def menu_available?(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    if self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible?
      return true
    else
      return false
    end
  end
  
  private
  
  def data_sakai_ref
    hash = {}
    current_id=""
    @browser.div(:id=>"lhnavigation_container").lis.each do |li|
      hash.store(li.text, li.html[/(?<=data-sakai-ref=").+-id\d+/])
    end
    hash.delete_if { |key, value| key == "" }
    hash.each do |key, value|
      next if @browser.div(:id=>value).exist? == false
      next if @browser.div(:id=>value).visible? == false
      if @browser.div(:id=>value).visible?
        current_id = value 
      end
    end
    return current_id
  end
  
end

# The left menu when on any of the "Explore" pages.
module LeftMenuBarSearch
  
  include PageObject
  
  # Page Object Definitions...
  navigating_link(:all_types, "All types", "ExploreAll")
  navigating_link(:content, "Content", "ExploreContent")
  navigating_link(:people, "People", "ExplorePeople")
  navigating_link(:groups, "Groups", "ExploreGroups")
  navigating_link(:courses, "Courses", "ExploreCourses")
  navigating_link(:research_projects, "Research projects", "ExploreResearch")
  
end

# The Left Menu Bar when in the context of the "You" pages
module LeftMenuBarYou
  
  include PageObject
  
  # Page Object Definitions
  navigating_link(:basic_information, "Basic Information", "MyProfileBasicInfo")
  navigating_link(:about_me, "About Me", "MyProfileAboutMe")
  navigating_link(:online, "Online", "MyProfileOnline")
  navigating_link(:contact_information, "Contact Information", "MyProfileContactInfo")
  
  alias contact_info contact_information
  
  navigating_link(:publications, "Publications", "MyProfilePublications")
  
  permissions_menu(:about_me_permissions, "About Me")
  permissions_menu(:online_permissions, "Online")
  permissions_menu(:contact_information_permissions, "Contact Information")
  permissions_menu(:publications_permissions, "Publications")
  
  div(:profile_pic_arrow, :class=>"s3d-dropdown-menu-arrow entity_profile_picture_down_arrow")
  
  link(:inbox_link, :text=>"Inbox")
  link(:invitations_link, :text=>"Invitations")
  link(:sent_link, :text=>"Sent")
  link(:trash_link, :text=>"Trash")
  
  # Custom Methods
  
  def inbox
    self.inbox_link
    sleep 1
    self.wait_for_ajax
  end
  
  def invitations
    self.invitations_link
    sleep 1
    self.wait_for_ajax
  end
  
  def sent
    self.sent_link
    sleep 1
    self.wait_for_ajax
  end

  def trash
    self.trash_link
    sleep 1
    self.wait_for_ajax
  end
  
  # The div for the "Lock icon" next to the My messages menu
  def my_messages_lock_icon
    self.div(:text=>"My Messages").div(:class=>"lhnavigation_private")
  end
  
  # Expands and collapses the My Messages Tree
  def show_hide_my_messages_tree
    self.div(:id=>"lhnavigation_container").link(:text=>"My Messages").click
  end
  
  # Opens the Pop Up dialog for changing the Avatar image for the
  # current page.
  def change_picture
    profile_pic_arrow_element.fire_event("onclick")
    self.link(:id=>"changepic_container_trigger").click
    self.class.class_eval { include ChangePicturePopUp }
  end

  # 
  def unread_message_count
    count_div = self.div(:text=>/My Messages/, :class=>"lhnavigation_item_content").div(:class=>"lhnavigation_levelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end

  def unread_inbox_count
    count_div = self.div(:text=>/Inbox/, :class=>"lhnavigation_subnav_item_content").div(:class=>"lhnavigation_sublevelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end
  
  def unread_invitations_count
    count_div = self.div(:text=>/Invitations/, :class=>"lhnavigation_subnav_item_content").div(:class=>"lhnavigation_sublevelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end


end

# The left menu bar when creating Groups, Courses, or Research
module LeftMenuBarCreateWorlds
  
  include PageObject
  
  # Page Object Definitions
  navigating_link(:group, "Group", "CreateGroups")
  navigating_link(:course, "Course", "MyProfileCategories")
  navigating_link(:research, "Research", "MyProfileAboutMe")
  
end

#
module PageRevisionsBar
  
  include PageObject
  
end

# The Search field that will appear above some list pages
module SearchBar
  
  include PageObject
  
  # Custom Methods...
  
  # Enters the specified text string in the search field.
  # Includes a trailing line feed character so that the search
  # will occur immediately, meaning you don't have to include a
  # line in the script for clicking on the search button.
  def search_for=(text)
    self.text_field(:id=>"search_text").set("#{text}\n")
    wait_for_ajax
  end
  
  alias search= search_for=
  alias search search_for=
  alias search_for search_for=
  alias find search_for=
  alias find= search_for=
  
end

# Methods for the 3 buttons that appear above all Document-type "Areas" in
# Groups/Courses.
module DocButtons

  include PageObject
  
  # Page Objects
  button(:edit_page_button, :id=>"sakaidocs_editpage")
  button(:add_page_button, :id=>"sakaidocs_addpage_top")
  button(:page_revisions_button, :id=>"sakaidocs_revisions")
  
  # Custom Methods...
  
  # Clicks the Edit Page button.
  def edit_page
    self.back_to_top
    edit_page_button
    wait_for_ajax
    self.class.class_eval { include DocumentWidget }
  end
  
  # Clicks the Add Page button, then enters the text string
  # into the page title field, followed by a line feed.
  def add_page(text)
    self.back_to_top
    add_page_button
    wait_for_ajax
    self.send_keys text + "\n"
  end
  
  # Clicks the Page Revisions button.
  def page_revisions
    self.back_to_top
    page_revisions_button
    wait_for_ajax
    
  end
  
  private
  
  # The generic method for editing widget settings. DO NOT USE!
  def widget_settings
    # jQuery
    click_settings=%|$("#context_settings").trigger("mousedown");|
    
    # watir-webdriver
    edit_page
    open_widget_menu
    self.execute_script(click_settings)
    wait_for_ajax
  end
  
  # The generic method for removing widgets. DO NOT USE!
  def remove_widget
    # JQuery
    jq_remove = %|$("#context_remove").trigger("mousedown");|
    
    # watir-webdriver
    self.edit_page
    self.open_widget_menu
    self.execute_script(jq_remove)
    wait_for_ajax
  end
  
  # The generic method for editing widget wrappings. DO NOT USE!
  def widget_wrapping
    
    #jQuery
    jq_wrapping = %|$("#context_appearance_trigger").trigger("mousedown");|
    
    #watir-webdriver
    edit_page
    open_widget_menu
    self.execute_script(jq_wrapping)
    wait_for_ajax
    self.class.class_eval { include AppearancePopUp }
  end
  
  # The generic method for opening the widget menu. DO NOT USE!
  def open_widget_menu(number=0)
    # jQuery commands
    click_widget=%|tinyMCE.get("elm1").selection.select(tinyMCE.get("elm1").dom.select('.widget_inline')[#{number}]);|
    node_change=%|tinyMCE.get("elm1").nodeChanged();|
    
    # watir-webdriver
    wait_for_ajax
    @browser.execute_script(click_widget)
    wait_for_ajax
    @browser.execute_script(node_change)
    wait_for_ajax
  end
  
end

# Page Elements and Custom Methods that are shared among the three Error pages
module CommonErrorElements
  
  include PageObject
  
  # TBD
  
end

#
 #
  # # # # # # # # # # # # 
  #    Pop-Up Dialogs   #
  # # # # # # # # # # # # 
 #
#
# Methods related to the My Account Pop Up dialog.
module AccountPreferencesPopUp
  
  include PageObject
  
  # Page Object Definitions
  button(:preferences, :id=>"accountpreferences_preferences_tab")
  button(:privacy_settings, :id=>"accountpreferences_privacy_tab")
  button(:password, :id=>"accountpreferences_password_tab")
  
  select_list(:time_zone, :id=>"time_zone")
  select_list(:language, :id=>"pass_language")
  
  text_field(:current_password, :id=>"curr_pass")
  text_field(:new_password, :id=>"new_pass")
  text_field(:retype_password, :id=>"retype_pass")
  
  button(:save_new_password, :text=>"Save new password")
  button(:save_preferences, :text=>"Save preferences")
  button(:save_privacy_settings, :text=>"Save privacy settings")
  
  span(:new_password_error, :id=>"new_pass_error")
  span(:retype_password_error, :id=>"retype_pass_error")
  
  # Custom methods...
  
  # Need this custom Cancel button method because there are three different
  # cancel buttons on this pop-up. This method will find the one that works
  # and click on it.
  def cancel
    case
    when @browser.div(:id=>"accountpreferences_preferContainer").visible?
      @browser.div(:id=>"accountpreferences_preferContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
    when @browser.div(:id=>"accountpreferences_changePrivacyContainer").visible?
      @browser.div(:id=>"accountpreferences_changePrivacyContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
    when @browser.div(:id=>"accountpreferences_changePassContainer").visible?
      @browser.div(:id=>"accountpreferences_changePassContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
    else
      puts "\nCouldn't find the cancel button!\n"
    end
  end

end

# Page Objects and Methods for the Add Areas Pop up dialog.
# Many page objects in this module are NOT defined using the
# Page Object gem, so they will need to be handled differently
# than usual. See the descriptions of the methods for more detail.
module AddAreasPopUp
  
  include PageObject
  
  # Page Object Definitions...
  
  # Common elements...
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
  
  # Content list...
  button(:content_list, :text=>"Content list")
  
  # Participants list...
  button(:participants_list, :text=>"Participants list")
  
  # Widgets...
  button(:widgets, :text=>"Widgets")
  
  # Custom Methods...
  
  # Clicks the list categories link.
  def list_categories
    list_categories_button
    wait_for_ajax
    self.class.class_eval { include AddRemoveCategories }
  end
  
  # The "Search Everywhere" text field. Due to a strange bug with
  # Watir-webdriver and/or PageObject, we're using this method for the
  # a definition of the field, so if you need to enter a text string into it
  # you'll need to use Watir-webdriver's ".set" method, like this:
  # page_object.search_everywhere.set "text string"
  def search_everywhere
    @browser.text_field(:id=>"addarea_existing_everywhere_search")
  end
  
  # Defines the Existing Document Name field based on the currently
  # selected tab. Test script steps will need to use Watir's .set method
  # for entering text strings into the fields.
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
  
  # Defines the Existing Doc Permissions select list field.
  # To select an item from this field you'll need to include Watir's
  # .select method in your test script step, like this:
  # page_object.existing_doc_permissions.select "option"
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
  
  # The div containing the search results list.
  # This method is primarily for use in the procedural methods
  # in this module rather than for steps in a test script (because it
  # only refers to the "Everywhere" list.
  def search_results
    self.div(:id=>"addarea_existing_everywhere_bottom")
  end
  
  # The name field for adding a Content List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.content_list_name.set "Name"
  def content_list_name
    @browser.text_field(:id=>"addarea_contentlist_name")
  end
  
  # The permissions field for adding a Content List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.content_list_permissions.select "Option"
  def content_list_permissions
    @browser.select(:id=>"addarea_contentlist_permissions")
  end
  
  # The name field for adding a Participant List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.participants_list_name.set "Name"
  def participants_list_name
    @browser.text_field(:id=>"addarea_participants_name")
  end
  
  # The permissions field for adding a Participants List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.participants_list_permissions.select "Option"
  def participants_list_permissions
    @browser.select(:id=>"addarea_participants_permissions")
  end
  
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
    self.done_add_button
    wait_for_ajax
  end
  
  alias done_add create
  
  # This method expects to be passed a hash object like this:
  # { :name=>"The name of the target document",
  #   :title=>"The placement title string",
  #   :visible=>"Who can see it" }
  # The method adds an existing document using the specified hash contents.
  # Note that it uses the "Everywhere" page, so if you want to use
  # one of the other pages for the search, you'll have to code all steps in
  # the test script itself.
  def add_from_existing(document)
    self.everywhere
    search_everywhere.set(document[:name] + "\n")
    wait_for_ajax #
    search_results.li(:text=>/#{Regexp.escape(document[:name])}/).fire_event("onclick")
    existing_doc_name.set document[:title]
    existing_doc_permissions.select document[:visible]
    
    self.create
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
  
  # Page Objects
  
  # Upload content tab...
  link(:upload_content, :text=>"Upload content")

  text_field(:file_title, :id=>"newaddcontent_upload_content_title")
  text_area(:file_description, :id=>"newaddcontent_upload_content_description")
  # "tags and categories" field is defined below...
  select_list(:who_can_see_file, :id=>"newaddcontent_upload_content_permissions")
  select_list(:file_copyright, :id=>"newaddcontent_upload_content_copyright")
  
  # Create new document tab...
  link(:create_new_document, :text=>"Create new document")
  
  text_field(:name_document, :id=>"newaddcontent_add_document_title")
  text_area(:document_description, :id=>"newaddcontent_add_document_description")
  # "tags and categories" field is defined below...
  select_list(:who_can_see_document, :id=>"newaddcontent_add_document_permissions")
  select_list(:document_copyright, :id=>"newaddcontent_upload_content_copyright")
  
  # Use existing content tab...
  link(:all_content, :text=>"All content")
  link(:add_content_my_library, :text=>"My Library")
  
  # Add link tab...
  link(:add_link, :text=>"Add link")
  
  text_field(:paste_link_address, :id=>"newaddcontent_add_link_url")
  text_field(:link_title, :id=>"newaddcontent_add_link_title")
  text_area(:link_description, :id=>"newaddcontent_add_link_description")
  # "tags and categories" field is defined below...
  
  # button(:add, :text=>"Add") Must be defined with a custom method. See below...
  
  # Collected items column...
  select_list(:save_all_to, :id=>"newaddcontent_saveto")
  
  button(:list_categories, :text=>"List categories")
  
  button(:done_add_collected_button, :text=>"Done, add collected")
  
  # Custom Methods...
  
  # Clicks the "Add" button that moves items into the
  # "Collected Items" list.
  def add
    active_content_div.button(:text=>"Add").click
    wait_for_ajax
  end
  
  # Works to enter text into any of the "Tags and Categories"
  # fields on the "Add Content" dialog.
  def tags_and_categories=(text)
    active_content_div.text_field(:id=>/as-input-\d+/).set text +"\n"
    wait_for_ajax
  end
  
  # Removes the item from the selected list.
  def remove(item)
    self.link(:title=>"Remove #{item}").click
  end
  
  # Enters the specified text in the Search field.
  # Note that the method appends a line feed on the string, so the search will
  # happen immediately when it is invoked.
  def search_for_content=(text)
    self.text_field(:class=>"newaddcontent_existingitems_search").set("#{text}\n")
  end
  
  # Checks the checkbox for the specified item.
  def check_content(item)
    self.li(:text=>item).checkbox.set
  end
  
  alias check_item check_content
  alias check_document check_content
  
  # Enters the specified filename in the file field.
  def upload_file=(file_name)
    self.file_field(:name=>"fileData").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
  end
  
  def done_add_collected
    done_add_collected_button
    sleep 2
    wait_for_ajax
  end
  
  private
  
  # A helper method for determining what div
  # is currently visible.
  def active_content_div
    case
    when self.div(:id=>"newaddcontent_upload_content_template").visible?
      return self.div(:id=>"newaddcontent_upload_content_template")
    when self.div(:id=>"newaddcontent_add_document_template").visible?
      return self.div(:id=>"newaddcontent_add_document_template")
    when self.div(:id=>"newaddcontent_add_existing_template").visible?
      return self.div(:id=>"newaddcontent_add_existing_template")
    when self.div(:id=>"newaddcontent_add_link_template").visible?
      return self.div(:id=>"newaddcontent_add_link_template")
    end
  end
  
end

# Page Objects and Methods related to the Pop Up for Categories.
module AddRemoveCategories
  
  include PageObject
  
  # Page Objects
  
  button(:save_categories, :text=>"Assign and save")
  button(:dont_save, :text=>"Don't save")
  
  # Custom Methods...
  
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
    if @browser.link(:title=>text).parent.class_name =~ /jstree-unchecked/
      @browser.link(:title=>text).click
    end
    sleep 0.3
  end
  
  # Returns an array of the categories selected in the pop-up container.
  def selected_categories
    list = []
    @browser.div(:id=>"assignlocation_jstree_selected_container").lis.each do |li|
      list << li.text
    end
    return list
  end
  
end

# Page Objects and Methods related to the "Add widgets" pop-up on the Dashboard
module AddRemoveWidgets
  
  include PageObject
  
  # Clicks the Close button on the dialog for adding/removing widgets
  # to/from the Dashboard.
  def close_add_widget
    @browser.div(:class=>"s3d-dialog-close jqmClose").fire_event("onclick")
    wait_for_ajax
    MyDashboard.new @browser
  end
  
  # Adds all widgets to the dashboard
  def add_all_widgets
    array = @browser.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "add" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Add").click
      wait_for_ajax
    end
    close_add_widget
  end
  
  # Removes all widgets from the dashboard
  def remove_all_widgets
    array = @browser.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "remove" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Remove").click
      wait_for_ajax
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

# Page Objects and Methods related to the Pop Up Dialog for Contacts
module AddToContactsPopUp

  include PageObject
  
  # Page Object
  button(:invite_button, :text=>"Invite")
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
  
  # Custom Methods...
  
  def invite
    invite_button
    sleep 0.5
    wait_for_ajax
  end
  
end

#
module AppearancePopUp
  
  include PageObject
  
  # Page Object
  
  # Custom Methods...
  
end

# Page Objects and Custom Methods related to the "Select your profile picture" pop-up dialog
module ChangePicturePopUp
  
  include PageObject
  
  # Page Objects
  
  h1(:pop_up_title, :class=>"s3d-dialog-header")
  file_field(:pic_file, :id=>"profilepicture")
  button(:upload, :id=>"profile_upload")
  button(:save, :id=>"save_new_selection")
  button(:cancel, :text=>"Cancel")
  div(:error_message, :id=>"changepic_nofile_error")
  image(:thumbnail, :id=>"thumbnail_img")
  
  # Custom Methods...
  
  # Uploads the specified file name for the Avatar photo
  def upload_a_new_picture(file_name)
    self.back_to_top
    #puts(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
    self.pic_file_element.when_visible { @browser.file_field(:id=>"profilepicture").set("/Users/abrahamheward/Work/Kuali-Sakai-Functional-Test-Automation-Framework/data/sakai-oae/Mercury.gif") }#File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name) }
    self.upload
    sleep 5 
  end
  
  # Clicks the Save button for the Change Picture Pop Up.
  def save_new_selection
    self.save_element.when_visible { save }
    wait_for_ajax
  end
  
  def thumbnail_source
    self.thumbnail_element.src
  end
  
end

#
module CommentsPopUp
  
  include PageObject
  
end

# Objects in the Pop Up dialog for setting viewing permissions for Content
module ContentPermissionsPopUp
  
  include PageObject
  
  # Page Objects
  radio_button(:anyone_public, :id=>"contentpermissions_see_public")
  radio_button(:logged_in_people_only, :id=>"contentpermissions_see_everyone")
  radio_button(:private_to_the_shared_with_list, :id=>"contentpermissions_see_private")
  select_list(:content_permissions, :id=>"contentpermissions_members_autosuggest_permissions")
  text_area(:sharing_message, :id=>"contentpermissions_members_autosuggest_text")
  button(:share_button, :id=>"contentpermissions_members_autosuggest_sharebutton")
  button(:save_and_close_button, :id=>"contentpermissions_apply_permissions")
  button(:cancel, :class=>"s3d-link-button jqmClose s3d-bold")
  
  # Custom Methods...
  
  # Enters the specified name in the "Who can edit it or
  # who is it associated with?" search field. Then clicks
  # on the first item in the search results menu--which means
  # that this method assumes the search will be successful
  # and the first item listed is the desired item to select.
  def share_with=(name)
    self.text_field(:id=>/contentpermissionscontainer\d+/).set name
    sleep 0.6
    wait_for_ajax
    self.div(:class=>"as-results").li(:id=>"as-result-item-0").fire_event "onclick"
    wait_for_ajax
  end
  
  # Clicks the "Save and close" button then waits for all ajax calls
  # to finish
  def save_and_close
    save_and_close_button
    wait_for_ajax
  end
  
  # Clicks the "Share" button and waits for the ajax calls to finish.
  def share
    self.button(:id=>"contentpermissions_members_autosuggest_sharebutton").flash
    self.button(:id=>"contentpermissions_members_autosuggest_sharebutton").click
    wait_for_ajax
  end
  
end

# Methods for the "Delete" Pop-up dialog.
module DeletePagePopUp
  
  include PageObject
  
  # Page Objects
  button(:delete_button, :id=>"lhnavigation_delete_confirm")
  button(:dont_delete_button, :class=>"s3d-link-button s3d-bold jqmClose")
  
  # Custom Methods
  
  def delete
    delete_button
    wait_for_ajax
  end
  
  def dont_delete
    dont_delete_button
    wait_for_ajax
  end
  
end

#
module DiscussionPopUp
  
  include PageObject
  
  # Page Objects
  
  # Custom Methods
  
end

#
module ExportAsTemplate
  
  include PageObject
  
  # Page Objects
  
  # Custom Methods
  
end
#
module FilesAndDocsPopUp
  
  include PageObject
  
  # Page Objects
  link(:display_settings, :id=>"embedcontent_tab_display")
  text_field(:name, :class=>"as-input")
  button(:dont_add_button, :class=>"s3d-link-button s3d-bold embedcontent_dont_add")
  
  # Custom Methods...
  
  def dont_add
    dont_add_button
    wait_for_ajax
  end
  
end

#
module GoogleGadgetPopUp
  
  include PageObject
  
  # Page Objects
  
  # Custom Methods
  
end

# Page Objects and Methods related to the Pop Up that appears for modifying
# the settings for the Google Maps Widget.
module GoogleMapsPopUp
  
  include PageObject
  
  # Page Objects
  text_field(:location, :id=>"googlemaps_input_text_location")
  button(:search_button, :id=>"googlemaps_button_search")
  button(:dont_add, :id=>"googlemaps_cancel")
  button(:add_map, :id=>"googlemaps_save")
  radio_button(:large, :id=>"googlemaps_radio_large")
  radio_button(:small, :id=>"googlemaps_radio_small")
  
  # Custom Methods...
  
  def search
    search_button
    sleep 2
  end
  
end

#
module InlineContentPopUp
  
  include PageObject

  # Page Objects
  
  # Custom Methods

end

# Page Objects and Methods related to the Pop Up that allows modifying a
# Group's/Course's participants.
module ManageParticipants
  
  include PageObject
  
  # Page Objects
  checkbox(:add_all_contacts, :id=>"addpeople_select_all_contacts")
  checkbox(:remove_all_contacts, :id=>"addpeople_select_all_selected_contacts")
  button(:remove_selected, :text=>"Remove selected")
  button(:save, :class=>"s3d-button s3d-overlay-action-button addpeople_finish_adding")
  button(:cancel, :class=>"s3d-link-button jqmClose s3d-bold")
  select_list(:role_for_selected_members, :id=>"addpeople_selected_all_permissions")
  
  # Custom Methods
  
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
      self.text_field(:id=>/addpeople/, :class=>"as-input").focus
      self.text_field(:id=>/addpeople/, :class=>"as-input").send_keys(letter)
      self.wait_until { self.div(:id=>/^as-results-/).visible? }
      if self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).present?
        @browser.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
        break
      end
    end
  end
  
  alias add_contact_by_search add_by_search
  alias add_participant_by_search add_by_search
  alias search_and_add_participant add_by_search
  alias add_by_search= add_by_search
  
  alias done_apply_settings save
  alias apply_and_save save
  
  alias dont_apply cancel
  
  # Checks to remove the specified contact.
  def check_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.set
  end
  
  # Unchecks the remove checkbox for the specified contact
  def uncheck_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.clear
  end
  
  
  # For the specified contact, updates to the specified role.fd
  def set_role_for(contact, role)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.select(:class=>"addpeople_selected_permissions").select(role)
  end
  
end

#
module OurAgreementPopUp
  
  include PageObject
  
  # Page Objects
  button(:no_button, :id=>"acceptterms_action_dont_accept")
  button(:yes_button, :id=>"acceptterms_action_accept")
  
  # Custom Methods
  def no_please_log_me_out
    
  end
  
  def yes_I_accept
    self.yes_button
    self.wait_for_ajax
    MyDashboard.new @browser
  end
  
end

#
module OwnerInfoPopUp
  
  include PageObject
  
  # Page Objects
  button(:close_owner_info, :id=>"personinfo_close_button")
  
  # Custom Methods
  
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

# The Pending Requests Pop-Up for Groups/Courses/Projects
module PendingRequestsPopUp
  
  include PageObject
  
  # Page Objects
  button(:done_button, :text=>"Done")
  
  
  # Custom Methods...
  
  # Clicks the "Add as a member" link for the
  # specified user.
  def add_as_member(name)
    self.div(:class=>"fl-force-left joinrequests_details",:text=>/#{Regexp.escape(name)}/).button(:text=>"Add as a member").click
    self.wait_for_ajax(3)
  end
  
  alias add_as_a_member add_as_member
  
  # Clicks the "ignore" button for the specified
  # user
  def ignore(name)
    self.div(:class=>"fl-force-left joinrequests_details",:text=>/#{Regexp.escape(name)}/).button(:text=>"Ignore").click
    self.wait_for_ajax(3)
  end
  
  def done
    self.done_button
    self.wait_for_ajax(3)
  end
  
end

# Objects and Methods for the Area Permissions Pop Up dialog
module PermissionsPopUp
  
  include PageObject
  
  # Page Objects
  h1(:permissions_header, :class=>"s3d-dialog-header")
  radio_button(:anyone_public, :id=>"areapermissions_see_public")
  radio_button(:anyone_logged_in, :id=>"areapermissions_see_loggedin")
  radio_button(:specific_roles_only, :id=>"areapermissions_see_private")
  
  checkbox(:lecturers_can_see, :id=>"areapermissions_see_lecturer")
  checkbox(:teaching_assistants_can_see, :id=>"areapermissions_see_ta")
  checkbox(:students_can_see, :id=>"areapermissions_see_student")
  
  checkbox(:lecturers_can_edit, :id=>"areapermissions_edit_lecturer")
  checkbox(:teaching_assistants_can_edit, :id=>"areapermissions_edit_ta")
  checkbox(:students_can_edit, :id=>"areapermissions_edit_student")
  
  button(:cancel_button, :class=>"s3d-link-button jqmClose s3d-bold")
  button(:apply_permissions_button, :id=>"areapermissions_apply_permissions")
  
  # Custom Methods
  def apply_permissions
    self.apply_permissions_button
    sleep 0.3
    #wait_for_ajax(2)
  end
  
  def cancel
    self.cancel_button
    wait_for_ajax(2)
  end
  
end

# Methods and objects for the Profile Permissions Pop Up--that appears when
# you select the Permissions item for the "My Profile" pages.
module ProfilePermissionsPopUp
  
  include PageObject
  
  select_list(:can_be_seen_by, :id=>"userpermissions_area_general_visibility")
  button(:apply_permissions_button, :id=>"userpermissions_apply_permissions")
  
  def apply_permissions
    apply_permissions_button
    sleep 0.3
    #wait_for_ajax
  end
  
  def cancel
    self.div(:id=>"userpermissions_container").button(:class=>"s3d-link-button jqmClose s3d-bold").click
  end
  
end

#
module RemoteContentPopUp
  
  include PageObject
  
end

#
module RemoveContactsPopUp
  
  include PageObject
  
  # Page Objects
  button(:remove_contact_button, :id=>"contacts_delete_contact_confirm")
  button(:cancel_button, :class=>"s3d-link-button s3d-bold jqmClose")
  
  # Custom Methods...
  
  def remove_contact
    remove_contact_button
    sleep 0.5
    wait_for_ajax
  end
  
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

# The Email message fields in My Messages and the pop up dialog
# that appears when in the Worlds context
# (or when you click the little envelop icon in lists of People).
module SendMessagePopUp
  
  include PageObject
  
  list_item(:no_results, :class=>"as-message")
  
  def see_all_element
    current_div.link(:id=>"inbox_back_to_messages")
  end
  
  def see_all
    see_all_element.click
  end
  
  # Removes the recipient from the To list for the email.
  def remove_recipient(name)
    name_li(name).link(:text=>"×").click
  end
  
  # Returns an array containing the specified message recipients
  def message_recipients
    recipients = []
    self.lis(:id=>/as-selection-/).each do |li|
      string = li.text
      string.gsub!("×\n","")
      recipients << string
    end
    return recipients
  end
  
  # Enters the specified text string into the
  # "Send this message to" text box, then clicks
  # The matching item in the results list box.
  def send_this_message_to=(name)
    name.split("", 4).each do |letter|
      current_div.text_field(:id=>"sendmessage_to_autoSuggest", :class=>"as-input").focus
      current_div.text_field(:id=>"sendmessage_to_autoSuggest", :class=>"as-input").send_keys(letter)
      self.wait_until { self.div(:id=>"as-results-sendmessage_to_autoSuggest").visible? }
      if self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).present?
        self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
        break
      end
    end
  end
  
  def subject_element
    current_div.text_field(:id=>"comp-subject")
  end
  
  # Enters the specified text string into the
  # "Subject" field
  def subject=(text)
    subject_element.set text
  end
  
  # Enters the specified text string into the Body
  # field.
  def body_element
    current_div.textarea(:id=>"comp-body")
  end
  
  def body=(text)
    body_element.set text
  end
  
  # Clicks the "Send message" button
  def send_message_element
    current_div.button(:id=>"send_message")
  end
  
  def send_message
    send_message_element.click
    wait_for_ajax
  end
  
  # Clicks the "Don't send" button
  def dont_send
    current_div.button(:id=>"send_message_cancel").click
    wait_for_ajax
  end
  
  # Clicks the link for accepting a join request inside a Manager's join
  # request email
  def accept_join_request
    self.link(:text=>/=joinrequests/).click
    # currently this opens a page in a new tab.
    # UGLY!!!
    # FIXME
  end
  
  # Private Methods
  private
  
  def current_div
    begin 
      return active_div
    rescue NoMethodError
      return self
    end
  end
  
end

# The Settings Pop Up dialog for Courses/Groups/Research...
module SettingsPopUp

  include PageObject
  
  text_field(:title, :id=>"worldsettings_title")
  text_area(:description, :id=>"worldsettings_description")
  text_area(:tags, :id=>"worldsettings_tags")
  select_list(:can_be_discovered_by, :id=>"worldsettings_can_be_found_in")
  select_list(:membership, :id=>"worldsettings_membership")
  
  button(:apply_settings_button, :id=>"worldsettings_apply_button")
  
  def apply_settings
    apply_settings_button
    wait_for_ajax
  end
  
end

# Methods related to the Pop Up for Sharing Content with others.
module ShareWithPopUp
  
  include PageObject
  
  text_field(:share_with_field, :id=>/newsharecontentcontainer\d+/)
  
  # Clicks the arrow for adding a custom message to the share.
  def add_a_message
    @browser.span(:id=>"newsharecontent_message_arrow").fire_event('onclick')
  end
  
  text_area(:message_text, :id=>"newsharecontent_message")
  
  button(:share, :id=>"sharecontent_send_button")
  button(:cancel, :id=>"newsharecontent_cancel")
  
  def share_with=(name)
    #self.share_with_field=name + "\n"
    #sleep 0.6
    #self.wait_for_ajax
    #self.li(:id=>"as-result-item-0").click
    
    name.split("", 5).each do |letter|
      self.share_with_field_element.focus
      self.share_with_field_element.send_keys(letter)
      self.wait_until { self.div(:id=>/^as-results-/).visible? }
      if self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).present?
        @browser.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
        break
      end
    end
    
  end
  
  # Gonna add the social network validations later
  
end

#
 #
  # # # # # # # # # # # # 
  #       Widgets       #
  # # # # # # # # # # # # 
 #
#
# Methods related to the expandable Collector item that can appear at the top of any page.
module CollectorWidget
  
  include PageObject
  
end

# Methods associated with documents that use the TinyMCE Editor.
module DocumentWidget
  
  include PageObject
  
  # Page Objects
  button(:dont_save, :id=>"sakaidocs_edit_cancel_button")
  button(:save_button, :id=>"sakaidocs_edit_save_button")
  button(:insert, :id=>"sakaidocs_insert_dropdown_button")
  select_list(:format, :id=>/formatselect/)
  select_list(:font, :id=>/fontselect/)
  select_list(:font_size, :id=>/fontsizeselect/)
  link(:bold, :id=>/_bold/)
  link(:italic, :id=>/_italic/)
  link(:underline, :id=>/_underline/)
  
  # These methods click the Insert button (you must be editing the document first),
  # then select the specified menu item, to bring up the Widget settings dialog.
  # The first argument is the method name (which automatically gets pre-pended
  # with "insert_", the second is the id of the target
  # button in the Insert menu, and the last argument is the name of the module
  # to be included in the current Class object. The module name can be nil,
  # since not every item in the insert button list brings up a Pop Up dialog.
  insert_button(:files_and_documents, "embedcontent", "FilesAndDocsPopUp")
  insert_button(:discussion, "discussion", "Discussion")
  insert_button(:remote_content, "remotecontent", "RemoteContentPopUp" )
  insert_button(:inline_content, "inlinecontent", "InlineContentPopUp" )
  insert_button(:google_maps, "googlemaps", "GoogleMapsPopUp" )
  insert_button(:comments, "comments", "CommentsPopUp" )
  insert_button(:rss_feed_reader, "rss", "RSSFeedPopUp" )
  insert_button(:google_gadget, "ggadget", "GoogleGadgetPopUp" )
  insert_button(:horizontal_line, "hr")
  insert_button(:tests_and_quizzes, "sakai2samigo")
  insert_button(:calendar, "sakai2calendar")
  insert_button(:jisc_content, "jisccontent")
  insert_button(:assignments, "sakai2assignments")
  insert_button(:basic_lti, "basiclti")
  insert_button(:gradebook, "sakai2gradebook")
  
  # Custom Methods...
  
  # Clicks the Save button
  def save
    save_button
    sleep 1
    wait_for_ajax
  end
  
  # Erases the entire contents of the TinyMCE Editor, then
  # enters the specified string into the Editor.
  def set_content=(text)
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    self.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
    self.frame(:id=>"elm1_ifr").send_keys(text)
  end
  
  # Appends the specified string to the contents of the TinyMCE Editor.
  def add_content=(text)
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    self.frame(:id=>"elm1_ifr").send_keys(text)
  end
  
  # Selects all the contents of the TinyMCE Editor
  def select_all
    self.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
  end
  
  # Clicks the Text Box of the TinyMCE Editor so that the edit cursor
  # will become active in the Editor.
  def insert_text
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
  end
  
  # Other MCE Objects TBD later, though we're not in the business of testing TinyMCE...
  
end

# Methods related to the Library List page.
module LibraryWidget
  
  include PageObject
  
  # Enters the specified string in the search field.
  # Note that it appends a line feed on the string, so the
  # search occurs immediately.
  def search_library_for=(text)
    self.text_field(:id=>"mylibrary_livefilter").set("#{text}\n")
  end
  
  checkbox(:add, :id=>"mylibrary_check_all")
  
  # Checks the specified Library item.
  def check_content(item)
    self.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.set
  end
  
  # Unchecks the specified library item.
  def uncheck_content(item)
    self.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.clear
  end
  
  checkbox(:remove_all_library_items, :id=>"mylibrary_check_all")
  
end

# Contains methods common to all Results lists
module ListWidget
  
  include PageObject
  
  # Page Objects
  select_list(:sort_by, :id=>/sortby/)
  select_list(:filter_by, :id=>"facted_select")
  
  # Custom Methods...
  
  # Returns an array containing the text of the links (for Groups, Courses, etc.) listed
  def results_list
    list = []
    begin
      self.spans(:class=>"s3d-search-result-name").each do |element|
        list << element.text
      end
    rescue
      list = []
    end
    return list
  end
  
  alias courses results_list
  alias course_list results_list
  alias groups_list results_list
  alias groups results_list
  alias projects results_list
  alias documents results_list
  alias documents_list results_list
  alias content_list results_list
  alias results results_list
  alias people_list results_list
  alias contacts results_list
  alias memberships results_list
  
end

# Methods related to lists of Collections
module ListCollections
  
  include PageObject
  
end

# Methods related to lists of Content-type objects
module ListContent
  
  include PageObject
  
  # Clicks to share the specified item.
  def share(item)
    name_li(name).button(:title=>"Share content").click
    self.wait_until { @browser.text.include? "Or, share it on a webservice:" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  alias share_content share
  
  # Adds the specified (listed) content to the library.
  def add_content_to_library(name)
    name_li(name).button(:title=>"Save content").click
    self.wait_until { @browser.text.include? "Save to" }
    self.class.eval_class { include SaveContentPopUp }
  end
  
  alias add_document add_content_to_library
  alias save_content add_content_to_library
  
  # Clicks to view the owner information of the specified item.
  def view_owner_information(name)
    self.button(:title=>"View owner information for #{name}").click
    self.wait_until { @browser.text.include? "Add to contacts" }
    self.class.eval_class { include OwnerInfoPopUp }
  end
  
  # Returns the mimetype text next to the Content name--the text that describes
  # what the system thinks the content is.
  def content_type(name)
    self.div(:class=>"s3d-search-result-right", :text=>/#{Regexp.escape(name)}/).span(:class=>"searchcontent_result_mimetype").text
  end
  
  alias view_owner_info view_owner_information
  
end

# Methods related to lists of People/Participants
module ListPeople
  
  include PageObject
  
  # Clicks the plus sign next to the specified Contact name.
  # Obviously the name must exist in the list.
  def add_contact(name)
    self.button(:title=>"Request connection with #{name}").click
    self.wait_until { @browser.button(:text=>"Invite").visible? }
    self.class.class_eval { include AddToContactsPopUp }
  end
  
  alias request_contact add_contact
  alias request_connection add_contact
  
  # Clicks the X to remove the selected person from the
  # Contacts list (in My Contacts).
  def remove(name)
    self.button(:title=>"Remove contact #{name}").click
    wait_for_ajax
    self.class.class_eval { include RemoveContactsPopUp }
  end
  
  alias remove_contact remove
  
  def send_message_to(name)
    name_li(name).button(:class=>"s3d-link-button s3d-action-icon s3d-actions-message searchpeople_result_message_icon sakai_sendmessage_overlay").click
    wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end
  
  # This method checks whether or not the listed
  # person has the "Add contact" button available.
  # To ensure the test case will be valid, it first
  # makes sure the specified person is in the list.
  # Returns true if the button is available.
  def addable?(name)
    if name_link(name).exists?
      self.button(:title=>"Request connection with #{name}").present?
    else
      puts "\n#{name} isn't in the results list. Check your script.\nThis may be a false negative.\n"
      return false
    end
  end
  
  def not_addable?(name)
    addable?(name)== true ? false : true
  end
  
end

# Methods related to lists of Groups/Courses
module ListGroups
  
  include PageObject
  
  def join_button_for(name)
    name_li(name).div(:class=>/searchgroups_result_left_filler/)
  end
  
  # Clicks on the plus sign image for the specified group in the list.
  def add_group(name)
    name_li(name).div(:class=>/searchgroups_result_left_filler/).fire_event("onclick")
  end
  
  alias add_course add_group
  alias add_research add_group
  alias join_course add_group
  alias join_group add_group

=begin # Tentatively moving this code to the GlobalMethods module
    # This will be experimental for a while...

  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Group listed on
  # the page because it will instantiate the GroupLibrary class).
  def open_group(name)
    name_link(name).click
    sleep 1
    wait_for_ajax
    @browser.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    Library.new(@browser)
  end
  
  alias view_group open_group
  alias view_course open_group
  alias open_course open_group
=end
  # Returns the specified item's "type", as shown next to the item name--i.e.,
  # "GROUP", "COURSE", etc.
  def group_type(item)
    self.span(:class=>"s3d-search-result-name",:text=>item).parent.span(:class=>"mymemberships_item_grouptype").text
  end
  
  # Clicks the Message button for the specified listed item.
  def message_course(name)
    name_li(name).button(:class=>/sakai_sendmessage_overlay/).click
    self.class.class_eval { include SendMessagePopUp }
  end
  
  alias message_group message_course
  alias message_person message_course
  alias message_research message_course
  
end

# Methods related to lists of Research Projects
module ListProjects
  
  include PageObject
  
  # Page Objects
  
  # Custom Methods...
  
  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Research item listed on
  # the page because it will instantiate the ResearchIntro class).
  def open_research(name)
    name_link(name).click
    sleep 1
    wait_for_ajax
    self.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    ResearchIntro.new @browser
  end
  
  alias view_research open_research
  alias open_project open_research
  
end

# Methods related to the Mail Pages. (Is this needed????)
module MailWidget
  
  include PageObject
  
end

# Methods related to the Participants "Area" or "Page" in
# Groups/Courses. This is not the same thing as the ManageParticipants
# module, which relates to the "Add People" Pop Up.
module ParticipantsWidget
  
  include PageObject
  
end


#
#
# ======================
# ======================
# Page Classes
# ======================
# ======================


# Methods for the Assignments Widget page.
class Assignments
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def cle_frame
    self.frame(:src=>/sakai2assignments.launch.html/)
  end
  
end

# The Login page for OAE.
class LoginPage
  
  include PageObject
  include HeaderFooterBar
  include GlobalMethods
  
  # Page Objects
  div(:expand_categories, :class=>"categories_expand")
  
  # Custom Methods...
  
  # Clicks the Sign Up link on the Login Page.
  def sign_up
    link(:id=>"navigation_anon_signup_link").click
    CreateNewAccount.new @browser
  end
  
  # Returns an array containing the titles of the items
  # displayed in the "Recent activity" box on the login page.
  def recent_activity_list
    list = []
    self.div(:id=>"recentactivity_activity_container").links(:class=>"recentactivity_activity_item_title recentactivity_activity_item_text s3d-regular-links s3d-bold").each do |link|
      list << link.text
    end
    return list.uniq!
  end
  
  # Returns an array containing the titles of the items in the
  # Featured Content area of the page.
  def featured_content_list
    list = []
    self.div(:id=>"featuredcontent_content_container").links(:class=>/featuredcontent_content_title/).each do |link|
      list << link.text
    end
    return list
  end
  
end

# Page Objects and Methods for the "All Categories" page.
# Note that this page is distinct from the "Search => All types"
# page.
class AllCategoriesPage
  
  include PageObject
  include HeaderFooterBar
  include GlobalMethods
  
  # Page Objects
  div(:page_title, :class=>"s3d-contentpage-title")
  
  # Custom Methods...
  
end

#
class Calendar
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include GlobalMethods
  
  def calendar_frame
    self.frame(:src=>/sakai2calendar.launch.html/)
  end
  
end

# Methods related to the Content Details page.
class ContentDetailsPage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include DocButtons
  include LeftMenuBar
  
  # Page Objects
  text_area(:description, :id=>"contentmetadata_description_description")
  text_area(:comment_text_area, :id=>"contentcomments_txtMessage")
  button(:comment_button, :text=>"Comment")
  button(:see_more, :id=>"contentmetadata_show_more")
  button(:see_less, :id=>"contentmetadata_show_more")
  button(:permissions_menu_button, :id=>"entity_content_permissions")
  button(:permissions_button, :text=>"Permissions")
  button(:delete_button, :text=>"Delete")
  button(:add_to_button, :id=>"entity_content_save")
  button(:share_button, :id=>"entity_content_share")
  
  span(:name, :id=>"entity_name")
  span(:type, :id=>"entity_type")
  
  # Custom Methods...
  
  # Header row items...
  def update_name=(new_name)
    name_element.click
    self.text_field(:id=>"entity_name_text").set new_name + "\n"
  end
  
  # Visibility...
  def change_visibility_private
    
  end
  
  def change_visibility_logged_in
    
  end
  
  def change_visibility_public
    
  end
  
  # Collaboration...
  
  #
  def view_collaborators
    
  end
  
  #
  def change_collaborators
    
  end
  
  # This method is currently not working 
  #def change_sharing
  #  self.div(:class=>"entity_owns_actions_share has_counts ew_permissions").hover
  #  self.div(:class=>"entity_owns_actions_share has_counts ew_permissions").click
  #  self.execute_script(%|$('.entity_owns_actions_share.has_counts.ew_permissions').trigger("mouseover");|)
  #  wait_for_ajax
  #  self.div(:class=>"entity_owns_actions_share has_counts ew_permissions").button(:class=>"s3d-link-button ew_permissions").click 
  #  self.class.class_eval { include ContentPermissionsPopUp }
  #end
  
  def collaboration_share
    self.div(:id=>"entity_actions").button(:text=>"Share").click
    self.wait_until { self.text.include? "Who do you want to share with?" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  # Comments count...
  
  # Comments field...
  
  # Clicks the Comments button
  def comment
    comment_button
    wait_for_ajax(2)
  end
  
  #
  def comment_text(text)
    comment_text_area_element.click
    comment_text_area_element.send_keys text
  end
  
  # Clicks the "Add to..." button
  def add_to
    add_to_button
    wait_for_ajax(2)
  end
  
  # Clicks "Permissions" in the menu...
  def permissions
    permissions_menu_button
    wait_for_ajax(2)
    permissions_button
    wait_for_ajax(2)
    self.class.class_eval { include ContentPermissionsPopUp }
  end
  
  # Returns an array object containing the items displayed in
  # "Related Content" on the page.
  def related_content
    list = []
    self.div(:class=>"relatedcontent_list").links.each do |link|
      list << link.title
    end
    return list
  end
  
  # Clicks on the "Share Content" button.
  def share_content
    self.div(:id=>"entity_actions").span(:class=>"entity_share_content").click
    self.wait_until { @browser.text.include? "Who do you want to share with?" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  # Clicks on the "Add to library" button.
  def add_to_library
    self.button(:text=>"Add to library").click
    self.wait_until { self.text.include? "Save to" }
    self.class.class_eval { include SaveContentPopUp }
  end
  
  # Opens the description text field for editing.
  def edit_description
    self.div(:id=>"contentmetadata_description_container").fire_event "onmouseover"
    self.div(:id=>"contentmetadata_description_container").fire_event "onclick"
  end
  
  # Opens the tag field for editing.
  def edit_tags
    self.div(:id=>"contentmetadata_tags_container").fire_event "onclick"
  end
  
  # Opens the Copyright field for editing.
  def edit_copyright
    self.div(:id=>"contentmetadata_copyright_container").fire_event "onclick"
  end
  
  # Opens the Categories field for editing.
  def edit_categories
    self.div(:id=>"contentmetadata_locations_container").fire_event "onclick"
    self.class.class_eval { include AddRemoveCategories }
  end
  
  # Returns an array containing the tags and categories listed on the page.
  def tags_and_categories_list
    list =[]
    self.div(:id=>"contentmetadata_tags_container").links.each do |link|
      list << link.text
    end
    return list
  end
  
  
  # The "share" button next to the Download button.
  def share_with_others
    self.share_button
    self.wait_for_ajax
    self.class.class_eval { include ShareWithPopUp }
  end
  
  # Comments List Stuff
  
  #
  def last_comment
    hash = {}
    comments_table = self.div(:class=>"contentcommentsTable")
    last_message = comments_table.div(:class=>"contentcomments_comment last")
    hash.store(:poster, last_message.span(:class=>"contentcomments_posterDataName s3d-regular-links").link.text)
    hash.store(:date, last_message.span(:class=>"contentcomments_dateComment").text)
    hash.store(:message, last_message.div(:class=>"contentcomments_message").text)
    hash.store(:delete_button, last_message.button(:id=>/contentcomments_delete_\d+/))
    return hash
  end
  
  #
  def first_comment
    hash = {}
    comments_table = self.div(:class=>"contentcommentsTable")
    last_message = comments_table.div(:class=>"contentcomments_comment last")
    hash.store(:poster, last_message.span(:class=>"contentcomments_posterDataName s3d-regular-links").link.text)
    hash.store(:date, last_message.span(:class=>"contentcomments_dateComment").text)
    hash.store(:message, last_message.div(:class=>"contentcomments_message").text)
    hash.store(:delete_button, last_message.button(:id=>/contentcomments_delete_\d+/))
    return hash
  end
  
end

# Methods related to the page for creating a new user account
class CreateNewAccount
  
  include PageObject
  include HeaderFooterBar
  
  text_field(:user_name, :id=>"username")
  text_field(:institution, :id=>"institution")
  # The password field's method name needs to be
  # "new_password" so that it doesn't conflict with
  # the "password" field in the Sign In menu...
  text_field(:new_password, :id=>"password")
  text_field(:retype_password, :id=>"password_repeat")
  select_list(:role, :id=>"role")
  select_list(:title, :id=>"title")
  text_field(:first_name,:id=>"firstName")
  text_field(:last_name,:id=>"lastName")
  text_field(:email,:id=>"email")
  text_field(:email_confirm, :id=>"emailConfirm")
  text_field(:phone_number,:id=>"phone")
  checkbox(:receive_tips, :id=>"emailContact")
  checkbox(:contact_me_directly, :id=>"contactMe")
  button(:create_account_button, :id=>"save_account")
  
  span(:username_error, :id=>"username_error")
  span(:password_error, :id=>"password_error")
  span(:password_repeat_error, :id=>"password_repeat_error")
  span(:title_error, :id=>"title_error")
  span(:firstname_error, :id=>"firstName_error")
  span(:lastname_error, :id=>"lastName_error")
  span(:email_error, :id=>"email_error")
  span(:email_confirm_error, :id=>"emailConfirm_error")
  span(:institution_error, :id=>"institution_error")
  span(:role_error, :id=>"role_error")
  
  def create_account
    self.create_account_button
    sleep 7
    wait_for_ajax(5)
    MyDashboard.new @browser
    #self.class.class_eval { include OurAgreementPopUp }
  end

end
#
class CreateCourses
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBarCreateWorlds
  
  def use_math_template
    self.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    # Class goes here
  end
  
  def use_basic_template
    self.div(:class=>"selecttemplate_template_small selecttemplate_template_right").button(:text=>"Use this template").click
    self.wait_until { self.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
end

#
class CreateGroups
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBarCreateWorlds
  
  text_field(:title, :id=>"newcreategroup_title")
  text_field(:suggested_url, :id=>"newcreategroup_suggested_url")
  text_area(:description, :id=>"newcreategroup_description")
  text_area(:tags, :name=>"newcreategroup_tags")
  select_list(:can_be_discovered_by, :id=>"newcreategroup_can_be_found_in")
  select_list(:membership, :id=>"newcreategroup_membership")
  
  def add_people
    self.button(:text, "Add people").click
    wait_for_ajax(2)
    self.class.class_eval { include ManageParticipants }
  end

  def add_more_people
    self.button(:text, "Add more people").click
    wait_for_ajax(2)
    self.class.class_eval { include ManageParticipants }
  end

  def list_categories
    self.button(:text=>"List categories").click
    wait_for_ajax(2)
    self.class.class_eval { include AddRemoveCategories }
  end
  
  def create_basic_course
    create_thing
    unless url_error_element.visible?
      self.wait_until(45) { self.text.include? "Add content" }
      self.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").wait_until_present
      Library.new @browser
    end
  end
  
  alias create_simple_group create_basic_course
  alias create_group create_basic_course
  alias create_research_support_group create_basic_course
  
  def create_research_project
    create_thing
    unless url_error_element.visible?
      self.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").wait_until_present
      ResearchIntro.new @browser
    end
  end
  
  span(:url_error, :id=>"newcreategroup_suggested_url_error")
  
  private
  
  def create_thing
    self.button(:class=>"s3d-button s3d-overlay-button newcreategroup_create_simple_group").click
    sleep 0.3
    self.div(:id=>"sakai_progressindicator").wait_while_present
    wait_for_ajax(2)
  end
  
end

#
class CreateResearch
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBarCreateWorlds
  
  def use_research_project_template
    self.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    self.wait_until { self.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
  def use_research_support_group_template
    self.div(:class=>"selecttemplate_template_small selecttemplate_template_right").button(:text=>"Use this template").click
    self.wait_until { self.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
end

# Page Object and methods for the SEARCH ALL TYPES page
# NOT the "Browse All Categories" page!
class ExploreAll

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListCollections
  include ListContent
  include ListGroups
  include ListPeople
  include ListProjects
  include SearchBar

  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:class=>"searchall_content_main")
    top.div(:id=>"results_header").span.text =~ /^.+(?=.\()/
    $~.to_s
  end

end

#
class ExploreContent

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListContent
  include SearchBar

  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:class=>"searchcontent_content_main")
    top.div(:id=>"results_header").span.text =~ /^.+(?=.\()/
    $~.to_s
  end

end

#
class ExplorePeople

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListPeople
  include SearchBar

  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:class=>"searchpeople_content_main")
    top.div(:id=>"results_header").span.text =~ /^.+(?=.\()/
    $~.to_s
  end

end

#
class ExploreGroups

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListGroups
  include SearchBar

  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:id=>"searchgroups_widget", :index=>0)
    top.div(:id=>"results_header").span(:id=>"searchgroups_type_title").text
  end

end

# 
class ExploreCourses
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListGroups
  include SearchBar
  
  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:id=>"searchgroups_widget", :index=>1)
    top.div(:id=>"results_header").span(:id=>"searchgroups_type_title").text
  end
  
  def courses_count
    #TBD
  end
  
  def filter_by=(selection)
    self.select(:id=>"facted_select").select(selection)
    wait_for_ajax(2)
  end
  
  def sort_by=(selection)
    self.div(:class=>"s3d-search-sort").select().select(selection)
    wait_for_ajax(2)
  end
  
end

#
class ExploreResearch

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarSearch
  include ListWidget
  include ListProjects
  include SearchBar
  
  # Returns the results header title (the text prior to the count of the results returned)
  def results_header
    top = self.div(:id=>"searchgroups_widget", :index=>2)
    top.div(:id=>"results_header").span(:id=>"searchgroups_type_title").text
  end
  
end


# Methods related to objects found on the Dashboard
class MyDashboard
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  include ChangePicturePopUp # FIXME ... Rethink including this by default

  # Page Objects
  button(:edit_layout, :text=>"Edit layout")
  radio_button(:one_column, :id=>"layout-picker-onecolumn")
  radio_button(:two_column, :id=>"layout-picker-dev")
  radio_button(:three_column, :id=>"layout-picker-threecolumn")
  button(:save_layout, :id=>"select-layout-finished")
  button(:add_widgets, :text=>"Add Widget")
  image(:profile_pic, :id=>"entity_profile_picture")
  div(:my_name, :class=>"s3d-bold entity_name_me")
  
  #div(:page_title, :class=>"s3d-contentpage-title")
  
  # Custom Methods...

  # Returns the text contents of the page title div  
  def page_title
    self.div(:id=>"s3d-page-container").div(:class=>"s3d-contentpage-title").text
  end
  
  def add_widgets
    self.button(:text=>"Add widget").click
    self.wait_until { self.text.include? "Add widgets" }
    self.class.class_eval { include AddRemoveWidgets }
  end
  
  # Returns an array object containing a list of all selected widgets.
  def displayed_widgets
    list = []
    self.div(:class=>"fl-container-flex widget-content").divs(:class=>"s3d-contentpage-title").each do |div|
      list << div.text
    end
    return list
  end

  # Returns the name of the recent membership item displayed.
  def recent_membership_item
    self.div(:class=>"recentmemberships_widget").link(:class=>/recentmemberships_item_link/).text
  end
  
  def go_to_most_recent_membership
    self.link(:class=>"recentmemberships_item_link s3d-widget-links s3d-bold").click
    sleep 2 # The next line sometimes throws an "unknown javascript error" without this line.
    wait_for_ajax(2)
    Library.new @browser
  end

  # Returns an array containing all the items listed in the "My memberships" dashboard widget.
  def my_memberships_list
    list = []
    self.ul(:class=>"mygroup_items_list").spans(:class=>"mygroups_ellipsis_text").each do |span|
      list << span.text
    end
    return list
  end
  

end

#
class MyMessages
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  # Page Objects
  button(:accept_invitation, :text=>"Accept invitation")
  button(:ignore_invitation, :text=>"Ignore invitation")
  
  # Custom Methods...
  
  # Returns the text of the displayed page title
  def page_title
    active_div.span(:id=>"inbox_box_title").text
  end
  
  # Clicks the "Compose message" button on any of the
  # My messages pages.
  def compose_message
    active_div.link(:id=>"inbox_create_new_message").click
    wait_for_ajax(2)
    self.class.class_eval { include SendMessagePopUp }
  end
  
  # Returns an Array containing the list of Email subjects.
  def message_subjects
    list = []
    active_div.divs(:class=>"inbox_subject").each do |div|
      list << div.text
    end
    return list
  end

  # Clicks on the specified email to open it for reading
  def open_message(subject)
    active_div.div(:class=>"inbox_subject").link(:text=>subject).click
    wait_for_ajax(2)
    self.class.class_eval { include SendMessagePopUp }
  end

  def delete_message(subject)
    subject_div = active_div.div(:class=>"inbox_subject", :text=>subject)
    subject_div.parent.parent.parent.link(:title=>"Delete message").click
    self.wait_for_ajax
  end
  
  def reply_to_message(subject)
    subject_div = active_div.div(:class=>"inbox_subject", :text=>subject)
    subject_div.parent.parent.parent.link(:title=>"Reply").click
    self.wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end

  alias read_message open_message
  
  # Message Preview methods...
  
  def preview_sender(subject)
    message_div(subject).div(:class=>"inbox_name").button.text
  end
  
  def preview_recipient(subject)
    message_div(subject).div(:class=>"inbox_name").span.text
  end
  
  def preview_date(subject)
    message_div(subject).div(:class=>"inbox_date").span.text
  end
  
  def preview_profile_pic(subject)
    message_div(subject).image(:class=>"person_icon").src
  end
  
  def preview_body(subject)
    message_div(subject).div(:class=>"inbox_excerpt").text
  end
  
  # The New Message page is controlled by the SendMessagePopUp module

  # Read/Reply Page Objects (defined with Watir)

  # Returns the text of the name of the sender of the message being viewed
  def message_sender
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_name").button(:class=>"s3d-regular-links s3d-link-button s3d-bold personinfo_trigger_click personinfo_trigger").text
  end
  
  def message_recipient
    active_div.div(:class, "inbox_name").span(:class=>"inbox_to_list").text
  end
  
  # Returns the date of the message being viewed (as a String object)
  def message_date
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_date").span.text
  end

  # Returns the text of the message subject
  def message_subject
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_subject").link.text
  end
  
  # Returns the text of the message body.
  def message_body
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_excerpt").text
  end

  def delete_selected_element
    active_div.button(:id=>"inbox_delete_selected")
  end
  
  def delete_selected
    delete_selected_element.click
    self.wait_for_ajax
  end
  
  def mark_as_read_element
    active_div.button(:id=>"inbox_mark_as_read")
  end
  
  def mark_as_read
    mark_as_read_element.click
    sleep 0.3
    self.wait_for_ajax
  end

  def select_message(subject)
    subject_div = active_div.div(:class=>"inbox_subject", :text=>subject)
    subject_div.parent.parent.parent.checkbox.set
  end

  # Returns "read" or "unread", based on the relevant div's class setting.
  def message_status(subject)
    classname = self.div(:class=>/^inbox_item fl-container fl-fix/, :text=>/#{Regexp.escape(subject)}/).class_name
    if classname =~ /unread/
      return "unread"
    else
      return "read"
    end
  end

  # Counts the number of displayed messages on the current page.
  # Returns a hash containing counts for read and unread messages on the page.
  # Keys in the hash are :all, :read, and :unread.
  def message_counts
    hash = {}
    total = active_div.divs(:class=>"inbox_items_inner").length
    unread = active_div.divs(:class=>/unread/).length
    read = total - unread
    hash.store(:total, total)
    hash.store(:unread, unread)
    hash.store(:read, read)
    return hash
  end

  # Search
  def search_field_element
    active_div.text_field(:id=>"inbox_search_messages")
  end
  
  def search_messages=(text)
    search_field_element.set(text+"\n")
    self.wait_for_ajax
    sleep 0.3
  end
  
  def search_button_element
    active_div.button(:class=>"s3d-button s3d-overlay-button s3d-search-button")
  end
  
  def search_messages
    search_button_element.click
    self.wait_for_ajax
  end
  
  # Private Methods in this class
  private
  
  # determines which sub page is currently active,
  # so that all the other methods in the class will work
  # properly. 
  def active_div
    container_div = self.div(:id=>"s3d-page-container")
    id = "x"
    mail_divs = container_div.divs(:id=>"inbox_widget")
    if mail_divs.length == 1
      id = mail_divs[0].id
    else
      mail_divs.each do |div|
        if div.visible?
          id = div.parent.parent.parent.id
          break
        end
      end
    end
    if id == "x"
      puts "==========================="
      puts "Couldn't find the visible inbox widget div, so didn't get a valid ID"
      puts "==========================="
    end
    return self.div(:id=>id)
  end
  
  def message_div(subject)
    active_div.div(:class=>"inbox_subject",:text=>subject).parent.parent
  end
  
end

#
class MyProfileBasicInfo
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  # Basic Information
  text_field(:given_name, :name=>"firstName")
  text_field(:family_name, :id=>"lastName")
  text_field(:preferred_name, :id=>"preferredName")
  text_area(:tags, :name=>"tags")

  def list_categories
    self.button(:text=>"List categories").click
    wait_for_ajax(2)
    self.class.class_eval { include AddRemoveCategories }
  end

  def update
    self.form(:id=>"displayprofilesection_form_basic").button(:text=>"Update").click
    wait_for_ajax(2)
    #self.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileAboutMe

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  text_area(:about_Me, :id=>"aboutme")
  text_area(:academic_interests, :id=>"academicinterests")
  text_area(:personal_interests, :id=>"personalinterests")
  
  def update
    self.form(:id=>"displayprofilesection_form_aboutme").button(:text=>"Update").click
    wait_for_ajax(2)
    #self.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileOnline
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  button(:add_another_online, :text=>"Add another Online", :id=>"displayprofilesection_add_online")
  
  text_field(:site, :id=>/siteOnline_\d+/, :index=>-1)
  text_field(:url, :id=>/urlOnline_\d+/, :index=>-1)
  
  def update
    self.form(:id=>"displayprofilesection_form_online").button(:text=>"Update").click
  end
  
  # Returns a hash object, where the keys are the site names and the
  # values are the urls.
  def sites_list
    hash = {}
    self.div(:id=>"profilesection_generalinfo").divs.each do |div|
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
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  # Page Objects
  #button(:add_another, :text=>"Add another", :id=>/profilesection_add_link_\d/)
  text_field(:institution, :name=>"college", :index=>1)
  text_field(:department, :name=>"department", :index=>1) 
  text_field(:title_role, :name=>"role")
  text_field(:role, :name=>"role")
  text_field(:email, :name=>"emailContact")
  text_field(:instant_messaging, :name=>"imContact") 
  text_field(:phone, :name=>"phoneContact") 
  text_field(:mobile, :name=>"mobileContact") 
  text_field(:fax, :name=>"faxContact") 
  text_field(:address, :name=>"addressContact") 
  text_field(:city, :id=>"cityContact") 
  text_field(:state, :name=>"stateContact")
  text_field(:postal_code, :name=>"postalContact") 
  text_field(:country, :name=>"countryContact")
  
  # Custom Methods
  
  def update
    self.form(:id=>"displayprofilesection_form_contact").button(:text=>"Update").click
    wait_for_ajax(2)
  end
  
  # Takes a hash object and uses it to fill out
  # the fields on the form. The necessary key values in the
  # hash argument are as follows:
  # :institution, :department, :title, :email, :im, :phone,
  # :mobile, :fax, :address, :city, :state, :zip, and :country.
  # Any keys that are different or missing will be ignored.
  def fill_out_form(hash)
    self.institution=hash[:institution]
    self.department=hash[:department]
    self.title_role=hash[:title]
    self.email=hash[:email]
    self.instant_messaging=hash[:im]
    self.phone=hash[:phone]
    self.mobile=hash[:mobile]
    self.fax=hash[:fax]
    self.address=hash[:address]
    self.city=hash[:city]
    self.state=hash[:state]
    self.postal_code=hash[:zip]
    self.country=hash[:country]
  end
  
end

# Publications
class MyProfilePublications
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  # Page Objects
  
  button(:add_another_publication, :text=>"Add another publication", :id=>"displayprofilesection_add_publications")
  text_field(:main_title, :id=>/maintitle_\d+/, :index=>-1)
  text_field(:main_author, :name=>/mainauthor_\d+/, :index=>-1)
  text_field(:co_authors, :id=>/coauthor_\d+/, :index=>-1)
  text_field(:publisher, :id=>/publisher_\d+/, :index=>-1)
  text_field(:place_of_publication, :id=>/placeofpublication_\d+/, :index=>-1)
  text_field(:volume_title, :id=>/volumetitle_\d+/, :index=>-1)
  text_field(:volume_information, :id=>/volumeinformation_\d+/, :index=>-1)
  text_field(:year, :id=>/year_\d+/, :index=>-1)
  text_field(:number, :id=>/number_\d+/, :index=>-1)
  text_field(:series_title, :id=>/series.title_\d+/, :index=>-1)
  text_field(:url, :id=>/url_\d+/, :index=>-1)
  
  # Custom Methods...
  
  #
  def update
    self.form(:id=>"displayprofilesection_form_publications").button(:text=>"Update").click
    wait_for_ajax(2)
  end
  
  # Takes a hash object and uses it to fill
  # in all the publication fields. The key values
  # that the has must contain are as follows:
  # :main_title, :main_author, :co_authors, :publisher,
  # :place, :volume_title, :volume_info, :year, :number,
  # :series, :url.
  # Any missing or misspelled key values will be ignored.
  def fill_out_form(hash)
    self.main_title=hash[:main_title]
    self.main_author=hash[:main_author]
    self.co_authors=hash[:co_authors]
    self.publisher=hash[:publisher]
    self.place_of_publication=hash[:place]
    self.volume_title=hash[:volume_title]
    self.volume_information=hash[:volume_info]
    self.year=hash[:year]
    self.number=hash[:number]
    self.series_title=hash[:series]
    self.url=hash[:url]
  end
  
end

#
class MyLibrary
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include ListWidget
  include LeftMenuBarYou

  # Page Objects
  div(:empty_library, :id=>"mylibrary_empty") # It's likely that this doesn't work

  # Custom Methods and Page Objects...
  
  def page_title
    active_div.div(:class=>"s3d-contentpage-title").text
  end

  private
  
  def active_div
    id = self.div(:id=>/mylibrarycontainer/).parent.id
    return self.div(:id=>id)
  end
  
end

#
class MyMemberships

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include ListWidget
  include ListGroups
  include LeftMenuBarYou

  # Page Objects
  # none yet...
  
  # Custom methods...

  def page_title
    active_div.div(:class=>"s3d-contentpage-title").text
  end

  private
  
  def active_div
    id = self.div(:id=>/mymembershipscontainer/).parent.id
    return self.div(:id=>id)
  end


end

# Page Objects and Custom Methods for the My Contacts page.
class MyContacts

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include ListWidget
  include ListPeople
  include LeftMenuBarYou

  # Page Objects
  navigating_link(:find_and_add_people, "Find and add people", "ExplorePeople")

  # Page Objects defined with Watir-webdriver...
  
  # The text of the Page Title. It should usually return "My contacts".
  def page_title
    active_div.div(:class=>"s3d-contentpage-title").text
  end
  
  # This returns the the "contacts_invited" page div
  # (as a Watir page object). This can be used to validate
  # that there are pending invites on the page. Primarily, however, it's used
  # by other methods in this class--to differentiate the pending list
  # from the contacts list.
  def pending_contacts
    active_div.div(:id=>"contacts_invited")
  end
  
  # Custom Methods...
  
  # Returns the list of names of people requesting
  # contact
  def pending_invites
    list = []
    pending_contacts.links(:class=>"s3d-bold s3d-regular-light-links", :title=>/View/).each { |link| list << link.text }
    return list
  end
  
  # Clicks the "accept connection" plus sign for the specified
  # person in the Pending contacts list
  def accept_connection(name)
    self.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"Accept connection").click
    sleep 0.8
    wait_for_ajax(2)
  end
  
  def find_more_people
    active_div.link(:text=>"Find more people").click
    ExplorePeople.new @browser
  end
  
  # Private methods...
  
  private
  
  # The top div for the contents of the page.
  # This method is a helper method for other objects
  # defined on the page.
  def active_div
    self.div(:id=>/^contactscontainer\d+/)
  end
  
end


#
class ViewPerson
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  # Page Objects
  navigating_link(:basic_information, "Basic Information", "ViewPerson")
  navigating_link(:categories, "Categories", "ViewPerson")
  navigating_link(:about_me, "About Me", "ViewPerson")
  navigating_link(:online, "Online", "ViewPerson")
  navigating_link(:contact_information, "Contact Information", "ViewPerson")
  navigating_link(:publications, "Publications", "ViewPerson")
  div(:contact_name, :id=>"entity_name")
  button(:message_button, :id=>"entity_user_message")
  button(:add_to_contacts_button, :id=>"entity_user_add_to_contacts")
  button(:invitation_sent_button, :text=>"Contact invitation sent")
  button(:accept_invitation_button, :id=>"entity_user_accept_invitation")
  
  # Custom Methods...
  
  def accept_invitation
    accept_invitation_button
    wait_for_ajax(2)
  end
  
  def message
    message_button
    self.wait_until { self.text.include? "Send this message to:" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  def add_to_contacts
    add_to_contacts_button
    self.wait_until { @browser.text.include? "Add a personal note to the invitation:" }
    self.class.class_eval { include AddToContactsPopUp }
  end
  
  # Clicks the link to open the user's library profile page.
  def users_library
    self.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Library/).click
    sleep 2
    wait_for_ajax(2)
    self.class.class_eval { include ListWidget
                            include LibraryWidget }
  end
  
  # I believe this is not supported by rSmart's OAE preview
  #def users_memberships
  #  @browser.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Memberships/).click
  #  self.class.class_eval { include ListWidget }
  #end
  
  # Opens the user's Contacts page to display their contacts
  def users_contacts
    self.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Contacts/).click
    self.class.class_eval { include ListWidget }
  end
  
  # This method assumes the current page is the Basic Info page.
  # It returns a hash object where the key => value pair is:
  # "Field Title" => "Field Value" --e.g.: "Given name:"=>"Billy"
  def basic_info_data
    hash = {}
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Basic Information").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.divs(:class=>"displayprofilesection_field").each { |div| hash.store(div.span(:class=>"s3d-input-label").text, div.span(:class=>"field_value").text) }
    return hash
  end
  
  # Returns an array containing the text of all of the tags and categories
  # listed on the Basic Information page.
  def tags_and_categories_list
    list = []
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Basic Information").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.links.each { |link| list << link.text }
    return list
  end
  
  # This method assumes it will be run on the About Me page.
  # It returns a hash object where the key => value pair is:
  # "Field Title" => "Field Value" --e.g.: "About Me:"=>"Text of field"
  def about_me_data
    hash = {}
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"About Me").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.divs(:class=>"displayprofilesection_field").each { |div| hash.store(div.span(:class=>"s3d-input-label").text, div.span(:class=>"field_value").text) }
    return hash
  end
  
  # Returns a hash object where the key=>value pair is determined by the
  # field title and field values shown on the "Online" page.
  #
  # Because there can be an arbitrary number of Sites listed on the page,
  # The hash keys will have a number appended on the end. Example:
  # { "Site:1"=>"Twitter", "URL:1"=>"www.twitter.com","Site:2"=>"Facebook","URL:2"=>"www.facebook.com"}
  def online_data
    hash = {}
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Online").parent.parent.div(:id=>"displayprofilesection_body")
    x=0
    target_div.divs(:class=>"displayprofilesection_field").each do |div|
      div.span(:class=>"s3d-input-label").text == "Site:" ? x+=1 : x
      hash.store("#{div.span(:class=>"s3d-input-label").text}#{x}", div.span(:class=>"field_value").text)
    end
    return hash
  end
  
  # Returns a hash object where the key=>value pair is determined by the
  # field title and field values shown on the "Contact Information" page.
  #
  # Example: "Institution:"=>"University of Hard Knocks"
  def contact_info_data
    hash = {}
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Contact Information").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.divs(:class=>"displayprofilesection_field").each { |div| hash.store(div.span(:class=>"s3d-input-label").text, div.span(:class=>"field_value").text) }
    return hash
  end
  
  # Takes a hash object containing the test contact info (see required format below),
  # evaluates that data against the data returned with the contact_info_data
  # method and returns true if the data match, and false, if they do not.
  #
  # The hash object passed to the method must contain the following keys, exactly:
  # :institution, :department, :title, :email, :im, :phone, :mobile, :fax,
  # :address, :city, :state, :zip, :country
  def expected_contact_info?(hash)
    info = self.contact_info_data
    key_map = {"Institution:"=>:institution, "Department:"=>:department, "Title/Role:"=>:title,
      "Email:"=>:email, "Instant Messaging:"=>:im, "Phone:"=>:phone, "Mobile:"=>:mobile, "Fax:"=>:fax,
      "Address:"=>:address, "City:"=>:city, "State:"=>:state, "Postal Code:"=>:zip, "Country:"=>:country}
    fixed = Hash[info.map { |k, v| [key_map[k], v ] } ]
    fixed==hash ? true : false
  end
  
  # Returns an array of hashes. Each hash in the array refers to one of
  # the listed publications.
  #
  # Each hash's key=>value pairs are determined by the field title and field values for the publications.
  #
  # Example: "Main title:"=>"War and Peace","Main author:"=>"Tolstoy", etc....
  def publications_data
    list = []
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Publications").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.divs(:id=>"displayprofilesection_sections_publications").each do |div|
      hash = {}
      div.divs(:class=>"displayprofilesection_field").each { |subdiv| hash.store(subdiv.span(:class=>"s3d-input-label").text, subdiv.span(:class=>"field_value").text) }
      list << hash
    end
    return list
  end
  
  # Expects to be passed an array containing one or more hashes (see below for
  # how the hash should be formed). Note that it's okay to send a single hash instead
  # of an array containing one hash element. The method will do the
  # necessary cleaning of the data.
  #
  # The method returns true if the contents of the hash(es) match the data evaluated against,
  # otherwise returns false.
  # The hash(es) should contain all of the following keys...
  # :main_title, main_author, :co_authors, :publisher, :place, :volume_title,
  # :volume_info, :year, :number, :series, :url
  def expected_publications_data?(array_of_hash)
    expected_data=[]
    expected_data << array_of_hash
    expected_data.flatten!
    data_array = self.publications_data
    new_array = []
    key_map = { "Main title:"=>:main_title, "Main author:"=>:main_author,
    "Co-author(s):"=>:co_authors, "Publisher:"=>:publisher, "Place of publication:"=>:place,
    "Volume title:"=>:volume_title, "Volume information:"=>:volume_info,
    "Year:"=>:year, "Number:"=>:number, "Series title:"=>:series, "URL:"=>:url }
    data_array.each do |hash|
      fixed = Hash[hash.map { |k, v| [key_map[k], v ] } ]
      new_array << fixed
    end
    expected_data==new_array ? true : false
  end
  
end

#
class MyPreferences

  include PageObject
  include GlobalMethods

end


# Library pages in Courses/Groups/Research
class Library
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include HeaderBar
  include LeftMenuBar
  include LibraryWidget
  include ListWidget
  include ListContent
  
  def empty_library_element
    self.div(:id=>data_sakai_ref).div(:id=>"mylibrary_empty")
  end
  
end

# 
class Participants
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar

  text_field(:search_participants, :id=>"participants_search_field")
  
end

# Methods related to the Discussions "Area" in a Group/Course.
class Discussions
  
  include PageObject
  include GlobalMethods
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
    self.button(:id=>"discussion_add_topic").click
    wait_for_ajax(2) #
    #@browser.wait_until { @browser.h1(:class=>"discussion_topic_subject").parent.button(:text=>"Reply").present? }
  end
  
  button(:collapse_all, :text=>"Collapse all")
  button(:expand_all, :text=>"Expand all")
  button(:dont_add_reply, :id=>"discussion_dont_add_reply")
  button(:add_reply, :id=>"discussion_add_reply")
  
  # Clicks the "Reply" button for the specified message.
  def reply_to(message_title)
    self.h1(:class=>"discussion_topic_subject", :text=>message_title).parent.button(:text=>"Reply").click
    self.wait_until { self.h1(:class=>"discussion_topic_subject", :text=>message_title).parent.text_field(:id=>"discussion_topic_reply_text").present? }
  end
  
  # Clicks the "Quote" button for the specified message.
  def quote(message_text)
    self.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Quote").fire_event "onclick"
    wait_for_ajax(2) #
    #self.wait_until { self.textarea(:name=>"quoted_text", :text=>message_text).present? }
  end
  
  # Clicks the "Edit" button for the specified message.
  def edit(message_text)
    self.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Edit").click
    self.wait_until { self.textarea(:name=>"discussion_topic_reply_text", :text=>message_text).present? }
  end
  
  # Clicks the "Delete" button for a specified message.
  def delete(message_text)
    self.span(:class=>"discussion_post_message", :text=>message_text).parent.parent.button(:text=>"Delete").click
  end
  
  button(:restore, :text=>"Restore")

  # Clicks the button that expands the thread to view the replies.
  def view_replies(topic_title)
    self.h1(:class=>"discussion_topic_subject", :text=>topic_title).parent.button(:class=>"discussion_show_topic_replies s3d-button s3d-link-button").click
    
  end
  
  # Clicks the button that collapses an expanded message thread.
  def hide_replies(topic_title)
    self.h1(:class=>"discussion_topic_subject", :text=>topic_title).parent.button(:class=>"discussion_show_topic_replies s3d-button s3d-link-button").click
    
  end
  
end

# Methods related to the Comments "Area" in a Course/Group.
class Comments
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  button(:add_comment, :text=>"Add comment")
  button(:cancel, :id=>/comments_editComment_cancel/)
  text_area(:comment, :id=>"comments_txtMessage")
  text_area(:new_comment, :id=>/comments_editComment_txt_/)
  button(:undelete, :text=>"Undelete")
  
  # Clicks the "Submit comment" button.
  def submit_comment
    self.button(:text=>"Submit comment").click
    wait_for_ajax(2) #wait_until { self.text.include? "about 0 seconds ago" }
  end
  
  # Clicks the "Edit comment" button.
  def edit_comment
    self.button(:text=>"Edit comment").click
    wait_for_ajax(2) #wait_until { self.textarea(:title=>"Edit your comment").present? == false }
  end

  # Clicks the "Edit button" for the specified comment.
  def edit(comment)
    comment.gsub!("\n", " ")
    self.p(:text=>comment).parent.parent.button(:text=>"Edit").click
    wait_for_ajax(2) #wait_until { self.textarea(:title=>"Edit your comment").present? }
  end
  
  # Deletes the specified comment.
  def delete(comment)
    comment.gsub!("\n", " ")
    self.div(:text=>comment).parent.button(:text=>"Delete").click
    wait_for_ajax(2) #wait_until { self.button(:text=>"Undelete").present? }
  end
  
end

#
class JISC
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def jisc_frame
    self.frame(:title=>"JISC content")
  end
  
  in_frame(:title=>"JISC content") do |f|
    select_list(:choose_a_category, :id=>"themes", :frame=>f)
  end
  
end

#
class RSS
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  button(:sort_by_source, :text=>"Sort by source")
  button(:sort_by_date, :text=>"Sort by date")
  
  
end


#
class Tests
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def tests_frame
    self.frame(:src=>/sakai2samigo.launch.html/)
  end
  
end


#
class Files
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  # Edits the page, then opens the File Settings pop up.
  def files_settings
    widget_settings
    self.text_field(:class=>"as-input").when_present { self.class.class_eval { include FilesAndDocsPopUp } }
  end
  
  def remove_files_widget
    remove_widget
  end
  
  def files_wrapping
    widget_wrapping
  end
  
end

#
class Gadget
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def gadget_frame
    self.frame(:id=>"ggadget_remotecontent_settings_preview_frame")
  end
  
  
  
end

#
class Gradebook
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def gradebook_frame
    self.frame(:src=>/sakai2gradebook.launch.html/)
  end
  
end

#
class LTI
  
  include PageObject
  include GlobalMethods
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
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  # Defines the Google Maps image as an object.
  # Use this for verifying the presence of any text it's supposed to
  # contain (like the specified address it's supposed to be showing).
  def map_frame
    self.frame(:id, "googlemaps_iframe_map")
  end
  
  # Edits the page, then opens the Google Maps widget's Settings Dialog.
  def map_settings
    widget_settings
    self.text_field(:id=>"googlemaps_input_text_location").when_present { self.class.class_eval { include GoogleMapsPopUp } }
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
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  select_list(:year, :id=>"inlinecontent_settings_option1")
  select_list(:paper, :id=>"inlinecontent_settings_option2")
  button(:save, :id=>"inlinecontent_settings_insert")
  button(:cancel, :id=>"inlinecontent_settings_cancel")
  
end

#
class Remote
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def remote_frame
    self.frame(:id=>"remotecontent_settings_preview_frame")
  end
  
  
  
end

#
class ResearchIntro
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end


#
class Acknowledgements
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  
  # Page Objects
  div(:page_title, :class=>"s3d-bold entity_plaintitle")
  link(:featured, :text=>"Featured")
  link(:ui_technologies, :text=>"UI Technologies")
  link(:back_end_technologies, :text=>"Back-end Technologies")
  
  # Custom Methods
  
end

#
class FourOhFourPage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end

#
class FourOhThreePage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end

#
class FourOhFourPage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end