# Navigation links in Sakai's non-site pages
# 
# == Synopsis
#
# Defines all objects in Sakai Pages that are found in the
# context of the Admin user, in "My Workspace". No classes in this
# script should refer to pages that appear in the context of
# a particular Site, even though, as in the case of Resources,
# Announcements, and Help, the page may exist in both contexts.
#
# Most classes use the PageObject gem
# to create methods to interact with the objects on the pages.
#
# Author :: Abe Heward (aheward@rsmart.com)

# Page-object is the gem that parses each of the listed objects.
# For an introduction to the tool, written by the author, visit:
# http://www.cheezyworld.com/2011/07/29/introducing-page-object-gem/
#
# For more extensive detail, visit:
# https://github.com/cheezy/page-object/wiki/page-object
#
# Also, see the bottom of this script for a Page Class template for
# copying when you create a new class.

#require 'page-object'
#require  File.dirname(__FILE__) + '/app_functions.rb'

#================
# Aliases Pages
#================

# The Aliases page - "icon-sakai-aliases", found in the Administration Workspace
class Aliases
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:new_alias, :text=>"New Alias", :frame=>frame)
    text_field(:search_field, :id=>"search", :frame=>frame)
    link(:search_button, :text=>"Search", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# The Page that appears when you create a New Alias
class AliasesCreate
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:alias_name, :id=>"id", :frame=>frame)
    text_field(:target, :id=>"target", :frame=>frame)
    button(:save, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel", :frame=>frame)
    
  end

end

# Page for editing an existing Alias record
class EditAlias
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:remove_alias, :text=>"Remove Alias", :frame=>frame)
    text_field(:target, :id=>"target", :frame=>frame)
    button(:save, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel", :frame=>frame)
    
  end

end


#================
# Login Pages
#================

# This is the page where users log in to the site.
class Login
  
  include ToolsMenu
  
  def search_public_courses_and_projects
    @browser.frame(:index=>0).link(:text=>"Search Public Courses and Projects").click
    SearchPublic.new(@browser)
  end

  # Logs in to Sakai using the
  # specified credentials. Then it
  # instantiates the MyWorkspace class.
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
    MyWorkspace.new(@browser)
  end
  alias log_in login
  alias sign_in login

end

# The page where you search for public courses and projects.
class SearchPublic
  
  include ToolsMenu
  
  def home
    @browser.frame(:index=>0).link(:text=>"Home").click
    Login.new(@browser)
  end
  
  def search_for=(string)
    @browser.frame(:index=>0).text_field(:id=>"searchbox").set(Regexp.escape(string))
  end
  
  def search_for_sites
    @browser.frame(:index=>0).button(:value=>"Search for Sites").click
    SearchPublicResults.new(@browser)
  end

end

# The page showing the results list of Site matches to a search of public sites/projects.
class SearchPublicResults
  
  include ToolsMenu
  
  def click_site(site_name)
    @browser.frame(:index=>0).link(:text=>site_name).click
    SiteSummaryPage.new(@browser)
  end

  def home
    @browser.frame(:id=>"ifrm").link(:text=>"Home").click
    Login.new(@browser)
  end

end

# The page that appears when you click a Site in the Site Search Results page, when not logged
# in to Sakai.
class SiteSummaryPage
  
  include ToolsMenu
  
  def return_to_list
    @browser.frame(:index=>0).button(:value=>"Return to List").click
    SearchPublicResults.new(@browser)
  end

  def syllabus_attachments
    links = []
    @browser.frame(:id=>"ifrm").links.each do |link|
      if link.href=~/Syllabus/
        links << link.text
      end
    end
    return links
  end

end

#================
# Realms Pages
#================

# Realms page
class Realms
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:new_realm, :text=>"New Realm", :frame=>frame)
    link(:search, :text=>"Search", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    
  end

end

#================
# Sections - Site Management
#================

# The Add Sections Page in Site Management
class AddSections
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:overview, :id=>"addSectionsForm:_idJsp3", :frame=>frame)
    link(:student_memberships, :id=>"addSectionsForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"addSectionsForm:_idJsp17", :frame=>frame)
    select_list(:num_to_add, :id=>"addSectionsForm:numToAdd", :frame=>frame)
    select_list(:category, :id=>"addSectionsForm:category", :frame=>frame)
    button(:add_sections, :id=>"addSectionsForm:_idJsp89", :frame=>frame)
    button(:cancel, :id=>"addSectionsForm:_idJsp90", :frame=>frame)
    
    # Note that the following field definitions are appropriate for
    # ONLY THE FIRST instance of each of the fields. The Add Sections page
    # allows for an arbitrary number of these fields to exist.
    # If you are going to test the addition of multiple sections
    # and/or meetings, then their elements will have to be
    # explicitly called or defined in the test scripts themselves.
    text_field(:name, :id=>"addSectionsForm:sectionTable:0:titleInput", :frame=>frame)
    radio_button(:unlimited_size, :name=>"addSectionsForm:sectionTable:0:limit", :index=>0, :frame=>frame)
    radio_button(:limited_size, :name=>"addSectionsForm:sectionTable:0:limit", :index=>1, :frame=>frame)
    text_field(:max_enrollment, :id=>"addSectionsForm:sectionTable:0:maxEnrollmentInput", :frame=>frame)
    checkbox(:monday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:monday", :frame=>frame)
    checkbox(:tuesday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:tuesday", :frame=>frame)
    checkbox(:wednesday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:wednesday", :frame=>frame)
    checkbox(:thursday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:thursday", :frame=>frame)
    checkbox(:friday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:friday", :frame=>frame)
    checkbox(:saturday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:saturday", :frame=>frame)
    checkbox(:sunday, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:sunday", :frame=>frame)
    text_field(:start_time, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTime", :frame=>frame)
    radio_button(:start_am, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>0, :frame=>frame)
    radio_button(:start_pm, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>1, :frame=>frame)
    text_field(:end_time, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTime", :frame=>frame)
    radio_button(:end_am, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>0, :frame=>frame)
    radio_button(:end_pm, :name=>"addSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>1, :frame=>frame)
    text_field(:location, :id=>"addSectionsForm:sectionTable:0:meetingsTable:0:location", :frame=>frame)
    link(:add_days, :id=>"addSectionsForm:sectionTable:0:addMeeting", :frame=>frame)
    
  end

end


# Exactly like the Add Sections page, but used when editing an existing section
class EditSections
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:overview, :id=>"editSectionsForm:_idJsp3", :frame=>frame)
    link(:student_memberships, :id=>"editSectionsForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"editSectionsForm:_idJsp17", :frame=>frame)
    select_list(:num_to_add, :id=>"editSectionsForm:numToAdd", :frame=>frame)
    select_list(:category, :id=>"editSectionsForm:category", :frame=>frame)
    button(:add_sections, :id=>"editSectionsForm:_idJsp89", :frame=>frame)
    button(:cancel, :id=>"editSectionsForm:_idJsp90", :frame=>frame)
    
    # Note that the following field definitions are appropriate for
    # ONLY THE FIRST instance of each of the fields. The Edit Sections page
    # allows for an arbitrary number of these fields to exist.
    # If you are going to test the editing of multiple sections
    # and/or meetings, then their elements will have to be
    # explicitly called or defined in the test scripts themselves.
    text_field(:name, :id=>"editSectionsForm:sectionTable:0:titleInput", :frame=>frame)
    radio_button(:unlimited_size, :name=>"editSectionsForm:sectionTable:0:limit", :index=>0, :frame=>frame)
    radio_button(:limited_size, :name=>"editSectionsForm:sectionTable:0:limit", :index=>1, :frame=>frame)
    text_field(:max_enrollment, :id=>"editSectionsForm:sectionTable:0:maxEnrollmentInput", :frame=>frame)
    checkbox(:monday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:monday", :frame=>frame)
    checkbox(:tuesday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:tuesday", :frame=>frame)
    checkbox(:wednesday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:wednesday", :frame=>frame)
    checkbox(:thursday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:thursday", :frame=>frame)
    checkbox(:friday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:friday", :frame=>frame)
    checkbox(:saturday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:saturday", :frame=>frame)
    checkbox(:sunday, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:sunday", :frame=>frame)
    text_field(:start_time, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTime", :frame=>frame)
    radio_button(:start_am, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>0, :frame=>frame)
    radio_button(:start_pm, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:startTimeAm", :index=>1, :frame=>frame)
    text_field(:end_time, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTime", :frame=>frame)
    radio_button(:end_am, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>0, :frame=>frame)
    radio_button(:end_pm, :name=>"editSectionsForm:sectionTable:0:meetingsTable:0:endTimeAm", :index=>1, :frame=>frame)
    text_field(:location, :id=>"editSectionsForm:sectionTable:0:meetingsTable:0:location", :frame=>frame)
    link(:add_days, :id=>"editSectionsForm:sectionTable:0:addMeeting", :frame=>frame)
    
  end

end

# Options page for Sections
class SectionsOptions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    checkbox(:students_can_sign_up, :id=>"optionsForm:selfRegister", :frame=>frame)
    checkbox(:students_can_switch_sections, :id=>"optionsForm:selfSwitch", :frame=>frame)
    button(:update, :id=>"optionsForm:_idJsp50", :frame=>frame)
    button(:cancel, :id=>"optionsForm:_idJsp51", :frame=>frame)
    link(:overview, :id=>"optionsForm:_idJsp3", :frame=>frame)
    link(:add_sections, :id=>"optionsForm:_idJsp8", :frame=>frame)
    link(:student_memberships, :id=>"optionsForm:_idJsp12", :frame=>frame)
    
  end

end

# The Sections page
# found in the SITE MANAGEMENT menu for a Site
class SectionsOverview
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:add_sections, :id=>"overviewForm:_idJsp8", :frame=>frame)
    link(:student_memberships, :id=>"overviewForm:_idJsp12", :frame=>frame)
    link(:options, :id=>"overviewForm:_idJsp17", :frame=>frame)
    link(:sort_name, :id=>"overviewForm:sectionsTable:_idJsp54", :frame=>frame)
    link(:sort_ta, :id=>"overviewForm:sectionsTable:_idJsp73", :frame=>frame)
    link(:sort_day, :id=>"overviewForm:sectionsTable:_idJsp78", :frame=>frame)
    link(:sort_time, :id=>"overviewForm:sectionsTable:_idJsp83", :frame=>frame)
    link(:sort_location, :id=>"overviewForm:sectionsTable:_idJsp88", :frame=>frame)
    link(:sort_current_size, :id=>"overviewForm:sectionsTable:_idJsp93", :frame=>frame)
    link(:sort_avail, :id=>"overviewForm:sectionsTable:_idJsp97", :frame=>frame)
    
  end

end

#================
# Sites Page - from Administration Workspace
#================

# Sites page - arrived at via the link with class="icon-sakai-sites"
class Sites
  
  include PageObject
  include ToolsMenu
  
  # Clicks the first site Id link
  # listed. Useful when you've run a search and
  # you're certain you've got the result you want.
  # It then instantiates the EditSiteInfo page class.
  def click_top_item
    frm.link(:href, /#{Regexp.escape("&panel=Main&sakai_action=doEdit")}/).click
    EditSiteInfo.new(@browser)
  end
  
  # Clicks the specified Site in the list, using the
  # specified id value to determine which item to click.
  # It then instantiates the EditSiteInfo page class.
  # Use this method when you know the target site ID.
  def edit_site_id(id)
    frm.text_field(:id=>"search_site").value=id
    frm.link(:text=>"Site ID").click
    frm.link(:text, id).click
    EditSiteInfo.new(@browser)
  end
  
  # Clicks the New Site button, then instantiates
  # the EditSiteInfo page class.
  def new_site
    frm.link(:text, "New Site").click
    EditSiteInfo.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    text_field(:search_field, :id=>"search", :frame=>frame)
    link(:search_button, :text=>"Search", :frame=>frame)
    text_field(:search_site_id, :id=>"search_site", :frame=>frame)
    link(:search_site_id_button, :text=>"Site ID", :frame=>frame)
    text_field(:search_user_id, :id=>"search_user", :frame=>frame)
    link(:search_user_id_button, :text=>"User ID", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# Page that appears when you've clicked a Site ID in the
# Sites section of the Administration Workspace.
class EditSiteInfo
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Remove Site button, then instantiates
  # the RemoveSite page class.
  def remove_site
    frm.link(:text, "Remove Site").click
    RemoveSite.new(@browser)
  end
  
  # Clicks the Save button, then instantiates the Sites
  # page class.
  def save
    frm.button(:value=>"Save").click
    Sites.new(@browser)
  end
  
  # Clicks the Save As link, then instantiates
  # the SiteSaveAs page class.
  def save_as
    frm.link(:text, "Save As").click
    SiteSaveAs.new(@browser)
  end
  
  # Gets the Site ID from the page.
  def site_id_read_only
    @browser.frame(:index=>0).table(:class=>"itemSummary").td(:class=>"shorttext", :index=>0).text
  end
  
  # Enters the specified text string in the text area of
  # the FCKEditor.
  def description=(text)
    editor.td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  # The FCKEditor object. Use this object for
  # wait commands when the site is slow
  def editor
    @browser.frame(:index=>0).frame(:id, "description___Frame")
  end
  
  # Clicks the Properties button on the page,
  # then instantiates the AddEditSiteProperties
  # page class.
  def properties
    frm.button(:value=>"Properties").click
    AddEditSiteProperties.new(@browser)
  end
  
  # Clicks the Pages button, then instantiates
  # the AddEditPages page class.
  def pages
    frm.button(:value=>"Pages").click
    AddEditPages.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # Non-navigating, interactive page objects go here
    text_field(:site_id, :id=>"id", :frame=>frame)
    text_field(:title, :id=>"title", :frame=>frame)
    text_field(:type, :id=>"type", :frame=>frame)
    text_area(:short_description, :id=>"shortDescription", :frame=>frame)
    radio_button(:unpublished, :id=>"publishedfalse", :frame=>frame)
    radio_button(:published, :id=>"publishedtrue", :frame=>frame)
    radio_button(:public_view_yes, :id=>"pubViewtrue", :frame=>frame)
  end
  
end

# The page you come to when editing a Site in Sites
# and you click on the Pages button
class AddEditPages
  
  include PageObject
  include ToolsMenu
  
  # Clicks the link for New Page, then
  # instantiates the NewPage page class.
  def new_page
    frm.link(:text=>"New Page").click
    NewPage.new(@browser)
  end

end

# Page for adding a new page to a Site.
class NewPage
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Tools button, then instantiates
  # the AddEditTools class.
  def tools
    frm.button(:value=>"Tools").click
    AddEditTools.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    text_field(:title, :id=>"title", :frame=>frame)
  end

end

# Page when editing a Site and adding/editing tools for pages.
class AddEditTools
  
  include PageObject
  include ToolsMenu
  
  # Clicks the New Tool link, then instantiates
  # the NewTool class.
  def new_tool
    frm.link(:text=>"New Tool").click
    NewTool.new(@browser)
  end
  
  # Clicks the Save button, then
  # instantiates the AddEditPages class.
  def save
    frm.button(:value=>"Save").click
    AddEditPages.new(@browser)
  end

end

# Page for creating a new tool for a page in a site
class NewTool
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Done button, the instantiates
  # The AddEditTools class.
  def done
    frm.button(:value=>"Done").click
    AddEditTools.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    text_field(:title, :id=>"title", :frame=>frame)
    text_field(:layout_hints, :id=>"layoutHints", :frame=>frame)
    radio_button(:resources, :id=>"feature80", :frame=>frame)
  end
  
end

# Page that appears when you click "Remove Site" when editing a Site in Sites
class RemoveSite
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Remove button, then
  # instantiates the Sites class.
  def remove
    frm.button(:value=>"Remove").click
    Sites.new(@browser)
  end
  
end

# Page that appears when you click "Save As" when editing a Site in Sites
class SiteSaveAs
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Save button, then
  # instantiates the Sites class.
  def save
    frm.button(:value, "Save").click
    Sites.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:site_id, :id=>"id", :frame=>frame)
  end
  
end

class AddEditSiteProperties
  
  include PageObject
  include ToolsMenu
  
  # Clicks the New Property button
  def new_property
    frm.button(:value=>"New Property").click
    #Class.new(@browser)
  end
  
  # Clicks the Done button, then instantiates
  # the EditSiteInfo class.
  def done
    frm.button(:value=>"Done").click
    EditSiteInfo.new(@browser)
  end
  
  # Clicks the Save button, then instantiates
  # the Sites page class.
  def save
    frm.button(:value=>"Save").click
    Sites.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:name, :id=>"new_name", :frame=>frame)
    text_field(:value, :id=>"new_value", :frame=>frame)
  end
end



#================
# User's Account Page - in "My Settings"
#================

# The Page for editing User Account details
class EditAccount
  
  include PageObject
  include ToolsMenu
  
  # Clicks the update details button then
  # makes sure there isn't any error message present.
  # If there is, it reinstantiates the Edit Account Class,
  # otherwise it instantiates the UserAccount Class.
  def update_details
    frm.button(:value=>"Update Details").click
    # Need to check if the update took...
    if frm.div(:class=>"portletBody").h3.text=="My Account Details"
      # Apparently it did...
      UserAccount.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Account Details"
      # We are on the edit page (or we're using the Admin account)...
      EditAccount.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Users"
      Users.new(@browser)
    end
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:current_password, :id=>"pwcur", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
  end
  
end

# A Non-Admin User's Account page
# Accessible via the "Account" link in "MY SETTINGS"
#
# IMPORTANT: this class does not use PageObject or the ToolsMenu!!
# So, the only available method to navigate away from this page is
# Home. Otherwise, you'll have to call the navigation link
# Explicitly in the test case itself.
#
# Objects and methods used in this class must be explicitly
# defined using Watir and Ruby code.
#
# Do NOT use the PageObject syntax in this class.
class UserAccount
  
  def initialize(browser)
    @browser = browser
  end

  # Clicks the Modify Details button. Instantiates the EditAccount class.
  def modify_details
    @browser.frame(:index=>0).button(:name=>"eventSubmit_doModify").click
    EditAccount.new(@browser)
  end
  
  # Gets the text of the User ID field.
  def user_id
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[0][1].text
  end
  
  # Gets the text of the First Name field.
  def first_name
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[1][1].text
  end
  
  # Gets the text of the Last Name field.
  def last_name
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[2][1].text
  end
  
  # Gets the text of the Email field.
  def email
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[3][1].text
  end
  
  # Gets the text of the Type field.
  def type
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[4][1].text
  end
  
  # Gets the text of the Created By field.
  def created_by
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[0][1].text
  end
  
  # Gets the text of the Created field.
  def created
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[1][1].text
  end
  
  # Gets the text of the Modified By field.
  def modified_by
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[2][1].text
  end
  
  # Gets the text of the Modified (date) field.
  def modified
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[3][1].text
  end
  
  # Clicks the Home buton in the left menu.
  # instantiates the Home Class.
  def home
    @browser.link(:text, "Home").click
    Home.new(@browser)
  end

end

#================
# Users Pages - From the Workspace
#================

# The Page for editing User Account details
class EditUser
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:remove_user, :text=>"Remove User", :frame=>frame)
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
    button(:update_details, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel_changes, :name=>"eventSubmit_doCancel", :frame=>frame)
  end
  
end

# The Users page - "icon-sakai-users"
class Users
  
  include PageObject
  include ToolsMenu
  
  def new_user
    frm.link(:text=>"New User").click
    CreateNewUser.new @browser
  end
  
  # Returns the contents of the Name cell
  # based on the specified user ID value.
  def name(user_id)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[1].text
  end
  
  # Returns the contents of the Email cell
  # based on the specified user ID value.
  def email(user_id)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[2].text
  end
  
  # Returns the contents of the Type cell
  # based on the specified user ID value.
  def type(user_id)
    frm.table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(user_id)}/i)[3].text
  end
  
  def search_button
    frm.link(:text=>"Search").click
    frm.table(:class=>"listHier lines").wait_until_present
    Users.new @browser
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:clear_search, :text=>"Clear Search", :frame=>frame)
    text_field(:search_field, :id=>"search", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end
  
end

# The Create New User page
class CreateNewUser
  
  include PageObject
  include ToolsMenu
  
  def save_details
    frm.button(:name=>"eventSubmit_doSave").click
    Users.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:user_id, :id=>"eid", :frame=>frame)
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
    select_list(:type, :name=>"type", :frame=>frame)
    button(:cancel_changes, :name=>"eventSubmit_doCancel", :frame=>frame)
  end
  
end


#================
# User Membership Pages from Administration Workspace
#================

# User Membership page for admin users - "icon-sakai-usermembership"
class UserMembership
  
  include PageObject
  include ToolsMenu
  
  # Returns an array containing the user names displayed in the search results.
  def names
    names = []
    frm.table(:class=>/listHier/).rows.each do |row|
      names << row[2].text
    end
    names.delete_at(0)
    return names
  end
  
  # Returns the user id of the specified user (assuming that person
  # appears in the search results list, otherwise this method will
  # throw an error.)
  def user_id(name)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(name)}/)[0].text
  end
  
  # Returns the user type of the specified user (assuming that person
  # appears in the search results list, otherwise this method will
  # throw an error.)
  def type(name)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(name)}/)[4].text
  end

  # Returns the text contents of the "instruction" paragraph that
  # appears when there are no search results.
  def alert_text
    frm.p(:class=>"instruction").text
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    select_list(:user_type, :id=>"userlistForm:selectType", :frame=>frame)
    select_list(:user_authority, :id=>"userlistForm:selectAuthority", :frame=>frame)
    text_field(:search_field, :id=>"userlistForm:inputSearchBox", :frame=>frame)
    button(:search, :id=>"userlistForm:searchButton", :frame=>frame)
    button(:clear_search, :id=>"userlistForm:clearSearchButton", :frame=>frame)
    select_list(:page_size, :id=>"userlistForm:pager_pageSize", :frame=>frame)
    button(:export_csv, :id=>"userlistForm:exportCsv", :frame=>frame)
    button(:export_excel, :id=>"userlistForm:exportXls", :frame=>frame)
    link(:sort_user_id, :id=>"userlistForm:_idJsp13:_idJsp14", :frame=>frame)
    link(:sort_internal_user_id, :id=>"userlistForm:_idJsp13:_idJsp18", :frame=>frame)
    link(:sort_name, :id=>"userlistForm:_idJsp13:_idJsp21", :frame=>frame)
    link(:sort_email, :id=>"userlistForm:_idJsp13:_idJsp24", :frame=>frame)
    link(:sort_type, :id=>"userlistForm:_idJsp13:_idJsp28", :frame=>frame)
    link(:sort_authority, :id=>"userlistForm:_idJsp13:_idJsp31", :frame=>frame)
    link(:sort_created_on, :id=>"userlistForm:_idJsp13:_idJsp34", :frame=>frame)
    link(:sort_modified_on, :id=>"userlistForm:_idJsp13:_idJsp37", :frame=>frame)
    #(:, =>"", :frame=>frame)
    
  end

end

#================
# Job Scheduler pages in Admin Workspace
#================

# The topmost page in the Job Scheduler in Admin Workspace
class JobScheduler
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Jobs link, then instantiates
  # the JobList Class.
  def jobs
    frm.link(:text=>"Jobs").click
    JobList.new(@browser)
  end
  
end

# The list of Jobs (click the Jobs button on Job Scheduler)
class JobList
  
  include PageObject
  include ToolsMenu
  
  # Clicks the New Job link, then
  # instantiates the CreateNewJob Class.
  def new_job
    frm.link(:text=>"New Job").click
    CreateNewJob.new(@browser)
  end
  
  # Clicks the link with the text "Triggers" associated with the
  # specified job name, 
  # then instantiates the EditTriggers Class.
  def triggers(job_name)
    frm.div(:class=>"portletBody").table(:class=>"listHier lines").row(:text=>/#{Regexp.escape(job_name)}/).link(:text=>/Triggers/).click
    sleep 1
    EditTriggers.new(@browser)
  end
  
  def event_log
    frm.link(:text=>"Event Log").click
    EventLog.new(@browser)
  end
  
end

# The Create New Job page
class CreateNewJob
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Post button, then
  # instantiates the JobList Class.
  def post
    frm.button(:value=>"Post").click
    JobList.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:job_name, :id=>"_id2:job_name", :frame=>frame)
    select_list(:type, :name=>"_id2:_id10", :frame=>frame)
  end
end

# The page for Editing Triggers
class EditTriggers
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Run Job Now" link, then
  # instantiates the RunJobConfirmation Class.
  def run_job_now
    frm.div(:class=>"portletBody").link(:text=>"Run Job Now").click
    RunJobConfirmation.new(@browser)
  end
  
  def return_to_jobs
    frm.link(:text=>"Return_to_Jobs").click
    JobList.new(@browser)
  end
  
  def new_trigger
    frm.link(:text=>"New Trigger").click
    CreateTrigger.new(@browser)
  end

end

# The Create Trigger page
class CreateTrigger
  
  include PageObject
  include ToolsMenu
  
  def post
    frm.button(:value=>"Post").click
    EditTriggers.new(@browser)
  end

  in_frame(:index=>0) do |frame|
    text_field(:name, :id=>"_id2:trigger_name", :frame=>frame)
    text_field(:cron_expression, :id=>"_id2:trigger_expression", :frame=>frame)
  end
end


# The page for confirming you want to run a job
class RunJobConfirmation
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Run Now" button, then
  # instantiates the JobList Class.
  def run_now
    frm.button(:value=>"Run Now").click
    JobList.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    #(:, =>"", :frame=>frame)
  end
end

# The page containing the Event Log
class EventLog
  
  include PageObject
  include ToolsMenu

end
