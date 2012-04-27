# coding: UTF-8

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
      when self.div(:id=>"accountpreferences_preferContainer").visible?
        self.div(:id=>"accountpreferences_preferContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
      when self.div(:id=>"accountpreferences_changePrivacyContainer").visible?
        self.div(:id=>"accountpreferences_changePrivacyContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
      when self.div(:id=>"accountpreferences_changePassContainer").visible?
        self.div(:id=>"accountpreferences_changePassContainer").button(:class=>"s3d-link-button s3d-bold accountpreferences_cancel").click
      else
        puts "\nCouldn't find the cancel button!\n"
    end
  end

end # AccountPreferencesPopUp

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
    self.list_categories_button
    self.wait_for_ajax
    self.class.class_eval { include AddRemoveCategories }
  end

  # The "Search Everywhere" text field. Due to a strange bug with
  # Watir-webdriver and/or PageObject, we're using this method for the
  # definition of the field, so if you need to enter a text string into it
  # you'll need to use Watir-webdriver's ".set" method, like this:
  # page_object.search_everywhere.set "text string"
  def search_everywhere
    self.text_field(:id=>"addarea_existing_everywhere_search")
  end

  # Defines the Existing Document Name field based on the currently
  # selected tab. Test script steps will need to use Watir's .set method
  # for entering text strings into the fields.
  def existing_doc_name
    a = "addarea_existing_mylibrary_container"
    b = "addarea_existing_everywhere_container"
    c = "addarea_existing_currentlyviewing_container"
    case
      when self.div(:id=>a).visible?
        return self.div(:id=>a).text_field(:name=>"addarea_existing_name")
      when self.div(:id=>b).visible?
        return self.div(:id=>b).text_field(:name=>"addarea_existing_name")
      when self.div(:id=>c).visible?
        return self.div(:id=>c).text_field(:name=>"addarea_existing_name")
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
      when self.div(:id=>a).visible?
        return self.div(:id=>a).select(:name=>"addarea_existing_permissions")
      when self.div(:id=>b).visible?
        return self.div(:id=>b).select(:name=>"addarea_existing_permissions")
      when self.div(:id=>c).visible?
        return self.div(:id=>c).select(:name=>"addarea_existing_permissions")
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
    self.text_field(:id=>"addarea_contentlist_name")
  end

  # The permissions field for adding a Content List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.content_list_permissions.select "Option"
  def content_list_permissions
    self.select(:id=>"addarea_contentlist_permissions")
  end

  # The name field for adding a Participant List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.participants_list_name.set "Name"
  def participants_list_name
    self.text_field(:id=>"addarea_participants_name")
  end

  # The permissions field for adding a Participants List page. Use of this method
  # in a test script will require including a Watir method. For example,
  # if you want to send the field a text string, you'll use the .set
  # method, like this: page_object.participants_list_permissions.select "Option"
  def participants_list_permissions
    @browser.select(:id=>"addarea_participants_permissions")
  end

  # The text field for entering the widget name. When using this method directly,
  # be sure to remember that it will require Watir-webdriver methods, as well.
  # However, it should not be necessary to call this method directly, as it is
  # used as a helper for other methods in this class.
  def widget_name
    self.text_field(:id=>"addarea_widgets_name")
  end

  # The select list field for selecting the widget. When using this method directly,
  # be sure to remember that it will require Watir-webdriver methods, as well.
  # However, it should not be necessary to call this method directly, as it is
  # used as a helper for other methods in this class.
  def select_widget
    self.select(:id=>"addarea_widgets_widget")
  end

  # The select list for defining the widget permissions. When using this method directly,
  # be sure to remember that it will require Watir-webdriver methods, as well.
  # However, it should not be necessary to call this method directly, as it is
  # used as a helper for other methods in this class.
  def widget_permissions
    self.select(:id=>"addarea_widgets_permissions")
  end

  # Clicks the "Done, add" button in the Add Area flyout dialog, then
  # waits for the Ajax calls to drop to zero.
  def create
    self.done_add_button
    self.wait_for_ajax
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
    self.wait_for_ajax #
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

end  # AddAreasPopUp

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

  # Progress Indicator that appears while files are uploading
  div(:progress_indicator, :id=>"sakai_progressindicator")

  # Custom Methods...

  # Clicks the "Add" button that moves items into the
  # "Collected Items" list.
  def add
    active_content_div.button(:text=>"Add").click
    sleep 0.1
    self.wait_until { self.done_add_collected_button_element.enabled? }
  end

  # Works to enter text into any of the "Tags and Categories"
  # fields on the "Add Content" dialog.
  def tags_and_categories=(text)
    active_content_div.text_field(:id=>/as-input-\d+/).set("#{text}\n")
    self.wait_for_ajax
  end

  # Removes the item from the selected list.
  def remove(item)
    name_li(item).button(:title=>"Remove").click
    self.wait_for_ajax
  end

  # Enters the specified text in the Search field.
  # Note that the method appends a line feed on the string, so the search will
  # happen immediately when it is invoked.
  def search_for_content=(text)
    self.text_field(:class=>"newaddcontent_existingitems_search").set("#{text}\n")
  end

  # Checks the checkbox for the specified item.
  def check_content(item)
    name_li(item).wait_until_present
    name_li(item).checkbox.set
  end

  alias check_item check_content
  alias check_document check_content

  # Enters the specified filename in the file field.
  def upload_file=(file_name)
    self.file_field(:name=>"fileData").wait_until_present
    self.file_field(:name=>"fileData").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
  end

  # Clicks the "Done, add collected" button, then waits for
  # the page to refresh and any ajax calls to complete.
  def done_add_collected
    self.done_add_collected_button
    self.progress_indicator_element.wait_while_present
  end

  # Private methods...
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

end  # AddContentContainer

# Page Objects and Methods related to the Pop Up for Categories.
module AddRemoveCategories

  include PageObject

  # Page Objects

  button(:save_categories, :text=>"Assign and save")
  button(:dont_save, :text=>"Don't save")

  # Custom Methods...

  # Opens the specified category tree.
  def open_tree(text)
    self.link(:title=>text).parent.ins.fire_event("onclick")
  end

  # Checks the specified category.
  def check_category(text)
    if self.link(:title=>text).exists? == false
      puts "\nCategory...\n#{text}\n...not found in list!\n\nPlease check for typos in your test data.\n"
    end
    if self.link(:title=>text).visible? == false
      self.link(:title=>text).parent.parent.parent.ins.click
    end
    if self.link(:title=>text).parent.class_name =~ /jstree-unchecked/
      self.link(:title=>text).click
    end
    sleep 0.3
  end

  # Returns an array of the categories selected in the pop-up container.
  def selected_categories
    list = []
    self.div(:id=>"assignlocation_jstree_selected_container").lis.each do |li|
      list << li.text
    end
    return list
  end

end # AddRemoveCategories

# Page Objects and Methods related to the "Add widgets" pop-up on the Dashboard
module AddRemoveWidgets

  include PageObject

  # Clicks the Close button on the dialog for adding/removing widgets
  # to/from the Dashboard. Returns the MyDashboard class object.
  def close_add_widget
    self.div(:class=>"s3d-dialog-close jqmClose").fire_event("onclick")
    self.wait_for_ajax
    MyDashboard.new @browser
  end

  # Adds all widgets to the dashboard
  def add_all_widgets
    array = self.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "add" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Add").click
      self.wait_for_ajax
    end
    close_add_widget
  end

  # Removes all widgets from the dashboard
  def remove_all_widgets
    array = self.div(:id=>"add_goodies_body").lis.select { |li| li.class_name == "remove" }
    sub_array = array.select { |li| li.visible? }
    sub_array.each do |li|
      li.button(:text=>"Remove").click
      self.wait_for_ajax
    end
    close_add_widget
  end

  # Clicks the "Add" button for the specified widget
  def add_widget(name)
    self.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/).button.click
  end

  # Unchecks the checkbox for the specified widget.
  def remove_widget(name)
    self.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_remove_/).button.click
  end

