# Page classes that are in some way common to both
# the Site context and the My Workspace context.
# 
# == Synopsis
#
# This script defines the page classes that are
# common to both page contexts--within a Site or within My Workspace.
#
# Author :: Abe Heward (aheward@rsmart.com)

#require File.dirname(__FILE__) + '/app_functions.rb'



#================
# Evaluation System Pages
#================

# The "Evaluations Dashboard"
class EvaluationSystem
  
  include PageObject
  include ToolsMenu
  
  def my_templates
    frm.link(:text=>"My Templates").click
    MyTemplates.new(@browser)
  end
  
  def add_template
    frm.link(:text=>"Add Template").click
    AddTemplateTitle.new(@browser)
  end

  def take_evaluation(evaluation_name)
    frm.div(:class=>"summaryBox").table(:text=>/#{Regexp.escape(evaluation_name)}/).link.click
    TakeEvaluation.new(@browser)
  end
  
  def status_of(evaluation_name)
    return frm.div(:class=>"summaryBox").table(:text=>/#{Regexp.escape(evaluation_name)}/)[1][1].text
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddTemplateTitle
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    EditTemplate.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
    text_area(:description, :id=>"description", :frame=>frame)
  end
end

# 
class EditTemplate
  
  include PageObject
  include ToolsMenu
  
  def item_text=(text)
    frm.frame(:id, "item-text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def new_evaluation
    frm.link(:text=>"New evaluation").click
    frm.frame(:id, "instructions:1:input___Frame").td(:id, "xEditingArea").wait_until_present
    NewEvaluation.new(@browser)
  end

  def add
    frm.button(:value=>"Add").click
    frm.frame(:id, "item-text___Frame").td(:id, "xEditingArea").wait_until_present
  end
  
  def save_item
    frm.button(:value=>"Save item").click
    frm.link(:text=>"New evaluation").wait_until_present
    EditTemplate.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    select_list(:item, :id=>"add-item-control::add-item-classification-selection", :frame=>frame)
  end
end

# 
class NewEvaluation
  
  include PageObject
  include ToolsMenu
  
  def continue_to_settings
    frm.button(:value=>"Continue to Settings").click
    EvaluationSettings.new(@browser)
  end
  
  def instructions=(text)
    frm.frame(:id, "instructions:1:input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
  end
end

# 
class EvaluationSettings
  
  include PageObject
  include ToolsMenu

  def continue_to_assign_to_courses
    frm.button(:value=>"Continue to Assign to Courses").click
    EditEvaluationAssignment.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class EditEvaluationAssignment
  
  include PageObject
  include ToolsMenu
  
  def save_assigned_groups
    frm.button(:value=>"Save Assigned Groups").click
    ConfirmEvaluation.new(@browser)
  end

  def check_group(title)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(title)}/).checkbox(:name=>"selectedGroupIDs").set
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

#
class ConfirmEvaluation
  
  include PageObject
  include ToolsMenu
  
  def done
    frm.button(:value=>"Done").click
    MyEvaluations.new(@browser)
  end

end

# 
class MyEvaluations
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class TakeEvaluation
  
  include PageObject
  include ToolsMenu
  
  def submit_evaluation
    frm.button(:value=>"Submit Evaluation").click
    EvaluationSystem.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
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
  in_frame(:class=>"portletMainIframe") do |frame|
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
  
  # Returns an array of strings of the Calendar Events listed below
  # the Calendar
  def calendar_events
    events = []
    table = @browser.frame(:class=>"portletMainIframe", :index=>2).table(:id=>"calendarForm:datalist_event_list")
    table.wait_until_present
    table.rows.each do |row|
      events << row.link.text
    end
    return events
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

# New class template. For quick class creation...
class ResourcesUploadFiles
  
  include ToolsMenu
  
  @@filex=0
  
  # Enters the specified folder/filename value into
  # the file field on the page. Note that files are
  # assumed to be in the relative path ../../data/sakai-cle-test-api
  # The method will throw an error if the specified file
  # is not found.
  # 
  # This method is designed to be able to use
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path="")
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
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

# Resources page for a given Site, in the Course Tools menu
class Resources < AddFiles

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this=>             "Resources",
      :parent =>          "Resources",
      :file_details =>    "EditFileDetails",
      :create_folders =>  "CreateFolders",
      :upload_files =>    "ResourcesUploadFiles"
    }
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

#================
# Site Setup/Site Editor Pages
#================

