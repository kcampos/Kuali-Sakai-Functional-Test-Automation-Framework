# Navigation links in Sakai
# 
# == Synopsis
#
# Defines all objects in Sakai Pages. Uses the PageObject gem
# to create methods to interact with those objects.
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

require 'page-object'
require 'cgi'

#================
# Page Navigation Objects
#================

# ToolsMenu contains all possible links that could
# be found in the menu along the left side of the Sakai pages.
module ToolsMenu
  
  include PageObject
  
  # The list of left side menu items, formatted according to the
  # PageObject requirements...
  link(:account, :text=>"Account")
  link(:aliases, :text=>"Aliases")
  
  def administration_workspace
    @browser.link(:text, "Administration Workspace").click
    MyWorkspace.new(@browser)
  end
  
  link(:announcements, :class => 'icon-sakai-announcements')
  link(:assignments, :text=>"Assignments")
  link(:basic_lti, :text=>"Basic LTI")
  link(:blogs, :text=>"Blogs")
  link(:calendar, :text=>"Calendar")
  link(:certification, :text=>"Certification")
  link(:chat_room, :text=>"Chat Room")
  link(:configuration_viewer, :text=>"Configuration Viewer")
  link(:customizer, :text=>"Customizer")
  link(:discussion_forums, :text=>"Discussion Forums")
  link(:drop_box, :text=>"Drop Box")
  link(:email, :text=>"Email")
  link(:email_archive, :text=>"Email Archive")
  link(:email_template_administration, :text=>"Email Template Administration")
  link(:evaluation_system, :text=>"Evaluation System")
  link(:feedback, :text=>"Feedback")
  
  def forums
    @browser.link(:text=>"Forums").click
    Forums.new(@browser)
  end
  
  link(:gradebook, :text=>"Gradebook")
  link(:gradebook2, :text=>"Gradebook2")
  link(:help, :text=>"Help")
  
  def home
    @browser.link(:text, "Home").click
    Home.new(@browser)
  end
  
  def job_scheduler
    @browser.link(:text=>"Job Scheduler").click
    JobScheduler.new(@browser)
  end
  
  link(:lessons, :text=>"Lessons")
  link(:lesson_builder, :text=>"Lesson Builder")
  link(:link_tool, :text=>"Link Tool")
  link(:live_virtual_classroom, :text=>"Live Virtual Classroom")
  link(:matrices, :text=>"Matrices")
  link(:media_gallery, :text=>"Media Gallery")
  link(:membership, :text=>"Membership")
  link(:memory, :text=>"Memory")
  link(:messages, :text=>"Messages")
  link(:my_sites, :text=>"My Sites")
  link(:news, :text=>"News")
  link(:online, :text=>"On-Line")
  link(:oauth_providers, :text=>"Oauth Providers")
  link(:oauth_tokens, :text=>"Oauth Tokens")
  link(:openSyllabus, :text=>"OpenSyllabus")
  link(:podcasts, :text=>"Podcasts")
  link(:polls, :text=>"Polls")
  link(:portfolios, :text=>"Portfolios")
  link(:preferences, :text=>"Preferences")
  link(:profile, :text=>"Profile")
  link(:realms, :text=>"Realms")
  
  def resources
    # Will eventually need logic here
    # to determine whether to load the class for
    # the Resources page in a particular site or the page
    # while in the Admin workspace.
    
    # For now, though, this only works to go to
    # the page within a given Site.
    @browser.link(:text, "Resources").click
    Resources.new(@browser)
  end
  
  link(:roster, :text=>"Roster")
  link(:rsmart_support, :text=>"rSmart Support")
  link(:search, :text=>"Search")
  link(:sections, :text=>"Sections")
  link(:site_archive, :text=>"Site Archive")
  
  def site_editor
    @browser.link(:text=>"Site Editor").click
    SiteEditor.new(@browser)
  end
  
  def site_setup
    @browser.link(:text=>"Site Setup").click
    SiteSetup.new(@browser)
  end
  
  link(:site_statistics, :text=>"Site Statistics")
  
  def sites
    @browser.link(:class=>"icon-sakai-sites").click
    Sites.new(@browser)
  end
  
  link(:skin_manager, :text=>"Skin Manager")
  link(:super_user, :text=>"Super User")
  link(:syllabus, :text=>"Syllabus")
  
  def tests_and_quizzes
    # Need this logic to determine whether user
    # is a student or instructor/admin
    @browser.link(:class, "icon-sakai-siteinfo").exist? ? x=0 : x=1
    @browser.link(:text=>"Tests & Quizzes").click
    x==0 ? AssessmentsList.new(@browser) : TakeAssessmentList.new(@browser)
    
  end
  
  link(:user_membership, :text=>"User Membership")
  link(:users, :text=>"Users")
  link(:web_content, :text=>"Web Content")
  link(:wiki, :text=>"Wiki")
  
  # The Page Reset button, found on all Site pages
  link(:reset, :href=>/tool-reset/)
  
  # Shortcut method so you don't have to type out
  # the whole string: @browser.frame(:index=>index)
  def frm(index)
    @browser.frame(:index=>index)
  end
  
end


#================
# Aliases Pages
#================

# The Aliases page - "icon-sakai-aliases"
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
# Announcements Pages
#================

