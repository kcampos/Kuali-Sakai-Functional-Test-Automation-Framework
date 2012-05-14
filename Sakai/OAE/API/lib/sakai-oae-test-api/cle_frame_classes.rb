# coding: UTF-8

#================
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# This is a module containing methods that are
# common to all the question pages inside the
# Assessment section of a Site.
module QuestionHelpers

  include PageObject

  # Saves the question by clicking the Save button, then makes the determination
  # whether to instantiate the EditAssessment class, or the EditQuestionPool class.
  def save

    quiz = frm.div(:class=>"portletBody").div(:index=>0).text
    pool = frm.div(:class=>"portletBody").div(:index=>1).text

    frm.button(:value=>"Save").click

    if quiz =~ /^Assessments/
      EditAssessment.new(@browser)
    elsif pool =~ /^Question Pools/
      EditQuestionPool.new(@browser)
    else
      puts "Unexpected text: "
      p pool
      p quiz
    end

  end

  in_frame(:index=>1) do |frame|
    link(:assessments, :text=>"Assessments", :frame=>frame)
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    link(:question_pools, :text=>"Question Pools", :frame=>frame)
    link(:questions, :text=>/Questions:/, :frame=>frame)
  end

end


# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList

  include PageObject

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
    #puts "clicking question pools"
    #10.times {frm.link(:text=>"Question Pools").flash}
    frm.link(:text=>"Question Pools").click
    #sleep 200
    #puts "clicked..."
    #frm.link(:text=>"Add New Pool").wait_until_present
    #frm.h3(:text=>"Question Pools").wait_until_present(120)
    QuestionPoolsList.new(@browser)
  end

  # Collects the titles of the Assessments listed as "Pending"
  # then returns them as an Array.
  def pending_assessment_titles
    titles =[]
    pending_table = frm.table(:id=>"authorIndexForm:coreAssessments")
    1.upto(pending_table.rows.size-1) do |x|
      titles << pending_table[x][1].span(:id=>/assessmentTitle/).text
    end
    return titles
  end

  # Collects the titles of the Assessments listed as "Published"
  # then returns them as an Array.
  def published_assessment_titles
    titles =[]
    published_table = frm.div(:class=>"tier2", :index=>2).table(:class=>"listHier", :index=>0)
    1.upto(published_table.rows.size-1) do |x|
      titles << published_table[x][1].span(:id=>/publishedAssessmentTitle/).text
    end
    return titles
  end

  # Returns an Array of the inactive Assessment titles displayed
  # in the list.
  def inactive_assessment_titles
    titles =[]
    inactive_table = frm.div(:class=>"tier2", :index=>2).table(:id=>"authorIndexForm:inactivePublishedAssessments")
    1.upto(inactive_table.rows.size-1) do |x|
      titles << inactive_table[x][1].span(:id=>/inactivePublishedAssessmentTitle/).text
    end
    return titles
  end

  # Opens the selected test for scoring
  # then instantiates the AssessmentTotalScores class.
  def score_test(test_title)
    frm.tbody(:id=>"authorIndexForm:_id88:tbody_element").row(:text=>/#{Regexp.escape(test_title)}/).link(:id=>/authorIndexToScore/).click
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

  # Scrapes the value of the due date from the page. Returns it as a string.
  def due_date
    frm.div(:class=>"tier2").table(:index=>0)[0][0].text
  end

  # Scrapes the value of the time limit from the page. Returns it as a string.
  def time_limit
    frm.div(:class=>"tier2").table(:index=>0)[3][0].text
  end

  # Scrapes the submission limit from the page. Returns it as a string.
  def submission_limit
    frm.div(:class=>"tier2").table(:index=>0)[6][0].text
  end

  # Scrapes the Feedback policy from the page. Returns it as a string.
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

  # Scrapes the Assessment Type from the page and returns it as a string.
  def assessment_type_title
    frm.div(:class=>"tier2").table(:index=>0)[0][1].text
  end

  # Scrapes the Assessment Author information from the page and returns it as a string.
  def assessment_type_author
    frm.div(:class=>"tier2").table(:index=>$frame_index)[1][1].text
  end

  # Scrapes the Assessment Type Description from the page and returns it as a string.
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

  # Gets the user ids listed in the
  # scores table, returns them as an Array
  # object.
  #
  # Note that this method is only appropriate when student
  # identities are not being obscured on this page. If student
  # submissions are set to be anonymous then this method will fail
  # to return any ids.
  def student_ids
    ids = []
    scores_table = frm.table(:id=>"editTotalResults:totalScoreTable").to_a
    scores_table.delete_at(0)
    scores_table.each { |row| ids << row[1] }
    return ids
  end

  # Adds a comment to the specified student's comment box.
  #
  # Note that this method assumes that the student identities are not being
  # obscured on this page. If they are, then this method will not work for
  # selecting the appropriate comment box.
  def comment_for_student(student_id, comment)
    index_val = student_ids.index(student_id)
    frm.text_field(:name=>"editTotalResults:totalScoreTable:#{index_val}:_id345").value=comment
  end

  # Clicks the Submit Date link in the table header to sort/reverse sort the list.
  def sort_by_submit_date
    frm.link(:text=>"Submit Date").click
  end

  # Enters the specified string into the topmost box listed on the page.
  #
  # This method is especially useful when the student identities are obscured, since
  # in that situation you can't target a specific student's comment box, obviously.
  def comment_in_first_box=(comment)
    frm.text_field(:name=>"editTotalResults:totalScoreTable:0:_id345").value=comment
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

  # Clicks the Save button, then instantiates
  # the EditAssessment page class.
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

  # Clicks the Publish button, then
  # instantiates the AssessmentsList page class.
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
  include QuestionHelpers

  in_frame(:class=>"portletMainIframe") do |frame|
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
    text_area(:question_text, :id=>"itemForm:_id82_textinput", :frame=>frame)
    button(:add_attachments, :name=>"itemForm:_id126", :frame=>frame)

    text_area(:answer_a, :id=>"itemForm:mcchoices:0:_id140_textinput", :frame=>frame)
    link(:remove_a, :id=>"itemForm:mcchoices:0:removelinkSingle", :frame=>frame)
    text_area(:answer_b, :id=>"itemForm:mcchoices:1:_id140_textinput", :frame=>frame)
    link(:remove_b, :id=>"itemForm:mcchoices:1:removelinkSingle", :frame=>frame)
    text_area(:answer_c, :id=>"itemForm:mcchoices:2:_id140_textinput", :frame=>frame)
    link(:remove_c, :id=>"itemForm:mcchoices:2:removelinkSingle", :frame=>frame)
    text_area(:answer_d, :id=>"itemForm:mcchoices:3:_id140_textinput", :frame=>frame)
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
    radio_button(:randomize_answers_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:_id162", :frame=>frame) }
    radio_button(:randomize_answers_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:_id162", :frame=>frame) }
    radio_button(:require_rationale_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:_id166", :frame=>frame) }
    radio_button(:require_rationale_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:_id166", :frame=>frame) }
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id186_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id190_textinput", :frame=>frame)

  end

end

# The page for setting up a Survey question
class Survey

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id69_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id113", :frame=>frame)
    radio_button(:yes_no) { |page| page.radio_button_element(:index=>0, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:disagree_agree) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:disagree_undecided) {|page| page.radio_button_element(:index=>2, :name=>"itemForm:selectscale", :frame=>frame) }
    radio_button(:below_above) {|page| page.radio_button_element(:index=>3, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:strongly_agree) {|page| page.radio_button_element(:index=>4, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:unacceptable_excellent) {|page| page.radio_button_element(:index=>5, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:one_to_five) {|page| page.radio_button_element(:index=>6, :name=>"itemForm:selectscale", :frame=>frame)}
    radio_button(:one_to_ten) {|page| page.radio_button_element(:index=>7, :name=>"itemForm:selectscale", :frame=>frame)}
    text_area(:feedback, :id=>"itemForm:_id140_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a Short Answer/Essay question
class ShortAnswer

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id69_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id113", :frame=>frame)
    text_area(:model_short_answer, :id=>"itemForm:_id129_textinput", :frame=>frame)
    text_area(:feedback, :id=>"itemForm:_id133_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a Fill-in-the-blank question
class FillInBlank

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id75_textinput", :frame=>frame)
    checkbox(:case_sensitive, :name=>"itemForm:_id76", :frame=>frame)
    checkbox(:mutually_exclusive, :name=>"itemForm:_id78", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id126", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a numeric response question
class NumericResponse

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id73_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id117", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id133_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id135_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a matching question
class Matching

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id78_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id122", :frame=>frame)
    text_area(:choice, :id=>"itemForm:_id147_textinput", :frame=>frame)
    text_area(:match, :id=>"itemForm:_id151_textinput", :frame=>frame)
    button(:save_pairing, :name=>"itemForm:_id164", :frame=>frame)
    text_area(:feedback_for_correct, :id=>"itemForm:_id184_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id189_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a True/False question
class TrueFalse

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id77_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id121", :frame=>frame)
    text_field(:negative_point_value, :id=>"itemForm:answerdsc", :frame=>frame)
    radio_button(:answer_true) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:TF", :frame=>frame)}
    radio_button(:answer_false) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:TF", :frame=>frame)}
    radio_button(:required_rationale_yes) {|page| page.radio_button_element(:index=>0, :name=>"itemForm:rational", :frame=>frame)}
    radio_button(:required_rationale_no) {|page| page.radio_button_element(:index=>1, :name=>"itemForm:rational", :frame=>frame)}
    text_area(:feedback_for_correct, :id=>"itemForm:_id148_textinput", :frame=>frame)
    text_area(:feedback_for_incorrect, :id=>"itemForm:_id152_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

#  The page for setting up a question that requires an audio response
class AudioRecording

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id69_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id113", :frame=>frame)
    text_field(:time_allowed, :id=>"itemForm:timeallowed", :frame=>frame)
    select_list(:number_of_attempts, :id=>"itemForm:noattempts", :frame=>frame)
    text_field(:feedback, :id=>"itemForm:_id146_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

# The page for setting up a question that requires
# attaching a file
class FileUpload

  include PageObject
  include QuestionHelpers

  in_frame(:index=>1) do |frame|
    button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
    text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
    text_area(:question_text, :id=>"itemForm:_id69_textinput", :frame=>frame)
    button(:add_attachments, :id=>"itemForm:_id113", :frame=>frame)
    text_field(:feedback, :id=>"itemForm:_id130_textinput", :frame=>frame)
    select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
    select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

  end

end

# The page that appears when you are editing a type of assessment
class EditAssessmentType

  include PageObject

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

  # Clicks the Save button, then
  # instantiates the QuestionPoolsList page class.
  def save
    #10.times {frm.button(:id=>"questionpool:submit").flash}
    frm.button(:id=>"questionpool:submit").click
    #sleep 180
    #frm.button(:value=>"Create").wait_until_present(120)
    QuestionPoolsList.new(@browser)
  end

  def cancel
    frm.button(:value=>"Cancel").click
    QuestionPoolsList.new @browser
  end

  in_frame(:index=>1) do |frame|
    text_field(:pool_name, :id=>"questionpool:namefield", :frame=>frame)
    text_field(:department_group, :id=>"questionpool:orgfield", :frame=>frame)
    text_area(:description, :id=>"questionpool:descfield", :frame=>frame)
    text_field(:objectives, :id=>"questionpool:objfield", :frame=>frame)
    text_field(:keywords, :id=>"questionpool:keyfield", :frame=>frame)

  end

end

# The Page that appears when editing an existing question pool
class EditQuestionPool

  include PageObject

  # Clicks the Add Question link, then
  # instantiates the SelectQuestionType class.
  def add_question
    frm.link(:id=>"editform:addQlink").click
    SelectQuestionType.new(@browser)
  end

  # Clicks the Question Pools link, then
  # instantiates the QuestionPoolsList class.
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

  # Clicks the edit button, then instantiates
  # the EditQuestionPool page class.
  def edit_pool(name)
    frm.span(:text=>name).fire_event("onclick")
    EditQuestionPool.new(@browser)
  end

  # Clicks the Add New Pool link, then
  # instantiates the AddQuestionPool page class.
  def add_new_pool
    #puts "clicking add new pool..."
    #10.times {frm.link(:text=>"Add New Pool").flash}
    frm.link(:text=>"Add New Pool").click
    #puts "clicked..."
    #frm.text_field(:id=>"questionpool:namefield").wait_until_present(200)
    AddQuestionPool.new(@browser)
  end

  # Returns an array containing strings of the pool names listed
  # on the page.
  def pool_names
    names= []
    frm.table(:id=>"questionpool:TreeTable").rows.each do | row |
      if row.span(:id=>/questionpool.+poolnametext/).exist?
        names << row.span(:id=>/questionpool.+poolnametext/).text
      end
    end
    return names
  end

  # Clicks "Import" and then instantiates the
  # PoolImport page class.
  def import
    frm.link(:text=>"Import").click
    PoolImport.new(@browser)
  end

  # Clicks the Assessments link and then
  # instantiates the AssessmentsList page class.
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

  # Enters the target file into the Choose File
  # file field. Note that it assumes the file is in
  # the data/sakai-cle-test-api folder in the expected resources
  # tree.
  def choose_file=(file_name)
    frm.file_field(:name=>"importPoolForm:_id6.upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + file_name)
  end

  # Clicks the Import button, then
  # instantiates the QuestionPoolsList
  # page class.
  def import
    frm.button(:value=>"Import").click
    QuestionPoolsList.new(@browser)
  end

end

# This page appears when adding a question to a pool
class SelectQuestionType

  include PageObject

  # Selects the specified question type from the
  # drop-down list, then instantiates the appropriate
  # page class, based on the question type selected.
  def select_question_type(qtype)
    frm.select(:id=>"_id1:selType").select(qtype)
    frm.button(:value=>"Save").click

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
#
# It may be that we want to deprecate this class and simply use
# the AssessmentsList class alone.
class TakeAssessmentList

  include PageObject

  # Returns an array containing the assessment names that appear on the page.
  def available_assessments
    # define this later
  end

  # Method to get the titles of assessments that
  # the student user has submitted. The titles are
  # returned in an Array object.
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

  # Clicks the specified assessment
  # then instantiates the BeginAssessment
  # page class.
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
    test_table = frm.table(:id=>"selectIndexForm:reviewTable").to_a
    test_table.delete_if { |row| row[3] != "Immediate" }
    index_value = test_table.index { |row| row[0] == test_name }
    frm.link(:text=>"Feedback", :index=>index_value).click
    # Need to add a call to a New class here, when it's written
  end

end

# The student view of the overview page of an Assessment
class BeginAssessment

  include PageObject

  # Clicks the Begin Assessment button.
  def begin_assessment
    frm.button(:value=>"Begin Assessment").click
  end

  # Clicks the Cancel button and instantiates the X Class.
  def cancel
    # Define this later
  end

  # Selects the specified radio button answer
  def multiple_choice_answer(letter)
    index = case(letter.upcase)
              when "A" then "0"
              when "B" then "1"
              when "C" then "2"
              when "D" then "3"
              when "E" then "4"
            end
    frm.radio(:name=>/takeAssessmentForm.+:deliverMultipleChoice.+:_id.+:#{index}/).click
  end

  # Enters the answer into the specified blank number (1-based).
  def fill_in_blank_answer(answer, blank_number)
    index = blank_number.to_i-1
    frm.text_field(:name=>/deliverFillInTheBlank:_id.+:#{index}/).value=answer
  end

  # Clicks either the True or the False radio button, as specified.
  def true_false_answer(answer)
    answer.upcase=~/t/i ? index = 0 : index = 1
    frm.radio(:name=>/deliverTrueFalse/, :index=>index).set
  end

  # Enters the specified string into the Rationale text box.
  def true_false_rationale(text)
    frm.text_field(:name=>/:deliverTrueFalse:rationale/).value=text
  end

  # Enters the specified text into the "Short Answer" field.
  def short_answer(answer)
    frm.text_field(:name=>/deliverShortAnswer/).value=answer
  end

  # Selects the specified matching value, at the spot specified by the number (1-based counting).
  def match_answer(answer, number)
    index = number.to_i-1
    frm.select(:name=>/deliverMatching/, :index=>index).select(answer)
  end

  # Enters the specified file name (and subdirectory below the expected target Sakai-CLE path) in the file field.
  def file_answer(file_name)
    frm.file_field(:name=>/deliverFileUpload/).set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + file_name)
    frm.button(:value=>"Upload").click
  end

  # Clicks the Next button and instantiates the BeginAssessment Class.
  def next
    frm.button(:value=>"Next").click
    BeginAssessment.new(@browser)
  end

  # Clicks the Submit for Grading button and instantiates the ConfirmSubmission Class.
  def submit_for_grading
    frm.button(:value=>"Submit for Grading").click
    ConfirmSubmission.new(@browser)
  end

end

# The confirmation page that appears when submitting an Assessment.
# The last step before actually submitting the the Assessment.
class ConfirmSubmission

  include PageObject

  # Clicks the Submit for Grading button and instantiates
  # the SubmissionSummary Class.
  def submit_for_grading
    frm.button(:value=>"Submit for Grading").click
    SubmissionSummary.new(@browser)
  end

end

# The summary page that appears when an Assessment has been submitted.
class SubmissionSummary

  include PageObject

  # Clicks the Continue button and instantiates
  # the TakeAssessmentList Class.
  def continue
    frm.button(:value=>"Continue").click
    TakeAssessmentList.new(@browser)
  end

end

#================
# Assignments Pages
#================

module AssignmentsMenu

  include PageObject

  def assignments_frame
    self.frame(:src=>/sakai2assignments.launch.html/)
  end
  alias frm assignments_frame

  def add_assignment
    frm.link(:title=>"Add").click
    frm.frame(:id=>"new_assignment_instructions___Frame").td(:id=>"xEditingArea").wait_until_present
    AddAssignments.new @browser
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
  # Then it instantiates the AddAssignments page class.
  def edit_assignment(assignment_name)
    index = assignments_titles.index(assignment_name)
    frm.link(:text=>"Edit", :index=>index).click
    AddAssignments.new(@browser)
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
class AddAssignments

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

end # AddAssignments

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
    frm.file_field(:id=>"clonableUpload", :name=>"upload#{@@file_number}").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + file_name)
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

  # Enters the specified file into the file field name. Method takes an optional
  # file_path parameter that it will pre-pend before the supplied filename, allowing
  # the file name and path name to be distinct variables.
  #
  # Does NOT instantiate any class, so use only when no page refresh occurs.
  def upload_file(filename, file_path="")
    frm.file_field(:id=>"upload").set(file_path + filename)
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
        :parent => "AddAssignments",
        :second => "AssignmentStudent",
        :third => "AssignmentSubmission"
    }
  end

end
