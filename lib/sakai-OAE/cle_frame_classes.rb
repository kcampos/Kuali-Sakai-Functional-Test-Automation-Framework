# coding: UTF-8

module AssignmentsMenu

  include PageObject

  def assignments_frame
    self.frame(:src=>/sakai2assignments.launch.html/)
  end
  alias frm assignments_frame

  def add_assignment
    frm.link(:title=>"Add").click
    frm.frame(:id=>"new_assignment_instructions___Frame").td(:id=>"xEditingArea").wait_until_present
    AssignmentsAdd.new @browser
  end

  def grade_report
    frm.link(:text=>"Grade Report").click
    GradeReport.new @browser
  end

  def student_view
    frm.link(:text=>"Student View").click
    StudentView.new @browser
  end

  def permissions
    frm.link(:text=>"Permissions").click
    AssignmentsPermissions.new @browser
  end

  def options
    frm.link(:text=>"Options").click
    AssignmentsOptions.new @browser
  end

  def assignment_list
    frm.link(:text=>"Assignment list").click
    Assignments.new @browser
  end

  # Clicks the Reorder button, then instantiates
  # the AssignmentsReorder page class.
  def reorder
    frm.link(:text=>"Reorder").click
    AssignmentsReorder.new(@browser)
  end

end # Assignments Menu module

#
class Assignments # Note that the OAE portion of this class can be found in the page_classes file.

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsMenu

  # Returns an array of the displayed assignment titles.
  # Use for verification of test steps.
  def assignments_titles
    titles = []
    frm.table(:class=>"listHier lines nolines").links(:href=>/doView_assignment/).each { |x| titles << x.text }
    titles
  end
  alias assignment_titles assignments_titles
  alias assignments_list assignments_titles
  alias titles assignments_titles
  alias list assignments_titles

  # Clicks the Edit link for the Assignment specified.
  # Then it instantiates the AssignmentsAdd page class.
  def edit_assignment(assignment_name)
    index = assignments_titles.index(assignment_name)
    frm.link(:text=>"Edit", :index=>index).click
    AssignmentsAdd.new(@browser)
  end

  # Checks the appropriate checkbox, based on the specified assignment_name
  # Then clicks the Update button and confirms the deletion request.
  def delete_assignment(assignment_name)
    check_assignment(assignment_name)
    frm.button(:value=>"Update").click
    sleep 0.2
    frm.button(:value=>"Delete").click
  end

  # Clicks on the Duplicate link for the Assignment specified.
  def duplicate_assignment(assignment_name)
    index = assignments_titles.index(assignment_name)
    frm.link(:text=>"Duplicate", :index=>index).click
  end

  # Checks the checkbox for the specified Assignment,
  # using the assignment id as the identifier.
  def check_assignment(assignment_name)
    assignment_row(assignment_name).checkbox.set
  end

  # Opens the specified assignment for viewing
  #
  # Instantiates the student view or instructor/admin
  # view based on the landing page attributes
  def open_assignment(assignment_name)
    frm.link(:text=>assignment_name).click
    if frm.div(:class=>"portletBody").p(:class=>"instruction").exist? && frm.div(:class=>"portletBody").p(:class=>"instruction").text == "Add attachment(s), then choose the appropriate button at the bottom."
      AssignmentStudent.new(@browser)
    elsif frm.div(:class=>"portletBody").h3.text=="Viewing assignment..." || frm.div(:class=>"portletBody").h3.text.include?("Submitted") || frm.button(:value=>"Back to list").exist?
      AssignmentsPreview.new(@browser)
    else
      frm.frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").wait_until_present
      AssignmentStudent.new(@browser)
    end
  end
  alias view_assignment open_assignment

  # Gets the contents of the status column
  # for the specified assignment
  def status_of(assignment_name)
    assignment_row(assignment_name).td(:headers=>"status").text
  end

  # Clicks the View Submissions link for the specified
  # Assignment, then instantiates the AssignmentSubmissionList
  # page class.
  def view_submissions_for(assignment_name)
    assignment_row(assignment_name).link(:text=>"View Submissions").click
    AssignmentSubmissionList.new(@browser)
  end

  # Clicks the Grade link for the specified Assignment,
  # then instantiates the AssignmentSubmissionList page class.
  def grade(assignment_name)
    assignment_row(assignment_name).link(:text=>"Grade").click
    AssignmentSubmissionList.new(@browser)
  end

  in_frame(:index=>2) do |frame|
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:sort_assignment_title, :text=>"Assignment title", :frame=>frame)
    link(:sort_status, :text=>"Status", :frame=>frame)
    link(:sort_open, :text=>"Open", :frame=>frame)
    link(:sort_due, :text=>"Due", :frame=>frame)
    link(:sort_in, :text=>"In", :frame=>frame)
    link(:sort_new, :text=>"New", :frame=>frame)
    link(:sort_scale, :text=>"Scale", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    button(:update, :name=>"eventSubmit_doDelete_confirm_assignment", :frame=>frame)
  end

  # Private methods
  private

  def assignment_row(assignment_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(assignment_name)}/)
  end

end # Assignments