# The topmost page for the Announcements tool
class Announcements
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:merge, :text=>"Merge", :frame=>frame)
    link(:options, :text=>"Options", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
    
  end

end

# Adding a new Announcement
class AnnouncementsAdd
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    
    # Going to define the WYSIWYG text editor at some later time
    
    text_field(:title, :id=>"subject", :frame=>frame)
    radio_button(:show, :id=>"hidden_false", :frame=>frame)
    radio_button(:hide, :id=>"hidden_true", :frame=>frame)
    radio_button(:specify_dates, :id=>"hidden_specify", :frame=>frame)
    button(:add_attachments, :name=>"attach", :frame=>frame)
    button(:add_announcement, :name=>"post", :frame=>frame)
    button(:preview, :name=>"preview", :frame=>frame)
    button(:clear, :name=>"cancel", :frame=>frame)
    
  end

end

# Page for merging announcements from other sites
class AnnouncementsMerge
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    # This page can have an arbitrary number of site checkboxes.
    # Only the first 5 are defined here.
    # The rest will have to be called explicitly in any
    # test case that needs to access those elements
    checkbox(:site1, :id=>"site1", :frame=>frame)
    checkbox(:site2, :id=>"site2", :frame=>frame)
    checkbox(:site3, :id=>"site3", :frame=>frame)
    checkbox(:site4, :id=>"site4", :frame=>frame)
    checkbox(:site5, :id=>"site5", :frame=>frame)
    button(:save, :name=>"eventSubmit_doUpdate", :frame=>frame)
    button(:clear, :name=>"eventSubmit_doCancel", :frame=>frame)
  end

end

# Page for setting up options for announcements
class AnnouncementsOptions
  
  include PageObject
  include ToolsMenu
=begin  
  in_frame(:index=>0) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end
=end
end

# Page containing permissions options for announcements
class AnnouncementsPermissions
  
  include PageObject
  include ToolsMenu
=begin  
  in_frame(:index=>0) do |frame|
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    (:, :=>"", :frame=>frame)
    
  end
=end
end



#================
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList
  
  include PageObject
  include ToolsMenu
  
  def create
    builder_or_text = frm(1).radio(:value=>"1", :name=>"authorIndexForm:_id29").set?
    
    frm(1).button(:value=>"Create").click
    
    if builder_or_text == true
      EditAssessment.new(@browser)
    else
      # Need to add Markup page class, then add the reference here.
    end
    
  end
  
  def question_pools
    frm(1).link(:text=>"Question Pools").click
    QuestionPoolsList.new(@browser)
  end
  
  def get_published_titles
    table_array = @browser.frame(:index=>1).div(:class=>"tier2", :index=>2).table(:class=>"listHier").to_a
    table_array.delete_at(0)
    titles = []
    table_array.each { |row| titles << CGI::unescapeHTML(row[1])}
    return titles
  end
  
  def score_test(test_title)
    test_names = get_published_titles
    index_value = test_names.index(test_title)
    frm(1).link(:id=>"authorIndexForm:_id88:#{index_value}:authorIndexToScore1").click
    AssessmentTotalScores.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    link(:assessment_types, :text=>"Assessment Types", :frame=>frame)
    text_field(:title, :id=>"authorIndexForm:title", :frame=>frame)
    radio_button(:create_using_builder) { |page| page.radio_button_element(:name=>"authorIndexForm:_id29", index=>0, :frame=>frame) }
    radio_button(:create_using_text) { |page| page.radio_button_element(:name=>"authorIndexForm:_id29", :index=>1, :frame=>frame) }
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
  
  def due_date
    frm(1).div(:class=>"tier2").table(:index=>0)[0][0].text
  end
  
  def time_limit
    frm(1).div(:class=>"tier2").table(:index=>0)[3][0].text
  end
  
  def submission_limit
    frm(1).div(:class=>"tier2").table(:index=>0)[6][0].text
  end
  
  def feedback
    frm(1).div(:class=>"tier2").table(:index=>0)[9][0].text
  end
  
  def done
    frm(1).button(:name=>"takeAssessmentForm:_id5").click
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
  
  def assessment_type_title
    frm(1).div(:class=>"tier2").table(:index=>0)[0][1].text
  end
  
  def assessment_type_author
    frm(1).div(:class=>"tier2").table(:index=>0)[1][1].text
  end
  
  def assessment_type_description
    frm(1).div(:class=>"tier2").table(:index=>0)[2][1].text
  end
  
  def save_and_publish
    frm(1).button(:value=>"Save Settings and Publish").click
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
    radio_button(:released_to_anonymous) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:_id117", :index=>0, :frame=>frame) }
    radio_button(:released_to_site) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:_id117", :index=>1, :frame=>frame) }
    text_area(:specified_ips, :name=>"assessmentSettingsAction:_id132", :frame=>frame)
    text_field(:secondary_id, :id=>"assessmentSettingsAction:username", :frame=>frame)
    text_field(:secondary_pw, :id=>"assessmentSettingsAction:password", :frame=>frame)
    checkbox(:timed_assessment, :id=>"assessmentSettingsAction:selTimeAssess", :frame=>frame)
    select_list(:limit_hour, :id=>"assessmentSettingsAction:timedHours", :frame=>frame)
    select_list(:limit_mins, :id=>"assessmentSettingsAction:timedMinutes", :frame=>frame)
    radio_button(:linear_access) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNavigation", :index=>0, :frame=>frame) }
    radio_button(:random_access) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNavigation", :index=>1, :frame=>frame) }
    radio_button(:question_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>0, :frame=>frame) }
    radio_button(:part_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>1, :frame=>frame) }
    radio_button(:assessment_per_page) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:assessmentFormat", :index=>2, :frame=>frame) }
    radio_button(:continuous_numbering) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNumbering", :index=>0, :frame=>frame) }
    radio_button(:restart_per_part) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:itemNumbering", :index=>1, :frame=>frame) }
    checkbox(:add_mark_for_review, :id=>"assessmentSettingsAction:markForReview1", :frame=>frame)
    radio_button(:unlimited_submissions) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:unlimitedSubmissions", :index=>0, :frame=>frame) }
    radio_button(:only_x_submissions) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:unlimitedSubmissions", :index=>1, :frame=>frame) }
    text_field(:allowed_submissions, :id=>"assessmentSettingsAction:submissions_Allowed", :frame=>frame)
    radio_button(:late_submissions_not_accepted) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:lateHandling", :index=>0, :frame=>frame) }
    radio_button(:late_submissions_accepted) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:lateHandling", :index=>1, :frame=>frame) }
    text_area(:submission_message, :id=>"assessmentSettingsAction:_id245_textinput", :frame=>frame)
    text_field(:final_page_url, :id=>"assessmentSettingsAction:finalPageUrl", :frame=>frame)
    radio_button(:question_level_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>0, :frame=>frame) }
    radio_button(:selection_level_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>1, :frame=>frame) }
    radio_button(:both_feedback_levels) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackAuthoring", :index=>2, :frame=>frame) }
    radio_button(:immediate_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>0, :frame=>frame) }
    radio_button(:feedback_on_submission) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>1, :frame=>frame) }
    radio_button(:no_feedback) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>2, :frame=>frame) }
    radio_button(:feedback_on_date) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackDelivery", :index=>3, :frame=>frame) }
    text_field(:feedback_date, :id=>"assessmentSettingsAction:feedbackDate", :frame=>frame)
    radio_button(:only_release_scores) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackComponentOption", :index=>0, :frame=>frame) }
    radio_button(:release_questions_and) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:feedbackComponentOption", :index=>1, :frame=>frame) }
    checkbox(:release_student_response, :id=>"assessmentSettingsAction:feedbackCheckbox1", :frame=>frame)
    checkbox(:release_correct_response, :id=>"assessmentSettingsAction:feedbackCheckbox3", :frame=>frame)
    checkbox(:release_students_assessment_scores, :id=>"assessmentSettingsAction:feedbackCheckbox5", :frame=>frame)
    checkbox(:release_students_question_and_part_scores, :id=>"assessmentSettingsAction:feedbackCheckbox7", :frame=>frame)
    checkbox(:release_question_level_feedback, :id=>"assessmentSettingsAction:feedbackCheckbox2", :frame=>frame)
    checkbox(:release_selection_level_feedback, :id=>"assessmentSettingsAction:feedbackCheckbox4", :frame=>frame)
    checkbox(:release_graders_comments, :id=>"assessmentSettingsAction:feedbackCheckbox6", :frame=>frame)
    checkbox(:release_statistics, :id=>"assessmentSettingsAction:feedbackCheckbox8", :frame=>frame)
    radio_button(:student_ids_seen) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:anonymousGrading1", :index=>0, :frame=>frame) }
    radio_button(:anonymous_grading) { |page| page.radio_button_element( :name=>"assessmentSettingsAction:anonymousGrading1", :index=>1, :frame=>frame) }
    #radio_button(:no_gradebook_options) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
    #radio_button(:grades_sent_to_gradebook) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
    #radio_button(:record_highest_score) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
    #radio_button(:record_last_score) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
    #radio_button(:background_color) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
    #text_field(:color_value, :id=>"", :frame=>frame)
    #radio_button(:background_image) { |page| page.radio_button_element( :name=>"", :index=>0, :frame=>frame) }
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
  
  # This method gets the user ids listed in the
  # scores table.
  def student_ids
    ids = []
    scores_table = frm(1).table(:id=>"editTotalResults:totalScoreTable").to_a
    scores_table.delete_at(0)
    scores_table.each { |row| ids << row[1] }
    return ids
  end
  
  # Method for adding a comment to a particular student's comment box.
  def comment_for_student(student_id, comment)
    available_ids = student_ids
    index_val = available_ids.index(student_id)
    
    frm(1).text_field(:name=>"editTotalResults:totalScoreTable:#{index_val}:_id345").value=comment
    
  end
  
  def update
    frm(1).button(:value=>"Update").click
    AssessmentTotalScores.new(@browser)
  end
  
  def assessments
    frm(1).link(:text=>"Assessments").click
    AssessmentsList
  end

