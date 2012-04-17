#!/usr/bin/env ruby
# coding: UTF-8

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
  link(:user_options_name, :id=>"topnavigation_user_options_name")
  link(:help, :id=>"help_tab")

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
    self.wait_for_ajax
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
    self.wait_for_ajax
    AllCategoriesPage.new @browser
  end

  # Clicks the Acknowledgements link in the page Footer.
  def acknowledgements
    self.acknowledgements_link
    sleep 1
    self.wait_for_ajax
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
    self.wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end

  # Clicks the language button in the page footer.
  def change_language
    self.language_button
    self.wait_for_ajax
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
    self.wait_for_ajax
  end

  # Opens the User Options menu in the header menu bar,
  # clicks the Preferences item, waits for the Account Preferences
  # Pop up dialog to appear, and then includes the AccountPreferencesPopUp
  # module in the currently instantiated Class Object.
  def my_account
    self.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    self.link(:id=>"subnavigation_preferences_link").click
    self.wait_for_ajax
    self.class.class_eval { include AccountPreferencesPopUp }
  end

  # Clicks the Sign out command in the user menu in the header bar.
  # returns the LoginPage class object.
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
    self.wait_until { self.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end

  def add_collection

  end

  # Clicks the Colector icon in the header bar, to either display
  # or hide the collector widget, depending on its current state.
  def toggle_collector
    self.collector
    self.wait_for_ajax
    self.class.class_eval { include CollectorWidget }
  end

  # Clicks the messages container button
  def messages_container
    self.messages_container_button
    self.wait_for_ajax
    self.class.class_eval { include MessagesContainerPopUp }
  end

  # Clicks the "Sign up" link. Returns the CreateNewAccount class object
  def sign_up
    self.sign_up_link
    self.button(:id=>"save_account").wait_until_present
    self.wait_for_ajax
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

  # Clicks the "Join group" button.
  def join_group
    self.join_group_button
    self.wait_until { notification_element.exists? }
  end

  # Clicks the "Request to join group" button
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
    self.wait_for_ajax
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
  # It expands the menu to display the document's sub-pages.
  def expand(name)
    self.div(:id=>"lhnavigation_container").link(:text=>name).click
  end

  # Changes the title of the specified page ("from_string")
  # to the string value specified by to_string.
  def change_title_of(from_string, to_string)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).hover
    self.wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    self.wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhavigation_submenu_edittitle").click
    self.link(:class=>/lhnavigation_page_title_value/, :text=>from_string).parent.text_field(:class=>"lhnavigation_change_title").set("#{to_string}\n")
  end

  alias change_title change_title_of

  # Deletes the page specified by page_name.
  def delete_page(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    self.wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'300px', top:'300px', display: 'block'})")
    self.wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhavigation_submenu_deletepage").click
    self.wait_for_ajax
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
    self.wait_for_ajax
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
    self.wait_for_ajax #.wait_until { self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible? }
    self.div(:class=>"lhnavigation_selected_submenu_image").hover
    self.execute_script("$('#lhnavigation_submenu').css({left:'328px', top:'349px', display: 'block'})")
    self.wait_for_ajax #.wait_until { self.link(:id=>"lhavigation_submenu_edittitle").visible? }
    self.link(:id=>"lhnavigation_submenu_profile").click
    self.wait_for_ajax #.button(:title=>"Show debug info").wait_until_present
    self.window(:title=>"rSmart | Content Profile").use
    ContentDetailsPage.new self
  end

  alias view_profile_for_page view_profile_of_page
  alias view_page_profile view_profile_of_page

  # Clicks the "Add a new area" button.
  def add_new_area
    self.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").click
    self.wait_for_ajax
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

  # Returns true if the specified page name appears in the list of items in the
  # Left menu bar. Returns false if the specified menu can't be found.
  # TODO - should be re-written to work more like the typical Ruby
  # question-mark method: Should be applied to the string being tested, not the
  # browser object.
  def menu_available?(page_name)
    self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    if self.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).parent.div(:class=>"lhnavigation_selected_submenu_image").visible?
      return true
    else
      return false
    end
  end

  # Private methods...
  private

  def data_sakai_ref
    hash = {}
    current_id=""
    self.div(:id=>"lhnavigation_container").lis.each do |li|
      hash.store(li.text, li.html[/(?<=data-sakai-ref=").+-id\d+/])
    end
    hash.delete_if { |key, value| key == "" }
    hash.each do |key, value|
      next if self.div(:id=>value).exist? == false
      next if self.div(:id=>value).visible? == false
      if self.div(:id=>value).visible?
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

  # Clicks the Inbox link in the left-hand menu. Waits for the new page to
  # load.
  def inbox
    self.inbox_link
    sleep 1
    self.wait_for_ajax
  end

  # Clicks the Invitations link in the left-hand menu. Waits for the new page to
  # load.
  def invitations
    self.invitations_link
    sleep 1
    self.wait_for_ajax
  end

  # Clicks the Sent link in the left-hand menu. Waits for the new page to
  # load.
  def sent
    self.sent_link
    sleep 1
    self.wait_for_ajax
  end

  # Clicks the Trash link in the left-hand menu. Waits for the new page to
  # load.
  def trash
    self.trash_link
    sleep 1
    self.wait_for_ajax
  end

  # The div for the "Lock icon" next to the My messages menu
  def my_messages_lock_icon
    self.div(:text=>"My Messages").div(:class=>"lhnavigation_private")
  end

  # Expands/Collapses the My Messages Tree
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

  # Returns the number displayed in the left menu for the total
  # unread messages. If there is no number displayed there, this
  # method will return a zero. Note that the number returned is
  # an Integer and not a String.
  def unread_message_count
    count_div = self.div(:text=>/My Messages/, :class=>"lhnavigation_item_content").div(:class=>"lhnavigation_levelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end

  # Returns the number displayed in the left menu for the Inbox's
  # unread messages. If there is no number displayed there, this
  # method will return a zero. Note that the number returned is
  # an Integer and not a String.
  def unread_inbox_count
    count_div = self.div(:text=>/Inbox/, :class=>"lhnavigation_subnav_item_content").div(:class=>"lhnavigation_sublevelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end

  # Returns the number displayed in the left menu for the Invitation's
  # unread messages. If there is no number displayed there, this
  # method will return a zero. Note that the number returned is
  # an Integer and not a String.
  def unread_invitations_count
    count_div = self.div(:text=>/Invitations/, :class=>"lhnavigation_subnav_item_content").div(:class=>"lhnavigation_sublevelcount")
    if count_div.present?
      count_div.text.to_i
    else
      0
    end
  end

  def my_library_count
    count_div = name_link("My library").parent.div(:class=>"lhnavigation_levelcount")
    count_div.present? ? count_div.text.to_i : 0
  end

  def my_contacts_count
    count_div = self.div()
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
    self.wait_for_ajax
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
    self.wait_for_ajax
    self.class.class_eval { include DocumentWidget }
  end

  # Clicks the Add Page button, then enters the text string
  # into the page title field, followed by a line feed.
  def add_page(text)
    self.back_to_top
    add_page_button
    self.wait_for_ajax
    self.send_keys text + "\n"
  end

  # Clicks the Page Revisions button.
  def page_revisions
    self.back_to_top
    page_revisions_button
    self.wait_for_ajax

  end

  # Private methods...
  private

  # The generic method for editing widget settings. DO NOT USE!
  def widget_settings
    # jQuery
    click_settings=%|$("#context_settings").trigger("mousedown");|

    # watir-webdriver
    edit_page
    open_widget_menu
    self.execute_script(click_settings)
    self.wait_for_ajax
  end

  # The generic method for removing widgets. DO NOT USE!
  def remove_widget
    # JQuery
    jq_remove = %|$("#context_remove").trigger("mousedown");|

    # watir-webdriver
    self.edit_page
    self.open_widget_menu
    self.execute_script(jq_remove)
    self.wait_for_ajax
  end

  # The generic method for editing widget wrappings. DO NOT USE!
  def widget_wrapping

    #jQuery
    jq_wrapping = %|$("#context_appearance_trigger").trigger("mousedown");|

    #watir-webdriver
    edit_page
    open_widget_menu
    self.execute_script(jq_wrapping)
    self.wait_for_ajax
    self.class.class_eval { include AppearancePopUp }
  end

  # The generic method for opening the widget menu. DO NOT USE!
  def open_widget_menu(number=0)
    # jQuery commands
    click_widget=%|tinyMCE.get("elm1").selection.select(tinyMCE.get("elm1").dom.select('.widget_inline')[#{number}]);|
    node_change=%|tinyMCE.get("elm1").nodeChanged();|

    # watir-webdriver
    self.wait_for_ajax
    self.execute_script(click_widget)
    self.wait_for_ajax
    self.execute_script(node_change)
    self.wait_for_ajax
  end

end
