# Navigation links in Sakai's site pages
# 
# == Synopsis
#
# Defines all objects in Sakai Pages that are found in the
# context of a Course or Portfolio Site. No classes in this
# script should refer to pages that appear in the context of
# "My Workspace", even though, as in the case of Resources,
# Announcements, and Help, the page may exist in both contexts.
#
# Author :: Abe Heward (aheward@rsmart.com)
#
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
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList
  
  include PageObject
  include ToolsMenu
  
  # This method reads the type of assessment selected for creation,
  # then clicks the Create button and instantiates the proper class.
  #
  # If the assessment is going to be made in the builder, then
  # EditAssessment is called. If from Markup text...
  def create
    builder_or_text = frm.radio(:value=>"1", :name=>"authorIndexForm:_id29").set?
    
    frm.button(:value=>"Create").click
    
    if builder_or_text == true
      EditAssessment.new(@browser)
    else
      # Need to add Markup page class, then add the reference here.
    end
    
  end
  
  # Clicks the Question Pools link, then instantiates
  # the QuestionPoolsList class.
  def question_pools
    frm.link(:text=>"Question Pools").click
    QuestionPoolsList.new(@browser)
  end
  
  # Collects the titles of the Assessments listed as "Pending"
  # then returns them as an Array.
  def pending_assessment_titles
    titles =[]
    pending_table = @browser.frame(:index=>1).table(:class=>"authorIndexForm:coreAssessments")
    1.upto(pending_table.rows.size-1) do |x|
      titles << pending_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end
  
  # Collects the titles of the Assessments listed as "Published"
  # then returns them as an Array.
  def published_assessment_titles
    titles =[]
    published_table = @browser.frame(:index=>1).div(:class=>"tier2", :index=>2).table(:class=>"listHier")
    1.upto(published_table.rows.size-1) do |x|
      titles << published_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end
  
  def inactive_assessment_titles
    titles =[]
    inactive_table = @browser.frame(:index=>1).div(:class=>"tier2", :index=>2).table(:class=>"authorIndexForm:inactivePublishedAssessments")
    1.upto(inactive_table.rows.size-1) do |x|
      titles << inactive_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end
  
  # Opens the selected test for scoring
  # then instantiates the AssessmentTotalScores class.
  def score_test(test_title)
    test_names = get_published_titles
    index_value = test_names.index(test_title)
    frm.link(:id=>"authorIndexForm:_id88:#{index_value}:authorIndexToScore1").click
    AssessmentTotalScores.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    text_field(:title, :id=>"authorIndexForm:title", :frame=>frame)
    radio_button(:create_using_builder) { |page| page.radio_button_element(:name=>"authorIndexForm:_id29", index=>0, :frame=>frame) }
    radio_button(:create_using_text) { |page| page.radio_button_element(:name=>"authorIndexForm:_id29", :index=>$frame_index, :frame=>frame) }
    select_list(:select_assessment_type, :id=>"authorIndexForm:assessmentTemplate", :frame=>frame)
    button(:import, :id=>"authorIndexForm:import", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    
  end

end

# Page that appears when previewing an assessment.
# It shows the basic information about the assessment.
class PreviewOverview
  
  include PageObject
  include ToolsMenu
  
  # Scrapes the value of the due date from the page.
  def due_date
    frm.div(:class=>"tier2").table(:index=>0)[0][0].text
  end
  
  # Scrapes the value of the time limit from the page.
  def time_limit
    frm.div(:class=>"tier2").table(:index=>0)[3][0].text
  end
  
  # Scrapes the submission limit from the page.
  def submission_limit
    frm.div(:class=>"tier2").table(:index=>0)[6][0].text
  end
  
  # Scrapes the Feedback policy from the page.
  def feedback
    frm.div(:class=>"tier2").table(:index=>0)[9][0].text
  end
  
  # Clicks the Done button, then instantiates
  # the EditAssessment class.
  def done
    frm.button(:name=>"takeAssessmentForm:_id5").click
    EditAssessment.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    button(:begin_assessment, :id=>"takeAssessmentForm:beginAssessment3", :frame=>frame)
    
  end

end

# The Settings page for a particular Assessment
class AssessmentSettings
  
  include PageObject
  include ToolsMenu
  
  # Scrapes the Assessment Type from the page
  def assessment_type_title
    frm.div(:class=>"tier2").table(:index=>0)[0][1].text
  end
  
  # Scrapes the Assessment Author information from the page
  def assessment_type_author
    frm.div(:class=>"tier2").table(:index=>$frame_index)[1][1].text
  end
  
  # Scrapes the Assessment Type Description from the page.
  def assessment_type_description
    frm.div(:class=>"tier2").table(:index=>0)[2][1].text
  end
  
  # Clicks the Save Settings and Publish button
  # then instantiates the PublishAssessment class.
  def save_and_publish
    frm.button(:value=>"Save Settings and Publish").click
    PublishAssessment.new(@browser)
  end  
  
  in_frame(:index=>1) do |frame|
    link(:open, :text=>"Open", :frame=>frame)
    link(:close, :text=>"Close", :frame=>frame)
    text_field(:title, :id=>"assessmentSettingsAction:intro:assessment_title", :frame=>frame)
    text_field(:authors, :id=>"assessmentSettingsAction:intro:assessment_author", :frame=>frame)
    text_area(:description, :id=>"assessmentSettingsAction:intro:_id44_textinput", :frame=>frame)
    button(:add_attachments_to_intro, :name=>"assessmentSettingsAction:intro:_id90", :frame=>frame)
    text_field(:available_date, :id=>"assessmentSettingsAction:startDate", :frame=>frame)
    text_field(:due_date, :id=>"assessmentSettingsAction:endDate", :frame=>frame)
    text_field(:retract_date, :id=>"assessmentSettingsAction:retractDate", :frame=>frame)
    radio_button(:released_to_anonymous) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:_id117", :index=>$frame_index, :frame=>frame) }
    radio_button(:released_to_site) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:_id117", :index=>$frame_index, :frame=>frame) }
    text_area(:specified_ips, :name=>"assessmentSettingsAction:_id132", :frame=>frame)
    text_field(:secondary_id, :id=>"assessmentSettingsAction:username", :frame=>frame)
    text_field(:secondary_pw, :id=>"assessmentSettingsAction:password", :frame=>frame)
    checkbox(:timed_assessment, :id=>"assessmentSettingsAction:selTimeAssess", :frame=>frame)
    select_list(:limit_hour, :id=>"assessmentSettingsAction:timedHours", :frame=>frame)
    select_list(:limit_mins, :id=>"assessmentSettingsAction:timedMinutes", :frame=>frame)
    radio_button(:linear_access) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNavigation", :index=>$frame_index, :frame=>frame) }
    radio_button(:random_access) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNavigation", :index=>$frame_index, :frame=>frame) }
    radio_button(:question_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>$frame_index, :frame=>frame) }
    radio_button(:part_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>$frame_index, :frame=>frame) }
    radio_button(:assessment_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>2, :frame=>frame) }
    radio_button(:continuous_numbering) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNumbering", :index=>$frame_index, :frame=>frame) }
    radio_button(:restart_per_part) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNumbering", :index=>$frame_index, :frame=>frame) }
    checkbox(:add_mark_for_review, :id=>"assessmentSettingsAction:markForReview1", :frame=>frame)
    radio_button(:unlimited_submissions) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:unlimitedSubmissions", :index=>$frame_index, :frame=>frame) }
    radio_button(:only_x_submissions) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:unlimitedSubmissions", :index=>$frame_index, :frame=>frame) }
    text_field(:allowed_submissions, :id=>"assessmentSettingsAction:submissions_Allowed", :frame=>frame)
    radio_button(:late_submissions_not_accepted) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:lateHandling", :index=>$frame_index, :frame=>frame) }
    radio_button(:late_submissions_accepted) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:lateHandling", :index=>$frame_index, :frame=>frame) }
    text_area(:submission_message, :id=>"assessmentSettingsAction:_id245_textinput", :frame=>frame)
    text_field(:final_page_url, :id=>"assessmentSettingsAction:finalPageUrl", :frame=>frame)
    radio_button(:question_level_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>$frame_index, :frame=>frame) }
    radio_button(:selection_level_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>$frame_index, :frame=>frame) }
    radio_button(:both_feedback_levels) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>2, :frame=>frame) }
    radio_button(:immediate_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>$frame_index, :frame=>frame) }
    radio_button(:feedback_on_submission) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>$frame_index, :frame=>frame) }
    radio_button(:no_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>2, :frame=>frame) }
    radio_button(:feedback_on_date) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>3, :frame=>frame) }
    text_field(:feedback_date, :id=>"assessmentSettingsAction:feedbackDate", :frame=>frame)
    radio_button(:only_release_scores) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackComponentOption", :index=>$frame_index, :frame=>frame) }
    radio_button(:release_questions_and) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackComponentOption", :index=>$frame_index, :frame=>frame) }
    checkbox(:release_student_response, :id=>"assessmentSettingsAction:feedbackCheckbox1", :frame=>frame)
    checkbox(:release_correct_response, :id=>"assessmentSettingsAction:feedbackCheckbox3", :frame=>frame)
    checkbox(:release_students_assessment_scores, :id=>"assessmentSettingsAction:feedbackCheckbox5", :frame=>frame)
    checkbox(:release_students_question_and_part_scores, :id=>"assessmentSettingsAction:feedbackCheckbox7", :frame=>frame)
    checkbox(:release_question_level_feedback, :id=>"assessmentSettingsAction:feedbackCheckbox2", :frame=>frame)
    checkbox(:release_selection_level_feedback, :id=>"assessmentSettingsAction:feedbackCheckbox4", :frame=>frame)
    checkbox(:release_graders_comments, :id=>"assessmentSettingsAction:feedbackCheckbox6", :frame=>frame)
    checkbox(:release_statistics, :id=>"assessmentSettingsAction:feedbackCheckbox8", :frame=>frame)
    radio_button(:student_ids_seen) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:anonymousGrading1", :index=>$frame_index, :frame=>frame) }
    radio_button(:anonymous_grading) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:anonymousGrading1", :index=>$frame_index, :frame=>frame) }
    #radio_button(:no_gradebook_options) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #radio_button(:grades_sent_to_gradebook) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #radio_button(:record_highest_score) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #radio_button(:record_last_score) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #radio_button(:background_color) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #text_field(:color_value, :id=>"", :frame=>frame)
    #radio_button(:background_image) { |page| page.radio_button_element( :name=>"", :index=>$frame_index, :frame=>frame) }
    #text_field(:image_name, :=>"", :frame=>frame)
    #text_field(:keywords, :=>"", :frame=>frame)
    #text_field(:objectives, :=>"", :frame=>frame)
    #text_field(:rubrics, :=>"", :frame=>frame)
    #checkbox(:record_metadata_for_questions, :=>"", :frame=>frame)
    button(:save, :name=>"assessmentSettingsAction:_id383", :frame=>frame)
    button(:cancel, :name=>"assessmentSettingsAction:_id385", :frame=>frame)
    
  end