end

# The page that appears when you're creating a new quiz
# or editing an existing one
class EditAssessment
  
  include PageObject
  include ToolsMenu
  
  def insert_question_after(part_num, question_num, qtype)
    if question_num.to_i == 0
      @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:changeQType").select(qtype)
    else
      @browser.frame(:index=>1).select(:id=>"assesssmentForm:parts:#{part_num.to_i - 1}:parts:#{question_num.to_i - 1}:changeQType").select(qtype)
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
  
  def remove_question(part_num, question_num)
    @browser.frame(:index=>1).link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:deleteitem").click
  end
  
  def edit_question(part_num, question_num)
    @browser.frame(:index=>1).link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:parts:#{question_num.to_i-1}:modify").click
  end
  
  def copy_part_to_pool(part_num)
    @browser.frame(:index=>1).link(:id=>"assesssmentForm:parts:#{part_num.to_i-1}:copyToPool").click
  end
  
  def remove_part(part_num)
    @browser.frame(:index=>1).link(:xpath, "//a[contains(@onclick, 'assesssmentForm:parts:#{part_num.to_i-1}:copyToPool')]").click
  end
  
  def add_part
    frm(1).link(:text=>"Add Part").click
    AddEditAssessmentPart.new(@browser)
  end
  
  def select_question_type(qtype)
    @browser.frame(:index=>1).select(:id=>"assesssmentForm:changeQType").select(qtype)

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
  
  def preview
    frm(1).link(:text=>"Preview").click
    PreviewOverview.new(@browser)
  end
  
  def settings
    frm(1).link(:text=>"Settings").click
    AssessmentSettings.new(@browser)
  end
  
  def publish
    frm(1).link(:text=>"Publish").click
    AssessmentsList.new(@browser)
  end
  
  def question_pools
    frm(1).link(:text=>"Question Pools").click
    QuestionPoolsList.new(@browser)
  end
  
  def get_question_text(part_number, question_number)
    frm(1).table(:id=>"assesssmentForm:parts:#{part_number.to_i-1}:parts").div(:class=>"tier3", :index=>question_number.to_i-1).text
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
    @browser.frame(:index=>1).button(:name=>"modifyPartForm:_id89").click
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
    @browser.frame(:index=>1).button(:value=>"Publish").click
    AssessmentsList.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    button(:cancel, :value=>"Cancel", :frame=>frame)
    button(:edit, :name=>"publishAssessmentForm:_id23", :frame=>frame)
    select_list(:notification, :id=>"publishAssessmentForm:number", :frame=>frame)
    
  end