# This module contains the methods referring to the menu items
# across the top of all the Site Editor pages.
module SiteEditorMenu
  
  # Clicks the Edit Tools link, then
  # instantiates the EditSiteTools class.
  def edit_tools
    frm.link(:text=>"Edit Tools").click
    EditSiteTools.new(@browser)
  end
  
  # Clicks the Manage Groups link and
  # instantiates the Groups Class.
  def manage_groups
    frm.link(:text=>"Manage Groups").click
    Groups.new(@browser)
  end
  
  # Clicks the Duplicate Site link and instantiates
  # the DuplicateSite class.
  def duplicate_site
    frm.link(:text=>"Duplicate Site").click
    DuplicateSite.new(@browser)
  end
  
  def add_participants
    frm.link(:text=>"Add Participants").click
    SiteSetupAddParticipants.new @browser
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
    SiteEditor.new(@browser)
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

# The topmost "Site Editor" page,
# found in SITE MANAGEMENT
# or else Site Setup after you have
# selected to Edit a particular site.
class SiteEditor
  
  include PageObject
  include ToolsMenu
  include SiteEditorMenu
  
  # Sets the specified role for the specified participant.
  #
  # Because the participant is selected using a regular expression,
  # the "participant" string can be anything that will suffice as a
  # unique match--i.e., last name, first name, or user id, or any combination,
  # as long as it will match a part of the string that appears in the
  # desired row.
  def set_role(participant, role)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(participant)}/).select(:id=>/role/).select(role)
  end
  
  def update_participants
    frm.button(:value=>"Update Participants").click
    SiteEditor.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:previous, :name=>"previous", :frame=>frame)
    button(:return_to_sites_list, :name=>"", :frame=>frame)
    button(:next, :name=>"", :frame=>frame)
    link(:printable_version, :text=>"Printable Version", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

# Groups page inside the Site Editor
class Groups
    
  include PageObject
  include ToolsMenu
  include SiteEditorMenu
  
  # Clicks the Create New Group link and
  # instantiates the CreateNewGroup Class.
  def create_new_group
    create_new_group_link_element.wait_until_present
    create_new_group_link
    CreateNewGroup.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    link(:create_new_group_link, :text=>"Create New Group", :frame=>frame)
    link(:auto_groups, :text=>"Auto Groups", :frame=>frame)
    button(:remove_checked, :id=>"delete-groups", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The Create New Group page inside the Site Editor
class CreateNewGroup

  include PageObject
  include ToolsMenu
  
  # Clicks the Add button and instantiates the Groups Class.
  def add
    frm.button(:id=>"save").click
    Groups.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"group_title", :frame=>frame)
    text_field(:description, :id=>"group_description", :frame=>frame)
    select_list(:site_member_list, :name=>"siteMembers-selection", :frame=>frame)
    select_list(:group_member_list, :name=>"groupMembers-selection", :frame=>frame)
    button(:right, :name=>"right", :index=>0, :frame=>frame)
    button(:left, :name=>"left", :index=>0, :frame=>frame)
    button(:all_right, :name=>"right", :index=>1, :frame=>frame)
    button(:all_left, :name=>"left",:index=>1, :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The first page of the Duplicate Site pages in the Site Editor.
class DuplicateSite
  
  include PageObject
  include ToolsMenu
   
  def duplicate
    frm.button(:value=>"Duplicate").click
    frm.span(:class=>"submitnotif").wait_while_present(300)
    SiteEditor.new(@browser)
  end

  # Returns the site name in the header, for verification.
  def site_name
    frm.div(:class=>"portletBody").h3.span(:class=>"highlight").text
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:site_title, :id=>"title", :frame=>frame)
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
  end
end


# Page for Adding Participants to a Site in Site Setup
class SiteSetupAddParticipants
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupChooseRole.new @browser
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_area(:official_participants, :id=>"content::officialAccountParticipant", :frame=>frame)
    text_area(:non_official_participants, :id=>"content::nonOfficialAccountParticipant", :frame=>frame)
    radio_button(:assign_all_to_same_role, :id=>"content::role-row:0:role-select", :frame=>frame)
    radio_button(:assign_each_individually, :id=>"content::role-row:1:role-select", :frame=>frame)
    radio_button(:active_status, :id=>"content::status-row:0:status-select", :frame=>frame)
    radio_button(:inactive_status, :id=>"content::status-row:1:status-select", :frame=>frame)
    button(:cancel, :id=>"content::cancel", :frame=>frame)
    
  end

end

# Page for selecting Participant roles individually
class SiteSetupChooseRolesIndiv
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    #SiteSetupParticipantEmail.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processDifferentRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    select_list(:user_role, :id=>"content::user-row:0:role-select-selection", :frame=>frame)
  end

end

# Page for selecting the same role for All. This class is used for
# both Course and Portfolio sites.
class SiteSetupChooseRole
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupParticipantEmail.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processSameRoleBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Acancel&Fast%20track%20action=siteAddParticipantHandler.processCancel", :frame=>frame)
    radio_button(:guest, :value=>"Guest", :frame=>frame)
    radio_button(:instructor, :value=>"Instructor", :frame=>frame)
    radio_button(:student, :value=>"Student", :frame=>frame)
    radio_button(:evaluator, :value=>"Evaluator", :frame=>frame)
    radio_button(:organizer, :value=>"Organizer", :frame=>frame)
    radio_button(:participant, :value=>"Participant", :frame=>frame)
    radio_button(:reviewer, :value=>"Reviewer", :frame=>frame)
    radio_button(:teaching_assistant, :id=>"content::role-row:3:role-select", :frame=>frame)
  end

end

# Page for specifying whether to send an email
# notification to the newly added Site participants
class SiteSetupParticipantEmail
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteSetupParticipantConfirmation.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
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
  
  def finish
    frm.button(:value=>"Finish").click
    SiteEditor.new(@browser)
  end
  
  # Returns the value of the id field for the specified name.
  def id(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[1].text
  end
  
  # Returns the value of the Role field for the specified name.
  def role(name)
    frm.table(:class=>"listHier").row(:text=>/#{Regexp.escape(name)}/)[2].text
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    button(:back, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmBack", :frame=>frame)
    button(:cancel, :name=>"command link parameters&Submitting%20control=content%3A%3Aback&Fast%20track%20action=siteAddParticipantHandler.processConfirmCancel", :frame=>frame)
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
  
  in_frame(:class=>"portletMainIframe") do |frame|
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
    SiteEditor.new(@browser)
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
  
  in_frame(:class=>"portletMainIframe") do |frame|
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
      SiteAccess.new(@browser)
    elsif frm.div(:class=>"portletBody").text =~ /^Confirming site tools edits/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "There's another path to define"
    end
  end

  in_frame(:class=>"portletMainIframe") do |frame|
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
  
  in_frame(:class=>"portletMainIframe") do |frame|
    # Note that ONLY THE FIRST instances of the
    # subject, course, and section fields
    # are included in the page elements definitions here,
    # because their identifiers are dependent on how
    # many instances exist on the page.
    # This means that if you need to access the second
    # or subsequent of these elements, you'll need to
    # explicitly identify/define them in the test case
    # itself.
    text_field(:subject, :name=>/Subject:/, :frame=>frame)
    text_field(:course, :name=>/Course:/, :frame=>frame)
    text_field(:section, :name=>/Section:/, :frame=>frame)
    text_field(:authorizers_username, :id=>"uniqname", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    select_list(:add_more_rosters, :id=>"number", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# The Site Access Page that appears during Site creation
# immediately following the Add Multiple Tools Options page.
class SiteAccess
  
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
    ConfirmSiteSetup.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
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
class ConfirmSiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Request Site button, then
  # instantiates the SiteSetup Class.
  def request_site
    frm.button(:value=>"Request Site").click
    SiteSetup.new(@browser)
  end
  
  # For portfolio sites...
  # Clicks the "Create Site" button and
  # instantiates the SiteSetup class.
  def create_site
    frm.button(:value=>"Create Site").click
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
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:special_instructions, :id=>"additional", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
    button(:back, :name=>"Back", :frame=>frame)
    button(:cancel, :name=>"Cancel", :frame=>frame)
  end
  
end

# 
class PortfolioSiteInfo
  
  include PageObject
  include ToolsMenu

  def description=(text)
    frm.frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def continue
    frm.button(:value=>"Continue").click
    PortfolioSiteTools.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title", :frame=>frame)
    text_field(:url_alias, :id=>"alias_0", :frame=>frame)
    text_area(:short_description, :id=>"short_description", :frame=>frame)
    text_field(:icon_url, :id=>"iconUrl", :frame=>frame)
    text_field(:site_contact_name, :id=>"siteContactName", :frame=>frame)
    text_field(:site_contact_email, :id=>"siteContactEmail", :frame=>frame)
  end
end

# 
class PortfolioSiteTools
  
  include PageObject
  include ToolsMenu

  def continue
    frm.button(:value=>"Continue").click
    PortfolioConfigureToolOptions.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    checkbox(:all_tools, :id=>"all", :frame=>frame)
    
  end
end

# 
class PortfolioConfigureToolOptions
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    SiteAccess.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:email, :id=>"emailId", :frame=>frame)
  end
end