end

# Instructor's view of Students' assessment scores
class AssessmentTotalScores
  
  include PageObject
  include ToolsMenu
  
  # Gets the user ids listed in the
  # scores table.
  def student_ids
    ids = []
    scores_table = frm.table(:id=>"editTotalResults:totalScoreTable").to_a
    scores_table.delete_at(0)
    scores_table.each { |row| ids << row[1] }
    return ids
  end
  
  # Adds a comment to the specified student's comment box.
  def comment_for_student(student_id, comment)
    available_ids = student_ids
    index_val = available_ids.index(student_id)
    
    frm.text_field(:name=>"editTotalResults:totalScoreTable:#{index_val}:_id345").value=comment
    
  end
  
  # Clicks the Update button, then instantiates
  # the AssessmentTotalScores class.
  def update
    frm.button(:value=>"Update").click
    AssessmentTotalScores.new(@browser)
  end
  
  # Clicks the Assessments link on the page
  # then instantiates the AssessmentsList class.
  def assessments
    frm.link(:text=>"Assessments").click
    AssessmentsList.new(@browser)
  end

end

# The page that appears when you're creating a new quiz
# or editing an existing one
class EditAssessment
  
  include PageObject
  include ToolsMenu
  
  # Allows insertion of a question at a specified
  # point in the Assessment. Must include the
  # part number, the question number, and the type of
  # question. Question Type must match the Type
  # value in the drop down.
  #
  # The method will instantiate the page class
  # based on the selected question type.
  def insert_question_after(part_num, question_num, qtype)
    if question_num.to_i == 0
      frm.select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:changeQType").select(qtype)
    else
      frm.select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:parts:#{question_num.to_i - 1}:changeQType").select(qtype)
    end
    
    page = case(qtype)
    when "Multiple Choice" then MultipleChoice.new(@browser)
    when "True False" then TrueFalse.new(@browser)
    when "Survey" then Survey.new(@browser)
    when "Short Answer/Essay" then ShortAnswer.new(@browser)
    when "Fill in the Blank" then FillInBlank.new(@browser)
    when "Numeric Response" then NumericResponse.new(@browser)
    when "Matching" then Matching.new(@browser)
    when "Audio Recording" then AudioRecording.new(@browser)
    when "File Upload" then FileUpload.new(@browser)
    else puts "#{qtype} is not a valid question type"
    end
    
    return page
    
  end
  
  # Allows removal of question by part number and question number.
  def remove_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:deleteitem").click
  end
  
  # Allows editing of a question by specifying its part number
  # and question number.
  def edit_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:modify").click
  end
  
  # Allows copying an Assessment part to a Pool.
  def copy_part_to_pool(part_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:copyToPool").click
  end
  
  # Allows removing a specified
  # Assessment part number.
  def remove_part(part_num)
    frm.link(:xpath, "//a[contains(@onclick, 'assesssmentForm:parts:#{part_num.to_i-1}:copyToPool')]").click
  end
  
  # Clicks the Add Part button, then
  # instantiates the AddEditAssessmentPart page class.
  def add_part
    frm.link(:text=>"Add Part").click
    AddEditAssessmentPart.new(@browser)
  end
  
  # Selects the desired question type from the
  # drop down list, then instantiates the appropriate
  # page class.
  def select_question_type(qtype)
    frm.select(:id=>"assesssmentForm:changeQType").select(qtype)

    page = case(qtype)
    when "Multiple Choice" then MultipleChoice.new(@browser)
    when "True False" then TrueFalse.new(@browser)
    when "Survey" then Survey.new(@browser)
    when "Short Answer/Essay" then ShortAnswer.new(@browser)
    when "Fill in the Blank" then FillInBlank.new(@browser)
    when "Numeric Response" then NumericResponse.new(@browser)
    when "Matching" then Matching.new(@browser)
    when "Audio Recording" then AudioRecording.new(@browser)
    when "File Upload" then FileUpload.new(@browser)
    else puts "#{qtype} is not a valid question type"
    end
    
    return page
    
  end
  
  # Clicks the Preview button,
  # then instantiates the PreviewOverview page class.
  def preview
    frm.link(:text=>"Preview").click
    PreviewOverview.new(@browser)
  end
  
  # Clicks the Settings link, then
  # instantiates the AssessmentSettings page class.
  def settings
    frm.link(:text=>"Settings").click
    AssessmentSettings.new(@browser)
  end
  
  # Clicks the Publish button, then
  # instantiates the PublishAssessment page class.
  def publish
    frm.link(:text=>"Publish").click
    PublishAssessment.new(@browser)
  end
  
  # Clicks the Question Pools button, then
  # instantiates the QuestionPoolsList page class.
  def question_pools
    frm.link(:text=>"Question Pools").click
    QuestionPoolsList.new(@browser)
  end
  
  # Allows retrieval of a specified question's
  # text, by part and question number.
  def get_question_text(part_number, question_number)
    frm.table(:id=>"assesssmentForm:parts:#{part_number.to_i-1}:parts").div(:class=>"tier3", :index=>question_number.to_i-1).text
  end
  
  in_frame(:index=>1) do |frame|
    link(:assessments, :text=>"Assessments", :frame=>frame)
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    link(:print, :text=>"Print", :frame=>frame)
    button(:update_points, :id=>"assesssmentForm:pointsUpdate", :frame=>frame)
  end

end

# This is the page for adding and editing a part of an assessment
class AddEditAssessmentPart
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:name=>"modifyPartForm:_id89").click
    EditAssessment.new(@browser)    
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"modifyPartForm:title", :frame=>frame)
    text_area(:information, :id=>"modifyPartForm:_id10_textinput", :frame=>frame)
    button(:add_attachments, :name=>"modifyPartForm:_id54", :frame=>frame)
    radio_button(:questions_one_by_one) { |page| page.radio_button_element(:index=>0, :name=>"modifyPartForm:_id60", :frame=>frame)}
    radio_button(:random_draw) { |page| page.radio_button_element(:index=>1, :name=>"modifyPartForm:_id60", :frame=>frame) }
    select_list(:pool_name, :id=>"modifyPartForm:assignToPool", :frame=>frame)
    text_field(:number_of_questions, :id=>"modifyPartForm:numSelected", :frame=>frame)
    text_field(:point_value_of_questions, :id=>"modifyPartForm:numPointsRandom", :frame=>frame)
    text_field(:negative_point_value, :id=>"modifyPartForm:numDiscountRandom", :frame=>frame)
    radio_button(:randomized_each_time) { |page| page.radio_button_element(:index=>0, :name=>"modifyPartForm:randomizationType", :frame=>frame) }
    radio_button(:randomized_once) { |page| page.radio_button_element(:index=>1, :name=>"modifyPartForm:randomizationType", :frame=>frame) }
    radio_button(:order_as_listed) { |page| page.radio_button_element(:index=>0, :name=>"modifyPartForm:_id81", :frame=>frame) }
    radio_button(:random_within_part) { |page| page.radio_button_element(:index=>1, :name=>"modifyPartForm:_id81", :frame=>frame) }
    text_field(:objective, :id=>"modifyPartForm:obj", :frame=>frame)
    text_field(:keyword, :id=>"modifyPartForm:keyword", :frame=>frame)
    text_field(:rubric, :id=>"modifyPartForm:rubric", :frame=>frame)
    button(:cancel, :name=>"modifyPartForm:_id90", :frame=>frame)
  end

end

# The review page once you've selected to Save and Publish
# the assessment
class PublishAssessment
  
  include PageObject
  include ToolsMenu
  
  def publish
    frm.button(:value=>"Publish").click
    AssessmentsList.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :value=>"Cancel", :frame=>frame)
    button(:edit, :name=>"publishAssessmentForm:_id23", :frame=>frame)
    select_list(:notification, :id=>"publishAssessmentForm:number", :frame=>frame)
    
  end

end

