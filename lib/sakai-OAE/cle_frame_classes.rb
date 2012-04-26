# coding: UTF-8

module CLEAssignments

  include PageObject

  def add_assignment
    assignments_frame.link(:title=>"Add").click
    assignments_frame.frame(:id=>"new_assignment_instructions___Frame").td(:id=>"xEditingArea").wait_until_present
    AssignmentsAdd.new @browser
  end

  def grade_report
    frm.link(:text=>"Grade Report")
    GradeReport.new @browser
  end

  def student_view
    frm.link(:text=>"Student View")
    StudentView.new @browser
  end

  def permissions
    frm.link(:text=>"Permissions")
    AssignmentsPermissions.new @browser
  end

  def options
    frm.link(:text=>"Options")
    AssignmentsOptions.new @browser
  end

  class AssignmentsAdd

    include PageObject

    def frm
      self.frame(:src=>/sakai2assignments.launch.html/)
    end

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

    # Clicks the Add Attachments button, then
    # instantiates the AssignmentAttachments page class.
    def add_attachments
      frm.button(:value=>"Add Attachments").click
      AssignmentAttachments.new(@browser)
    end

    in_frame(:index=>2) do |frame|
      span(:gradebook_warning, :id=>"gradebookListWarnAssoc", :frame=>frame)
      div(:alert, :id=>"alertMessage", :frame=>frame)
      button(:save_draft, :name=>"Save", :frame=>frame)
      button(:cancel, :value=>"Cancel", :frame=>frame)
      button(:post, :value=>"Post", :frame=>frame)
      hidden_field(:assignment_id, :name=>"assignmentId", :frame=>frame)
      link(:assignment_list, :text=>"Assignment List", :frame=>frame)
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

end # CLEAssignments

