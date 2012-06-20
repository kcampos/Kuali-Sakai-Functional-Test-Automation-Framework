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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.menu_elements(identifier)
    in_frame(identifier) do |frame|
      link(:assessments, :text=>"Assessments", :frame=>frame)
      link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
      link(:question_pools, :text=>"Question Pools", :frame=>frame)
      link(:questions, :text=>/Questions:/, :frame=>frame)
    end
  end

end

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
module AssessmentsListMethods
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
    frm.link(:text=>"Question Pools").click
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
  # @param test_title [String] the title of the test to be clicked.
  def score_test(test_title)
    frm.tbody(:id=>"authorIndexForm:_id88:tbody_element").row(:text=>/#{Regexp.escape(test_title)}/).link(:id=>/authorIndexToScore/).click
    AssessmentTotalScores.new(@browser)
  end

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
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
  
end

# Page that appears when previewing an assessment.
# It shows the basic information about the assessment.
module PreviewOverviewMethods
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      button(:begin_assessment, :id=>"takeAssessmentForm:beginAssessment3", :frame=>frame)
  
    end
  end
  
end

# The Settings page for a particular Assessment
module AssessmentSettingsMethods
  include PageObject
  # Scrapes the Assessment Type from the page and returns it as a string.
  def assessment_type_title
    frm.div(:class=>"tier2").table(:index=>0)[0][1].text
  end

  # Scrapes the Assessment Author information from the page and returns it as a string.
  def assessment_type_author
    frm.div(:class=>"tier2").table(:index=>0)[1][1].text
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
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

end

# Instructor's view of Students' assessment scores
module AssessmentTotalScoresMethods
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
  # @param student_id [String] the target student id
  # @param comment [String] the text of the comment being made to the student
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
  # @param comment [String] the text to be entered into the Comment box
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
module EditAssessmentMethods
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
  # @param part_num [String] the Part number containing the question you want to remove
  # @param question_num [String] the number of the question you want to remove
  def remove_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:deleteitem").click
  end

  # Allows editing of a question by specifying its part number
  # and question number.
  # @param part_num [String] the Part number containing the question you want
  # @param question_num [String] the number of the question you want
  def edit_question(part_num, question_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:modify").click
  end

  # Allows copying an Assessment part to a Pool.
  # @param part_num [String] the part number of the assessment you want
  def copy_part_to_pool(part_num)
    frm.link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:copyToPool").click
  end

  # Allows removing a specified
  # Assessment part number.
  # @param part_num [String] the part number of the assessment you want
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
  # @param qtype [String] the text of the item you want to select from the list
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
  # @param part_num [String] the Part number containing the question you want
  # @param question_num [String] the number of the question you want
  def get_question_text(part_number, question_number)
    frm.table(:id=>"assesssmentForm:parts:#{part_number.to_i-1}:parts").div(:class=>"tier3", :index=>question_number.to_i-1).text
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      link(:assessments, :text=>"Assessments", :frame=>frame)
      link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
      link(:print, :text=>"Print", :frame=>frame)
      button(:update_points, :id=>"assesssmentForm:pointsUpdate", :frame=>frame)
    end
  end
end

# This is the page for adding and editing a part of an assessment
module AddEditAssessmentPartMethods
  include PageObject
  # Clicks the Save button, then instantiates
  # the EditAssessment page class.
  def save
    frm.button(:name=>"modifyPartForm:_id89").click
    EditAssessment.new(@browser)
  end

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
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
end

# The review page once you've selected to Save and Publish
# the assessment
module PublishAssessmentMethods
  include PageObject
  # Clicks the Publish button, then
  # instantiates the AssessmentsList page class.
  def publish
    frm.button(:value=>"Publish").click
    AssessmentsList.new(@browser)
  end

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      button(:cancel, :value=>"Cancel", :frame=>frame)
      button(:edit, :name=>"publishAssessmentForm:_id23", :frame=>frame)
      select_list(:notification, :id=>"publishAssessmentForm:number", :frame=>frame)

    end
  end
end

# The page for setting up a multiple choice question
module MultipleChoiceMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

# The page for setting up a Survey question
module SurveyMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a Short Answer/Essay question
module ShortAnswerMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a Fill-in-the-blank question
module FillInBlankMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a numeric response question
module NumericResponseMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a matching question
module MatchingMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a True/False question
module TrueFalseMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

#  The page for setting up a question that requires an audio response
module AudioRecordingMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
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
end

# The page for setting up a question that requires
# attaching a file
module FileUploadMethods
  include PageObject
  include QuestionHelpers

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    QuestionHelpers.menu_elements(identifier)
    in_frame(identifier) do |frame|
      button(:cancel, :id=>"itemForm:_id63", :frame=>frame)
      text_field(:answer_point_value, :id=>"itemForm:answerptr", :frame=>frame)
      text_area(:question_text, :id=>"itemForm:_id69_textinput", :frame=>frame)
      button(:add_attachments, :id=>"itemForm:_id113", :frame=>frame)
      text_field(:feedback, :id=>"itemForm:_id130_textinput", :frame=>frame)
      select_list(:assign_to_part, :id=>"itemForm:assignToPart", :frame=>frame)
      select_list(:assign_to_pool, :id=>"itemForm:assignToPool", :frame=>frame)

    end
  end
end

# The page that appears when you are editing a type of assessment
module EditAssessmentTypeMethods
  include PageObject
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      #(:, :=>"", :frame=>frame)
      #(:, :=>"", :frame=>frame)
      #(:, :=>"", :frame=>frame)
      #(:, :=>"", :frame=>frame)
      #(:, :=>"", :frame=>frame)

    end
  end
end

# The Page that appears when adding a new question pool
module AddQuestionPoolMethods
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      text_field(:pool_name, :id=>"questionpool:namefield", :frame=>frame)
      text_field(:department_group, :id=>"questionpool:orgfield", :frame=>frame)
      text_area(:description, :id=>"questionpool:descfield", :frame=>frame)
      text_field(:objectives, :id=>"questionpool:objfield", :frame=>frame)
      text_field(:keywords, :id=>"questionpool:keyfield", :frame=>frame)

    end
  end
end

# The Page that appears when editing an existing question pool
module EditQuestionPoolMethods
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
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
end

# The page with the list of existing Question Pools
module QuestionPoolsListMethods
  include PageObject
  # Clicks the edit button, then instantiates
  # the EditQuestionPool page class.
  # @param name [String] the name of the pool you want to edit
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    end
  end

end

# The page that appears when you click to import
# a pool.
module PoolImportMethods
  include PageObject
  # Enters the target file into the Choose File
  # file field. Including the file path separately is optional.
  # @param file_name [String] the name of the file you want to choose. Can include path info, if desired.
  # @param file_path [String] Optional. This is the path information for the file location.
  def choose_file(file_name, file_path="")
    frm.file_field(:name=>"importPoolForm:_id6.upload").set(file_path + file_name)
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
module SelectQuestionTypeMethods
  include PageObject
  # Selects the specified question type from the
  # drop-down list, then instantiates the appropriate
  # page class, based on the question type selected.
  # @param qtype [String] the text of the question type you want to select from the drop down list.
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

  # Encapsulates all the PageObject code into a module
  # method that can be called from the necessary class.
  # @private
  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      button(:cancel, :value=>"Cancel", :frame=>frame)
    end
  end
end

# Page of Assessments accessible to a student user
#
# It may be that we want to deprecate this class and simply use
# the AssessmentsList class alone.
module TakeAssessmentListMethods
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
  # @param name [String] the name of the assessment you want to take
  def take_assessment(name)
    begin
      frm.link(:text=>name).click
    rescue Watir::Exception::UnknownObjectException
      frm.link(:text=>CGI::escapeHTML(name)).click
    end
    BeginAssessment.new(@browser)
  end

  # TODO This method is in need of improvement to make it more generalized for finding the correct test.
  #
  def feedback(test_name)
    test_table = frm.table(:id=>"selectIndexForm:reviewTable").to_a
    test_table.delete_if { |row| row[3] != "Immediate" }
    index_value = test_table.index { |row| row[0] == test_name }
    frm.link(:text=>"Feedback", :index=>index_value).click
    # Need to add a call to a New class here, when it's written
  end

end

# The student view of the overview page of an Assessment
module BeginAssessmentMethods
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
  # @param answer [String]
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

  # Enters the specified file name in the file field. You can include the path to the file
  # as an optional second parameter.
  def file_answer(file_name, file_path="")
    frm.file_field(:name=>/deliverFileUpload/).set(file_path + file_name)
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
module ConfirmSubmissionMethods
  include PageObject
  # Clicks the Submit for Grading button and instantiates
  # the SubmissionSummary Class.
  def submit_for_grading
    frm.button(:value=>"Submit for Grading").click
    SubmissionSummary.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      span(:validation, :class=>"validation", :frame=>frame)
    end
  end

end

# The summary page that appears when an Assessment has been submitted.
module SubmissionSummaryMethods
  include PageObject
  # Clicks the Continue button and instantiates
  # the TakeAssessmentList Class.
  def continue
    frm.button(:value=>"Continue").click
    TakeAssessmentList.new(@browser)
  end

  def self.page_elements(identifier)
    in_frame(identifier) do |frame|
      div(:summary_info, :class=>"tier1", :frame=>frame)
    end
  end

end
