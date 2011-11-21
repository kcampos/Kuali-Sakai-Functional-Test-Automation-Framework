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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
end

# The page where you search for public courses and projects.
class SearchPublic
  
  include ToolsMenu
  
  def home
    @browser.frame(:index=>0).link(:text=>"Home").click
    Login.new(@browser)
  end
  
  def search_for=(string)
    @browser.frame(:index=>0).text_field(:id=>"searchbox").set(string)
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
    @browser.frame(:index=>0).frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
    text_field(:name, :id=>"new_name", :frame=>frame)
    text_field(:value, :id=>"new_value", :frame=>frame)
  end
end


#================
# Site Setup Pages in the Workspace
#================

# Page for Adding Participants to a Site in Site Setup
class SiteSetupAddParticipants
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    text_area(:official_participants, :id=>"content::officialAccountParticipant", :frame=>frame)
    text_area(:non_official_participants, :id=>"content::nonOfficialAccountParticipant", :frame=>frame)
    radio_button(:assign_all_to_same_role, :id=>"content::role-row:0:role-select", :frame=>frame)
    radio_button(:assign_each_individually, :id=>"content::role-row:1:role-select", :frame=>frame)
    radio_button(:active_status, :id=>"content::status-row:0:status-select", :frame=>frame)
    radio_button(:inactive_status, :id=>"content::status-row:1:status-select", :frame=>frame)
    button(:continue, :id=>"content::continue", :frame=>frame)
    button(:cancel, :id=>"content::cancel", :frame=>frame)
    
  end

end

