#!/usr/bin/env ruby
# 
# == Synopsis
# 
# Sakai-OAE Page Object definitionstext_field(:name, :tag=>"identifier")

#
require 'page-object'
#require File.dirname(__FILE__) + "/app_functions.rb"

# ======================
# Modules and namespaces
# ======================

# The Topmost Header menu bar, present on most pages,
# plus the Footer contents, too.
module HeaderFooterBar
  
  include PageObject
  
  link(:help, :id=>"help_tab")
  float_menu(:my_dashboard, "You", "My Dashboard", "Add Widget", "MyDashboard")
  float_menu(:my_messages, "You", "My Messages", "Compose message", "MyMessages")
  float_menu(:my_profile, "You", "My Profile", "Given Name:", "MyProfileBasicInfo")
  float_menu(:my_library, "You", "My Library", "My Library", "MyLibrary")
  float_menu(:my_memberships, "You", "My Memberships", "My Memberships", "MyMemberships") 
  float_menu(:my_contacts, "You", "My Contacts", "My Contacts", "MyContacts")
  float_menu(:add_contacts, "Create + Add", "Add contacts", "Search", "AddContacts")  
  float_menu(:create_groups, "Create + Add", "Groups", "Create a Simple group", "CreateGroups")
  float_menu(:create_courses, "Create + Add", "Courses", "Create Courses", "CreateCourses")
  float_menu(:create_research, "Create + Add", "Research", "Create", "CreateResearch")  
  float_menu(:explore_all_categories, "Explore", "Browse all categories", "categories", "Explore")
  float_menu(:explore_content,"Explore","Content", "Sort by:", "Explore")
  float_menu(:explore_people,"Explore","People","Sort by:", "Explore")
  float_menu(:explore_groups,"Explore","Groups","Sort by:","Explore")
  float_menu(:explore_courses,"Explore","Courses","Sort by:","Explore")
  float_menu(:explore_research,"Explore","Research","Sort by:","Explore")
  
  def my_preferences
    @browser.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    @browser.link(:id=>"subnavigation_preferences_link").click
    @browser.wait_until { @browser.text.include? "Account preferences" }
    self.class.class_eval { include AccountPreferencesPopUp }
  end
  
  def add_content
    @browser.link(:title=>"Create + Add").fire_event("onmouseover")
    @browser.link(:title=>"Add content").click
    @browser.wait_until { @browser.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  # This button definition should work for all Cancel buttons, I hope...
  button(:cancel, :text=>"Cancel")
  
  # This button definition should work for all save buttons, I hope...
  button(:save, :text=>"Save")
  
  # Define global search later
  
  # Define footer items later
  
end

# This is the Header that appears in the Worlds context,
# So it appears for Courses, Groups, and Research
module HeaderBar
  
  include PageObject
  
  def message
    @browser.button(:text=>"Message").click
    @browser.wait_until { @browser.text.include? "Send Message" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  def add_content
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Add content").click
    @browser.wait_until { @browser.text.include? "Collected items" }
    self.class.class_eval { include AddContentContainer }
  end
  
  def manage_participants
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Manage participants").click
    @browser.wait_until { @browser.text.include? "My contacts and memberships" }
    self.class.class_eval { include ManageParticipants }
  end
  
  def settings
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Settings").click
    @browser.wait_until { @browser.text.include? "Apply Settings" }
    self.class.class_eval { include WorldSettings }
  end
  
  def categories
    @browser.button(:id=>"entity_group_permissions").click
    @browser.button(:text=>"Categories").click
    @browser.wait_until { @browser.text.include? "Assign a category" }
    self.class.class_eval { include AddRemoveCategories }
  end
  
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
    classname = case(type)
    when "document"
      @browser.button(:id=>"sakaidocs_editpage").wait_until_present
      return "GroupDocument"
    when "library"
      @browser.wait_until { @browser.div(:class=>"mylibrary_widget").visible? }
      return "GroupLibrary"
    when "participant"
      @browser.wait_until { @browser.div(:class=>"participants_widget").visible? }
      return "GroupParticipants"
    when "discussion"
      @browser.
      return ""
    when "remote"
      @browser.
      return ""
    when "inline"
      @browser.
      return ""
    when "tests"
      @browser.
      return ""
    when "calendar"
      @browser.
      return ""
    when "maps"
      @browser.
      return ""
    when "files"
      @browser.
      return ""
    when "comments"
      @browser.
      return ""
    when "jisc"
      @browser.
      return ""
    when "assignments"
      @browser.
      return ""
    when "rss"
      @browser.
      return ""
    when "lti"
      @browser.
      return ""
    when "gadget"
      @browser.
      return ""
    when "gradebook"
      @browser.
      return ""
    when "existing"
      @browser.wait_until { @browser.div(:class=>"sakaidocs_widget").visible? }
      return "GroupDocument"
    end
    eval(classname).new @browser
  end
  
  #
  def change_title_of(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.link(:id=>"lhavigation_submenu_edittitle").click
  end
  
  alias change_title change_title_of
  
  #
  def delete_page(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.link(:id=>"lhavigation_submenu_deletepage").click
  end
  
  #
  def permissions_for(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.link(:id=>"lhnavigation_submenu_permissions").click
    @browser.wait_until { @browser.text.include? "Area permissions for" }
    self.class.class_eval { include AreaPermissionsPopUp }
  end
  
  alias permissions_of permissions_for
  alias permissions permissions_for
  
  #
  def view_profile_of(page_name)
    @browser.link(:class=>/lhnavigation_page_title_value/, :text=>page_name).fire_event("onmouseover")
    @browser.link(:id=>"lhnavigation_submenu_profile").click
  end
  
  alias view_profile_for view_profile_of
  alias view_profile view_profile_of
  
  text_field(:new_title, :id=>"lhnavigation_change_title")
  
end

# The Left Menu Bar when in the context of the "You" pages
module YouPagesLeftMenu
  
  include PageObject
  
  navigating_link(:basic_information, "Basic Information", "Given Name:","MyProfileBasicInfo")
  navigating_link(:categories, "Categories", "Add or remove categories", "MyProfileCategories")
  navigating_link(:about_me, "About Me", "Academic Interests", "MyProfileAboutMe")
  navigating_link(:online, "Online", "Add another Online", "MyProfileOnline")
  navigating_link(:contact_information, "Contact Information", "Add another", "MyProfileContactInfo")
  navigating_link(:publications, "Publications", "Add another publication", "MyProfilePublications")
  
  permissions_menu(:about_me_permissions, "About Me")
  permissions_menu(:online_permissions, "Online")
  permissions_menu(:contact_information_permissions, "Contact Information")
  permissions_menu(:publications_permissions, "Publications")
  
  def change_picture
    @browser.div(:class=>"entity_profile_picture_down_arrow").fire_event("onclick")
    @browser.link(:id=>"changepic_container_trigger").click
    self.class.class_eval { include ChangePicturePopUp }
  end

end

# The left menu bar when creating Groups, Courses, or Research
module CreateWorldsLeftMenu
  
  include PageObject
  
  navigating_link(:group, "Group", "Create a simple group","CreateGroups")
  navigating_link(:course, "Course", "Add or remove categories", "MyProfileCategories")
  navigating_link(:research, "Research", "Academic Interests", "MyProfileAboutMe")
  
end

# Module for Left Menu items that are relevant to a Course or Group or Research
module WorldsLeftMenu
  
  include PageObject
  
  # Clicks the "Add a new area" button.
  def add_new_area
    @browser.button(:id=>"group_create_new_area").click
  end
  
  # Clicks the create button in the Add Area flyout dialog.
  def create
    @browser.button(:id=>"addarea_create_new_area").click
    @browser.button(:id=>"addarea_create_new_area").wait_while_present
  end
  
  alias add_a_new_area add_new_area
  
  # This method expects to be passed a hash object with
  # the following properties:
  # {:name=> "your name string", :visible=>"string to match the select list", :pages=>"number from 1 to 4" }
  # These values are then entered into the New Document page and the document is saved.
  def add_a_new_document(document)
    add_new_area
    click_sub_menu "New document"
    click_select
    @browser.text_field(:id=>"addarea_pages_page_name").set document[:name]
    @browser.select(:id=>"addarea_pages_permissions").select document[:visible]
    @browser.select(:id=>"addarea_pages_numberofpages").select document[:pages]
    create
  end
  
  # This method expects to be passed a hash object like this:
  # { :name=>"The name of the target document",
  #   :title=>"The placement title string",
  #   :visible=>"Who can see it" }
  def add_an_existing_document(document)
    add_new_area
    click_sub_menu "Existing document"
    click_select
    @browser.text_field(:id=>"addarea_sakaidoc_searchfield").set(document[:name] + "\n")
    sleep 0.2
    @browser.div(:id=>"addarea_sakaidoc_existingdocscontainer").li(:text=>/#{Regexp.escape(document[:name])}/).fire_event("onclick")
    @browser.text_field(:id=>"addarea_sakaidoc_page_name").set document[:title]
    @browser.select(:id=>"addarea_sakaidoc_permissions").select document[:visible]
    create
  end
  
  alias add_existing_document add_an_existing_document
  alias add_existing_doc add_an_existing_document
  
  def add_participant_list(list)
    add_new_area
    click_sub_menu "Participant list"
    click_select
    @browser.text_field(:id=>"addarea_participantlist_page_name").set list[:name]
    @browser.select(:id=>"addarea_participantlist_permissions").select list[:visible]
    create
  end
  
  alias add_a_participant_list add_participant_list
  
  def add_content_library(document)
    add_new_area
    click_sub_menu "Content library"
    click_select
    @browser.text_field(:id=>"addarea_contentlibrary_page_name").set document[:name]
    @browser.select(:id=>"addarea_contentlibrary_permissions").select document[:visible]
    create
  end
  
  alias add_a_content_library add_content_library
  
  def add_widget_page(document)
    add_new_area
    click_sub_menu "Widget page"
    click_select
    @browser.text_field(:id=>"addarea_widgetpage_page_name").set document[:name]
    @browser.select(:id=>"addarea_widgetpage_selectwidget").select document[:widget]
    @browser.select(:id=>"addarea_widgetpage_permissions").select document[:visible]
    create
  end
  
  alias add_widget add_widget_page
  alias add_a_widget add_widget_page
  alias add_a_widget_page add_widget_page
  
  def public_pages
    list = []
    @browser.ul(:id=>"lhnavigation_public_pages").lis.each do |li|
      list << li.link.text
    end
    return list
  end

  # =========================
  # =========================
  private
  
  def click_select
    begin
      @browser.button(:text=>"Select").wait_until_present(3)
      @browser.button(:text=>"Select").click
    rescue Watir::Wait::TimeoutError => error
      if @browser.image(:id=>"addarea_preview_image").visible?
        # we do nothing and move on
      else
        puts error
      end
    end
  end
  
  def click_sub_menu(item)
    @browser.li(:text=>item).fire_event("onclick")
  end
  
  # =========================
  # =========================

end

# Objects contained in the "Select your profile picture" pop-up dialog
module ChangePicturePopUp
  
  include PageObject
  
  def upload_a_new_picture(file_name)
    @browser.button(:text=>"Upload a new picture").wait_until_present
    @browser.button(:text=>"Upload a new picture").click
    @browser.file_field(:id=>"profilepicture").wait_until_present
    @browser.file_field(:id=>"profilepicture").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
    @browser.button(:id=>"profile_upload").click
    @browser.button(:id=>"save_new_selection").wait_until_present
  end
  
  def save_new_selection
    @browser.button(:id=>"save_new_selection").click
    @browser.button(:id=>"save_new_selection").wait_while_present
  end
  
end

# Objects in the Pop Up dialog for setting viewing permissions
module PermissionsPopUp
  
  include PageObject
  
  select_list(:can_be_seen_by, :id=>"userpermissions_area_general_visibility")
  
  navigating_button(:apply_permissions, "userpermissions_apply_permissions")
  
end

# The Permissions Pop Up dialog for World Area pages
module AreaPermissionsPopUp
  
  include PageObject
  
  select_list(:can_be_seen_by, :id=>"areapermissions_area_general_visibility")
  select_list(:selected_roles, :id=>"areapermissions_change_selected")
  button(:apply_permissions, :text=>"Apply permissions")
  checkbox(:all_roles, "areapermissions_check_uncheck_all")
  
  def check_student
    @browser.div(:text=>/Student/).checkbox.set
  end
  
  def check_teaching_assistant
    @browser.div(:text=>/Teaching Assistant/).checkbox.set
  end

  def check_lecturer
    @browser.div(:text=>/Lecturer/).checkbox.set
  end
  
  def student_permissions=(perm)
    @browser.div(:text=>/Student/).select(:class=>"areapermissions_role_select").select perm
  end
  
  def teaching_assistant_permissions=(perm)
    @browser.div(:text=>/Teaching Assistant/).select(:class=>"areapermissions_role_select").select perm
  end
  
  def lecturer_permissions=(perm)
    @browser.div(:text=>/Lecturer/).select(:class=>"areapermissions_role_select").select perm
  end
  
end

# The Email message pop up dialog that appears when in the Worlds context
# (or when you click the little envelop icon )
module SendMessagePopUp
  
  include PageObject
  
  text_field(:send_this_message_to, :id=>"sendmessage_to_autoSuggest")
  text_field(:subject, :id=>"comp-subject")
  text_area(:body, :id=>"comp-body")
  
  def remove_recipient(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).link(:text=>"x").click
  end
  
  button(:send_message, :id=>"send_message")
  button(:dont_send, :id=>"send_message_cancel")
  
end

#
module AccountPreferencesPopUp
  
  include PageObject
  
end

#
module JoinGroupPopUp
  
  include PageObject
  
  button(:join_group, :text=>"Join group")
  
end

# 
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
module SaveContentPopUp
  
  include PageObject
  
  select_list(:saving_to, :id=>"savecontent_select")
  button(:add, :text=>"Add")
  
end

#
module ShareWithPopUp
  
  include PageObject
  
  text_area(:share_with, :id=>/newsharecontentcontainer\d+/)
  
  def add_a_message
    @browser.span(:id=>"newsharecontent_message_arrow").fire_event('onclick')
  end
  
  text_area(:message_text, :id=>"newsharecontent_message")
  
  button(:share, :id=>"sharecontent_send_button")
  
  # Gonna add the social network validations later
  
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
module ManageParticipants
  
  include PageObject
  
  checkbox(:add_all_contacts, :id=>"addpeople_select_all_contacts")
  
  def add_contact(contact)
    @browser.li(:text=>contact).checkbox(:class=>"addpeople_checkbox").set
  end
  
  checkbox(:remove_all_contacts, :id=>"addpeople_select_all_selected_contacts")
  button(:remove_selected, :text=>"Remove selected")
  
  button(:done_apply_settings, :text=>"Done, apply settings")
  
  def check_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.set
  end
  
  def uncheck_remove_contact(contact)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.checkbox.clear
  end
  
  select_list(:role_for_selected_members, :id=>"addpeople_selected_all_permissions")
  
  def set_role_for(contact, role)
    @browser.div(:id=>"addpeople_selected_contacts_container").link(:text=>contact).parent.select(:class=>"addpeople_selected_permissions").select(role)
  end
  
end

#
module WorldSettings

  include PageObject
  
  text_field(:title, :id=>"worldsettings_title")
  text_area(:description, :id=>"worldsettings_description")
  text_area(:tags, :id=>"worldsettings_tags")
  select_list(:can_be_discovered_by, :id=>"worldsettings_can_be_found_in")
  select_list(:membership, :id=>"worldsettings_membership")
  
  button(:apply_settings, :text=>"Apply Settings")
  
end

#
module AddRemoveCategories
  
  include PageObject
  
  def open_tree(text)
    @browser.link(:title=>text).parent.ins.fire_event("onclick")
  end
  
  def check_category(text)
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
  
  button(:save_categories, :text=>"Save")
  button(:dont_save, :text=>"Don't save")
  
end

# Page objects in the Add content dialog box
module AddContentContainer
  
  include PageObject
  
  link(:upload_content, :text=>"Upload content")

  def upload_file=(file_name)
    @browser.file_field(:id=>"multifile_upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + file_name)
  end
  
  text_field(:file_title, :id=>"newaddcontent_upload_content_title")
  text_area(:file_description, :id=>"newaddcontent_upload_content_description")
  text_field(:file_tags, :id=>"newaddcontent_upload_content_tags")
  select_list(:who_can_see_file, :id=>"newaddcontent_upload_content_permissions")
  select_list(:file_copyright, :id=>"newaddcontent_upload_content_copyright")
  
  link(:create_new_document, :text=>"Create new document")
  
  text_field(:name_document, :id=>"newaddcontent_add_document_title")
  text_area(:document_description, :id=>"newaddcontent_add_document_description")
  text_field(:document_tags, :id=>"newaddcontent_add_document_tags")
  select_list(:who_can_see_document, :id=>"newaddcontent_add_document_permissions")
  
  link(:all_content, :text=>"All content")
  link(:add_content_my_library, :text=>"My Library")
  
  def search_for_content=(text)
    @browser.text_field(:class=>"newaddcontent_existingitems_search").set("#{text}\n")
  end
  
  def check_content(item)
    @browser.li(:text=>item).checkbox.set
  end
  
  alias check_item check_content
  alias check_document check_content
  
  link(:add_link, :text=>"Add link")
  
  text_field(:paste_link_address, :id=>"newaddcontent_add_link_url")
  text_field(:link_title, :id=>"newaddcontent_add_link_title")
  text_area(:link_description, :id=>"newaddcontent_add_link_description")
  text_field(:link_tags, :id=>"newaddcontent_add_link_tags")
  
  button(:add, :text=>"Add")
  
  select_list(:save_all_to, :id=>"newaddcontent_saveto")
  
  def remove(item)
    @browser.link(:title=>"Remove #{item}").click
  end
  
  def edit_details(item)
    @browser.div(:id=>"newaddcontent_container_selecteditems_container").li(:text=>/#{Regexp.escape(item)}/).button(:text=>"Edit details").click
  end
  
  alias edit_item_details edit_details
  
  text_field(:edit_title, :id=>"newaddcontent_selecteditems_edit_data_title")
  text_area(:edit_description, :id=>"newaddcontent_selecteditems_edit_data_description")
  text_field(:edit_tags, :id=>"newaddcontent_selecteditems_edit_data_tags")
  
  def add_permissions(item)
    @browser.div(:id=>"newaddcontent_container_selecteditems_container").li(:text=>/#{Regexp.escape(item)}/).button(:text=>"Add permissions").click
  end 
  
  select_list(:edit_who_can_see_it, :id=>"newaddcontent_selecteditems_edit_permissions_permissions")
  select_list(:edit_copyright, :id=>"newaddcontent_selecteditems_edit_permissions_copyright")
  
  button(:save, :text=>"Save")
  
  button(:done_add_collected, :class=>"s3d-button s3d-overlay-button newaddcontent_container_start_upload")
  
end

# =========
# "Widget" Modules--meaning helper tools for the right-hand pane on site pages...
# =========

# Inclusive of all methods having to do with lists of Content,
# Groups, Contacts, etc.
module ListWidget
  
  include PageObject
  
  select_list(:sort_by, :id=>/sortby/)
  select_list(:filter_by, :id=>"facted_select")
  
  # Clicks on the plus sign image for the specified group in the list.
  def add_group(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).div(:class=>/sakai_joingroup_overlay/).fire_event("onclick")
    @browser.wait_until { @browser.button(:text=>"Join group").visible? }
    self.class.eval_class { include JoinGroupPopUp }
  end
  
  alias add_course add_group
  alias add_research add_group
  
  def add_contact(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).div(:class=>/sakai_addtocontacts_overlay/).fire_event("onclick")
    @browser.wait_until { @browser.button(:text=>"Invite").visible? }
    self.class.eval_class { include AddToContactsPopUp }
  end
  
  alias request_contact add_contact
  alias request_connection add_contact
  
  def add_content_to_library(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"Save content").click
    @browser.wait_until { @browser.text.include? "Save to" }
    self.class.eval_class { include SaveContentPopUp }
  end
  
  alias add_document add_content_to_library
  alias save_content add_content_to_library
  
  def open_group(name)
    @browser.link(:text=>name).click
    GroupLibrary.new(@browser)
  end
  
  alias view_group open_group
  alias view_course open_group
  alias open_course open_group
  
  def open_research(name)
    @browser.link(:text=>name).click
    ResearchIntro.new @browser
  end
  
  alias view_research open_research
  
  def open_document(name)
    @browser.link(:text=>name).click
    ContentDetailsPage.new @browser
  end
  
  alias open_content open_document
  
  def message_course(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:class=>/sakai_sendmessage_overlay/).click
    self.class.class_eval { include SendMessagePopUp }
  end
  
  alias message_group message_course
  alias message_person message_course
  alias message_research message_course

  def view_owner_information(name)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"View owner information").click
    @browser.wait_until { @browser.text.include? "Add to contacts" }
    self.class.eval_class { include OwnerInfoPopUp }
  end
  
  alias view_owner_info view_owner_information
  
  def share(item)
    @browser.li(:text=>/#{Regexp.escape(name)}/).button(:title=>"Share content").click
    @browser.wait_until { @browser.text.include? "Or, share it on a webservice:" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  alias share_content share
  
  def view_person(name)
    @browser.link(:text=>name).click
    ViewPerson.new @browser
  end
  
end

#
module LibraryWidget
  
  include PageObject
  
  def search_library_for=(text)
    @browser.text_field(:id=>"mylibrary_livefilter").set("#{text}\n")
  end
  
  checkbox(:add, :id=>"mylibrary_check_all")
  
  def check_content(item)
    @browser.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.set
  end
  
  def uncheck_content(item)
    @browser.div(:class=>"fl-container fl-fix mylibrary_item", :text=>/#{Regexp.escape(item)}/).checkbox.clear
  end
  
  checkbox(:remove_all_library_items, :id=>"mylibrary_check_all")
  
end

#
module DocumentWidget
  
  include PageObject
  
end

#
module ParticipantsWidget
  
  include PageObject
  
end

#
module MailWidget
  
  include PageObject
  
end


# ======================
# Page Classes
# ======================

# The Login page for OAE.
class LoginPage
  
  include PageObject
  include HeaderFooterBar
  
  def sign_up
    link(:id=>"navigation_anon_signup_link").click
    CreateNewAccount.new @browser
  end
  
end

# The page for creating a new user account
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

#
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

  def close_add_widget
    @browser.div(:class=>"s3d-dialog-close jqmClose").fire_event("onclick")
    sleep 1 #FIXME
    MyDashboard.new @browser
  end
  
  def add_all_widgets
    @browser.div(:id=>"add_goodies_body").lis.each do |li|
      if li.visible? && li.id=~/_add_/
        li.button.click
      end
    end
  end
  
  def remove_all_widgets
    @browser.div(:id=>"add_goodies_body").lis.each do |li|
      if li.visible? && li.id=~/_remove_/
        li.button.click
      end
    end
  end
  
  def add_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_add_/).button.click
  end
  
  def remove_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_remove_/).button.click
  end
  
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
    CourseLibrary.new @browser
  end

end

#
class MyMessages
  
  include HeaderFooterBar
  include YouPagesLeftMenu
 
end

#
class MyProfileBasicInfo
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  # Basic Information
  text_field(:given_name, :name=>"basic_elements_firstName")
  text_field(:family_name, :id=>"profilesection_generalinfo_basic_elements_lastName")
  text_field(:preferred_name, :id=>"profilesection_generalinfo_basic_elements_preferredName")
  text_area(:tags, :id=>"profilesection_generalinfo_basic_elements_tags")

  def update
    @browser.div(:id=>/profilesection-basic/).button(:text=>"Update").click
    @browser.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileCategories
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  include AddRemoveCategories
  
  # Categories
  button(:add_or_remove_categories, :text=>"Add or remove categories")

  # Returns an array of the categories shown on the Categories page itself.
  def listed_categories
    list = []
    @browser.ul(:id=>"profilesection_generalinfo_locations").lis.each do |li|
      list << li.text
    end
    return list
  end
  
end

#
class MyProfileAboutMe

  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  text_area(:about_Me, :id=>"profilesection_generalinfo_aboutme_elements_aboutme")
  text_area(:academic_interests, :id=>"profilesection_generalinfo_aboutme_elements_academicinterests")
  text_area(:personal_interests, :id=>"profilesection_generalinfo_aboutme_elements_personalinterests")
  
  def update
    @browser.div(:id=>/profilesection-aboutme/).button(:text=>"Update").click
    @browser.wait_until { @browser.div(:id=>"gritter-notice-wrapper").exist? }
  end

end

#
class MyProfileOnline
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  button(:add_another_online, :text=>"Add another Online", :id=>/profilesection_add_link/)
  
  text_field(:site, :title=>"Site", :index=>-1)
  text_field(:url, :title=>"URL", :index=>-1)
  
  def update
    @browser.div(:id=>/profilesection-online/).button(:text=>"Update").click
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

# Contact Information
class MyProfileContactInfo
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  button(:add_another, :text=>"Add another", :id=>/profilesection_add_link_\d/)
  text_field(:institution, :title=>"Institution", :index=>-1)
  text_field(:department, :title=>"Department", :index=>-1) 
  text_field(:title_role, :title=>"Title/Role", :index=>-1) 
  text_field(:email, :title=>"Email", :index=>-1) 
  text_field(:instant_messaging, :title=>"Instant Messaging", :index=>-1) 
  text_field(:phone, :title=>"Phone", :index=>-1) 
  text_field(:mobile, :title=>"Mobile", :index=>-1) 
  text_field(:fax, :title=>"Fax", :index=>-1) 
  text_field(:address, :title=>"Address", :index=>-1) 
  text_field(:city, :title=>"City", :index=>-1) 
  text_field(:state, :title=>"State", :index=>-1)
  text_field(:postal_code, :title=>"Postal Code", :index=>-1) 
  text_field(:country, :title=>"Country", :index=>-1)
  
  def update
    @browser.div(:id=>/profilesection-contact/).button(:text=>"Update").click
  end
end

# Publications
class MyProfilePublications
  
  include PageObject
  include HeaderFooterBar
  include YouPagesLeftMenu
  
  button(:add_another_publication, :text=>"Add another publication", :id=>/profilesection_add_link_\d+/)
  
  def update
    @browser.div(:id=>/profilesection-publications/).button(:text=>"Update").click
  end
  
  text_field(:main_title, :title=>"Main title", :index=>-1)
  text_field(:main_author, :title=>"Main author", :index=>-1)
  text_field(:co_authors, :title=>"Co-author(s)", :index=>-1)
  text_field(:publisher, :title=>"Publisher", :index=>-1)
  text_field(:place_of_publication, :title=>"Place of publication", :index=>-1)
  text_field(:volume_title, :title=>"Volume title", :index=>-1)
  text_field(:volume_information, :title=>"Volume information", :index=>-1)
  text_field(:year, :title=>"Year", :index=>-1)
  text_field(:number, :title=>"Number", :index=>-1)
  text_field(:series_title, :title=>"Series title", :index=>-1)
  text_field(:url, :title=>"URL", :index=>-1)
  
end

#
class MyLibrary
  
  include PageObject
  include HeaderFooterBar
  

end

#
class MyMemberships

  include PageObject
  include HeaderFooterBar
  
  def go_to(item_name)
    @browser.link(:text=>item_name).click
    @browser.button(:id=>"entity_group_permissions").wait_until_present
    sleep 0.3
    GroupLibrary.new @browser
  end

end

#
class MyContacts

  include PageObject
  include HeaderFooterBar
  

end


#
class AddContacts
  
end

#
class CreateGroups
  
  include PageObject
  include HeaderFooterBar
  include PermissionsPopUp
  include AccountPreferencesPopUp
  include CreateWorldsLeftMenu
  
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
    CreateABasicCourse.new @browser
  end
  
end

#
class CreateABasicCourse
  
  include PageObject
  include HeaderFooterBar
  include CreateWorldsLeftMenu
  
  text_field(:title, :id=>"newcreategroup_title")
  text_field(:suggested_url, :id=>"newcreategroup_suggested_url")
  text_area(:description, :id=>"newcreategroup_description")
  text_area(:tags, :id=>"newcreategroup_tags")
  select_list(:can_be_discovered_by, :id=>"newcreategroup_can_be_found_in")
  select_list(:membership, :id=>"newcreategroup_membership")
  
  def create_basic_course
    @browser.button(:class=>"s3d-button s3d-overlay-button newcreategroup_create_simple_group").click
    @browser.wait_until { @browser.text.include? "Add content" }
    GroupLibrary.new @browser
  end
  
end

#
class CreateResearch
  
  include PageObject
  include HeaderFooterBar
  include CreateWorldsLeftMenu
  
end

#
class Explore
  
  include PageObject
  include HeaderFooterBar
  include ListWidget
  
  def search_people_for=(text)
    @browser.text_field(:id=>"searchpeople_text").set("#{text}\n")
  end
  
  def search_content_for=(text)
    @browser.text_field(:id=>"searchcontent_text").set("#{text}\n")
  end
  
  def search_groups_for=(text)
    @browser.text_field(:id=>"searchgroups_text").set("#{text}\n")
  end
  
  alias search_courses_for= search_groups_for=
  alias search_research_for= search_groups_for=
  
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
  
  navigating_link(:basic_information, "Basic Information", "Given Name:", "ViewPerson")
  navigating_link(:categories, "Categories", nil, "ViewPerson")
  navigating_link(:about_me, "About Me", nil, "ViewPerson")
  navigating_link(:online, "Online", nil, "ViewPerson")
  navigating_link(:contact_information, "Contact Information", nil, "ViewPerson")
  navigating_link(:publications, "Publications", nil, "ViewPerson")
  
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
class ExploreGroups

end

# 
class ExploreCourses
  
end

#
class ExploreResearch
  
end

#
class MyPreferences

end


# 
class GroupLibrary
  
  include PageObject
  include HeaderFooterBar
  include WorldsLeftMenu
  include HeaderBar
  include LeftMenuBar
  include LibraryWidget
  include ListWidget
  
  
  
end

# 
class GroupParticipants
  
  include PageObject
  include HeaderFooterBar
  include WorldsLeftMenu
  include HeaderBar

  
end

#
class ResearchIntro
  
  include PageObject
  include HeaderFooterBar
  
end

class ContentDetailsPage
  
  include PageObject
  include HeaderFooterBar
  
  def share
    @browser.button(:id=>"entity_content_share").click
    @browser.wait_until { @browser.text.include? "Who do you want to share with?" }
    self.class.class_eval { include ShareWithPopUp }
  end
  
  def add_to_library
    @browser.button().click
    @browser.wait_until { @browser.text.include? "Save to" }
    self.class.eval_class { include SaveContentPopUp }
  end
  
end