# The page for setting up a multiple choice question
class MultipleChoice
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :value=>"Cancel", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    link(:whats_this, :text=>"(What's This?)", :frame=>frame)
    radio_button(:single_correct) { |page| page.radio_button_element(:name=>"itemForm:chooseAnswerTypeForMC", :index=>0, :frame=>frame) }
    radio_button(:enable_negative_marking) { |page| page.radio_button_element(:name=>"itemForm:partialCreadit_NegativeMarking", :index=>0, :frame=>frame) }
    
    # Element present when negative marking selected:
    text_field(:negative_point_value, :id=>"itemForm:answerdsc", :frame=>frame)
    
    radio_button(:enable_partial_credit) { |page| page.radio_button_element(:name=>"itemForm:partialCreadit_NegativeMarking", :index=>1, :frame=>frame) }
    link(:reset_to_default, :text=>"Reset to Default Grading Logic", :frame=>frame)
    radio_button(:multi_single) {|page| page.radio_button_element(:name=>"itemForm:chooseAnswerTypeForMC", :index=>1, :frame=>frame) }
    radio_button(:multi_multi) {|page| page.radio_button_element(:name=>"itemForm:chooseAnswerTypeForMC", :index=>2, :frame=>frame) }
    text_area(:question_text, :id=>"itemForm:_id81_textinput", :frame=>frame)
    button(:add_attachments, :name=>"itemForm:_id125", :frame=>frame)
    
    text_area(:answer_a, :id=>"itemForm:mcchoices:0:_id139_textinput", :frame=>frame)
    link(:remove_a, :id=>"itemForm:mcchoices:0:removelinkSingle", :frame=>frame)
    text_area(:answer_b, :id=>"itemForm:mcchoices:1:_id139_textinput", :frame=>frame)
    link(:remove_b, :id=>"itemForm:mcchoices:1:removelinkSingle", :frame=>frame)
    text_area(:answer_c, :id=>"itemForm:mcchoices:2:_id139_textinput", :frame=>frame)
    link(:remove_c, :id=>"itemForm:mcchoices:2:removelinkSingle", :frame=>frame)
    text_area(:answer_d, :id=>"itemForm:mcchoices:3:_id139_textinput", :frame=>frame)
    link(:remove_d, :id=>"itemForm:mcchoices:3:removelinkSingle", :frame=>frame)
    
    # Radio buttons that appear when "single correct" is selected
    radio_button(:a_correct, :name=>"itemForm:mcchoices:0:mcradiobtn", :frame=>frame)
    radio_button(:b_correct, :name=>"itemForm:mcchoices:1:mcradiobtn", :frame=>frame)
    radio_button(:c_correct, :name=>"itemForm:mcchoices:2:mcradiobtn", :frame=>frame)
    radio_button(:d_correct, :name=>"itemForm:mcchoices:3:mcradiobtn", :frame=>frame)
    
    # % Value fields that appear when "single correct" and "partial credit" selected
    text_field(:a_value, :id=>"itemForm:mcchoices:0:partialCredit", :frame=>frame)
    text_field(:b_value, :id=>"itemForm:mcchoices:1:partialCredit", :frame=>frame)
    text_field(:c_value, :id=>"itemForm:mcchoices:2:partialCredit", :frame=>frame)
    text_field(:d_value, :id=>"itemForm:mcchoices:3:partialCredit", :frame=>frame)
    
    link(:reset_score_values, :text=>"Reset Score Values", :frame=>frame)
    
    # Checkboxes that appear when "multiple correct" is selected
    checkbox(:a_correct, :name=>"itemForm:mcchoices:0:mccheckboxes", :frame=>frame)
    checkbox(:b_correct, :name=>"itemForm:mcchoices:1:mccheckboxes", :frame=>frame)
    checkbox(:c_correct, :name=>"itemForm:mcchoices:2:mccheckboxes", :frame=>frame)
    checkbox(:d_correct, :name=>"itemForm:mcchoices:3:mccheckboxes", :frame=>frame)
    
    select_list(:insert_additional_answers, :id=>"itemForm:insertAdditionalAnswerSelectMenu", :frame=>frame)
    radio_button(:randomize_answers_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:_id161", :frame=>frame) }
    radio_button(:randomize_answers_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:_id161", :frame=>frame) }
    radio_button(:require_rationale_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:_id165", :frame=>frame) }
    radio_button(:require_rationale_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:_id165", :frame=>frame) }
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id185_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id189_textinput", :frame=>frame)
    
  end
  
end

# The page for setting up a Survey question
class Survey
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id68_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id112", :frame=>frame)
    radio_button(:yes_no) { |page| page.radio_button_element(:index=>0, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:disagree_agree) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:disagree_undecided) {|page| page.radio_button_element(:index=>2, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:below_above) {|page| page.radio_button_element(:index=>3, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:strongly_agree) {|page| page.radio_button_element(:index=>4, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:unacceptable_excellent) {|page| page.radio_button_element(:index=>5, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:one_to_five) {|page| page.radio_button_element(:index=>6, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:one_to_ten) {|page| page.radio_button_element(:index=>7, :name=>"itemForm:selectscale", :frame=>frame)}
    text_area(:feedback, :id=>"itemForm:_id139_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a Short Answer/Essay question
class ShortAnswer
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id68_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id112", :frame=>frame)
    text_area(:model_short_answer, :id=>"itemForm:_id128_textinput", :frame=>frame)
    text_area(:feedback, :id=>"itemForm:_id132_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a Fill-in-the-blank question
class FillInBlank
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id74_textinput", :frame=>frame)
    checkbox(:case_sensitive, :name=>"itemForm:_id75", :frame=>frame)
    checkbox(:mutually_exclusive, :name=>"itemForm:_id77", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id125", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a numeric response question
class NumericResponse
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id72_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id116", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id132_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id134_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a matching question
class Matching
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id76_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id120", :frame=>frame)
    text_area(:choice, :id=>"itemForm:_id145_textinput", :frame=>frame)
    text_area(:match, :id=>"itemForm:_id148_textinput", :frame=>frame)
    button(:save_pairing, :name=>"itemForm:_id161", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id181_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id186_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a True/False question
class TrueFalse
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id76_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id120", :frame=>frame)
    text_field(:negative_point_value, :id=>"itemForm:answerdsc", :frame=>frame)
    radio_button(:answer_true) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:TF", :frame=>frame)}
    radio_button(:answer_false) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:TF", :frame=>frame)}
    radio_button(:required_rationale_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:rational", :frame=>frame)}
    radio_button(:required_rationale_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:rational", :frame=>frame)}
    text_area(:feedback_for_correct, :id=>"itemForm:_id147_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id151_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

#  The page for setting up a question that requires an audio response
class AudioRecording
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id68_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id112", :frame=>frame)
    text_field(:time_allowed, :id=>"itemForm:timeallowed", :frame=>frame)
    select_list(:number_of_attempts, :id=>"itemForm:noattempts", :frame=>frame)
    text_field(:feedback, :id=>"itemForm:_id145_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

# The page for setting up a question that requires
# attaching a file
class FileUpload
  
  include PageObject
  include ToolsMenu
  include QuestionHelpers
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id62", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id68_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id112", :frame=>frame)
    text_field(:feedback, :id=>"itemForm:_id129_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    
  end

end

# The page that appears when you are editing a type of assessment
class EditAssessmentType
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    
  end

end

# The Page that appears when adding a new question pool
class AddQuestionPool
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:id=>"questionpool:submit").click
    QuestionPoolsList.new(@browser)
  end
  
  
  in_frame(:index=>1) do |frame|
    text_field(:pool_name, :id=>"questionpool:namefield", :frame=>frame)
    text_field(:department_group, :id=>"questionpool:orgfield", :frame=>frame)
    text_area(:description, :id=>"questionpool:descfield", :frame=>frame)
    text_field(:objectives, :id=>"questionpool:objfield", :frame=>frame)
    text_field(:keywords, :id=>"questionpool:keyfield", :frame=>frame)
    button(:cancel, :id=>"questionpool:_id11", :frame=>frame)
    
  end

end

# The Page that appears when editing an existing question pool
class EditQuestionPool
  
  include PageObject
  include ToolsMenu
  
  def add_question
    frm.link(:id=>"editform:addQlink").click
    SelectQuestionType.new(@browser)
  end
  
  def question_pools
    frm.link(:text=>"Question Pools").click
    QuestionPoolsList.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:pool_name, :id=>"editform:namefield", :frame=>frame)
    text_field(:department_group, :id=>"editform:orgfield", :frame=>frame)
    text_area(:description, :id=>"editform:descfield", :frame=>frame)
    text_field(:objectives, :id=>"editform:objfield", :frame=>frame)
    text_field(:keywords, :id=>"editform:keyfield", :frame=>frame)
    button(:update, :id=>"editform:Update", :frame=>frame)
    button(:save, :id=>"questionpool:submit", :frame=>frame)
    button(:cancel, :id=>"questionpool:_id11", :frame=>frame)
    
  end

end

# The page with the list of existing Question Pools
class QuestionPoolsList
  
  include PageObject
  include ToolsMenu
  
  def edit_pool(name)
    frm.span(:text=>name).fire_event("onclick")
    EditQuestionPool.new(@browser)
  end
  
  def add_new_pool
    frm.link(:text=>"Add New Pool").click
    AddQuestionPool.new(@browser)
  end
  
  def import
    frm.link(:text=>"Import").click
    PoolImport.new(@browser)
  end
  
  def assessments
    frm.link(:text=>"Assessments").click
    AssessmentsList.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
  end
  
end

# The page that appears when you click to import
# a pool.
class PoolImport
  
  include PageObject
  include ToolsMenu
  
  def choose_file=(filename)
    frm.file_field(:name=>"importPoolForm:_id6.upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
  end
  
  def import
    frm.button(:value=>"Import").click
    QuestionPoolsList.new(@browser)
  end
  
end

# This page appears when adding a question to a pool
class SelectQuestionType
  
  include PageObject
  include ToolsMenu
  
  def select_question_type(qtype)
    frm(1).select(:id=>"_id1:selType").select(qtype)
    frm(1).button(:value=>"Save").click
    
    page = case(qtype)
    when "Multiple Choice" then MultipleChoice.new(@browser)
    when "True False" then TrueFalse.new(@browser)
    when "Survey" then Survey.new(@browser)
    when "Short Answer/Essay" then ShortAnswer.new(@browser)
    when "Fill in the Blank" then FillInBlank.new(@browser)
    when "Numeric Response" then NumericResponse.new(@browser)
    when "Matching" then Matching.new(@browser)
    when "Audio Recording" then AudioRecording.new(@browser)
    when "File Upload" then FileUpload.new(@browser)
    else puts "nothing selected"
    end
    
    return page
    
  end
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :value=>"Cancel", :frame=>frame)
  end
  
end

# Page of Assessments accessible to a student user
class TakeAssessmentList
  
  include PageObject
  include ToolsMenu
  
  def available_assessments
    # define this later
  end
  
  # Method to get the titles of assessments that
  # the student user has submitted
  def submitted_assessments
    table_array = @browser.frame(:index=>1).table(:id=>"selectIndexForm:reviewTable").to_a
    table_array.delete_at(0)
    titles = []
    table_array.each { |row|
      unless row[0] == ""
        titles << row[0]
      end
    }
    
    return titles
    
  end
  
  def take_assessment(name)
    begin
      frm.link(:text=>name).click
    rescue Watir::Exception::UnknownObjectException
      frm.link(:text=>CGI::escapeHTML(name)).click
    end
    BeginAssessment.new(@browser)
  end

  # This method is in need of improvement to make it
  # more generalized for finding the correct test.
  def feedback(test_name)
    test_table = frm(1).table(:id=>"selectIndexForm:reviewTable").to_a
    test_table.delete_if { |row| row[3] != "Immediate" }
    index_value = test_table.index { |row| row[0] == test_name }
    frm(1).link(:text=>"Feedback", :index=>index_value).click
    # Need to add a call to a New class here, when it's written
  end

end

# The student view of the overview page of an Assessment
class BeginAssessment
  
  include PageObject
  include ToolsMenu
  
  def begin_assessment
    frm.button(:value=>"Begin Assessment").click
  end
  
  def cancel
    # Define this later
  end

end

#================
# Assignments Pages
#================

# The page where you create a new assignment
class AssignmentAdd
  
  include PageObject
  include ToolsMenu
  
  # The rich text editor on this page is not defined here, yet.
  # It will need special handling in the test case itself.
  
  def post
    frm.button(:value=>"Post").click
    AssignmentsList.new(@browser)
  end
  
  def save_draft
    frm.button(:name=>"save").click
    AssignmentsList.new(@browser)
  end
   
  # The alert_text object on the Add/Edit Assignments page
  def alert_text
    frm.div(:class=>"portletBody").div(:class=>"alertMessage").text
  end
    
  # A method to insert text into the rich text editor
  def instructions=(instructions)
    frm.frame(:id, "new_assignment_instructions___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
  end
  
  in_frame(:index=>1) do |frame|
    hidden_field(:assignment_id, :name=>"assignmentId", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
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
    radio_button(:do_not_add_assignment, :id=>"no",:name=>"new_assignment_add_to_gradebook", :frame=>frame)
    radio_button(:add_assignment, :id=>"add", :name=>"new_assignment_add_to_gradebook", :frame=>frame)
    radio_button(:do_not_send_notifications, :id=>"notsendnotif", :frame=>frame)
    radio_button(:send_notifications, :id=>"sendnotif", :frame=>frame)
    radio_button(:send_summary_email, :id=>"sendnotifsummary", :frame=>frame)
    radio_button(:do_not_send_grade_notif, :id=>"notsendreleasegradenotif", :frame=>frame)
    radio_button(:send_grade_notif, :id=>"sendreleasegradenotif", :frame=>frame)
    button(:add_attachments, :name=>"attach", :frame=>frame)
    link(:add_model_answer, :id=>"modelanswer_add", :frame=>frame)
    link(:add_private_note, :id=>"note_add", :frame=>frame)
    link(:add_all_purpose_item, :id=>"allPurpose_add", :frame=>frame)
    
    button(:preview, :name=>"preview", :frame=>frame)
    button(:cancel, :name=>"cancel", :frame=>frame)
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
  
end

# Page that appears when you first click the Assignments link
class AssignmentsList
  
  include PageObject
  include ToolsMenu
  
  def assignments_titles
    titles = []
    a_table = @browser.frame(:index=>1).table(:class=>"listHier lines nolines")
    1.upto(a_table.rows.size-1) do |x|
      titles << a_table[x][1].h4(:index=>0).text
    end
    return titles
  end
  
  def add
    frm.link(:text=>"Add").click
    AssignmentAdd.new(@browser)
  end
  
  def edit_assignment_id(id)
    frm.link(:href=>/#{Regexp.escape(id)}/).click
    AssignmentAdd.new(@browser)
  end
  
  def get_assignment_id(assignment_name)
    frm.link(:text=>/#{Regexp.escape(assignment_name)}/).href =~ /(?<=\/a\/\S{36}\/).+(?=&pan)/
    return $~.to_s
  end
  
  def permissions
    frm.link(:text=>"Permissions").click
    AssignmentsPermissions.new(@browser)
  end
  
  def check_assignment(id) #FIXME to use name instead of id.
    frm.checkbox(:value, /#{id}/).set
  end
  
  in_frame(:index=>1) do |frame|
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:reorder, :text=>"Reorder", :frame=>frame)
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
  
end

# Options page for Assignments
class AssignmentsOptions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    radio_button(:default, :id=>"submission_list_option_default", :frame=>frame)
    radio_button(:only_show_filtered_submissions, :id=>"submission_list_option_searchonly", :frame=>frame)
    button(:update, :name=>"eventSubmit_doUpdate_options", :frame=>frame)
    button(:cancel, :name=>"eventSubmit_doCancel_options", :frame=>frame)
    
  end

end

# The Permissions Page in Assignments
class AssignmentsPermissions
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
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
    button(:save, :id=>"eventSubmit_doSave", :frame=>frame)
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

end

# Page that appears when you click to preview an Assignment
class AssignmentsPreview
  
  include PageObject
  include ToolsMenu
  
  def created_by
    frm.table(:class=>"itemSummary")[0][1].text
  end
  
  def modified
    frm.table(:class=>"itemSummary")[1][1].text
  end
  
  def open
    frm.table(:class=>"itemSummary")[2][1].text
  end
  
  def due
    frm.table(:class=>"itemSummary")[3][1].text
  end
  
  def accept_until
    frm.table(:class=>"itemSummary")[4][1].text
  end
  
  def student_submissions
    frm.table(:class=>"itemSummary")[5][1].text
  end
  
  def grade_scale
    frm.table(:class=>"itemSummary")[6][1].text
  end
  
  def add_due_date
    frm.table(:class=>"itemSummary")[7][1].text
  end
  
  def announce_open_date
    frm.table(:class=>"itemSummary")[8][1].text
  end
  
  def honor_pledge
    frm.table(:class=>"itemSummary")[9][1].text
  end
  
  def add_to_gradebook
    frm.table(:class=>"itemSummary")[10][1].text
  end
  
  def assignment_instructions
    frm.div(:class=>"textPanel").text
  end
  
  def post
    frm.button(:name=>"post").click
    AssignmentsList.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    hidden_field(:assignment_id, :name=>"assignmentId", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:hide_assignment, :href=>/doHide_preview_assignment_assignment/, :frame=>frame)
    link(:show_assignment, :href=>/doShow_preview_assignment_assignment/, :frame=>frame)
    link(:hide_student_view, :href=>/doHide_preview_assignment_student_view/, :frame=>frame)
    link(:show_student_view, :href=>/doShow_preview_assignment_student_view/, :frame=>frame)
    button(:edit, :name=>"revise", :frame=>frame)
    button(:save_draft, :name=>"save", :frame=>frame)
    button(:done, :name=>"done", :frame=>frame)
    
  end
  
end

# The reorder page for Assignments
class AssignmentsReorder
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
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
    button(:save, :name=>"save", :frame=>frame)
    button(:cancel, :name=>"cancel", :frame=>frame)
    
  end

end

# A Student user's page for editing/submitting an assignment.
class AssignmentStudent
  
  include PageObject
  include ToolsMenu
  
  def title
    frm.table(:class=>"itemSummary")[0][1].text
  end
  
  def due
    frm.table(:class=>"itemSummary")[0][2].text
  end
  
  def status
    frm.table(:class=>"itemSummary")[0][3].text
  end
  
  def grade_scale
    frm.table(:class=>"itemSummary")[0][4].text
  end
  
  def modified
    frm.table(:class=>"itemSummary")[0][5].text
  end
  
  def add_assignment_text(text)
    frm.frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def remove_assignment_text
    frm.frame(:id, "Assignment.view_submission_text___Frame").div(:title=>"Select All").fire_event("onclick")
    frm.frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end
  
  def file_field #FIXME
    frm.file_field(:id=>"clonableUpload")
  end
  
  in_frame(:index=>1) do |frame|
    button(:submit, :id=>"post", :frame=>frame)
    button(:preview, :id=>"preview", :frame=>frame)
    button(:save_draft, :id=>"save", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
    button(:select_files, :id=>"attach", :frame=>frame)
    link(:add_another_file, :id=>"addMoreAttachmentControls", :frame=>frame)
  end

end

# The page that appears when you click on an assignments "Grade" link
# as an instructor. Shows the list of students and their
# assignment submission status.
class AssignmentSubmissionList
  
  include PageObject
  include ToolsMenu
  
  def show_resubmission_settings
    frm.image(:src, "/library/image/sakai/expand.gif?panel=Main").click
  end
  
  def show_assignment_details
    frm.image(:src, "/library/image/sakai/expand.gif").click
  end
  
  def student_table
    table = frm.table(:class=>"listHier lines nolines").to_a
  end
  
  in_frame(:index=>1) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
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

# The page that shows a student's submitted assignment
class AssignmentSubmission
  
  include PageObject
  include ToolsMenu
  
  def student_assignment_text
    frm.frame(:id, "grade_submission_feedback_text___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def set_instructor_comments(text)
    frm.frame(:id, "grade_submission_feedback_comment___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  in_frame(:index=>1) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:assignment_list, :text=>"Assignment List", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:reorder, :text=>"Reorder", :frame=>frame)
    button(:previous, :name=>"prevsubmission1", :frame=>frame)
    button(:return_to_list, :name=>"cancelgradesubmission1", :frame=>frame)
    button(:next, :name=>"nextsubmission1", :frame=>frame)
    button(:add_attachments, :name=>"attach", :frame=>frame)
    select_list(:select_default_grade, :name=>"grade_submission_grade", :frame=>frame)
    checkbox(:allow_resubmission, :id=>"allowResToggle", :frame=>frame)
    select_list(:num_resubmissions, :id=>"allowResubmitNumberSelect", :frame=>frame)
    select_list(:accept_until_month, :id=>"allow_resubmit_closeMonth", :frame=>frame)
    select_list(:accept_until_day, :id=>"allow_resubmit_closeDay", :frame=>frame)
    select_list(:accept_until_year, :id=>"allow_resubmit_closeYear", :frame=>frame)
    select_list(:accept_until_hour, :id=>"allow_resubmit_closeHour", :frame=>frame)
    select_list(:accept_until_min, :id=>"allow_resubmit_closeMin", :frame=>frame)
    select_list(:accept_until_meridian, :id=>"allow_resubmit_closeAMPM", :frame=>frame)
    button(:save_dont_release, :name=>"save", :frame=>frame)
    button(:save_and_release, :name=>"return", :frame=>frame)
    button(:preview, :name=>"preview", :frame=>frame)
    button(:cancel, :name=>"cancel", :frame=>frame)
    
  end

end

# The Grade Report page accessed from the Assignments page
class GradeReport
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    #(:, :=>"", :frame=>frame)
    
  end

end

# The Student View page accessed from the Assignments page
class StudentView
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
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


#================
# Discussion Forums Pages
#================

# This module includes page objects that are common to
# all pages in the JForums.
module JForumsResources
  
  def discussion_home
    frm.link(:id=>"backtosite").click
    JForums.new(@browser)
  end
  
  def search
    frm.link(:id=>"search", :class=>"mainmenu").click
    DiscussionSearch.new(@browser)
  end
  
  def my_bookmarks
    frm.link(:class=>"mainmenu", :text=>"My Bookmarks").click
    MyBookmarks.new(@browser)
  end
  
  def my_profile
    frm.link(:id=>"myprofile").click
    DiscussionsMyProfile.new(@browser)
  end
  
  def member_listing
    frm.link(:text=>"Member Listing", :id=>"latest", :class=>"mainmenu").click
    DiscussionMemberListing.new(@browser)
  end
  
  def private_messages
    frm.link(:id=>"privatemessages", :class=>"mainmenu").click
    PrivateMessages.new(@browser)
  end
  
  def manage
    frm.link(:id=>"adminpanel", :text=>"Manage").click
    ManageDiscussions.new(@browser)
  end
  
  
end

# The topmost page in Discussion Forums
class JForums
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Clicks on the supplied forum name
  # Then instantiates the DiscussionForum class.
  def open_forum(forum_name)
    frm.link(:text=>forum_name).click
    DiscussionForum.new(@browser)
  end
  
  def open_topic(topic_title)
    frm.link(:text=>topic_title).click
    ViewTopic.new(@browser)
  end

end

# The page of a particular Discussion Forum, show the list
# of Topics in the forum.
class DiscussionForum
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Clicks the New Topic button,
  # then instantiates the NewTopic class
  def new_topic
    frm.image(:alt=>"New Topic").fire_event("onclick")
    NewTopic.new(@browser)
  end
  
  def open_topic(topic_title)
    frm.link(:href=>/posts.list/, :text=>topic_title).click
    ViewTopic.new(@browser)
  end
  
end

class DiscussionSearch
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Clicks the Search button on the page,
  # then instantiates the JForums class.
  def click_search
    frm.button(:value=>"Search").click
    JForums.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:keywords, :name=>"search_keywords", :frame=>frame)
  end
end

class ManageDiscussions
  
  include PageObject
  include ToolsMenu
  
  def manage_forums
    frm.link(:text=>"Manage Forums").click
    ManageForums.new(@browser)
  end

  # Creates an array of forum titles
  # which can be used for verification
  def forum_titles
    forum_titles = []
    forum_links = frm.links.find_all { |link| link.id=="forumEdit"}
    forum_links.each { |link| forum_titles << link.text }
    return forum_titles
  end

  in_frame(:index=>1) do |frame|
    
  end
end

class ManageForums
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.button(:value=>"Add").click
    ManageForums.new(@browser)
  end
  
  def update
    frm.button(:value=>"Update").click
    ManageDiscussions.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:forum_name, :name=>"forum_name", :frame=>frame)
    select_list(:category, :id=>"categories_id", :frame=>frame)
    text_area(:description, :name=>"description", :frame=>frame)
  end
end


class MyBookmarks
  
  include PageObject
  include ToolsMenu
  include JForumsResources


end

# The page for adding a new discussion topic.
class NewTopic
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  def message_text=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def submit
    frm.button(:value=>"Submit").click
    ViewTopic.new(@browser)
  end 
  
  def preview
    frm.button(:value=>"Preview").click
    PreviewDiscussionTopic.new(@browser)
  end
  
  # Enters the specified filename in the file field.
  def filename1(filename)
    frm.file_field(:name=>"file_0").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def filename2(filename)
    frm.file_field(:name=>"file_1").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end

  in_frame(:index=>1) do |frame|
    text_field(:subject, :id=>"subject", :frame=>frame)
    button(:attach_files, :value=>"Attach Files", :frame=>frame)
    button(:add_another_file, :value=>"Add another file", :frame=>frame)
  end
end

# Viewing a Topic/Message
class ViewTopic
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Gets the text of the Topic title.
  # Useful for verification.
  def topic_name
    frm.link(:id=>"top", :class=>"maintitle").text
  end
  
  # Gets the message text for the specified message (not zero-based).
  # Useful for verification.
  def message_text(message_number)
    frm.span(:class=>"postbody", :index=>message_number.to_i-1).text
  end
  
  def post_reply
    frm.image(:alt=>"Post Reply").fire_event("onclick")
    NewTopic.new(@browser)
  end
  
  # Clicks the Quick Reply button
  # and does not instantiate any page classes.
  def quick_reply 
    frm.image(:alt=>"Quick Reply").fire_event("onclick")
  end
  
  # Clicks the submit button underneath the Quick Reply box,
  # then re-instantiates the class, due to the page update.
  def submit
    frm.button(:value=>"Submit").click
    ViewTopic.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_area(:reply_text, :name=>"quickmessage", :frame=>frame)
  end
  
end

# The Profile page for Discussion Forums
class DiscussionsMyProfile
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  def submit
    frm.button(:value=>"Submit").click
    DiscussionsMyProfile.new(@browser)
  end
  
  # Gets the text at the top of the table.
  # Useful for verification.
  def header_text
    frm.table(:class=>"forumline").span(:class=>"gens").text
  end
  
  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def avatar=(filename)
    frm.file_field(:name=>"avatar").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:icq_uin, :name=>"icq", :frame=>frame)
    text_field(:aim, :name=>"aim", :frame=>frame)
    text_field(:web_site, :name=>"website", :frame=>frame)
    text_field(:occupation, :name=>"occupation", :frame=>frame)
    radio_button(:view_email) { |page| page.radio_button_element(:name=>"viewemail", :index=>$frame_index, :frame=>frame) }
  end
end

# The List of Members of a Site's Discussion Forums
class DiscussionMemberListing
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Checks if the specified Member name appears
  # in the member listing.
  def name_present?(name)
    member_links = frm.links.find_all { |link| link.href=~/user.profile/ }
    member_names = []
    member_links.each { |link| member_names << link.text }
    member_names.include?(name)
  end

end

# The page where users go to read their private messages in the Discussion
# Forums.
class PrivateMessages
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  def new_pm
    frm.image(:alt=>"New PM").fire_event("onclick")
    NewPrivateMessage.new(@browser)
  end
  
  def open_message(title)
    frm.link(:class=>"topictitle", :text=>title).click
    ViewPM.new(@browser)
  end
  
  # Collects all subject text strings of the listed
  # private messages and returns them in an Array.
  def pm_subjects
    anchor_objects = frm.links.find_all { |link| link.href=~/pm.read.+page/ }
    subjects = []
    anchor_objects.each { |link| subjects << link.text }
    return subjects 
  end
  
end

class ViewPM
  
  include PageObject
  include ToolsMenu
  
  def reply_quote
    frm.image(:alt=>"Reply Quote").fire_event("onclick")
    NewPrivateMessage.new(@browser)
  end

end

# New Private Message page in Discussion Forums.
class NewPrivateMessage
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  def message_body=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def submit
    frm.button(:value=>"Submit").click
    Information.new(@browser)
  end
  
  # Enters the specified filename in the file field.
  def filename1(filename)
    frm.file_field(:name=>"file_0").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def filename2(filename)
    frm.file_field(:name=>"file_1").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end

  in_frame(:index=>1) do |frame|
    select_list(:to_user, :name=>"toUsername", :frame=>frame)
    text_field(:subject, :id=>"subject", :frame=>frame)
    button(:attach_files, :value=>"Attach Files", :frame=>frame)
    button(:add_another_file, :value=>"Add another file", :frame=>frame)
  end
  
end

# The page that appears when you've done something in discussions, like
# sent a Private Message.
class Information
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Gets the information message on the page.
  # Useful for verification.
  def information_text
    frm.table(:class=>"forumline").span(:class=>"gen").text
  end

end


#================
# Forum Pages - NOT "Discussion Forums"
#================

# The forums page in a particular Site
class Forums
  
  include PageObject
  include ToolsMenu

  
  def new_forum
    frm.link(:text=>"New Forum").click
    EditForum.new(@browser)
  end

  def new_topic_for_forum(name)
    index = forum_titles.index(name)
    frm.link(:text=>"New Topic", :index=>index).click
    AddEditTopic.new(@browser)
  end

  def organize
    frm.link(:text=>"Organize").click
    OrganizeForums.new(@browser)
  end

  def template_settings
    frm.link(:text=>"Template Settings").click
    ForumTemplateSettings.new(@browser)
  end

  def forums_table
    frm.div(:class=>"portletBody").table(:id=>"msgForum:forums")
  end

  def forum_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name=="title" && link.id=="" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def topic_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name == "title" && link.id != "" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def forum_settings(name)
    index = forum_titles.index(name)
    frm.link(:text=>"Forum Settings", :index=>index).click
    EditForum.new(@browser)
  end
  
  def topic_settings(name)
    index = topic_titles.index(name)
    frm.link(:text=>"Topic Settings", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def delete_forum(name)
    index = forum_titles.index(name)
    frm.link(:id=>/msgForum:forums:\d+:delete/,:text=>"Delete", :index=>index).click
    EditForum.new(@browser)
  end
  
  def delete_topic(name)
    index = topic_titles.index(name)
    frm.link(:id=>/topics:\d+:delete_confirm/, :text=>"Delete", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def open_forum(forum_title)
    frm.link(:text=>forum_title).click
    # New Class def goes here.
  end
  
  def open_topic(topic_title)
    frm.link(:text=>topic_title).click
    TopicPage.new(@browser)
  end
  
end

class TopicPage
  
  include PageObject
  include ToolsMenu
  
  def post_new_thread
    frm.link(:text=>"Post New Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def thread_titles
    titles = []
    message_table = frm.table(:id=>"msgForum:messagesInHierDataTable")
    1.upto(message_table.rows.size-1) do |x|
      titles << message_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end
  
  def open_message(message_title)
    frm.div(:class=>"portletBody").link(:text=>message_title).click
    ViewForumThread.new(@browser)
  end
  
  def display_entire_message
    frm.link(:text=>"Display Entire Message").click
    TopicPage.new(@browser)
  end
  
end

class ViewForumThread
  
  include PageObject
  include ToolsMenu
  
  def reply_to_thread
    frm.link(:text=>"Reply to Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def reply_to_message(index)
    frm.link(:text=>"Reply", :index=>(index.to_i - 1)).click
    ComposeForumMessage.new(@browser)
  end

end


class ComposeForumMessage
  
  include PageObject
  include ToolsMenu
  
  def post_message
    frm.button(:text=>"Post Message").click
    # Not sure if we need logic here...
    TopicPage.new(@browser)
  end
  
  def editor
    frm.frame(:id, "dfCompose:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def message=(text)
    editor.send_keys(text)
  end
  
  def reply_text
    @browser.frame(:index=>1).div(:class=>"singleMessageReply").text
  end
  
  def add_attachments
    #FIXME
  end
  
  def cancel
    frm.button(:value=>"Cancel").click
    # Logic for picking the correct page class
    if frm.link(:text=>"Reply to Thread")
      ViewForumThread.new(@browser)
    elsif frm.link(:text=>"Post New Thread").click
      TopicPage.new(@browser)
    end 
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"dfCompose:df_compose_title", :frame=>frame)
  end
end

class ForumTemplateSettings
  
  include PageObject
  include ToolsMenu
  
  def page_title
    frm.div(:class=>"portletBody").h3(:index=>0).text
  end
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def cancel
    frm.button(:value=>"Cancel").click
    Forums.new(@browser)
  end
=begin
    def site_role=(role)
    frm.select(:id=>"revise:role").select(role)
    0.upto(frm.select(:id=>"revise:role").length - 1) do |x|
      if frm.div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm.select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end
        
      end
    end
  end
=end  

end

class OrganizeForums
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  # These are set to so that the user
  # does not have to start the list at zero...
  def forum(index)
    frm.select(:id, "revise:forums:#{index.to_i - 1}:forumIndex")
  end
  
  def topic(forumindex, topicindex)
    frm.select(:id, "revise:forums:#{forumindex.to_i - 1}:topics:#{topicindex.to_i - 1}:topicIndex")
  end
  
end

# The page for creating/editing a forum in a Site
class EditForum
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def save_and_add
    frm.button(:value=>"Save Settings & Add Topic").click
    AddEditTopic.new(@browser)
  end
  
  def editor
    frm.div(:class=>"portletBody").frame(:id, "revise:df_compose_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def add_attachments
    frm.button(:value=>/attachments/).click
    ForumsAddAttachments.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"revise:forum_title", :frame=>frame)
    text_area(:short_description, :id=>"revise:forum_shortDescription", :frame=>frame)
    
  end
end

class ForumsAddAttachments
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    sleep 2 #FIXME
    frm.div(:class=>"portletBody").h3(:index=>0).wait_until_present
    title = frm.div(:class=>"portletBody").h3(:index=>0).text
    # Need logic because new page will be different
    if title=="Topic Settings"
      AddEditTopic.new(@browser)
    elsif title=="Forum Settings"
      EditForum.new(@browser)
    end
  end
  
  def upload_file=(file_name)
    frm.file_field(:id, "upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
  end

end

class AddEditTopic
  
  include PageObject
  include ToolsMenu
  
  @@table_index=0
  
  def editor
    frm.div(:class=>"portletBody").frame(:id, "revise:topic_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def add_attachments
    frm.button(:value=>/Add.+ttachment/).click
    ForumsAddAttachments.new(@browser)
  end
  
  def roles
    roles=[]
    options = frm.select(:id=>"revise:role").options.to_a
    options.each { |option| roles << option.text }
    return roles
  end
  
  def site_role=(role)
    frm.select(:id=>"revise:role").select(role)
    0.upto(frm.select(:id=>"revise:role").length - 1) do |x|
      if frm.div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm.select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end
        
      end
    end
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"revise:topic_title", :frame=>frame)
    text_area(:short_description, :id=>"revise:topic_shortDescription", :frame=>frame)
  end
end


#================
# Gradebook Pages
#================

# The topmost page in a Site's Gradebook
class Gradebook
  
  include PageObject
  include ToolsMenu

  def items_titles
    items_table = frm.table(:class=>"listHier lines nolines")
    1.upto(items_table.rows.size-1) do |x|
      titles << items_table.row(:index=>x).a(:index=>0).text
    end
    return titles
  end
  
end




#================
# Lesson Pages
#================

# The Lessons page in a site ("icon-sakai-melete")
#
# Note that this class is inclusive of both the
# Instructor/Admin and the Student views of this page
# many methods will error out if used when in the
# Student view.
class Lessons
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Module link, then
  # instantiates the AddModule class.
  #
  # Assumes the Add Module link is present
  # and will error out if it is not.
  def add_module
    frm.link(:text=>"Add Module").click
    AddEditModule.new(@browser)
  end
  
  # Clicks on the Preferences link on the Lessons page,
  # then instantiates the LessonPreferences class.
  def preferences
    frm.link(:text=>"Preferences").click
    LessonPreferences.new(@browser)
  end
  
  def view
    frm.link(:text=>"View").click
    if frm.div(:class=>"meletePortletToolBarMessage").text=="Viewing student side..."
      ViewModuleList.new(@browser)
    else
      #FIXME
    end
  end
  
  def manage
    frm.link(:text=>"Manage").click
    LessonManage.new(@browser)
  end
  
  # Clicks on the link that matches the supplied
  # name value, then instantiates the
  # AddEditLesson, or ViewLesson class, depending
  # on which page loads.
  #
  # Will error out if there is no
  # matching link in the list.
  def open_lesson(name)
    frm.link(:text=>name).click
    if frm.div(:class=>"meletePortletToolBarMessage").text=="Editing module..."
      AddEditModule.new(@browser)
    else
      ViewModule.new(@browser)
    end
  end

end

# The student user's view of a Lesson Module.
class ViewModule
  
  include PageObject
  include ToolsMenu

  #FIXME

end

# This is the Instructor's preview of the Student's view
# of the list of Lesson Modules.
class ViewModuleList
  
  include PageObject
  include ToolsMenu
  
  def open_lesson(name)
    frm.link(:text=>name).click
    LessonStudentSide.new(@browser)
  end
  
  def open_section(name)
    frm.link(:text=>name).click
    SectionStudentSide.new(@browser)
  end
  
end

# The instructor's preview of the student view of the lesson.
class LessonStudentSide
  
  include PageObject
  include ToolsMenu
  
end

# The instructor's preview of the student's view of the section.
class SectionStudentSide
  
  include PageObject
  include ToolsMenu
  
  def manage
    frm.link(:text=>"Manage").click
    LessonManage.new(@browser)
  end
  
end

# The Managing Options page for Lessons
class LessonManage
  
  include PageObject
  include ToolsMenu
  
  def manage_content
    frm.link(:text=>"Manage Content").click
    LessonManageContent.new(@browser)
  end
  
  def sort
    frm.link(:text=>"Sort").click
    LessonManageSort.new(@browser)
  end

  def import_export
    frm.link(:text=>"Import/Export").click
    LessonImportExport.new(@browser)
  end

end

# The Sorting Modules and Sections page in Lessons
class LessonManageSort
  
  include PageObject
  include ToolsMenu

  def view
    frm.link(:text=>"View").click
    if frm.div(:class=>"meletePortletToolBarMessage").text=="Viewing student side..."
      ViewModuleList.new(@browser)
    else
      #FIXME
    end
  end

  in_frame(:index=>1) do |frame|
    link(:sort_modules, :id=>"SortSectionForm:sortmod", :frame=>frame)
    link(:sort_sections, :id=>"SortModuleForm:sortsec", :frame=>frame)
    
  end
end

# The Import/Export page in Manage Lessons for a Site
class LessonImportExport
  
  include PageObject
  include ToolsMenu

  # Uploads the file specified - meaning that it enters
  # the target file information, then clicks the import
  # button.
  # 
  # Note that it pulls the file from the
  # data folder.
  # 
  # The method also runs a Test::Unit assert
  # to verify the "successful upload" message appears.
  def upload_IMS(file_name)
    frm.file_field(:name, "impfile").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
    frm.link(:id=>"importexportform:importModule").click
    frm.table(:id=>"AutoNumber1").div(:text=>"Processing...").wait_while_present
    assert_equal(frm.span(:class=>"BlueClass").text, "Imported the package successfully. Modules are created at the end of existing modules.", "Import failed")
  end

end

# The User preference options page for Lessons.
#
# Note that this class is inclusive of Student
# and Instructor views of the page. Thus,
# not all methods in the class will work
# at all times.
class LessonPreferences
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Set button
  def set
    frm.link(:id=>"UserPreferenceForm:SetButton").click
  end
  
  # Clicks the View button
  # then instantiates the Lessons class.
  def view
    frm.link(:text=>"View").click
    Lessons.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    radio_button(:expanded) { |page| page.radio_button_element(:name=>"UserPreferenceForm:_id5", :index=>0, :frame=>frame) }
    radio_button(:collapsed) { |page| page.radio_button_element(:name=>"UserPreferenceForm:_id5", :index=>1, :frame=>frame) }
  end
end

# This Class encompasses methods for both the Add and the Edit pages for Lesson Modules.
class AddEditModule
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add button for the Lesson Module
  # then instantiates the ConfirmModule class.
  def add
    frm.link(:id=>/ModuleForm:submitsave/).click
    ConfirmModule.new(@browser)
  end

  def add_content_sections
    frm.link(:id=>/ModuleForm:sectionButton/).click
    AddEditSection.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>/ModuleForm:title/, :frame=>frame)
    text_area(:description, :id=>/ModuleForm:description/, :frame=>frame)
    text_area(:keywords, :id=>/ModuleForm:keywords/, :frame=>frame)
    text_field(:start_date, :id=>/ModuleForm:startDate/, :frame=>frame)
    text_field(:end_date, :id=>/ModuleForm:endDate/, :frame=>frame)
  end
end

# The confirmation page when you are saving a Lesson Module.
class ConfirmModule
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Content Sections button and
  # instantiates the AddEditSection class.
  def add_content_sections
    frm.link(:id=>/ModuleConfirmForm:sectionButton/).click
    AddEditSection.new(@browser)
  end
  
  # Clicks the Return to Modules button, then
  # instantiates the AddEditModule class.
  def return_to_modules
    frm.link(:id=>"AddModuleConfirmForm:returnModImg").click
    AddEditModule.new(@browser)
  end

end

class AddEditSection
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add button on the page
  # then instantiates the ConfirmSectionAdd class.
  def add
    frm.link(:id=>/SectionForm:submitsave/).click
    ConfirmSectionAdd.new(@browser)
  end

  # Pointer to the Edit Text box of the FCKEditor
  # on the page.
  def content_editor
    frm.frame(:id, "AddSectionForm:fckEditorView:otherMeletecontentEditor_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end

  def add_content=(text)
    content_editor.send_keys(text)
  end

  def clear_content
    frm.frame(:id, "AddSectionForm:fckEditorView:otherMeletecontentEditor_inputRichText___Frame").div(:title=>"Select All").fire_event("onclick")
    content_editor.send_keys :backspace
  end

  def select_url
    frm.link(:id=>"AddSectionForm:ContentLinkView:serverViewButton").click
    SelectingContent.new(@browser)
  end
  
  # This method clicks the Select button that appears on the page
  # then calls the LessonAddAttachment class.
  #
  # It assumes that the Content Type selection box has
  # already been updated to "Upload or link to a file in Resources".
  def select_or_upload_file
    frm.link(:id=>"AddSectionForm:ResourceHelperLinkView:serverViewButton").click
    LessonAddAttachment.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"AddSectionForm:title", :frame=>frame)
    select_list(:content_type, :id=>"AddSectionForm:contentType", :frame=>frame)
    checkbox(:auditory_content, :id=>"AddSectionForm:contentaudio", :frame=>frame)
  end
end

# Confirmation page for Adding (or Editing)
# a Section to a Module in Lessons.
class ConfirmSectionAdd
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Another Section button
  # then instantiates the AddSection class.
  def add_another_section
    frm.link(:id=>/SectionConfirmForm:saveAddAnotherbutton/).click
    AddEditSection.new(@browser)
  end
  
  # Clicks the Finish button
  # then instantiates the Lessons class.
  def finish
    frm.link(:id=>/Form:FinishButton/).click
    Lessons.new(@browser)
  end

end

class SelectingContent
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.link(:id=>"ServerViewForm:addButton").click
    AddEditSection.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:new_url, :id=>"ServerViewForm:link", :frame=>frame)
    text_field(:url_title, :id=>"ServerViewForm:link_title", :frame=>frame)
  end
end

class LessonAddAttachment
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button on the page
  # and instantiates the AddSection class.
  #
  # Note that it assumes the Continue button is present
  # and available.
  def continue
    frm.button(:value=>"Continue").click
    AddEditSection.new(@browser)
  end
  
  # Finds the row containing the target filename, then
  # clicks the Select link associated with the
  # file.
  #
  # Note it will error out if the name used is not found
  # in the list.
  def select_file(filename)
    index = file_names.index(filename)
    frm.link(:text=>"Select", :index=>index).click
  end
  
  # Returns an array of the file names currently listed
  # on the Add Attachments page for Lessons.
  # 
  # It excludes folder names.
  def file_names
    names = []
    table = frm.table(:class=>"listHier lines")
    anchors = table.links.find_all { |link| link.text != "" && link.title =~/File Type/ }
    anchors.each { |anchor| names << anchor.text }
    return names
  end
  
  #FIXME!!!
=begin
  # This method returns folder names only
  def folder_names
    names = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].h3.exist? && resources_table[x][2].a.title=~/folder/
        names << resources_table[x][2].text
      end
    end
    return names
  end
  
  # This method returns an array of both the file and folder names
  # currently listed on the Resources page.
  #
  # Note that it adds "" entries for any blank lines found
  # so that the row index will still be accurate for the
  # table itself. This is sometimes necessary for being
  # able to find the correct row.
  def resource_names
    titles = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][2].link.exist?
        titles << resources_table[x][2].text
      else
        titles << ""
      end
    end
    return titles
  end
=end  

end


#================
# Messages Pages
#================

# The Messages page for a Site
class Messages

  include PageObject
  include ToolsMenu
  
  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  def received 
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

  def sent
    frm.link(:text=>"Sent").click
    MessagesSentList.new(@browser)
  end
  
  def deleted
    frm.link(:text=>"Deleted").click
    MessagesDeletedList.new(@browser)
  end
  
  def draft
    frm.link(:text=>"Draft").click
    MessagesDraftList.new(@browser)
  end

  def open_folder(foldername)
    frm.link(:text=>foldername).click
    FolderList.new(@browser)
  end

  def new_folder
    frm.link(:text=>"New Folder").click
    MessagesNewFolder.new(@browser)
  end
  
  def settings
    frm.link(:text=>"Settings").click
    MessagesSettings.new(@browser)
  end
  
  # Gets the count of messages
  # in the specified folder
  # and returns it as a string
  def total_messages_in_folder(folder_name)
    index=folders.index(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:index=>index).span(:class=>"textPanelFooter", :index=>0).text =~ /\d+/
    return $~.to_s
  end
  
  # Gets the count of unread messages
  # in the specified folder and returns it
  # as a string
  def unread_messages_in_folder(folder_name)
    index=folders.index(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:index=>index).span(:class=>"textPanelFooter", :index=>0).text =~ /\d+/
    return $~.to_s
  end
  
  # Gets all the folder names
  def folders
    links = frm.table(:class=>"hierItemBlockWrapper").links.find_all { |link| link.title != /Folder Settings/ }
    folders = []
    links.each { |link| folders << link.text }
    return folders
  end
  
  def folder_settings(foldername)
    index = folders.index(foldername)
    frm.table(:class=>"hierItemBlockWrapper").link(:text=>"Folder Settings", :index=>index-4).click
    MessageFolderSettings.new(@browser)
  end
  
end

# The page showing the user's Sent Messages.
class MessagesSentList
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end
  
  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of received messages.
class MessagesReceivedList
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end
  
  # Clicks the Messages link in the
  # Breadcrumb bar at the top of the
  # page, then instantiates the Messages
  # class
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  def unread_messages
    # FIXME
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end

# Page for the Contents of a Custom Folder for Messages
class FolderList #FIXME
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end
  
  # Clicks the Messages link in the
  # Breadcrumb bar at the top of the
  # page, then instantiates the Messages
  # class
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  def unread_messages
    # FIXME
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end


# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo
  
  include PageObject
  include ToolsMenu
  
  def move_messages
    frm.button(:value=>"Move Messages").click
    Messages.new(@browser)
  end

  # Method for selecting any custom folders
  # present on the screen--and *only* the custom
  # folders. Count begins with "1" for the first custom
  # folder listed.
  def select_custom_folder_num(num)
    frm.radio(:index=>num.to_i+3).set 
  end

  in_frame(:index=>1) do |frame|
    radio_button(:received, :name=>"pvtMsgMove:_id16:0:privateForums:0:_id19", :frame=>frame)
    radio_button(:sent, :name=>"pvtMsgMove:_id16:0:privateForums:1:_id19", :frame=>frame)
    radio_button(:deleted, :name=>"pvtMsgMove:_id16:0:privateForums:2:_id19", :frame=>frame)
    radio_button(:draft, :name=>"pvtMsgMove:_id16:0:privateForums:3:_id19", :frame=>frame)
  end
end


# The page showing the list of deleted messages.
class MessagesDeletedList
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages[x][2].text
    end
    return titles
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end
  
  def delete
    frm.link(:text=>"Delete").click
    MessageDeleteConfirmation.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of Draft messages.
class MessagesDraftList
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The Page where you are reading a Message.
class MessageView
  
  include PageObject
  include ToolsMenu
  
  def reply
    frm.button(:value=>"Reply").click
    ReplyToMessage.new(@browser)
  end
  
  def forward
    frm.button(:value=>"Forward ").click
    ForwardMessage.new(@browser)
  end

  def received
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

end

# The page for composing a message
class ComposeMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click
    Messages.new(@browser)
  end
  
  def message_text=(text)
    frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:send_to, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The page for composing a message
class ReplyToMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click
    # Need logic here to ensure the
    # right class gets called...
    if frm.div(:class=>/breadCrumb/).text=~ /Messages.\/.Received/
      MessagesReceivedList.new(@browser)
    else #FIXME
      Messages.new(@browser)
    end
  end
  
  def message_text=(text)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_additional_recipients, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The page for composing a message
class ForwardMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click 
    MessagesReceivedList.new(@browser) #FIXME!
  end
  
  def message_text=(text)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_forward_recipients, :id=>"pvtMsgForward:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The attachment page for Messages
class MessagesAttachment
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.button(:value=>"Continue").click
    # Logic for determining which class to call...
    if frm.div(:class=>/breadCrumb/).text =~ /Messages \/ Compose/
      ComposeMessage.new(@browser)
    elsif frm.div(:class=>/breadCrumb/).text =~ /Reply to Message/
      ReplyToMessage.new(@browser)
    end
    
  end
  
  def upload_file(filename)
    frm.file_field(:id=>"upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + filename)
  end

  def attach_a_copy(filename)
    index=file_names.index(filename)
    frm.link(:text=>/Attach a copy/, :index=>index).click
  end

  # This method returns an array of the file names currently listed
  # on the Add Attachment page.
  # 
  # It excludes folder names.
  def file_names
    names = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].h4.exist? && resources_table[x][0].a(:index=>0).title=~/File Type/
        names << resources_table[x][0].text
      end
    end
    return names
  end

  in_frame(:index=>1) do |frame|
    text_field(:url, :id=>"url", :frame=>frame)
  end
end

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation
  
  include PageObject
  include ToolsMenu
  
  def alert_message_text
    frm.span(:class=>"alertMessage").text
  end
  
  def delete_messages
    frm.button(:value=>"Delete Message(s)").click
    MessagesDeletedList.new(@browser)
  end

  #FIXME
  # Want eventually to have a method that will return
  # an array of Message subjects

end

# The page for creating a new folder for Messages
class MessagesNewFolder
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.button(:value=>"Add").click
    Messages.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"pvtMsgFolderAdd:title", :frame=>frame)
  end
end

# The page for editing a Message Folder's settings
class MessageFolderSettings
  
  include PageObject
  include ToolsMenu

  def rename_folder
    frm.button(:value=>"Rename Folder").click
    RenameMessageFolder.new(@browser)
  end

  def add
    frm.button(:value=>"Add").click
    MessagesNewFolder.new(@browser)
  end

  def delete
    frm.button(:value=>"Delete").click
    FolderDeleteConfirm.new(@browser)
  end

end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm
  
  include PageObject
  include ToolsMenu
  
  def delete
    frm.button(:value=>"Delete").click
    Messages.new(@browser)
  end
end


#================
# Site Editor Pages for an individual Site
#================

# The topmost "Site Editor" page, found in SITE MANAGEMENT
# when you are "inside" a particular site.
class SiteEditor
  
  include PageObject
  include ToolsMenu
  
  def manage_groups
    frm.link(:text=>"Manage Groups").click
    Groups.new(@browser)
  end
  
  # Again we are defining the page <iframe> by its index.
  # This is a bad way to do it, but unless there's a
  # persistent and consistent <id> or <name> tag for the
  # iframe then this is our best option.
  in_frame(:index=>1) do |frame|
    link(:edit_site_information, :text=>"Edit Site Information", :frame=>frame)
    link(:edit_tools, :text=>"Edit Tools", :frame=>frame)
    link(:add_participants, :text=>"Add Participants", :frame=>frame)
    link(:edit_class_rosters, :text=>"Edit Class Roster(s)", :frame=>frame)
    link(:link_to_parent_site, :text=>"Link to Parent Site", :frame=>frame)
    link(:manage_access, :text=> "Manage Access", :frame=>frame)
  end

end

# Groups page inside the Site Editor
class Groups
    
  include PageObject
  include ToolsMenu
  
  def create_new_group
    frm.link(:text=>"Create New Group").click
    CreateNewGroup.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    link(:auto_groups, :text=>"Auto Groups", :frame=>frame)
    button(:remove_checked, :id=>"delete-groups", :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end

# The Create New Group page inside the Site Editor
class CreateNewGroup

  include PageObject
  include ToolsMenu
  
  def add
    frm.button(:id=>"save").click
    Groups.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"group_title", :frame=>frame)
    text_field(:description, :id=>"group_description", :frame=>frame)
    select_list(:site_member_list, :id=>"siteMembers-selection", :frame=>frame)
    select_list(:group_member_list, :id=>"groupMembers-selection", :frame=>frame)
    button(:right, :name=>"right", :index=>0, :frame=>frame)
    button(:left, :name=>"left", :index=>0, :frame=>frame)
    button(:all_right, :name=>"right", :index=>1, :frame=>frame)
    button(:all_left, :name=>"left",:index=>1, :frame=>frame)
    button(:cancel, :id=>"cancel", :frame=>frame)
  end
end


#================
# Syllabus pages in a Site
#================

# The Syllabus overview page will appear differently
# if there are no syllabi present.
# However, this class represents both pages.
class Syllabus
  
  include PageObject
  include ToolsMenu
  
  # This method is only available when the
  # Create/Edit button is present, which is
  # only when there are no syllabus items
  # on the page at all.
  def create_edit
    frm.link(:text=>"Create/Edit").click
    sleep 0.2
    frm.link(:text=>"Add").click
    sleep 0.2
    AddEditSyllabusItem.new(@browser)
  end
  
  def add
    frm.link(:text=>"Add").click
    AddEditSyllabusItem.new(@browser)
  end
  
  def check_title(title)
    index=syllabus_titles.index(title)
    frm.checkbox(:index=>index).set
  end
  
  def move_title_up(title)
    #FIXME
  end
  
  def move_title_down(title)
    #FIXME
  end
  
  def update
    frm.button(:value=>"Update").click
    DeleteSyllabusItems.new(@browser)
  end
  
  def open_item(title)
    frm.link(:text=>title).click
    Class.new(@browser)
  end
  
  def syllabus_titles
    titles = []
    s_table = frm.table(:class=>"listHier lines nolines")
    1.upto(s_table.rows.size-1) do |x|
      titles << s_table[x][1].text
    end
    return titles
  end
  
end

class AddEditSyllabusItem
  
  include PageObject
  include ToolsMenu
  
  def post
    frm.button(:value=>"Post").click
    Syllabus.new(@browser)
  end
  
  def editor
    if frm.div(:class=>"portletBody").h3(:index=>0).text=="Add syllabus..."
      frm.frame(:id, "_id4:_id19_textarea___Frame").td(:id, "xEditingArea").frame(:index=>0)
    elsif frm.div(:class=>"portletBody").h3(:index=>0).text=="Edit Syllabus Item"
      frm.frame(:id, "_id3:_id18_textarea___Frame").td(:id, "xEditingArea").frame(:index=>0)
    end
  end
  
  def content=(text)
    editor.send_keys(text)
  end
  
  
  def post
    frm.button(:value=>"Post").click
    Syllabus.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"_id4:title", :frame=>frame)
  end
  
end

class DeleteSyllabusItems
  
  include PageObject
  include ToolsMenu
  
  def delete
    frm.button(:value=>"Delete").click
    CreateEditSyllabus.new(@browser)
  end
  
end