end

# This is a module containing methods that are
# common to all the question pages
module QuestionHelpers
  
  include PageObject
  
  def save
    
    quiz = frm(1).div(:class=>"portletBody").div(:index=>0).text
    pool = frm(1).div(:class=>"portletBody").div(:index=>1).text
    
    frm(1).button(:value=>"Save").click
    
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
    frm(1).button(:id=>"questionpool:submit").click
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
    frm(1).link(:id=>"editform:addQlink").click
    SelectQuestionType.new(@browser)
  end
  
  def question_pools
    frm(1).link(:text=>"Question Pools").click
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
    frm(1).span(:text=>name).fire_event("onclick")
    EditQuestionPool.new(@browser)
  end
  
  def add_new_pool
    frm(1).link(:text=>"Add New Pool").click
    AddQuestionPool.new(@browser)
  end
  
  def import
    frm(1).link(:text=>"Import").click
    PoolImport.new(@browser)
  end
  
  def assessments
    frm(1).link(:text=>"Assessments").click
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
    frm(1).file_field(:name=>"importPoolForm:_id6.upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
  end
  
  def import
    frm(1).button(:value=>"Import").click
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
      frm(1).link(:text=>name).click
    rescue Watir::Exception::UnknownObjectException
      frm(1).link(:text=>CGI::escapeHTML(name)).click
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
    frm(1).button(:value=>"Begin Assessment").click
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
    button(:post, :name=>"post", :frame=>frame)
    button(:preview, :name=>"preview", :frame=>frame)
    button(:save_draft, :name=>"save", :frame=>frame)
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
  
  # The alert_text object on the Add/Edit Assignments page
    def alert_text
      frm(1).div(:class=>"portletBody").div(:class=>"alertMessage").text
    end
    
    # A method to insert text into the rich text editor
    def add_instructions(instructions)
      frm(1).frame(:id, "new_assignment_instructions___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(instructions)
    end
  
end

# Page that appears when you first click the Assignments link
class AssignmentsList
  
  include PageObject
  include ToolsMenu
  
  def assignments_table
    table = @browser.frame(:index=>1).table(:class=>"listHier lines nolines").to_a
  end
 
  in_frame(:index=>1) do |frame|
    link(:add, :text=>"Add", :frame=>frame)
    link(:grade_report, :text=>"Grade Report", :frame=>frame)
    link(:student_view, :text=>"Student View", :frame=>frame)
    link(:permissions, :text=>"Permissions", :frame=>frame)
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
  
  in_frame(:index=>0) do |frame|
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
    button(:post, :name=>"post", :frame=>frame)
    button(:edit, :name=>"revise", :frame=>frame)
    button(:save_draft, :name=>"save", :frame=>frame)
    button(:done, :name=>"done", :frame=>frame)
    
  end
  
  def created_by
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][1].text
  end
  
  def modified
    @browser.frame(:index=>1).table(:class=>"itemSummary")[1][1].text
  end
  
  def open
    @browser.frame(:index=>1).table(:class=>"itemSummary")[2][1].text
  end
  
  def due
    @browser.frame(:index=>1).table(:class=>"itemSummary")[3][1].text
  end
  
  def accept_until
    @browser.frame(:index=>1).table(:class=>"itemSummary")[4][1].text
  end
  
  def student_submissions
    @browser.frame(:index=>1).table(:class=>"itemSummary")[5][1].text
  end
  
  def grade_scale
    @browser.frame(:index=>1).table(:class=>"itemSummary")[6][1].text
  end
  
  def add_due_date
    @browser.frame(:index=>1).table(:class=>"itemSummary")[7][1].text
  end
  
  def announce_open_date
    @browser.frame(:index=>1).table(:class=>"itemSummary")[8][1].text
  end
  
  def honor_pledge
    @browser.frame(:index=>1).table(:class=>"itemSummary")[9][1].text
  end
  
  def add_to_gradebook
    @browser.frame(:index=>1).table(:class=>"itemSummary")[10][1].text
  end
  
  def assignment_instructions
    @browser.frame(:index=>1).div(:class=>"textPanel").text
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
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][1].text
  end
  
  def due
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][2].text
  end
  
  def status
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][3].text
  end
  
  def grade_scale
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][4].text
  end
  
  def modified
    @browser.frame(:index=>1).table(:class=>"itemSummary")[0][5].text
  end
  
  def add_assignment_text(text)
    @browser.frame(:index=>1).frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def remove_assignment_text
    @browser.frame(:index=>1).frame(:id, "Assignment.view_submission_text___Frame").div(:title=>"Select All").fire_event("onclick")
    @browser.frame(:index=>1).frame(:id, "Assignment.view_submission_text___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
  end
  
  def file_field #FIXME
    @browser.frame(:index=>1).file_field(:id=>"clonableUpload")
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
    @browser.frame(:index=>1).image(:src, "/library/image/sakai/expand.gif?panel=Main").click
  end
  
  def show_assignment_details
    @browser.frame(:index=>1).image(:src, "/library/image/sakai/expand.gif").click
  end
  
  def student_table
    table = @browser.frame(:index=>1).table(:class=>"listHier lines nolines").to_a
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
    @browser.frame(:index, 1).frame(:id, "grade_submission_feedback_text___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def set_instructor_comments(text)
    @browser.frame(:index, 1).frame(:id, "grade_submission_feedback_comment___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
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
  
  in_frame(:index=>0) do |frame|
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
  
  in_frame(:index=>0) do |frame|
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
# Calendar Pages for a Site
#================

# Top page of the Calendar
# For now it includes all views, though that probably
# means it will have to be re-instantiated every time
# a new view is selected.
class Calendar
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"view", :frame=>frame)
    select_list(:show_events, :id=>"timeFilterOption", :frame=>frame)
    select_list(:start_month, :id=>"customStartMonth", :frame=>frame)
    select_list(:start_day, :id=>"customStartDay", :frame=>frame)
    select_list(:start_year, :id=>"customStartYear", :frame=>frame)
    select_list(:end_month, :id=>"customEndMonth", :frame=>frame)
    select_list(:end_day, :id=>"customEndDay", :frame=>frame)
    select_list(:end_year, :id=>"customEndYear", :frame=>frame)
    button(:filter_events, :name=>"eventSubmit_doCustomdate", :frame=>frame)
    button(:go_to_today, :name=>"eventSubmit_doToday", :frame=>frame)
    
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
    frm(1).link(:text=>"New Forum").click
    EditForum.new(@browser)
  end

  def new_topic_for_forum(name)
    index = forum_titles.index(name)
    frm(1).link(:text=>"New Topic", :index=>index).click
    AddEditTopic.new(@browser)
  end

  def organize
    frm(1).link(:text=>"Organize").click
    OrganizeForums.new(@browser)
  end

  def template_settings
    frm(1).link(:text=>"Template Settings").click
    ForumTemplateSettings.new(@browser)
  end

  def forums_table
    @browser.frame(:index=>1).div(:class=>"portletBody").table(:id=>"msgForum:forums")
  end

  def forum_titles
    titles = []
    title_links = frm(1).div(:class=>"portletBody").links.find_all { |link| link.class_name=="title" && link.id=="" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def topic_titles
    titles = []
    title_links = frm(1).div(:class=>"portletBody").links.find_all { |link| link.class_name == "title" && link.id != "" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def forum_settings(name)
    index = forum_titles.index(name)
    frm(1).link(:text=>"Forum Settings", :index=>index).click
    EditForum.new(@browser)
  end
  
  def topic_settings(name)
    index = topic_titles.index(name)
    frm(1).link(:text=>"Topic Settings", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def delete_forum(name)
    index = forum_titles.index(name)
    frm(1).link(:id=>/msgForum:forums:\d+:delete/,:text=>"Delete", :index=>index).click
    EditForum.new(@browser)
  end
  
  def delete_topic(name)
    index = topic_titles.index(name)
    frm(1).link(:id=>/topics:\d+:delete_confirm/, :text=>"Delete", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def open_forum(forum_title)
    frm(1).link(:text=>forum_title).click
    # New Class def goes here.
  end
  
  def open_topic(topic_title)
    frm(1).link(:text=>topic_title).click
    TopicPage.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    #(:, =>"", :frame=>frame)
  end
end

class TopicPage
  
  include PageObject
  include ToolsMenu
  
  def post_new_thread
    frm(1).link(:text=>"Post New Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def open_message(message_title)
    frm(1).div(:class=>"portletBody").link(:text=>message_title).click
    ViewForumThread.new(@browser)
  end
  
  def display_entire_message
    frm(1).link(:text=>"Display Entire Message").click
    TopicPage.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    
  end
end

class ViewForumThread
  
  include PageObject
  include ToolsMenu
  
  def reply_to_thread
    frm(1).link(:text=>"Reply to Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def reply_to_message(index)
    frm(1).link(:text=>"Reply", :index=>(index.to_i - 1)).click
    ComposeForumMessage.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    
  end
end

class ComposeForumMessage
  
  include PageObject
  include ToolsMenu
  
  def post_message
    frm(1).button(:text=>"Post Message").click
    # Not sure if we need logic here...
    TopicPage.new(@browser)
  end
  
  def editor
    frm(1).frame(:id, "dfCompose:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def message=(text)
    editor.send_keys(text)
  end
  
  def reply_text
    @browser.frame(:index=>1).div(:class=>"singleMessageReply").text
  end
  
  def add_attachments
    
  end
  
  def cancel
    frm(1).button(:value=>"Cancel").click
    # Logic for picking the correct page class
    if frm(1).link(:text=>"Reply to Thread")
      ViewForumThread.new(@browser)
    elsif frm(1).link(:text=>"Post New Thread").click
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
    frm(1).div(:class=>"portletBody").h3(:index=>0).text
  end
  
  def save
    frm(1).button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def cancel
    frm(1).button(:value=>"Cancel").click
    Forums.new(@browser)
  end
=begin
    def site_role=(role)
    frm(1).select(:id=>"revise:role").select(role)
    0.upto(frm(1).select(:id=>"revise:role").length - 1) do |x|
      if frm(1).div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm(1).select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end
        
      end
    end
  end
=end  
  in_frame(:index=>1) do |frame|
    #radio_button(:name, :id=>"id", :frame=>frame)
  end
end

class OrganizeForums
  
  include PageObject
  include ToolsMenu
  
  def save
    frm(1).button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  # These are set to so that the user
  # does not have to start the list at zero...
  def forum(index)
    frm(1).select(:id, "revise:forums:#{index.to_i - 1}:forumIndex")
  end
  
  def topic(forumindex, topicindex)
    frm(1).select(:id, "revise:forums:#{forumindex.to_i - 1}:topics:#{topicindex.to_i - 1}:topicIndex")
  end
  
end

# The page for creating/editing a forum in a Site
class EditForum
  
  include PageObject
  include ToolsMenu
  
  def save
    frm(1).button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def save_and_add
    frm(1).button(:value=>"Save Settings & Add Topic").click
    AddEditTopic.new(@browser)
  end
  
  def editor
    frm(1).div(:class=>"portletBody").frame(:id, "revise:df_compose_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def add_attachments
    frm(1).button(:value=>/attachments/).click
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
    frm(1).button(:value=>"Continue").click
    frm(1).div(:class=>"portletBody").h3(:index=>0).wait_until_present
    title = frm(1).div(:class=>"portletBody").h3(:index=>0).text
    # Need logic because new page will be different
    if title=="Topic Settings"
      AddEditTopic.new(@browser)
    elsif title=="Forum Settings"
      EditForum.new(@browser)
    end
  end
  
  def upload_file=(file_name)
    frm(1).file_field(:id, "upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
  rescue Watir::Exception::ObjectDisabledException
    sleep 5
    frm(1).file_field(:id, "upload").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
  end
  
  in_frame(:index=>1) do |frame|
    #(:, =>"", :frame=>frame)
  end
end

class AddEditTopic
  
  include PageObject
  include ToolsMenu
  
  @@table_index=0
  
  def editor
    frm(1).div(:class=>"portletBody").frame(:id, "revise:topic_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def save
    frm(1).button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def add_attachments
    frm(1).button(:value=>/Add.+ttachment/).click
    ForumsAddAttachments.new(@browser)
  end
  
  def roles
    roles=[]
    options = frm(1).select(:id=>"revise:role").options.to_a
    options.each { |option| roles << option.text }
    return roles
  end
  
  def site_role=(role)
    frm(1).select(:id=>"revise:role").select(role)
    0.upto(frm(1).select(:id=>"revise:role").length - 1) do |x|
      if frm(1).div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm(1).select(:id=>"revise:perm:#{@@table_index}:level").select(value)
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
  end
  
  def open_my_site_by_id(id)
    @browser.link(:text, "My Sites").click
    @browser.link(:href, /#{id}/).click
    Home.new(@browser)
  end
  
  def open_my_site_by_name(name)
    @browser.link(:text, "My Sites").click
    @browser.link(:text, name).click
    # Add rescue clause here for truncated names...
    Home.new(@browser)
  end
  
end

# The Page that appears when you are not in a particular Site
# Note that this page differs depending on what user is logged in.
# The definitions below include all potential objects. We may
# have to split this class out into user-specific classes.
class MyWorkspace
  
  include PageObject
  include ToolsMenu
  
  def open_my_site_by_id(id)
    @browser.link(:text, "My Sites").click
    @browser.link(:href, /#{id}/).click
    Home.new(@browser)
  end
  
  def open_my_site_by_name(name)
    @browser.link(:text, "My Sites").click
    @browser.link(:text, name).click
    # Add rescue clause here for truncated names...
    Home.new(@browser)
  end
  
  # Because the links below are contained within iframes
  # we need the in_frame method in place so that the
  # links can be properly parsed in the PageObject
  # methods for them.
  # Note that the iframes are being identified by their
  # index values on the page. This is a very brittle
  # method for identifying them, but for now it's our
  # only option because both the <id> and <name>
  # tags are unique for every site.
  in_frame(:index=>2) do |frame|
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
# Resources Pages 
#================

# Resources page for a given Site, in the Course Tools menu
class Resources
  
  include PageObject
  include ToolsMenu
  
  # This method will need to be improved to allow
  # for Resources pages that contain multiple
  # folders
  def upload_files
    frm(1).link(:text, "Start Add Menu").fire_event("onfocus")
    frm(1).link(:text, "Upload Files").click
    ResourcesUploadFiles.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    
    
  end

end

# New class template. For quick class creation...
class ResourcesUploadFiles
  
  include PageObject
  include ToolsMenu
  
  @@filex=0
  
  def file_to_upload=(file_name)
    frm(1).file_field(:id, "content_#{@@filex}").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/" + file_name)
    @@filex+=1
  end
  
  def upload_files_now
    frm(1).button(:value=>"Upload Files Now").click
    Resources.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    link(:add_another_file, :text=>"Add Another File", :frame=>frame)
    
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
  
  # A method to click the first site Id link
  # listed. Useful when you've run a search and
  # you're certain you've got the result you want
  def click_top_item
    frm(0).link(:href, /#{Regexp.escape("&panel=Main&sakai_action=doEdit")}/).click
    EditSiteInfo.new(@browser)
  end
  
  # Use this method when you know the target site ID
  def edit_site_id(id)
    frm(0).text_field(:id=>"search_site").value=id
    frm(0).link(:text=>"Site ID").click
    frm(0).link(:text, id).click
    EditSiteInfo.new(@browser)
  end
  
  def new_site
    frm(0).link(:text, "New Site").click
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
  
  def remove_site
    frm(0).link(:text, "Remove Site").click
    RemoveSite.new(@browser)
  end
  
  def save
    frm(0).button(:value=>"Save").click
    Sites.new(@browser)
  end
  
  def save_as
    frm(0).link(:text, "Save As").click
    SiteSaveAs.new(@browser)
  end
  
  def site_id_read_only
    @browser.frame(:index=>0).table(:class=>"itemSummary").td(:class=>"shorttext", :index=>0).text
  end
  
  # Method for adding text to the rich text editor
  def add_description(text)
    @browser.frame(:index=>0).frame(:id, "description___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def pages
    frm(0).button(:value=>"Pages").click
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
  
  def new_page
    frm(0).link(:text=>"New Page").click
    NewPage.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    # (:, :=>"", :frame=>frame)
  end

end

# Page for adding a new page to a Site.
class NewPage
  
  include PageObject
  include ToolsMenu
  
  def tools
    frm(0).button(:value=>"Tools").click
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
  
  def new_tool
    frm(0).link(:text=>"New Tool").click
    NewTool.new(@browser)
  end
  
  def save
    frm(0).button(:value=>"Save").click
    AddEditPages.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    # Interactive page objects that do no navigation
    # or page refreshes go here.
    #(:, :=>"", :frame=>frame)
    
  end

end

# Page for creating a new tool for a page in a site
class NewTool
  
  include PageObject
  include ToolsMenu
  
  def done
    frm(0).button(:value=>"Done").click
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
  
  def remove
    frm(0).button(:value=>"Remove").click
    Sites.new(@browser)
  end
  
end

# Page that appears when you click "Save As" when editing a Site in Sites
class SiteSaveAs
  
  include PageObject
  include ToolsMenu
  
  def save
    frm(0).button(:value, "Save").click
    Sites.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    text_field(:site_id, :id=>"id", :frame=>frame)
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
    frm(1).link(:text=>"Manage Groups").click
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
    frm(1).link(:text=>"Create New Group").click
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
    frm(1).button(:id=>"save").click
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
# Site Setup Pages in the Admin Workspace
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
  
  def edit_tools
    frm(0).link(:text=>"Edit Tools").click
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
  
  def continue
    frm(0).button(:value=>"Continue").click
    # Logic for determining the new page class...
    if frm(0).div(:class=>"portletBody").text =~ /^Add Multiple Tool/
      AddMultipleTools.new(@browser)
    elsif frm(0).div(:class=>"portletBody").text =~ /^Confirming site tools edits for/
      ConfirmSiteToolsEdits.new(@browser)
    else
      puts "Something is wrong"
      puts frm(0).div(:class=>"portletBody").text
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
  
  def finish
    frm(0).button(:value=>"Finish").click
    SiteSetupEdit.new(@browser)
  end
  
end

# The Site Setup page - a.k.a., link class=>"icon-sakai-sitesetup"
class SiteSetup
  
  include PageObject
  include ToolsMenu
  
  # Site list contents are not defined as objects here,
  # as they will always have the potential to be different
  
  # Method for clicking the "New" link on the Site Setup page.
  def new
    frm(0).link(:text=>"New").click
    SiteType.new(@browser)
  end
  
  # Note that this method (and the following)
  # presumes that the site search
  # will be successful and that only one site will
  # be returned. It will need additional coding if
  # there may be future situations where this won't always
  # be true.
  def edit(site_name)
    frm(0).text_field(:id, "search").value=Regexp.escape(site_name)
    frm(0).button(:value=>"Search").click
    frm(0).div(:class=>"portletBody").checkbox(:name=>"selectedMembers").set
    frm(0).link(:text, "Edit").click
    SiteSetupEdit.new(@browser)
  end

  def delete(site_name)
    frm(0).text_field(:id, "Search").value=site_name
    frm(0).button(:value=>"Search").click
    frm(0).checkbox(:name=>"selectedMembers").set
    frm(0).link(:text, "Delete").click
    DeleteSite.new(@browser)
  end

  in_frame(:index=>0) do |frame|
    link(:delete, :text=>"Delete", :frame=>frame)
    text_field(:search, :id=>"search", :frame=>frame)
    button(:search, :value=>"Search", :frame=>frame)
    select_list(:view, :id=>"view", :frame=>frame)
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
  
  def remove
    frm(0).button(:value=>"Remove").click
    SiteSetup.new(@browser)
  end
  
  def cancel
    frm(0).button(:value=>"Cancel").click
    SiteSetup.new(@browser)
  end
  
end
#The Site Type page that appears when creating a new site
class SiteType
  
  include PageObject
  include ToolsMenu
  
  def select_course_site
    frm(0).radio(:id, "course").set
    @site_type = 1
  end
  
  def select_project_site
    frm(0).radio(:id, "project").set
    @site_type = 2
  end
  
  def select_portfolio_site
    frm(0).radio(:id, "portfolio").set
    @site_type = 3
  end
  
  def select_template_site
    frm(0).radio(:id, "copy").set
    @site_type = 4
  end
  
  # The page's Continue button
  def continue
    # Logic for the type of site selected...
    case(@site_type)
    when 1
      frm(0).button(:id=>"submitBuildOwn").click
      CourseSectionInfo.new(@browser)
    when 2
      frm(0).button(:id=>"submitFromTemplateCourse").click
      # Add page class here
    when 3
      frm(0).button(:id=>"submitBuildOwn").click
      # Add page class here
    when 4
      frm(0).button(:id=>"submitBuildOwn").click
      # Add page class here
    end
    
  end
  
  in_frame(:index=>0) do |frame|
    select_list(:academic_term, :id=>"selectTerm", :frame=>frame)
    button(:cancel, :id=>"cancelCreate", :frame=>frame)
  end
  
  
end

# The Add Multiple Tool Instances page that appears during Site creation
# after the Course Site Tools page
class AddMultipleTools
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm(0).button(:value=>"Continue").click
    # Logic to determine the new page class
    if frm(0).div(:class=>"portletBody").text =~ /Course Site Access/
      CourseSiteAccess.new(@browser)
    elsif frm(0).div(:class=>"portletBody").text =~ /^Confirming site tools edits/
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
  
  def continue
    frm(0).button(:value=>"Continue").click
    CourseSiteInfo.new(@browser)
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
  
  def continue
    frm(0).button(:value=>"Continue").click
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
  
  def request_site
    frm(0).button(:value=>"Request Site").click
    SiteSetup.new(@browser)
  end
  
end

# The Course Site Information page that appears when creating a new Site
# immediately after the Course/Section Information page
class CourseSiteInfo
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm(0).button(:value=>"Continue").click
    EditSiteTools.new(@browser)
  end
  
  # The WYSIWYG FCKEditor on this page will have to be
  # set up carefully, but later. The time for doing this is TBD.
  
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
# User's Account Page - "My Settings"
#================

# The Page for editing User Account details
class EditAccount
  
  include PageObject
  include ToolsMenu
  
  in_frame(:index=>0) do |frame|
    text_field(:first_name, :id=>"first-name", :frame=>frame)
    text_field(:last_name, :id=>"last-name", :frame=>frame)
    text_field(:email, :id=>"email", :frame=>frame)
    text_field(:create_new_password, :id=>"pw", :frame=>frame)
    text_field(:verify_new_password, :id=>"pw0", :frame=>frame)
    button(:update_details, :name=>"eventSubmit_doSave", :frame=>frame)
    button(:cancel_changes, :name=>"eventSubmit_doCancel", :frame=>frame)
  end
  
  # Need to add definitions of read-only text fields here.

end

# A Non-Admin User's Account page
# Accessible via the "Account" link in "MY SETTINGS"
class UserAccount
  
  # IMPORTANT: this class does not use PageObject or the ToolsMenu!!
  # So, the only available method to navigate away from this page is
  # Home. Otherwise, you'll have to call the navigation link
  # Explicitly in the test case itself.
  #
  # Objects and methods used in this class must be explicitly
  # defined using Watir and Ruby code.
  #
  # Do NOT use the PageObject syntax in this class.
  
  def initialize(browser)
    @browser = browser
  end

  def modify_details
    @browser.frame(:index=>0).button(:name=>"eventSubmit_doModify").click
  end
  
  def user_id
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[0][1].text
  end
  
  def first_name
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[1][1].text
  end
  
  def last_name
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[2][1].text
  end
  
  def email
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[3][1].text
  end
  
  def type
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>0)[4][1].text
  end
  
  def created_by
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[0][1].text
  end
  
  def created
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[1][1].text
  end
  
  def modified_by
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[2][1].text
  end
  
  def modified
    @browser.frame(:index=>0).table(:class=>"itemSummary", :index=>1)[3][1].text
  end
  
  def home
    @browser.link(:text, "Home").click
  end

end



#================
# Users Pages - From Administration Workspace
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
  
  # Need to add definitions of read-only text fields here.

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
  
  def jobs
    frm(0).link(:text=>"Jobs").click
    JobList.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
  
  end
end

# The list of Jobs (click the Jobs button on Job Scheduler)
class JobList
  
  include PageObject
  include ToolsMenu
  
  def new_job
    frm(0).link(:text=>"New Job").click
    CreateNewJob.new(@browser)
  end
  
  def triggers
    frm(0).link(:text=>"Triggers(0)").click
    EditTriggers.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    #(:, =>"", :frame=>frame)
  end
end

# The Create New Job page
class CreateNewJob
  
  include PageObject
  include ToolsMenu
  
  def post
    frm(0).button(:value=>"Post").click
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
  
  def run_job_now
    frm(0).div(:class=>"portletBody").link(:text=>"Jobs").click
    RunJobConfirmation.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    #(:, =>"", :frame=>frame)
  end
end

# The page for confirming you want to run a job
class RunJobConfirmation
  
  include PageObject
  include ToolsMenu
  
  def run_now
    frm(0).button(:value=>"Run Now").click
    JobList.new(@browser)
  end
  
  in_frame(:index=>0) do |frame|
    #(:, =>"", :frame=>frame)
  end
end