#
class AssignmentsAdd

  include PageObject
  include AssignmentsMenu

  # Sends the specified text to the text box in the FCKEditor
  # on the page.
  def instructions=(instructions)
    frm.frame(:id, "new_assignment_instructions___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
  end

  # Clicks the Preview button, then instantiates
  # the AssignmentsPreview page class.
  def preview
    frm.button(:value=>"Preview").click
    AssignmentsPreview.new(@browser)
  end

  # Clicks the Add Attachments or Add/Remove Attachments button, then
  # instantiates the AssignmentsAttachments page class.
  def add_attachments
    frm.button(:value=>/(Add|Add \/ Remove) Attachments/).click
    AssignmentsAttachments.new(@browser)
  end
  alias add_remove_attachments add_attachments

  # Returns an array listing the files attached to the assignment
  def attached_files
    array = []
    frm.ul(:class=>/attachList/).lis.each { |li| array << li.link.text }
    array
  end

  in_frame(:index=>2) do |frame|
    span(:gradebook_warning, :id=>"gradebookListWarnAssoc", :frame=>frame)
    div(:alert_box, :class=>"alertMessage", :frame=>frame)
    button(:save_draft, :name=>"save", :frame=>frame)
    button(:cancel, :value=>"Cancel", :frame=>frame)
    button(:post, :value=>"Post", :frame=>frame)
    hidden_field(:assignment_id, :name=>"assignmentId", :frame=>frame)
    text_field(:title, :id=>"new_assignment_title", :frame=>frame)
    select_list(:open_month, :id=>"new_assignment_openmonth", :frame=>frame)
    select_list(:open_day, :id=>"new_assignment_openday", :frame=>frame)
    select_list(:open_year, :id=>"new_assignment_openyear", :frame=>frame)
    select_list(:open_hour, :id=>"new_assignment_openhour", :frame=>frame)
    select_list(:open_minute, :id=>"new_assignment_openmin", :frame=>frame)
    select_list(:open_meridian, :id=>"new_assignment_openampm", :frame=>frame)
    select_list(:due_month, :id=>"new_assignment_duemonth", :frame=>frame)
    select_list(:due_day, :id=>"new_assignment_dueday", :frame=>frame)
    select_list(:due_year, :id=>"new_assignment_dueyear", :frame=>frame)
    select_list(:due_hour, :id=>"new_assignment_duehour", :frame=>frame)
    select_list(:due_minute, :id=>"new_assignment_duemin", :frame=>frame)
    select_list(:due_meridian, :id=>"new_assignment_dueampm", :frame=>frame)
    select_list(:accept_month, :id=>"new_assignment_closemonth", :frame=>frame)
    select_list(:accept_day, :id=>"new_assignment_closeday", :frame=>frame)
    select_list(:accept_year, :id=>"new_assignment_closeyear", :frame=>frame)
    select_list(:accept_hour, :id=>"new_assignment_closehour", :frame=>frame)
    select_list(:accept_minute, :id=>"new_assignment_closemin", :frame=>frame)
    select_list(:accept_meridian, :id=>"new_assignment_closeampm", :frame=>frame)
    select_list(:student_submissions, :id=>"subType", :frame=>frame)
    select_list(:grade_scale, :id=>"new_assignment_grade_type", :frame=>frame)
    checkbox(:allow_resubmission, :id=>"allowResToggle", :frame=>frame)
    select_list(:num_resubmissions, :id=>"allowResubmitNumber", :frame=>frame)
    select_list(:resub_until_month, :id=>"allow_resubmit_closeMonth", :frame=>frame)
    select_list(:resub_until_day, :id=>"allow_resubmit_closeDay", :frame=>frame)
    select_list(:resub_until_year, :id=>"allow_resubmit_closeYear", :frame=>frame)
    select_list(:resub_until_hour, :id=>"allow_resubmit_closeHour", :frame=>frame)
    select_list(:resub_until_minute, :id=>"allow_resubmit_closeMin", :frame=>frame)
    select_list(:resub_until_meridian, :id=>"allow_resubmit_closeAMPM", :frame=>frame)
    text_field(:max_points, :name=>"new_assignment_grade_points", :frame=>frame)
    checkbox(:add_due_date, :id=>"new_assignment_check_add_due_date", :frame=>frame)
    checkbox(:add_open_announcement, :id=>"new_assignment_check_auto_announce", :frame=>frame)
    checkbox(:add_honor_pledge, :id=>"new_assignment_check_add_honor_pledge", :frame=>frame)
    checkbox(:use_turnitin, :id=>"new_assignment_use_review_service", :frame=>frame)
    checkbox(:allow_students_to_view_report, :id=>"new_assignment_allow_student_view", :frame=>frame)
    radio_button(:do_not_add_to_gradebook, :id=>"no",:name=>"new_assignment_add_to_gradebook", :frame=>frame)
    radio_button(:add_to_gradebook, :id=>"add", :name=>"new_assignment_add_to_gradebook", :frame=>frame)
    radio_button(:do_not_send_notifications, :id=>"notsendnotif", :frame=>frame)
    radio_button(:send_notifications, :id=>"sendnotif", :frame=>frame)
    radio_button(:send_summary_email, :id=>"sendnotifsummary", :frame=>frame)
    radio_button(:do_not_send_grade_notif, :id=>"notsendreleasegradenotif", :frame=>frame)
    radio_button(:send_grade_notif, :id=>"sendreleasegradenotif", :frame=>frame)
    link(:add_model_answer, :id=>"modelanswer_add", :frame=>frame)
    link(:add_private_note, :id=>"note_add", :frame=>frame)
    link(:add_all_purpose_item, :id=>"allPurpose_add", :frame=>frame)
    text_area(:model_answer, :id=>"modelanswer_text", :frame=>frame)
    button(:model_answer_attach, :name=>"modelAnswerAttach", :frame=>frame)
    select_list(:show_model_answer, :id=>"modelanswer_to", :frame=>frame)
    button(:save_model_answer, :id=>"modelanswer_save", :frame=>frame)
    button(:cancel_model_answer, :id=>"modelanswer_cancel", :frame=>frame)
    text_area(:private_note, :id=>"note_text", :frame=>frame)
    select_list(:share_note_with, :id=>"note_to", :frame=>frame)
    button(:save_note, :id=>"note_save", :frame=>frame)
    button(:cancel_note, :id=>"note_cancel", :frame=>frame)
    text_field(:all_purpose_title, :id=>"allPurpose_title", :frame=>frame)
    text_area(:all_purpose_text, :id=>"allPurpose_text", :frame=>frame)
    button(:add_all_purpose_attachments, :id=>"allPurposeAttach", :frame=>frame)
    radio_button(:show_this_all_purpose_item, :id=>"allPurposeHide1", :frame=>frame)
    radio_button(:hide_this_all_purpose_item, :id=>"allPurposeHide2", :frame=>frame)
    checkbox(:show_from, :id=>"allPurposeShowFrom", :frame=>frame)
    checkbox(:show_until, :id=>"allPurposeShowTo", :frame=>frame)
    select_list(:show_from_month, :id=>"allPurpose_releaseMonth", :frame=>frame)
    select_list(:show_from_day, :id=>"allPurpose_releaseDay", :frame=>frame)
    select_list(:show_from_year, :id=>"allPurpose_releaseYear", :frame=>frame)
    select_list(:show_from_hour, :id=>"allPurpose_releaseHour", :frame=>frame)
    select_list(:show_from_minute, :id=>"allPurpose_releaseMin", :frame=>frame)
    select_list(:show_from_meridian, :id=>"allPurpose_releaseAMPM", :frame=>frame)
    select_list(:show_until_month, :id=>"allPurpose_retractMonth", :frame=>frame)
    select_list(:show_until_day, :id=>"allPurpose_retractDay", :frame=>frame)
    select_list(:show_until_year, :id=>"allPurpose_retractYear", :frame=>frame)
    select_list(:show_until_hour, :id=>"allPurpose_retractHour", :frame=>frame)
    select_list(:show_until_minute, :id=>"allPurpose_retractMin", :frame=>frame)
    select_list(:show_until_meridian, :id=>"allPurpose_retractAMPM", :frame=>frame)
    link(:expand_guest_list, :id=>"expand_1", :frame=>frame)
    link(:collapse_guest_list, :id=>"collapse_1", :frame=>frame)
    link(:expand_TA_list, :id=>"expand_2", :frame=>frame)
    link(:collapse_TA_list, :id=>"collapse_2", :frame=>frame)
    link(:expand_instructor_list, :id=>"expand_3", :frame=>frame)
    link(:collapse_instructor_list, :is=>"collapse_3", :frame=>frame)

    # Note that only the "All" checkboxes are defined, since other items may or may not be there
    checkbox(:all_guests, :id=>"allPurpose_Guest", :frame=>frame)
    checkbox(:all_TAs, :id=>"allPurpose_Teaching Assistant", :frame=>frame)
    checkbox(:all_instructors, :id=>"allPurpose_Instructor", :frame=>frame)
  end

end # AssignmentsAdd

#
class AssignmentsPermissions

  include PageObject

  in_frame(:index=>2) do |frame|
    button(:save, :value=>"Save", :frame=>frame)
    checkbox(:evaluators_share_drafts, :id=>"Evaluatorasn.share.drafts", :frame=>frame)
    checkbox(:organizers_share_drafts, :id=>"Organizerasn.share.drafts", :frame=>frame)
    checkbox(:guests_all_groups, :id=>"Guestasn.all.groups", :frame=>frame)
    checkbox(:guests_create_assignments, :id=>"Guestasn.new", :frame=>frame)
    checkbox(:guests_submit_to_assigments, :id=>"Guestasn.submit", :frame=>frame)
    checkbox(:guests_delete_assignments, :id=>"Guestasn.delete", :frame=>frame)
    checkbox(:guests_read_assignments, :id=>"Guestasn.read", :frame=>frame)
    checkbox(:guests_revise_assignments, :id=>"Guestasn.revise", :frame=>frame)
    checkbox(:guests_grade_assignments, :id=>"Guestasn.grade", :frame=>frame)
    checkbox(:guests_receive_notifications, :id=>"Guestasn.receive.notifications", :frame=>frame)
    checkbox(:guests_share_drafts, :id=>"Guestasn.share.drafts", :frame=>frame)
    checkbox(:instructors_all_groups, :id=>"Instructorasn.all.groups", :frame=>frame)
    checkbox(:instructors_create_assignments, :id=>"Instructorasn.new", :frame=>frame)
    checkbox(:instructors_submit_to_assigments, :id=>"Instructorasn.submit", :frame=>frame)
    checkbox(:instructors_delete_assignments, :id=>"Instructorasn.delete", :frame=>frame)
    checkbox(:instructors_read_assignments, :id=>"Instructorasn.read", :frame=>frame)
    checkbox(:instructors_revise_assignments, :id=>"Instructorasn.revise", :frame=>frame)
    checkbox(:instructors_grade_assignments, :id=>"Instructorasn.grade", :frame=>frame)
    checkbox(:instructors_receive_notifications, :id=>"Instructorasn.receive.notifications", :frame=>frame)
    checkbox(:instructors_share_drafts, :id=>"Instructorasn.share.drafts", :frame=>frame)
    checkbox(:students_all_groups, :id=>"Studentasn.all.groups", :frame=>frame)
    checkbox(:students_create_assignments, :id=>"Studentasn.new", :frame=>frame)
    checkbox(:students_submit_to_assigments, :id=>"Studentasn.submit", :frame=>frame)
    checkbox(:students_delete_assignments, :id=>"Studentasn.delete", :frame=>frame)
    checkbox(:students_read_assignments, :id=>"Studentasn.read", :frame=>frame)
    checkbox(:students_revise_assignments, :id=>"Studentasn.revise", :frame=>frame)
    checkbox(:students_grade_assignments, :id=>"Studentasn.grade", :frame=>frame)
    checkbox(:students_receive_notifications, :id=>"Studentasn.receive.notifications", :frame=>frame)
    checkbox(:students_share_drafts, :id=>"Studentasn.share.drafts", :frame=>frame)
    checkbox(:tas_all_groups, :id=>"Teaching Assistantasn.all.groups", :frame=>frame)
    checkbox(:tas_create_assignments, :id=>"Teaching Assistantasn.new", :frame=>frame)
    checkbox(:tas_submit_to_assigments, :id=>"Teaching Assistantasn.submit", :frame=>frame)
    checkbox(:tas_delete_assignments, :id=>"Teaching Assistantasn.delete", :frame=>frame)
    checkbox(:tas_read_assignments, :id=>"Teaching Assistantasn.read", :frame=>frame)
    checkbox(:tas_revise_assignments, :id=>"Teaching Assistantasn.revise", :frame=>frame)
    checkbox(:tas_grade_assignments, :id=>"Teaching Assistantasn.grade", :frame=>frame)
    checkbox(:tas_receive_notifications, :id=>"Teaching Assistantasn.receive.notifications", :frame=>frame)
    checkbox(:tas_share_drafts, :id=>"Teaching Assistantasn.share.drafts", :frame=>frame)
    link(:undo_changes, :text=>"Undo changes", :frame=>frame)
    button(:cancel, :id=>"eventSubmit_doCancel", :frame=>frame)
    link(:permission, :text=>"Permission", :frame=>frame)
    link(:guest, :text=>"Guest", :frame=>frame)
    link(:instructor, :text=>"Instructor", :frame=>frame)
    link(:student, :text=>"Student", :frame=>frame)
    link(:teaching_assistant, :text=>"Teaching Assistant", :frame=>frame)
    link(:same_permissions_for_all_groups, :text=>"Same site level permissions for all groups inside the site", :frame=>frame)
    link(:create_new_assignments, :text=>"Create new assignment(s)", :frame=>frame)
    link(:submit_to_assignments, :text=>"Submit to assignment(s)", :frame=>frame)
    link(:delete_assignments, :text=>"Delete assignment(s)", :frame=>frame)
    link(:read_assignments, :text=>"Read Assignment(s)", :frame=>frame)
    link(:revise_assignments, :text=>"Revise assignment(s)", :frame=>frame)
    link(:grade_submissions, :text=>"Grade assignment submission(s)", :frame=>frame)
    link(:receive_email_notifications, :text=>"Receive email notifications", :frame=>frame)
    link(:view_drafts_from_others, :text=>"Able to view draft assignment(s) created by other users", :frame=>frame)
  end

end # AssignmentsPermissions

# Options page for Assignments
class AssignmentsOptions

  include PageObject
  include AssignmentsMenu

  in_frame(:index=>2) do |frame|
    radio_button(:default, :id=>"submission_list_option_default", :frame=>frame)
    radio_button(:only_show_filtered_submissions, :id=>"submission_list_option_searchonly", :frame=>frame)
    button(:update, :name=>"eventSubmit_doUpdate_options", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel_options", :frame=>frame)

  end

end # AssignmentsOptions

# Page that appears when you click to preview an Assignment
class AssignmentsPreview

  include PageObject
  include AssignmentsMenu

  # Returns the text content of the page header
  def header
    frm.div(:class=>"portletBody").h3.text
  end

  # Returns a hash object containing the contents of the Item Summary table.
  # The hash's key is the header column and the value is the content column.
  def item_summary
    hash = {}
    frm.table(:class=>"itemSummary").rows.each do |row|
      hash.store(row.th.text, row.td.text)
    end
    hash
  end

  # Grabs the Assignment Instructions text.
  def assignment_instructions
    frm.div(:class=>"textPanel").text
  end

  # Grabs the instructor comments text.
  def instructor_comments
    frm.div(:class=>"portletBody").div(:class=>"textPanel", :index=>2).text
  end

  in_frame(:index=>2) do |frame|
    hidden_field(:assignment_id, :name=>"assignmentId", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:hide_assignment, :href=>/doHide_preview_assignment_assignment/, :frame=>frame)
    link(:show_assignment, :href=>/doShow_preview_assignment_assignment/, :frame=>frame)
    link(:hide_student_view, :href=>/doHide_preview_assignment_student_view/, :frame=>frame)
    link(:show_student_view, :href=>/doShow_preview_assignment_student_view/, :frame=>frame)
    button(:edit, :name=>"revise", :frame=>frame)
    button(:save_draft, :name=>"save", :frame=>frame)
    button(:done, :name=>"done", :frame=>frame)
    button(:back_to_list, :value=>"Back to list", :frame=>frame)
    button(:post, :name=>"post", :frame=>frame)
    button(:cancel, :value=>"Cancel", :frame=>frame)
  end

end

# The reorder page for Assignments
class AssignmentsReorder

  include PageObject
  include AssignmentsMenu

  in_frame(:index=>2) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:sort_by_title, :text=>"Sort by title", :frame=>frame)
    link(:sort_by_open_date, :text=>"Sort by open date", :frame=>frame)
    link(:sort_by_due_date, :text=>"Sort by due date", :frame=>frame)
    link(:undo_last, :text=>"Undo last", :frame=>frame)
    link(:undo_all, :text=>"Undo all", :frame=>frame)
    button(:cancel, :value=>"Cancel", :frame=>frame)
    button(:save, :value=>"Save", :frame=>frame)
  end

end

# A Student user's page for editing/submitting/view an assignment.
class AssignmentStudent

  include PageObject
  include AssignmentsMenu

  # Returns a hash object containing the contents of the Item Summary table.
  # The hash's Key is the header column and the value is the content column.
  def item_summary
    hash = {}
    frm.table(:class=>"itemSummary").rows.each do |row|
      hash.store(row.th.text, row.td.text)
    end
    return hash
  end

  # Enters the specified text into the Assignment Text FCKEditor.
  def assignment_text=(text)
    frm.frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clears out any existing text from the Assignment Text FCKEditor.
  def remove_assignment_text
    frm.frame(:id, "Assignment.view_submission_text___Frame").div(:title=>"Select All").fire_event("onclick")
    frm.frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end

  # This class variable allows adding an arbitrary number of
  # files to the page, as long as the adding steps alternate between
  # selecting the file and clicking the add more files button
  @@file_number = 0

  # Enters the specified file name into the file field (the
  # file is assumed to be in the data/sakai_cle folder in the
  # correct file path relative to the script being run).
  # Once the filename is entered in the field, the
  # @@file_number class variable is increased by one
  # in case any more files need to be added to the upload
  # list.
  def select_file=(file_name)
    frm.file_field(:id=>"clonableUpload", :name=>"upload#{@@file_number}").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
    @@file_number += 1
  end

  # Clicks the Submit button, then instantiates
  # the appropriate page class, based on the
  # page that gets loaded.
  def submit
    frm.button(:value=>"Submit").click
    @@file_number=0
    if frm.div(:class=>"portletBody").h3.text=~/Submission Confirmation/
      SubmissionConfirmation.new(@browser)
    elsif frm.button(:value=>"Back to list").exist?
      SubmissionConfirmation.new(@browser)
    else
      AssessmentsList.new(@browser)
    end
  end

  # Clicks the Resubmit button, then instantiates
  # the appropriate page class, based on the
  # page that gets loaded.
  #
  # Resets @@file_number to zero so that file
  # uploads will work if this page is visited again
  # in the same script.
  def resubmit
    frm.button(:value=>"Resubmit").click
    @@file_number=0
    if frm.link(:text=>"Assignment title").exist?
      puts "list..."
      AssessmentsList.new(@browser)
    else
      SubmissionConfirmation.new(@browser)
    end
  end

  # Clicks the Preview button, then
  # instantiates the AssignmentStudentPreview page class.
  #
  # Resets @@file_number to zero so that file
  # uploads will work if this page is visited again
  # in the same script.
  def preview
    frm.button(:value=>"Preview").click
    @@file_number=0
    AssignmentStudentPreview.new(@browser)
  end

  # Clicks the Save Draft button, then
  # instantiates the SubmissionConfirmation
  # page class.
  def save_draft
    frm.button(:value=>"Save Draft").click
    SubmissionConfirmation.new(@browser)
  end

  # Clicks the link to select more files
  # from the Workspace. Then instantiates
  # the AssignmentsAttachments page class.
  def select_more_files_from_workspace
    frm.link(:id=>"attach").click
    AssignmentsAttachments.new(@browser)
  end

  in_frame(:index=>2) do |frame|
    link(:add_another_file, :id=>"addMoreAttachmentControls", :frame=>frame)
    h3(:header, :index=>0, :frame=>frame)
    button(:cancel, :value=>"Cancel", :frame=>frame)
    button(:back_to_list, :value=>"Back to list", :frame=>frame)
    div(:instructor_comments, :class=>"textPanel", :index=>2, :frame=>frame)
  end

end

# Page that appears when a Student User clicks to Preview an
# assignment that is in progress.
class AssignmentStudentPreview

  include PageObject
  include AssignmentsMenu

  # Clicks the Submit button, then
  # instantiates the SubmissionConfirmation
  # page class.
  def submit
    frm.button(:value=>"Submit").click
    SubmissionConfirmation.new(@browser)
  end

  # Clicks the Save Draft button, then
  # instantiates the SubmissionConfirmation
  # page class.
  def save_draft
    frm.button(:value=>"Save Draft").click
    SubmissionConfirmation.new(@browser)
  end

  # Returns the contents of the submission box.
  def submission_text
    frm.div(:class=>"portletBody").div(:class=>/textPanel/).text
  end

  # Returns an array of strings. Each element in the
  # array is the name of attached files.
  def attachments
    names = []
    frm.ul(:class=>"attachList indnt1").links.each { |link| names << link.text }
    return names
  end

end

# The page that appears when a Student user has fully submitted an assignment
# or saves it as a draft.
class SubmissionConfirmation

  include PageObject
  include AssignmentsMenu

  # Returns the text of the success message on the page.
  def confirmation_text
    frm.div(:class=>"portletBody").div(:class=>"success").text
  end

  # Returns the text of the assignment submission.
  def submission_text
    frm.div(:class=>"portletBody").div(:class=>"textPanel indnt2").text
  end

  # Clicks the Back to list button, then
  # instantiates the Assignments page class.
  def back_to_list
    frm.button(:value=>"Back to list").click
    frm.link(:text=>"Assignment title").wait_until_present
    Assignments.new(@browser)
  end
end

# The page that appears when you click on an assignment's "Grade" or "View Submission" link
# as an instructor. Shows the list of students and their
# assignment submission status.
class AssignmentSubmissionList

  include PageObject
  include AssignmentsMenu

  # Clicks the Show Resubmission Settings button
  def show_resubmission_settings
    frm.image(:src, "/library/image/sakai/expand.gif?panel=Main").click
  end

  # Clicks the Show Assignment Details button.
  def show_assignment_details
    frm.image(:src, "/library/image/sakai/expand.gif").click
  end

  # Gets the Student table text and returns it in an Array object.
  def student_table
    table = frm.table(:class=>"listHier lines nolines").to_a
  end

  # Clicks the Grade link for the specified student, then
  # instantiates the AssignmentSubmission page class.
  def grade(student_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(student_name)}/).link(:text=>"Grade").click
    frm.frame(:id, "grade_submission_feedback_comment___Frame").td(:id, "xEditingArea").frame(:index=>0).wait_until_present
    AssignmentSubmission.new(@browser)
  end

  # Gets the value of the status field for the specified
  # Student. Note that the student's name needs to be entered
  # so that it's unique for the row, but it does not have
  # to match the entire name/id value--unless there are two
  # students with the same name.
  #
  # Useful for verification purposes.
  def submission_status_of(student_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(student_name)}/)[4].text
  end

  in_frame(:index=>2) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:reorder, :text=>"Reorder", :frame=>frame)
    text_field(:search_input, :id=>"search", :frame=>frame)
    button(:find, :value=>"Find", :frame=>frame)
    button(:clear, :value=>"Clear", :frame=>frame)
    link(:download_all, :text=>"Download All", :frame=>frame)
    link(:upload_all, :text=>"Upload All", :frame=>frame)
    link(:release_grades, :text=>"Release Grades", :frame=>frame)
    link(:sort_by_student, :text=>"Student", :frame=>frame)
    link(:sort_by_submitted, :text=>"Submitted", :frame=>frame)
    link(:sort_by_status, :text=>"Status", :frame=>frame)
    link(:sort_by_grade, :text=>"Grade", :frame=>frame)
    link(:sort_by_release, :text=>"Release", :frame=>frame)
    select_list(:default_grade, :id=>"defaultGrade_1", :frame=>frame)
    button(:apply, :name=>"apply", :frame=>frame)
    select_list(:num_resubmissions, :id=>"allowResubmitNumber", :frame=>frame)
    select_list(:accept_until_month, :id=>"allow_resubmit_closeMonth", :frame=>frame)
    select_list(:accept_until_day, :id=>"allow_resubmit_closeDay", :frame=>frame)
    select_list(:accept_until_year, :id=>"allow_resubmit_closeYear", :frame=>frame)
    select_list(:accept_until_hour, :id=>"allow_resubmit_closeHour", :frame=>frame)
    select_list(:accept_until_min, :id=>"allow_resubmit_closeMin", :frame=>frame)
    select_list(:accept_until_meridian, :id=>"allow_resubmit_closeAMPM", :frame=>frame)
    button(:update, :id=>"eventSubmit_doSave_resubmission_option", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
    button(:update, :name=>"eventSubmit_doDelete_confirm_assignment", :frame=>frame)

  end

end

# The page that shows a student's submitted assignment to an instructor user.
class AssignmentSubmission

  include PageObject
  include AssignmentsMenu

  # Enters the specified text string in the FCKEditor box for the assignment text.
  def assignment_text=(text)
    frm.frame(:id, "grade_submission_feedback_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Removes all the contents of the FCKEditor Assignment Text box.
  def remove_assignment_text
    frm.frame(:id, "grade_submission_feedback_text___Frame").div(:title=>"Select All").fire_event("onclick")
    frm.frame(:id, "grade_submission_feedback_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end

  # Enters the specified string into the Instructor Comments FCKEditor box.
  def instructor_comments=(text)
    frm.frame(:id, "grade_submission_feedback_comment___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clicks the Add Attachments button, then instantiates the AssignmentsAttachments Class.
  def add_attachments
    frm.button(:name=>"attach").click
    AssignmentsAttachments.new(@browser)
  end

  # Clicks the Return to List button, then instantiates the
  # AssignmentSubmissionList Class.
  def return_to_list
    frm.button(:value=>"Return to List").click
    AssignmentSubmissionList.new(@browser)
  end

  in_frame(:index=>2) do |frame|
    select_list(:select_default_grade, :name=>"grade_submission_grade", :frame=>frame)
    checkbox(:allow_resubmission, :id=>"allowResToggle", :frame=>frame)
    select_list(:num_resubmissions, :id=>"allowResubmitNumberSelect", :frame=>frame)
    select_list(:accept_until_month, :id=>"allow_resubmit_closeMonth", :frame=>frame)
    select_list(:accept_until_day, :id=>"allow_resubmit_closeDay", :frame=>frame)
    select_list(:accept_until_year, :id=>"allow_resubmit_closeYear", :frame=>frame)
    select_list(:accept_until_hour, :id=>"allow_resubmit_closeHour", :frame=>frame)
    select_list(:accept_until_min, :id=>"allow_resubmit_closeMin", :frame=>frame)
    select_list(:accept_until_meridian, :id=>"allow_resubmit_closeAMPM", :frame=>frame)
    button(:save_and_release, :value=>"Save and Release to Student", :frame=>frame)
    button(:save_and_dont_release, :value=>"Save and Don't Release to Student", :frame=>frame)
  end

end

# The Grade Report page accessed from the Assignments page
class GradeReport

  include PageObject
  include AssignmentsMenu

  # Returns an array of hashes. Each hash is a line from the
  # table. Hash keys are as follows:
  # :name, :assignment, :grade, :scale, :submitted
  def grade_report
    array = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      next if row.td(:headers=>"studentname").exists? == false
      hash = {}
      hash[:student] = row.td(:headers=>"").text
      hash[:assignment] = row.td(:headers=>"").text
      hash[:grade] = row.td(:headers=>"").text
      hash[:scale] = row.td(:headers=>"").text
      hash[:submitted] = row.td(:headers=>"").text
      array << hash
    end
    array
  end

  in_frame(:index=>2) do |frame|
    h3(:header, :index=>0, :frame=>frame)
    paragraph(:instruction, :class=>"instruction", :frame=>frame)
    link(:sort_by_student_name, :title=>" Sort by Last Name", :frame=>frame)
    link(:sort_by_assignment, :title=>"Checkmark", :frame=>frame)
    link(:sort_by_grade, :title=>" Sort by Grade", :frame=>frame)
    link(:sort_by_scale, :title=>"Sort by Scale", :frame=>frame)
    link(:sort_by_submitted, :title=>"Sort by Turned In Date", :frame=>frame)
    select_list(:select_page_size, :id=>"selectPageSize", :frame=>frame)
  end

end

# The Student View page accessed from the Assignments page
class StudentView

  include PageObject
  include AssignmentsMenu

  in_frame(:index=>2) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:sort_assignment_title, :text=>"Assignment title", :frame=>frame)
    link(:sort_status, :text=>"Status", :frame=>frame)
    link(:sort_open, :text=>"Open", :frame=>frame)
    link(:sort_due, :text=>"Due", :frame=>frame)
    link(:sort_scale, :text=>"Scale", :frame=>frame)
    select_list(:select_page_size, :name=>"selectPageSize", :frame=>frame)
    button(:next, :name=>"eventSubmit_doList_next", :frame=>frame)
    button(:last, :name=>"eventSubmit_doList_last", :frame=>frame)
    button(:previous, :name=>"eventSubmit_doList_prev", :frame=>frame)
    button(:first, :name=>"eventSubmit_doList_first", :frame=>frame)
  end

end

class AttachPageTools

  @@classes = { :this=>"Superclassdummy", :parent=>"Superclassdummy" }

  # Use this for debugging purposes only...
  def what_is_parent?
    puts @@classes[:parent]
  end

  # Returns an array of the displayed folder names.
  def folder_names
    names = []
    frm.table(:class=>/listHier lines/, :text=>/Title/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist? == false
      names << row.td(:class=>"specialLink").link(:title=>"Folder").text
    end
    return names
  end

  # Returns an array containing the list of items that are
  # slated to be attached.
  def items_to_attach
    array = []
    frm.table(:text=>/Items to attach/).links(:href=>/access.content.attachment/).each { |link| array << link.text }
    array
  end

  # Returns an array of the file names currently listed
  # on the page.
  #
  # It excludes folder names and does not include any items
  # slated to be attached.
  def file_names
    names = []
    frm.table(:class=>/listHier lines/, :text=>/Title/).rows.each do |row|
      next if row.td(:class=>"specialLink").exist? == false
      next if row.td(:class=>"specialLink").link(:title=>"Folder").exist?
      names << row.td(:class=>"specialLink").link(:href=>/access.content/, :index=>1).text
    end
    return names
  end

  # Clicks the Select button next to the specified file.
  def select_file(filename)
    frm.table(:class=>/listHier lines/).row(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click
  end

  # Clicks the Remove button.
  def remove
    frm.button(:value=>"Remove").click
  end

  # Clicks the remove link for the specified item in the attachment list.
  def remove_item(file_name)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doRemoveitem/).click
  end

  # Clicks the Move button.
  def move
    frm.button(:value=>"Move").click
  end

  # Clicks the Show Other Sites link.
  def show_other_sites
    frm.link(:text=>"Show other sites").click
  end

  # Clicks on the specified folder image, which
  # will open the folder tree and remain on the page.
  def open_folder(foldername)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(foldername)}/).link(:title=>"Open this folder").click
  end

  # Clicks on the specified folder name, which should open
  # the folder contents on a refreshed page.
  def go_to_folder(foldername)
    frm.link(:text=>foldername).click
  end

  # Sets the URL field to the specified value.
  def url=(url_string)
    frm.text_field(:id=>"url").set(url_string)
  end

  # Clicks the Add button next to the URL field.
  def add
    frm.button(:value=>"Add").click
  end

  # Gets the value of the access level cell for the specified
  # file.
  def access_level(filename)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(filename)}/)[6].text
  end

  def edit_details(name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).li(:text=>/Action/, :class=>"menuOpen").fire_event("onclick")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(name)}/).link(:text=>"Edit Details").click
    instantiate_class(:file_details)
  end

  # Enters the specified file into the file field name (assuming it's in the
  # data/sakai-oae folder or a subfolder therein)
  #
  # Does NOT instantiate any class, so use only when no page refresh occurs.
  def upload_file(filename)
    frm.file_field(:id=>"upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-oae/" + filename)
    if frm.div(:class=>"alertMessage").exist?
      sleep 2
      upload_file(filename)
    end
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_file_to_folder(folder_name)
    upload_files_to_folder(folder_name)
  end

  # Clicks the Add Menu for the specified
  # folder, then selects the Upload Files
  # command in the menu that appears.
  def upload_files_to_folder(folder_name)
    if frm.li(:text=>/A/, :class=>"menuOpen").exist?
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).li(:text=>/A/, :class=>"menuOpen").fire_event("onclick")
    else
      frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    end
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Upload Files").click
    instantiate_class(:upload_files)
  end

  # Clicks the "Attach a copy" link for the specified
  # file, then reinstantiates the Class.
  # If an alert box appears, the method will call itself again.
  # Note that this can lead to an infinite loop. Will need to fix later.
  def attach_a_copy(file_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(file_name)}/).link(:href=>/doAttachitem/).click
    if frm.div(:class=>"alertMessage").exist?
      sleep 1
      attach_a_copy(file_name) # TODO - This can loop infinitely
    end
    instantiate_class(:this)
  end

  # Clicks the Create Folders menu item in the
  # Add menu of the specified folder.
  def create_subfolders_in(folder_name)
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Start Add Menu").fire_event("onfocus")
    frm.table(:class=>/listHier lines/).row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Create Folders").click
    instantiate_class(:create_folders)
  end

  # Takes the specified array object containing pointers
  # to local file resources, then uploads those files to
  # the folder specified, checks if they all uploaded properly and
  # if not, re-tries the ones that failed the first time.
  #
  # Finally, it re-instantiates the AnnouncementsAttach page class.
  def upload_multiple_files_to_folder(folder, file_array)

    upload = upload_files_to_folder folder

    file_array.each do |file|
      upload.file_to_upload=file
      upload.add_another_file
    end

    resources = upload.upload_files_now

    file_array.each do |file|
      file =~ /(?<=\/).+/
      # puts $~.to_s # For debugging purposes
      unless resources.file_names.include?($~.to_s)
        upload_files = resources.upload_files_to_folder(folder)
        upload_files.file_to_upload=file
        resources = upload_files.upload_files_now
      end
    end
    instantiate_class(:this)
  end

  # Clicks the Continue button then
  # decides which page class to instantiate
  # based on the page that appears. This is going to need to be fixed.
  def continue
    frm.div(:class=>"highlightPanel").span(:id=>"submitnotifxxx").wait_while_present
    frm.button(:value=>"Continue").click
  end

  private

  # This is a private method that is only used inside this superclass.
  def instantiate_class(key)
    eval(@@classes[key]).new(@browser)
  end

  # This is another private method--a better way to
  # instantiate the @@classes hash variable.
  def set_classes_hash(hash_object)
    @@classes = hash_object
  end

end

# Page for attaching files to Assignments
class AssignmentsAttachments < AttachPageTools

  include AssignmentsMenu

  def initialize(browser)
    @browser = browser

    @@classes = {
        :this => "AssignmentsAttachments",
        :parent => "AssignmentsAdd",
        :second => "AssignmentStudent",
        :third => "AssignmentSubmission"
    }
  end

end