end # AddRemoveWidgets

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

  # Clicks the Invite button then waits for ajax calls to
  # calm down.
  def invite
    self.invite_button
    sleep 0.5
    self.wait_for_ajax
  end

end # AddToContactsPopUp

#
module AddToGroupsPopUp

  include PageObject



end # AddToGroupsPopUp

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
    self.save_element.when_visible { self.save }
    self.wait_for_ajax
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
    self.wait_for_ajax
    self.div(:class=>"as-results").li(:id=>"as-result-item-0").fire_event "onclick"
    self.wait_for_ajax
  end

  # Clicks the "Save and close" button then waits for all ajax calls
  # to finish
  def save_and_close
    save_and_close_button
    self.wait_for_ajax
  end

  # Clicks the "Share" button and waits for the ajax calls to finish.
  def share
    self.button(:id=>"contentpermissions_members_autosuggest_sharebutton").flash
    self.button(:id=>"contentpermissions_members_autosuggest_sharebutton").click
    self.wait_for_ajax
  end

end

# Methods for the Pop-up dialog that appears when you want to remove
# content from Libraries.
module DeleteContentPopUp

  include PageObject

  button(:remove_from_library_button, :text=>"Remove from library")
  button(:delete_from_the_system_button, :text=>"Delete from the system")

  # Clicks the cancel button on the Pop-up and waits for the Ajax calls to finish
  def cancel
    begin
      self.div(:id=>"deletecontent_dialog").button(:text=>"Cancel").click
    rescue
      self.button(:text=>"Cancel").click
    end
    self.wait_for_ajax
  end
  alias cancel_deleting_content cancel

  # Clicks the 'Remove from library' button and
  # waits for the Ajax calls to complete.
  def remove_from_library
    self.remove_from_library_button
    self.remove_from_library_button_element.wait_while_present
    sleep 1.5
    self.wait_for_ajax
  end

  # Clicks the 'Delete from the system' button and waits for
  # The Ajax calls to complete.
  def delete_from_the_system
    self.delete_from_the_system_button
    sleep 2
    self.wait_for_ajax
  end

  # TODO - Define this method
  def remove_from_the_system_anyway

  end

  # TODO - Define this method
  def remove_from_this_library_only

  end

