# coding: UTF-8
require 'sakai-OAE/gem_extensions'
require 'sakai-OAE/global_methods'
require 'sakai-OAE/toolbars_and_menus'
require 'sakai-OAE/pop_up_dialogs'
require 'sakai-OAE/widgets'

# Sakai-OAE Page Classes

# Methods for the Assignments Widget page.
class Assignments
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
  def assignments_frame
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

# TODO - Write a class description
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

  # Returns the text of the description display span.
  def description
    self.span(:id=>"contentmetadata_description_display").text
  end

  # Enters the specified text into the description text area box.
  # Note that this method first fires off the edit_description method
  # because the description text area is not present by default.
  def description=(text)
    edit_description
    self.text_area(:id=>"contentmetadata_description_description").set text
  end

  # Header row items...
  def update_name=(new_name)
    name_element.click
    self.text_field(:id=>"entity_name_text").set new_name + "\n"
  end
  
  # Visibility...
  def change_visibility_private
        # TODO - Write method
  end
  
  def change_visibility_logged_in
         # TODO - Write method
  end
  
  def change_visibility_public
       # TODO - Write method
  end
  
  # Collaboration...
  
  #
  def view_collaborators
     # TODO - Write method
  end
  
  #
  def change_collaborators
    # TODO - Write method
  end
  
  # This method is currently not working   TODO - Fix method
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
    self.wait_for_ajax(2)
  end
  
  # Enters the specified text string into the Comment box.
  def comment_text(text)
    comment_text_area_element.click
    comment_text_area_element.send_keys text
  end
  alias comment_text= comment_text
  
  # Clicks the "Add to..." button
  def add_to
    add_to_button
    self.wait_for_ajax(2)
  end
  
  # Clicks "Permissions" in the menu...
  def permissions
    permissions_menu_button
    self.wait_for_ajax(2)
    permissions_button
    self.wait_for_ajax(2)
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
  
  # This method grabs all of the information about the last listed comment and
  # returns it in a hash object. Relevant strings are put into the following
  # keys: :poster, :date, :message. The delete button element is defined in the
  # :delete_button key. Note that you'll have to use Watir's .click method to click
  # the button.
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

  # This method grabs all of the information about the first listed comment and
  # returns it in a hash object. Relevant strings are put into the following
  # keys: :poster, :date, :message. The delete button element is defined in the
  # :delete_button key. Note that you'll have to use Watir's .click method to click
  # the button.
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
  span(:password_strength, :class=>/strength (zero|one|two|three|four)/)

  # Clicks the 'create account' button, waits for the dashboard,
  # then returns the MyDashboard class object.
  def create_account
    self.back_to_top
    self.create_account_button
    sleep 4
    self.wait_until { self.text.include? "My dashboard" }
    MyDashboard.new @browser
    #self.class.class_eval { include OurAgreementPopUp }
  end

end