# Page for selecting Participant roles individually
class SiteSetupChooseRolesIndiv
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    button(:continue, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processDifferentRoleContinue", :frame=>frame)
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processDifferentRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    select_list(:user_role, :id=>"content::user-row:0:role-select-selection", :frame=>frame)
    # Note the remaining select lists are not defined here
    # because we can't know beforehand how many there will be
  end

end

# Page for selecting the same role for All
class SiteSetupChooseRole
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    button(:continue, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processSameRoleContinue", :frame=>frame)
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processSameRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    radio_button(:guest, :id=>"content::role-row:0:role-select", :frame=>frame)
    radio_button(:instructor, :id=>"content::role-row:1:role-select", :frame=>frame)
    radio_button(:student, :id=>"content::role-row:2:role-select", :frame=>frame)
    radio_button(:teaching_assistant, :id=>"content::role-row:3:role-select", :frame=>frame)
  end

end

# Page for specifying whether to send an email
# notification to the newly added Site participants
class SiteSetupParticipantEmail
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    button(:continue, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiContinue", :frame=>frame)
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processEmailNotiCancel", :frame=>frame)
    radio_button(:send_now, :id=>"content::noti-row:0:noti-select", :frame=>frame)
    radio_button(:dont_send, :id=>"content::noti-row:1:noti-select", :frame=>frame)
    
  end

end

# The confirmation page showing site participants and their set roles
class SiteSetupParticipantConfirmation
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    button(:finish, :name=>"command link parameters&Submitting%20control=content%3A%3Acontinue&Fast%20track%20action=siteAddParticipantHandler.processConfirmContinue", :frame=>frame)
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmCancel", :frame=>frame)
  end
end

# The page for Editing existing sites in the Administrator's Site Setup
class SiteSetupEdit
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Edit Tools link, then
  # instantiates the EditSiteTools class.
  def edit_tools
    frm.link(:text=>"Edit Tools").click
    EditSiteTools.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    link(:edit_site_information, :text=>"Edit Site Information", :frame=>frame)
    link(:add_participants, :text=>"Add Participants", :frame=>frame)
    link(:edit_class_rosters, :text=>"Edit Class Roster(s)", :frame=>frame)
    link(:manage_groups, :text=>"Manage Groups", :frame=>frame)
    link(:link_to_parent_site, :text=>"Link to Parent Site", :frame=>frame)
    link(:manage_access, :text=> "Manage Access", :frame=>frame)
    link(:duplicate_site, :text=>"Duplicate Site", :frame=>frame)
    link(:import_from_site, :text=>"Import from Site", :frame=>frame)
    link(:import_from_archive_file, :text=>"Import from Archive File", :frame=>frame)
    button(:previous, :name=>"previous", :frame=>frame)
    button(:return_to_sites_list, :name=>"", :frame=>frame)
    button(:next, :name=>"", :frame=>frame)
    link(:printable_version, :text=>"Printable Version", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    # Need to define read-only text field methods here.
    # Page Objects can do it. Need to research syntax, then fix it in other classes, too.
  end

end

# The Edit Tools page (click on "Edit Tools" when editing a site
# in Site Setup in the Admin Workspace)
class EditSiteTools

  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the appropriate class for the page that apears.
  def continue
    frm.button(:value=>"Continue").click
    # Logic for determining the new page class...
    if frm.div(:class=>"portletBody").text =~ /^Add Multiple Tool/
      AddMultipleTools.new(@browser)
    elsif frm.div(:class=>"portletBody").text =~ /^Confirming site tools edits for/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "Something is wrong"
      puts frm.div(:class=>"portletBody").text
    end
  end
  
  in_frame(:index=>0) do |frame|
    # This is a comprehensive list of all checkboxes and
    # radio buttons for this page, 
    # though not all will appear at one time.
    # The list will depend on the type of site being
    # created/edited.
    checkbox(:all_tools, :id=>"all", :frame=>frame)
    checkbox(:home, :id=>"home", :frame=>frame)
    checkbox(:announcements, :id=>"sakai.announcements", :frame=>frame)
    checkbox(:assignments, :id=>"sakai.assignment.grades", :frame=>frame)
    checkbox(:basic_lti, :id=>"sakai.basiclti", :frame=>frame)
    checkbox(:calendar, :id=>"sakai.schedule", :frame=>frame)
    checkbox(:email_archive, :id=>"sakai.mailbox", :frame=>frame)
    checkbox(:evaluations, :id=>"osp.evaluation", :frame=>frame)
    checkbox(:forms, :id=>"sakai.metaobj", :frame=>frame)
    checkbox(:glossary, :id=>"osp.glossary", :frame=>frame)
    checkbox(:matrices, :id=>"osp.matrix", :frame=>frame)
    checkbox(:news, :id=>"sakai.news", :frame=>frame)
    checkbox(:portfolio_layouts, :id=>"osp.presLayout", :frame=>frame)
    checkbox(:portfolio_showcase, :id=>"sakai.rsn.osp.iframe", :frame=>frame)
    checkbox(:portfolio_templates, :id=>"osp.presTemplate", :frame=>frame)
    checkbox(:portfolios, :id=>"osp.presentation", :frame=>frame)
    checkbox(:resources, :id=>"sakai.resources", :frame=>frame)
    checkbox(:roster, :id=>"sakai.site.roster", :frame=>frame)
    checkbox(:search, :id=>"sakai.search", :frame=>frame)
    checkbox(:styles, :id=>"osp.style", :frame=>frame)
    checkbox(:web_content, :id=>"sakai.iframe", :frame=>frame)
    checkbox(:wizards, :id=>"osp.wizard", :frame=>frame)
    checkbox(:blogger, :id=>"blogger", :frame=>frame)
    checkbox(:blogs, :id=>"sakai.blogwow", :frame=>frame)
    checkbox(:chat_room, :id=>"sakai.chat", :frame=>frame)
    checkbox(:discussion_forums, :id=>"sakai.jforum.tool", :frame=>frame)
    checkbox(:drop_box, :id=>"sakai.dropbox", :frame=>frame)
    checkbox(:email, :id=>"sakai.mailtool", :frame=>frame)
    checkbox(:forums, :id=>"sakai.forums", :frame=>frame)
    checkbox(:certification, :id=>"com.rsmart.certification", :frame=>frame)
    checkbox(:feedback, :id=>"sakai.postem", :frame=>frame)
    checkbox(:gradebook, :id=>"sakai.gradebook.tool", :frame=>frame)
    checkbox(:gradebook2, :id=>"sakai.gradebook.gwt.rpc", :frame=>frame)
    checkbox(:lesson_builder, :id=>"sakai.lessonbuildertool", :frame=>frame)
    checkbox(:lessons, :id=>"sakai.melete", :frame=>frame)
    checkbox(:live_virtual_classroom, :id=>"rsmart.virtual_classroom.tool", :frame=>frame)
    checkbox(:media_gallery, :id=>"sakai.kaltura", :frame=>frame)
    checkbox(:messages, :id=>"sakai.messages", :frame=>frame)
    checkbox(:news, :id=>"sakai.news", :frame=>frame)
    checkbox(:opensyllabus, :id=>"sakai.opensyllabus.tool", :frame=>frame)
    checkbox(:podcasts, :id=>"sakai.podcasts", :frame=>frame)
    checkbox(:polls, :id=>"sakai.poll", :frame=>frame)
    checkbox(:sections, :id=>"sakai.sections", :frame=>frame)
    checkbox(:site_editor, :id=>"sakai.siteinfo", :frame=>frame)
    checkbox(:site_statistics, :id=>"sakai.sitestats", :frame=>frame)
    checkbox(:syllabus, :id=>"sakai.syllabus", :frame=>frame)
    checkbox(:tests_and_quizzes_cb, :id=>"sakai.samigo", :frame=>frame)
    checkbox(:wiki, :id=>"sakai.rwiki", :frame=>frame)
    radio_button(:no_thanks, :id=>"import_no", :frame=>frame)
    radio_button(:yes, :id=>"import_yes", :frame=>frame)
    select_list(:import_sites, :id=>"importSites", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# Confirmation page when editing site tools in Site Setup
class ConfirmSiteToolsEdits
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Finish button, then instantiates
  # the SiteSetupEdit class.
  def finish
    frm.button(:value=>"Finish").click
    SiteSetupEdit.new(@browser)
  end
  
end

# The Site Setup page - a.k.a., link class=>"icon-sakai-sitesetup"
class SiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "New" link on the Site Setup page.
  # instantiates the SiteType class.
  def new
    frm.div(:class=>"portletBody").link(:text=>"New").click
    SiteType.new(@browser)
  end
  
  # Searches for the specified site, then
  # selects the specified Site's checkbox.
  # Then clicks the Edit button and instantiates
  # The SiteSetupEdit class.
  def edit(site_name)
    frm.text_field(:id, "search").value=Regexp.escape(site_name)
    frm.button(:value=>"Search").click
    frm.div(:class=>"portletBody").checkbox(:name=>"selectedMembers").set
    frm.div(:class=>"portletBody").link(:text, "Edit").click
    SiteSetupEdit.new(@browser)
  end

  # Enters the specified site name string in the search
  # field, clicks the Search button, then reinstantiates
  # the Class due to the page refresh.
  def search(site_name)
    frm.text_field(:id, "search").set site_name
    frm.button(:value, "Search").click
    SiteSetup.new(@browser)
  end

  # Searches for the specified site, then
  # checks the site, clicks the delete button,
  # and instantiates the DeleteSite class.
  def delete(site_name)
    frm.text_field(:id, "Search").value=site_name
    frm.button(:value=>"Search").click
    frm.checkbox(:name=>"selectedMembers").set
    frm.div(:class=>"portletBody").link(:text, "Delete").click
    DeleteSite.new(@browser)
  end
  
  # Returns an Array object containing strings of
  # all Site titles displayed on the web page.
  def site_titles
    titles = []
    sites_table = frm.table(:id=>"siteList")
    1.upto(sites_table.rows.size-1) do |x|
      titles << sites_table[x][1].text
    end
    return titles
  end
  
  in_frame(:class=>"portletMainIframe") do |frame| #FIXME!
    select_list(:view, :id=>"view", :frame=>frame)
    button(:clear_search, :value=>"Clear Search", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    link(:sort_by_title, :text=>"Worksite Title", :frame=>frame)
    link(:sort_by_type, :text=>"Type", :frame=>frame)
    link(:sort_by_creator, :text=>"Creator", :frame=>frame)
    link(:sort_by_status, :text=>"Status", :frame=>frame)
    link(:sort_by_creation_date, :text=>"Creation Date", :frame=>frame)
  end

end

# The Delete Confirmation Page for deleting a Site
class DeleteSite
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Remove button, then instantiates
  # the SiteSetup class.
  def remove
    frm.button(:value=>"Remove").click
    SiteSetup.new(@browser)
  end
  
  # Clicks the Cancel button, then instantiates
  # the SiteSetup class.
  def cancel
    frm.button(:value=>"Cancel").click
    SiteSetup.new(@browser)
  end
  
end
#The Site Type page that appears when creating a new site
class SiteType
  
  include PageObject
  include ToolsMenu
  
  # The page's Continue button. Button gets
  # clicked and then the appropriate class
  # gets instantiated, based on the page that
  # appears.
  def continue #FIXME
    if frm.button(:id, "submitBuildOwn").enabled?
      frm.button(:id, "submitBuildOwn").click
    elsif frm.button(:id, "submitFromTemplateCourse").enabled?
      frm.button(:id, "submitFromTemplateCourse").click
    elsif frm.button(:id, "submitFromTemplate").enabled?
      frm.button(:id, "submitFromTemplate").click
=begin
    elsif frm.button(:value=>"Continue", :index=>$frame_index).enabled?
      frm.button(:value=>"Continue", :index=>$frame_index).fire_event("onclick")
    elsif frm.button(:value=>"Continue", :index=>$frame_index).enabled?
      frm.button(:value=>"Continue", :index=>$frame_index).fire_event("onclick")
    elsif frm.button(:value=>"Continue", :index=>2).enabled?
      frm.button(:value=>"Continue", :index=>2).fire_event("onclick")
    else
      frm.button(:value=>"Continue", :index=>2).fire_event("onclick")
=end
    end
    
    if frm.div(:class=>"portletBody").h3.text=="Course/Section Information"
      CourseSectionInfo.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Project Site Information"
      ProjectSiteInfo.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Portfolio Site Information"
      PortfolioSiteInfo.new(@browser)
    else
      puts "Something is wrong on Saturn 3"
    end
  end
  
  in_frame(:index=>0) do |frame|
    radio_button(:course_site, :id=>"course", :frame=>frame)
    radio_button(:project_site, :id=>"project", :frame=>frame)
    radio_button(:portfolio_site, :id=>"portfolio", :frame=>frame)
    radio_button(:create_site_from_template, :id=>"copy", :frame=>frame)
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
    select_list(:select_template, :id=>"templateSiteId", :frame=>frame)
    select_list(:select_term, :id=>"selectTermTemplate", :frame=>frame)
    button(:cancel, :id=>"cancelCreate", :frame=>frame)
    checkbox(:copy_users, :id=>"copyUsers", :frame=>frame)
    checkbox(:copy_content, :id=>"copyContent", :frame=>frame)
  end
  
  
end

# The Add Multiple Tool Instances page that appears during Site creation
# after the Course Site Tools page
class AddMultipleTools
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the appropriate Class, based on the page that
  # appears.
  def continue
    frm.button(:value=>"Continue").click
    # Logic to determine the new page class
    if frm.div(:class=>"portletBody").text =~ /Course Site Access/
      CourseSiteAccess.new(@browser)
    elsif frm.div(:class=>"portletBody").text =~ /^Confirming site tools edits/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "There's another path to define"
    end
  end

  in_frame(:index=>0) do |frame|
    # Note that the text field definitions included here
    # for the Tools definitions are ONLY for the first
    # instances of each. Since the UI allows for
    # an arbitrary number, if you are writing tests
    # that add more then you're going to have to explicitly
    # reference them or define them in the test case script
    # itself--for now, anyway.
    text_field(:site_email_address, :id=>"emailId", :frame=>frame)
    text_field(:basic_lti_title, :id=>"title_sakai.basiclti", :frame=>frame)
    select_list(:more_basic_lti_tools, :id=>"num_sakai.basiclti", :frame=>frame)
    text_field(:lesson_builder_title, :id=>"title_sakai.lessonbuildertool", :frame=>frame)
    select_list(:more_lesson_builder_tools, :id=>"num_sakai.lessonbuildertool", :frame=>frame)
    text_field(:news_title, :id=>"title_sakai.news", :frame=>frame)
    text_field(:news_url_channel, :name=>"channel-url_sakai.news", :frame=>frame)
    select_list(:more_news_tools, :id=>"num_sakai.news", :frame=>frame)
    text_field(:web_content_title, :id=>"title_sakai.iframe", :frame=>frame)
    text_field(:web_content_source, :id=>"source_sakai.iframe", :frame=>frame)
    select_list(:more_web_content_tools, :id=>"num_sakai.iframe", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
    
  end
  
end

# The Course/Section Information page that appears when creating a new Site
class CourseSectionInfo
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then instantiates
  # the CourseSiteInfo Class.
  def continue
    frm.button(:value=>"Continue").click
    CourseSiteInfo.new(@browser)
  end
  
  # Clicks the Done button (or the
  # "Done - go to Site" button if it
  # happens to be there), then instantiates
  # the SiteSetup Class.
  def done
    frm.button(:value=>/Done/).click
    SiteSetup.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    # Note that ONLY THE FIRST instances of the
    # subject, course, and section fields
    # are included in the page elements definitions here,
    # because their identifiers are dependent on how
    # many instances exist on the page.
    # This means that if you need to access the second
    # or subsequent of these elements, you'll need to
    # explicitly identify/define them in the test case
    # itself.
    text_field(:subject, :name=>"Subject:0", :frame=>frame)
    text_field(:course, :name=>"Course:0", :frame=>frame)
    text_field(:section, :name=>"Section:0", :frame=>frame)
    text_field(:authorizers_username, :id=>"uniqname", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    select_list(:add_more_rosters, :id=>"number", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Course Site Access Page that appears during Site creation
# immediately following the Add Multiple Tools page.
class CourseSiteAccess
  
  include PageObject
  include ToolsMenu
  
  # The page element that displays the joiner role
  # select list. Use this method to validate whether the
  # select list is visible or not.
  #
  # Example: page.joiner_role_div.visible?
  def joiner_role_div
    frm.div(:id=>"joinerrole")
  end
  
  # Clicks the Continue button, then
  # instantiates the ConfirmCourseSiteSetup class.
  def continue
    frm.button(:value=>"Continue").click
    ConfirmCourseSiteSetup.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    radio_button(:publish_site, :id=>"publish", :frame=>frame)
    radio_button(:leave_as_draft, :id=>"unpublish", :frame=>frame)
    radio_button(:limited, :id=>"unjoinable", :frame=>frame)
    radio_button(:allow, :id=>"joinable", :frame=>frame)
    button(:back, :name=>"eventSubmit_doBack", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel_create", :frame=>frame)
    select_list(:joiner_role, :id=>"joinerRole", :frame=>frame)
  end

end

# The Confirmation page at the end of a Course Site Setup
class ConfirmCourseSiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Request Site button, then
  # instantiates the SiteSetup Class.
  def request_site
    frm.button(:value=>"Request Site").click
    SiteSetup.new(@browser)
  end
  
end

# The Course Site Information page that appears when creating a new Site
# immediately after the Course/Section Information page
class CourseSiteInfo
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button, then
  # instantiates the EditSiteTools Class.
  def continue
    frm.button(:value=>"Continue").click
    EditSiteTools.new(@browser)
  end
  
  # Gets the text contained in the alert box
  # on the web page.
  def alert_box_text
    frm.div(:class=>"portletBody").div(:class=>"alertMessage").text
  end
  
  in_frame(:index=>0) do |frame|
    text_field(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
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
    if frm.div(:class=>"alertMessage").exist?
      EditAccount.new(@browser)
    else
      UserAccount.new(@browser)
    end
  end
  
  in_frame(:index=>0) do |frame|
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
    link(:new_user, :text=>"New User", :frame=>frame)
    link(:search_button, :text=>"Search", :frame=>frame)
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
  
  in_frame(:index=>0) do |frame|
    text_field(:user_id, :id=>"eid", :frame=>frame)
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
    select_list(:type, :name=>"type", :frame=>frame)
    button(:save_details, :name=>"eventSubmit_doSave", :frame=>frame)
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
  
  in_frame(:index=>0) do |frame|
    select_list(:user_type, :id=>"userlistForm:selectType", :frame=>frame)
    select_list(:user_authority, :id=>"userlistForm:selectAuthority", :frame=>frame)
    text_field(:search_field, :id=>"userlistForm:inputSearchBox", :frame=>frame)
    button(:search_button, :id=>"userlistForm:searchButton", :frame=>frame)
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
  
  in_frame(:index=>0) do |frame|
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