end

# Methods for the "Delete" Pop-up dialog.
module DeletePagePopUp

  include PageObject

  # Page Objects
  button(:delete_button, :id=>"lhnavigation_delete_confirm")
  button(:dont_delete_button, :class=>"s3d-link-button s3d-bold jqmClose")

  # Custom Methods

  # Clicks the Delete button, then waits for any ajax calls to finish.
  def delete
    self.delete_button
    self.wait_for_ajax
  end

  # Clicks the "Don't delete" button, then waits for any Ajax calls
  # to complete
  def dont_delete
    self.dont_delete_button
    self.wait_for_ajax
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

  # Clicks the "Don't add" button, then waits for any Ajax calls
  # to complete
  def dont_add
    self.dont_add_button
    self.wait_for_ajax
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

  # Clicks the "Search" button, then waits for 2.5 seconds.
  def search
    self.search_button
    sleep 2.5
  end

end

#
module InlineContentPopUp

  include PageObject

  # Page Objects

  # Custom Methods

end

#
module LeaveWorldPopUp

  include PageObject

  # Clicks the "Yes, Apply" button and waits for
  # Ajax calls to finish
  def yes_apply
    self.button(:id=>"mymemberships_delete_membership_confirm").click
    sleep 1.5
    self.linger_for_ajax(2)
  end

  # Clicks the "Cancel" button and waits for Ajax
  # calls to complete
  def cancel
    self.div(:id=>"mymemberships_delete_membership_dialog").button(:class=>"s3d-link-button s3d-bold jqmClose").click
    self.linger_for_ajax(1)
  end

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
    self.li(:text=>contact).checkbox(:class=>"addpeople_checkbox").set
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
        self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
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
    self.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.set
  end

  # Unchecks the remove checkbox for the specified contact
  def uncheck_remove_contact(contact)
    self.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.clear
  end

  # For the specified contact, updates to the specified role.fd
  def set_role_for(contact, role)
    self.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.select(:class=>"addpeople_selected_permissions").select(role)
  end

end