# Methods related to the page that appears when you are
# creating a new Course.
class CreateCourses
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBarCreateWorlds

  # Clicks the button for using the math template,
  # then returns the MathTemplate class object.
  def use_math_template
    self.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    # TODO - Class goes here
  end

  # Clicks the button to use the basic template,
  # waits for the new page to load, then returns
  # the CreateGroups class object.
  def use_basic_template
    self.div(:class=>"selecttemplate_template_small selecttemplate_template_right").button(:text=>"Use this template").click
    self.wait_until { self.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end
  
end

# Methods related to the page where a new Course/Group/Project
# is set up.
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

  # Clicks the 'Add people' button and waits for the
  # Manage Participants dialog to appear.
  # Includes the ManageParticipants module in the class.
  def add_people
    self.button(:text, "Add people").click
    self.wait_for_ajax(2)
    self.class.class_eval { include ManageParticipants }
  end

  # Clicks the 'Add more people' button and waits for
  # the Manage Participants dialog to appear.
  # Includes the ManageParticipants module in the class.
  def add_more_people
    self.button(:text, "Add more people").click
    self.wait_for_ajax(2)
    self.class.class_eval { include ManageParticipants }
  end

  # Clicks the 'List categories' button, waits for
  # the Categories dialog to appear, and then
  # includes the AddRemoveCategories module in the class.
  def list_categories
    self.button(:text=>"List categories").click
    self.wait_for_ajax(2)
    self.class.class_eval { include AddRemoveCategories }
  end

  # Clicks the 'Create' button for the Course or Group, etc.,
  # then waits until the Course Library page loads. Once that
  # happens, returns the Library class object.
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

  # Clicks the 'Create' button then waits until the Research Intro page loads. Once that
  # happens, returns the ResearchIntro class object.
  def create_research_project
    create_thing
    unless url_error_element.visible?
      self.button(:id=>"group_create_new_area", :class=>"s3d-button s3d-header-button s3d-popout-button").wait_until_present
      ResearchIntro.new @browser
    end
  end


  span(:url_error, :id=>"newcreategroup_suggested_url_error")
  
  private

  # Do not use. This method is used by the public 'create' methods in this class.
  def create_thing
    self.button(:class=>"s3d-button s3d-overlay-button newcreategroup_create_simple_group").click
    sleep 0.3
    self.div(:id=>"sakai_progressindicator").wait_while_present
    sleep 2 # The poor man's wait_for_ajax, since that was failing.
  end
  
end

# Methods related to the page for Creating a Research Project
class CreateResearch
  
  include PageObject
  include HeaderFooterBar
  include LeftMenuBarCreateWorlds

  # Clicks the button for using the Research Project template, waits for the
  # page to load, then returns the CreateGroups class object.
  def use_research_project_template
    self.div(:class=>"selecttemplate_template_large").button(:text=>"Use this template").click
    self.wait_until { self.text.include? "Suggested URL:" }
    CreateGroups.new @browser
  end

  # Clicks the button for using the Research Support Group template,
  # waits for the page to load, then returns the CreateGroups class object.
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

# Methods related to the page for searching Content.
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

# Methods related to the People/Users search page
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

# Methods related to the Groups search page.
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

# Methods related to the page for searching Courses.
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

  # TODO - Describe method
  def courses_count
    #TODO - Write method
  end

  # Selects the specified item in the 'Filter by' field. Waits for
  # Ajax calls to drop to zero.
  def filter_by=(selection)
    self.select(:id=>"facted_select").select(selection)
    self.wait_for_ajax(2)
  end

  # Selects the specified item in the 'Sort by' field. Waits for
  # any Ajax calls to finish.
  def sort_by=(selection)
    self.div(:class=>"s3d-search-sort").select().select(selection)
    self.wait_for_ajax(2)
  end
  
end

# Methods related to the page for searching for Research Projects.
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
  include ChangePicturePopUp # TODO ... Rethink including this by default

  # Page Objects
  button(:edit_layout, :text=>"Edit layout")
  radio_button(:one_column, :id=>"layout-picker-onecolumn")
  radio_button(:two_column, :id=>"layout-picker-dev")
  radio_button(:three_column, :id=>"layout-picker-threecolumn")
  button(:save_layout, :id=>"select-layout-finished")
  button(:add_widgets_button, :text=>"Add Widget")  # Do not use for clicking the button. See custom methods
  image(:profile_pic, :id=>"entity_profile_picture")
  div(:my_name, :class=>"s3d-bold entity_name_me")
  
  #div(:page_title, :class=>"s3d-contentpage-title")
  
  # Custom Methods...

  # Returns the text contents of the page title div  
  def page_title
    self.div(:id=>"s3d-page-container").div(:class=>"s3d-contentpage-title").text
  end

  # Clicks the 'Add widget' button, waits for the page to load,
  # then includes the AddRemoveWidgets module in the class.
  # Note that this method is specifically "add_widgets" because
  # otherwise there would be a method collision with the "add widget"
  # method in the AddRemoveWidgets module.
  def add_widgets
    self.add_widgets_button
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
  
  # Clicks on the membership item displayed in the Recent Memberships widget.
  # Then returns the Library class object.
  def go_to_most_recent_membership
    self.link(:class=>"recentmemberships_item_link s3d-widget-links s3d-bold").click
    sleep 2 # The next line sometimes throws an "unknown javascript error" without this line.
    self.wait_for_ajax(2)
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

# Methods related to the My Messages pages.
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
    self.wait_for_ajax(2)
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
    self.wait_for_ajax(2)
    self.class.class_eval { include SendMessagePopUp }
  end

  # Clicks the Delete button for the specified message (specified by Subject), then
  # waits for Ajax calls to complete.
  def delete_message(subject)
    subject_div = active_div.div(:class=>"inbox_subject", :text=>subject)
    subject_div.parent.parent.parent.button(:title=>"Delete message").click
    self.wait_for_ajax
  end
  
  # Clicks the Reply button for the specified (by Subject) message
  # then waits for the Ajax calls to complete
  def reply_to_message(subject)
    subject_div = active_div.div(:class=>"inbox_subject", :text=>subject)
    subject_div.parent.parent.parent.link(:title=>"Reply").click
    self.wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end
  alias read_message open_message
  
  # Message Preview methods...
  
  # Returns the Sender text for the specified message (by Subject)
  def preview_sender(subject)
    message_div(subject).div(:class=>"inbox_name").button.text
  end
  
  # Returns the message recipient name for the specified message (by Subject)
  def preview_recipient(subject)
    message_div(subject).div(:class=>"inbox_name").span.text
  end
  
  # Returns the date/time string for the specified message.
  def preview_date(subject)
    message_div(subject).div(:class=>"inbox_date").span.text
  end
  
  # Returns the file path and name of the displayed profile pic of the
  # specified message.
  def preview_profile_pic(subject)
    message_div(subject).parent.image(:class=>"person_icon").src
  end
  
  # Returns the text of the Body of the specified message.
  def preview_body(subject)
    message_div(subject).div(:class=>"inbox_excerpt").text
  end
  
  # The New Message page is controlled by the SendMessagePopUp module

  # Read/Reply Page Objects (defined with Watir)

  # Returns the text of the name of the sender of the message being viewed
  def message_sender
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_name").button(:class=>"s3d-regular-links s3d-link-button s3d-bold personinfo_trigger_click personinfo_trigger").text
  end
  
  # Returns the recipient name text. The method assumes you're currently
  # viewing a message--that you're not looking at a list of messages.
  def message_recipient
    active_div.div(:class, "inbox_name").span(:class=>"inbox_to_list").text
  end
  
  # Returns the date of the message being viewed (as a String object)
  def message_date
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_date").span.text
  end

  # Returns the text of the message subject. The method assumes you're currently
  # viewing a message--that you're not looking at a list of messages.
  def message_subject
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_subject").link.text
  end
  
  # Returns the text of the message body.The method assumes you're currently
  # viewing a message--that you're not looking at a list of messages.
  def message_body
    active_div.div(:id=>"inbox_show_message").div(:class=>"inbox_excerpt").text
  end

  # The page element for the "Delete selected" button.
  def delete_selected_element
    active_div.button(:id=>"inbox_delete_selected")
  end
  
  # Clicks the "Delete selected" buton and waits for Ajax calls to complete
  def delete_selected
    delete_selected_element.click
    self.wait_for_ajax
  end
  
  # The page element for the "Mark as read" button
  def mark_as_read_element
    active_div.button(:id=>"inbox_mark_as_read")
  end
  
  # Clicks the "Mark as read" button, then waits for Ajax calls to complete
  def mark_as_read
    mark_as_read_element.click
    sleep 0.3
    self.wait_for_ajax
  end

  # Checks the checkbox for the specified message in the list.
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
  
  # The page element for the Search text field.
  def search_field_element
    active_div.text_field(:id=>"inbox_search_messages")
  end
  
  # Enters the specified text in the Search text box.
  # Note that it appends a line feed on the end of the text
  # so that the search happens immediately. Thus there is
  # no need for a second line in the test script to
  # specify clicking the Search button.
  def search_messages=(text)
    search_field_element.set(text+"\n")
    self.wait_for_ajax
    sleep 0.3
  end
  
  # The page element for the Search button
  def search_button_element
    active_div.button(:class=>"s3d-button s3d-overlay-button s3d-search-button")
  end
  
  # Clicks the Search button and waits for Ajax calls to complete
  def search_messages
    search_button_element.click
    self.wait_for_ajax
  end
  
  # Private Methods in this class
  private
  
  # Determines which sub page is currently active,
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
  
  # Uses the specified subject text to determine which message div to
  # use.
  def message_div(subject)
    active_div.div(:class=>"inbox_subject",:text=>subject).parent.parent
  end
  
end

# Methods related to the Basic Info page in My Profile
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
  span(:first_name_error, :id=>"firstName_error")
  span(:last_name_error, :id=>"lastName_error")

  # Clicks the "List categories" button and waits for the
  # pop-up dialog to load. Includes the AddRemoveCategories
  # module in the class object.
  def list_categories
    self.form(:id=>"displayprofilesection_form_basic").button(:text=>"List categories").click
    self.wait_for_ajax(3)
    self.class.class_eval { include AddRemoveCategories }
  end
  
  # Returns an array consisting of the contents of the Tags and Categories
  # field. Returns the categories split up among children and parents.
  # In other words, for example, "Engineering & Technology » Computer Engineering"
  # becomes "Engineering & Technology", "Computer Engineering" 
  def categories
    list = []
    self.form(:id=>"displayprofilesection_form_basic").ul(:class=>"as-selections").lis.each do |li|
      next if li.text == ""
      string = li.text[/(?<=\n).+/]
      split = string.split(" » ")
      list << split
    end
    list.flatten!
    list.uniq!
    return list
  end

  # Removes the specified category from the list
  def remove_category(name)
    self.form(:id=>"displayprofilesection_form_basic").li(:text=>/#{Regexp.escape(name)}/).link(:class=>"as-close").click
    self.wait_for_ajax
  end

  # Clicks the "Update" button and waits for any Ajax calls
  # to complete.
  def update
    self.form(:id=>"displayprofilesection_form_basic").button(:text=>"Update").click
    self.wait_for_ajax(2)
  end

end

# Methods related to the About Me page in My Profile
class MyProfileAboutMe

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  text_area(:about_Me, :id=>"aboutme")
  text_area(:academic_interests, :id=>"academicinterests")
  text_area(:personal_interests, :id=>"personalinterests")
  
  # Clicks the "Update" button and waits for any Ajax calls
  # to complete.
  def update
    self.form(:id=>"displayprofilesection_form_aboutme").button(:text=>"Update").click
    self.wait_for_ajax(2)
  end

end

# Methods related to the 'Online' page in My Profile.
class MyProfileOnline
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBarYou
  
  button(:add_another_online, :text=>"Add another Online", :id=>"displayprofilesection_add_online")
  
  text_field(:site, :id=>/siteOnline_\d+/, :index=>-1)
  text_field(:url, :id=>/urlOnline_\d+/, :index=>-1)
  
  # Clicks the "Update" button and waits for any Ajax calls
  # to complete.
  def update
    self.form(:id=>"displayprofilesection_form_online").button(:text=>"Update").click
    self.wait_for_ajax
  end
  
  # Returns a hash object, where the keys are the site names and the
  # values are the urls.
  def sites_list
    hash = {}
    self.div(:id=>"displayprofilesection_sections_online").divs(:class=>"s3d-form-field-wrapper").each do |div|
      hash.store(div.text_field(:id=>/siteOnline_/).value, div.text_field(:id=>/urlOnline_/).value)
    end
    return hash
  end
  
  # Removes the specified Online record from the list by clicking its
  # "Remove this Online" button.
  def remove_this_online(text)
    #find the div...
    div = self.div(:class=>"online").text_field(:value=>text).parent.parent.parent
    #click the button
    div.button(:id=>/displayprofilesection_remove_link_/).click
    self.wait_for_ajax
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
  text_field(:institution, :id=>"college", :name=>"college")
  text_field(:department, :id=>"department", :name=>"department")
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
  
  # Clicks the "Update" button and waits for any Ajax calls
  # to complete.
  def update
    self.form(:id=>"displayprofilesection_form_contact").button(:text=>"Update").click
    self.wait_for_ajax(2)
  end
  
  # Takes a hash object and uses it to fill out
  # the fields on the form. The necessary key values in the
  # hash argument are as follows:
  # :institution, :department, :title, :email, :im, :phone,
  # :mobile, :fax, :address, :city, :state, :zip, and :country.
  # Any keys that are different or missing will be ignored.
  def fill_out_form(hash)
    self.email=hash[:email]
    self.fax=hash[:fax]
    self.institution=hash[:institution]
    self.department=hash[:department]
    self.title_role=hash[:title]
    self.instant_messaging=hash[:im]
    self.phone=hash[:phone]
    self.mobile=hash[:mobile]
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
  span(:title_error, :id=>/maintitle_\d+_error/)
  span(:author_error, :id=>/mainauthor_\d+_error/)
  span(:publisher_error, :id=>/publisher_\d+_error/)
  span(:place_error, :id=>/placeofpublication_\d+_error/)
  span(:year_error, :id=>/year_\d+_error/)
  span(:url_error, :id=>/url_\d+_error/)
  
  # Custom Methods...
  
  # Clicks the "Update" button and waits for any Ajax calls
  # to complete.
  def update
    self.form(:id=>"displayprofilesection_form_publications").button(:text=>"Update").click
    self.wait_for_ajax(2)
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
  
  # Clicks the "Remove this publication" link for the publication specified (by
  # the Main title of the record in question).
  def remove_this_publication(main_title)
    target_div_id = self.text_field(:value=>main_title).parent.parent.parent.id
    self.div(:id=>target_div_id).button(:id=>/displayprofilesection_remove_link_/).click
    self.wait_for_ajax
  end
  
  # Returns an array containing all of the titles of the publications that exist
  # on the page.
  def publication_titles
    array = []
    self.div(:id=>"displayprofilesection_sections_publications").text_fields(:id=>/maintitle_/).each { |field| array << field.value }
    return array
  end
  alias titles publication_titles
  
  # Returns an array of hashes. Each hash in the array refers to one of
  # the listed publications.
  #
  # Each hash's key=>value pairs are determined by the field title and field values for the publications.
  #
  # Example: "Main title:"=>"War and Peace","Main author:"=>"Tolstoy", etc....
  def publications_data
    list = []
    self.div(:id=>"displayprofilesection_sections_publications").divs(:class=>"displayprofilesection_multiple_section").each do |div|
      hash = {}
      div.divs(:class=>"displayprofilesection_field").each { |subdiv| hash.store(subdiv.label(:class=>"s3d-input-label").text, subdiv.text_field.value) }
      list << hash
    end
    return list
  end
  alias publication_data publications_data
  alias publications_list publications_data
  
end

# Methods related to the User's My Library page.
class MyLibrary
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include ListWidget
  include ListContent
  include LeftMenuBarYou
  include LibraryWidget

  # Page Objects
  button(:empty_library_add_content_button, :id=>"mylibrary_addcontent")

  # Custom Methods and Page Objects...
  
  # Defines the div that displays when the library has no contents.
  # Useful for testing whether the library is empty or not.
  def empty_library
    active_div.div(:id=>"mylibrary_empty")
  end
  
  # Returns the text of the Page Title.
  def page_title
    active_div.div(:class=>"s3d-contentpage-title").text
  end

  # Private methods...
  private
  
  def active_div
    id = self.div(:id=>/mylibrarycontainer/).parent.id
    return self.div(:id=>id)
  end
  
end

# Methods related to the User's My Memberships page.
class MyMemberships

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include ListWidget
  include ListGroups
  include LeftMenuBarYou

  # Page Objects
  text_field(:search_memberships_field, :id=>"mymemberships_livefilter")
  select_list(:sort_by_list, :id=>"mymemberships_sortby")
  div(:gridview_button, :class=>/search-results-gridview/)
  div(:listview_button, :class=>/search-results-listview/)
  checkbox(:select_all, :id=>"mymemberships_select_checkbox")
  button(:add_selected_button, :id=>"mymemberships_addpeople_button") # Don't use this method. Use the custom one defined below
  button(:message_selected_button, :id=>"mymemberships_message_button") # Don't use this method. Use the custom one defined below
  link(:create_a_new_group_button, :text=>"Create a new group") # Don't use this method. Use the custom one defined below

  # Custom methods...

  # Returns the text of the Page Title.
  def page_title
    active_div.div(:class=>"s3d-contentpage-title").text
  end

  # Returns the div object for the blue quote bubble that
  # appears when the page is empty of memberships.
  def quote_bubble
    active_div.div(:class=>"s3d-no-results-container")
  end

  # Clicks the "Create one" link in the quote_bubble
  # div and then returns the CreateGroups class object.
  def create_one
    quote_bubble.link(:text=>"Create one").click
    self.wait_until { self.button(:class=>/create_simple_group/).present? }
    CreateGroups.new @browser
  end

  # Sorts the list of memberships according to the specified value
  def sort_by=(type)
    self.sort_by_list=type
    self.wait_for_ajax
  end

  # Private methods...
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
    self.wait_for_ajax(2)
  end
  
  # Clicks the "Find more people" link, then returns
  # the ExplorePeople class object.
  def find_more_people
    active_div.link(:text=>"Find more people").click
    self.wait_for_ajax
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

# Methods related to the page for viewing a User's profile
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
  
  # Clicks the "Accept invitation" button and waits for any Ajax calls
  # to complete
  def accept_invitation
    self.accept_invitation_button
    self.wait_for_ajax(2)
  end
  
  # Clicks the message button and waits for the Pop-up dialog to appear.
  def message
    self.message_button
    self.wait_until { self.text.include? "Send this message to:" }
    self.class.class_eval { include SendMessagePopUp }
  end
  
  # Clicks the "Add to contacts" button and waits for the Pop-up dialog
  # to appear.
  def add_to_contacts
    self.add_to_contacts_button
    self.wait_until { @browser.text.include? "Add a personal note to the invitation:" }
    self.class.class_eval { include AddToContactsPopUp }
  end
  
  # Clicks the link to open the user's library profile page.
  def users_library
    self.link(:class=>/s3d-bold lhnavigation_toplevel lhnavigation_page_title_value/, :text=>/Library/).click
    sleep 2
    self.wait_for_ajax(2)
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
  # listed on the Basic Information page. Note that it splits them up into
  # parent and child categories.
  def tags_and_categories_list
    list = []
    target_div = self.div(:class=>"s3d-contentpage-title", :text=>"Basic Information").parent.parent.div(:id=>"displayprofilesection_body")
    target_div.links.each { |link| list << link.text.split(" » ") }
    return list.flatten.uniq
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
    hash = {}
    self.div(:class=>"publications").divs(:class=>"displayprofilesection_field").each do |div|
      if div.span(:class=>"s3d-input-label").text=="Main title:" && hash != {}
        list << hash
        hash={}
      end
      hash.store(div.span(:class=>"s3d-input-label").text, div.span(:class=>"field_value").text)
    end
    list << hash
    return list
  end
  alias publication_data publications_data
  alias publications_list publications_data
  
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

# TODO - describe class
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
  
  # The page element that appears when there are no contents
  # in the Library
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
    self.wait_for_ajax(2) #
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
    self.wait_for_ajax(2) #
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
    self.wait_for_ajax(2) #wait_until { self.text.include? "about 0 seconds ago" }
  end
  
  # Clicks the "Edit comment" button.
  def edit_comment
    self.button(:text=>"Edit comment").click
    self.wait_for_ajax(2) #wait_until { self.textarea(:title=>"Edit your comment").present? == false }
  end

  # Clicks the "Edit button" for the specified comment.
  def edit(comment)
    comment.gsub!("\n", " ")
    self.p(:text=>comment).parent.parent.button(:text=>"Edit").click
    self.wait_for_ajax(2) #wait_until { self.textarea(:title=>"Edit your comment").present? }
  end
  
  # Deletes the specified comment.
  def delete(comment)
    comment.gsub!("\n", " ")
    self.div(:text=>comment).parent.button(:text=>"Delete").click
    self.wait_for_ajax(2) #wait_until { self.button(:text=>"Undelete").present? }
  end
  
end

# TODO - describe class
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

# TODO - describe class
class Tests
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons





  # The frame object that contains all of the CLE Tests and Quizzes objects
  def tests_frame
    self.frame(:id=>/id\d+_frame/)
  end
  
end

# TODO - describe class
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

  # TODO - Describe method
  def remove_files_widget
    remove_widget
  end

  # TODO - Describe method
  def files_wrapping
    widget_wrapping
  end
  
end

# Methods related to the Forum page in Courses/Groups
class Forum

  include GlobalMethods
  include LeftMenuBar
  include HeaderBar
  include HeaderFooterBar
  include DocButtons

  # The frame that contains the CLE Forums objects
  def forum_frame
    self.frame(:src=>/sakai2forums.launch.html/)
  end

end

# TODO - describe class
class Gadget
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # TODO - Describe method
  def gadget_frame
    self.frame(:id=>"ggadget_remotecontent_settings_preview_frame")
  end
  
  
  
end

# TODO - describe class
class Gradebook
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # TODO - Describe method
  def gradebook_frame
    self.frame(:src=>/sakai2gradebook.launch.html/)
  end
  
end

# TODO - describe class
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

# TODO - describe class
class Remote
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # TODO - Describe method
  def remote_frame
    self.frame(:id=>"remotecontent_settings_preview_frame")
  end
  
  
  
end

# TODO - describe class
class ResearchIntro
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  
end


# TODO - describe class
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

# TODO - describe class
class FourOhFourPage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end

# TODO - describe class
class FourOhThreePage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end

# TODO - describe class
class FourOhFourPage
  
  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include CommonErrorElements
  
end