#
module OurAgreementPopUp

  include PageObject

  # Page Objects
  button(:no_button, :id=>"acceptterms_action_dont_accept")
  button(:yes_button, :id=>"acceptterms_action_accept")

  # Custom Methods

  # Clicks the "No, please log me out" button, then returns the
  # LoginPage class object.
  def no_please_log_me_out

  end

  # Clicks the "Yes, I accept" button, then returns the MyDashboard
  # class object.
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

  # Clicks the button to send a message to the owner.
  def message_owner
    self.button(:text=>"Message").click
    self.wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end

  # Clicks the button to add the owner to the user's contacts list
  def add_to_contacts
    self.button(:text=>"Add to contacts").click
    self.wait_for_ajax
    self.class.class_eval { include AddToContactsPopUp }
  end

  # Clicks the link to go to the owner's profile page. Returns the
  # ViewPerson class object.
  def view_owner_profile
    self.span(:id=>"personinfo_user_name").link.click
    sleep 2
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
    self.linger_for_ajax(3)
  end
  alias add_as_a_member add_as_member

  # Clicks the "ignore" button for the specified
  # user
  def ignore(name)
    self.div(:class=>"fl-force-left joinrequests_details",:text=>/#{Regexp.escape(name)}/).button(:text=>"Ignore").click
    self.linger_for_ajax(3)
  end

  def done
    self.done_button
    self.linger_for_ajax(3)
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

  # Clicks the "Apply permissions" button
  def apply_permissions
    self.apply_permissions_button
    sleep 0.3
    #wait_for_ajax(2)
  end

  # Clicks the "Cancel" button
  def cancel
    self.cancel_button
    self.linger_for_ajax(2)
  end

end

# Methods and objects for the Profile Permissions Pop Up--that appears when
# you select the Permissions item for the "My Profile" pages.
module ProfilePermissionsPopUp

  include PageObject

  select_list(:can_be_seen_by, :id=>"userpermissions_area_general_visibility")
  button(:apply_permissions_button, :id=>"userpermissions_apply_permissions")

  # Clicks the "Apply permissions" button
  def apply_permissions
    self.apply_permissions_button
    self.linger_for_ajax
  end

  # Clicks the "Cancel" button
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

  # Clicks the Remove contact button and waits for the Ajax calls
  # to complete.
  def remove_contact
    self.remove_contact_button
    sleep 0.5
    self.linger_for_ajax
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
  button(:add_button, :id=>"savecontent_save", :text=>"Add")  # Don't use this method for clicking the button. Use the method below.
  button(:cancel_button, :class=>"savecontent_close s3d-link-button s3d-bold") # Don't use this method for clicking the button. Use the method below.

  # Clicks the Add button and waits for Ajax calls to finish
  def add
    self.add_button
    self.linger_for_ajax
  end

  # Clicks the Cancel button and waits for Ajax calls to finish
  def cancel
    self.cancel_button
    self.linger_for_ajax
  end

end

# The Email message fields in My Messages and the pop up dialog
# that appears when in the Worlds context
# (or when you click the little envelop icon in lists of People).
module SendMessagePopUp

  include PageObject

  list_item(:no_results, :class=>"as-message")

  # The "See all" page element definition.
  def see_all_element
    current_div.link(:id=>"inbox_back_to_messages")
  end

  # Clicks the "See all" element on the page.
  def see_all
    see_all_element.click
  end

  # Removes the recipient from the To list for the email by
  # clicking on the item's "x" button.
  def remove_recipient(name)
    name_li(name).link(:text=>"×").click
  end

  # Returns an array containing the listed message recipients
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

  # The "Subject" text field page element definition.
  def subject_element
    current_div.text_field(:id=>"comp-subject")
  end

  # Enters the specified text string into the
  # "Subject" field
  def subject=(text)
    subject_element.set text
  end

  # The "Body" text area element for the message.
  def body_element
    current_div.textarea(:id=>"comp-body")
  end

  # Enters the specified text string into the Body
  # field.
  def body=(text)
    body_element.set text
  end

  # The "Send message" button element on the page.
  def send_message_element
    current_div.button(:id=>"send_message")
  end

  # Clicks the "Send message" button
  def send_message
    send_message_element.click
    self.wait_for_ajax
  end

  # Clicks the "Don't send" button
  def dont_send
    current_div.button(:id=>"send_message_cancel").click
    self.linger_for_ajax(2)
  end

  # Clicks the link for accepting a join request inside a Manager's join
  # request email
  def accept_join_request
    self.link(:text=>/=joinrequests/).click
    # currently this opens a page in a new tab. So it's best not to use it.
    # UGLY!!!
    # TODO - Refactor this ugly method. They may change the behavior so that a new tab isn't opened
  end

  # Private Methods
  private

  def current_div
    begin
      self.div(:id=>"sendmessage_dialog_box")
      #return active_div
    rescue
      begin
        return active_div
      rescue NoMethodError
        return self
      end
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

  # Clicks the "Apply settings" button and waits for Ajax calls to complete.
  def apply_settings
    self.apply_settings_button
    self.wait_for_ajax
  end

end

# Methods related to the Pop Up for Sharing Content with others.
module ShareWithPopUp

  include PageObject

  text_field(:share_with_field, :id=>/newsharecontentcontainer\d+/)

  # Clicks the arrow for adding a custom message to the share.
  def add_a_message
    self.span(:id=>"newsharecontent_message_arrow").fire_event('onclick')
  end

  text_area(:message_text, :id=>"newsharecontent_message")

  button(:share, :id=>"sharecontent_send_button")
  button(:cancel, :id=>"newsharecontent_cancel")

  # Enters the specified name value into the "Share with" field, a character
  # at a time, then waits for the search results to return the expected name.
  # When the name is found in the results list, it gets clicked on.
  def share_with=(name)

    name.split("", 5).each do |letter|
      self.share_with_field_element.focus
      self.share_with_field_element.send_keys(letter)
      self.wait_until { self.ul(:class=>"as-list").present? }
      if self.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).present?
        @browser.li(:text=>/#{Regexp.escape(name)}/, :id=>/as-result-item-\d+/).click
        break
      end
    end

  end

  # Gonna add the social network validations later

end
