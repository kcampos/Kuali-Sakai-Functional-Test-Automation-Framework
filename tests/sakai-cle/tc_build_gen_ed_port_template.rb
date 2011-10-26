# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestBuildPortfolioTemplate < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_build_portfolio_template
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    resources = workspace.resources
=begin    
    # Add Files to Repository...
    create_folder = resources.create_subfolders_in "My Workspace"
    create_folder.folder_name="data"
    
    resources = create_folder.create_folders_now
    
    upload_files = resources.upload_files_to_folder "data"
    
    files = [
      "documents/evaluation.xsd",
      "documents/feedback.xsd",
      "documents/genEducation.xsd",
      "documents/reflection.xsd"
    ]

    files.each do |file|
      upload_files.file_to_upload=file
      upload_files.add_another_file
    end
    
    resources = upload_files.upload_files_now
=end 
    home = resources.open_my_site_by_name "Portfolio Site"
    
    # Build four Matrix Forms...
    forms = home.forms
=begin
    add_form = forms.add
    
    select_schema = add_form.select_schema_file
    
    select_schema = select_schema.show_other_sites
    
    select_schema = select_schema.open_folder "My Workspace"
    select_schema = select_schema.open_folder "data"
    select_schema = select_schema.select_file "evaluation.xsd"
    
    add_form = select_schema.continue
    add_form.name="Evaluation"
    add_form.instruction="Use the Display Name to identify the purpose of your evaluation."
    
    forms = add_form.add_form
    
    add_form2 = forms.add
    
    schema = add_form2.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder "data"
    schema = schema.select_file "genEducation.xsd"
    
    add_form2 = schema.continue
    add_form2.name="General Education Evidence"
    add_form2.instruction="Use the Display Name to identify the specific evidence associated with this cell that you will document with this instance of the General Education Evidence form. Use the other fields in this form to provide information about your evidence to assist the viewer in understanding its context, why you choose it, and your own evaluation of it."
    
    forms = add_form2.add_form
    
    add_form3 = forms.add
    
    schema = add_form3.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder "data"
    schema = schema.select_file "feedback.xsd"
    
    add_form3 = schema.continue
    add_form3.name="Feedback for Matrix"
    add_form3.instruction="Use the Display name to identify the purpose of your feedback."
    
    forms = add_form3.add_form
    
    add_form4 = forms.add
    
    schema = add_form4.select_schema_file
    schema = schema.show_other_sites
    schema = schema.open_folder "My Workspace"
    schema = schema.open_folder "data"
    schema = schema.select_file "reflection.xsd"
    
    add_form4 = schema.continue
    add_form4.name="Reflection for Matrix"
    add_form4.instruction="Reflect upon the evidence you have added to this matrix cell by responding to the following questions."
    
    forms = add_form4.add_form

    # Publish the four forms...
    publish = forms.publish "Evaluation"
    forms = publish.yes
    publish = forms.publish "General Education Evidence"
    forms = publish.yes
    publish = forms.publish "Feedback for Matrix"
    forms = publish.yes
    publish = forms.publish "Reflection for Matrix"
    forms = publish.yes
=end  
    styles = forms.styles
=begin
    # Add Style to site...
    add_style = styles.add
    
    attach = add_style.select_file
    attach = attach.show_other_sites
    attach.open_folder "My Workspace"
    
    upload = attach.upload_files_to_folder "data"
    upload.file_to_upload="documents/wacky2.css"
    
    attach = upload.upload_files_now
    
    add_style = attach.continue
    add_style.name="Wacky Style"
    add_style.description="Style for general use."
    
    styles = add_style.add_style
=end
    matrices = style.matrices
    
    add_matrix = matrices.add
    add_matrix.title="General Education"
    
    select = add_matrix.select_style
    
    add_matrix = select.select_style "Wacky Style"
    
    column1 = add_matrix.add_column
    column1.name="Level 1"
    add_matrix = column1.update
    
    column2 = add_matrix.add_column
    column2.name="Level 2"
    add_matrix = column2.update
    
    column3 = add_matrix.add_column
    column3.name="Level 3"
    add_matrix = column3.update
    
    row1 = add_matrix.add_row
    row1.name="Written Communication"
    row1.background_color="#B0E65A"
    row1.font_color="#000000"
    
    add_matrix = row1.update
    
    row2 = add_matrix.add_row
    row2.name="Critical Thinking"
    row2.background_color="#BDD676"
    row2.font_color="#000000"
    
    add_matrix = row2.update

    row3 = add_matrix.add_row
    row3.name="Information Retrieval and Technology"
    row3.background_color="#D3E195"
    row3.font_color="#000000"
    
    add_matrix = row3.update
    
    row4 = add_matrix.add_row
    row4.name="Quantitative Reasoning"
    row4.background_color="#E3F29F"
    row4.font_color="#000000"
    
    add_matrix = row4.update
    
    row5 = add_matrix.add_row
    row5.name="Oral Communication"
    row5.background_color="#F0FFA9"
    row5.font_color="#000000"
    
    add_matrix = row5.update
    
    row5 = add_matrix.add_row
    row5.name="Understanding Self and Community"
    row5.background_color="#ECFFD3"
    row5.font_color="#000000"
    
    add_matrix = row5.update
    matrices = add_matrix.create_matrix
    
    #
    @selenium.click "link=Edit"
    #
    #  ////////////////////////////////////////////////  Start edit cell //////////////////////////////////////
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[2]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[2]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[2]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[3]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[3]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[3]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[4]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[4]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[4]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[5]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[5]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[5]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[6]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[6]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[6]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[7]/td[1]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[7]/td[2]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//table[@summary='Matrix Scaffolding (click on a cell to edit)']/tbody/tr[7]/td[3]"
    #
    @selenium.click "defaultReflectionForm"
    @selenium.select "reflectionDevice-id", "label=Reflection for Matrix (123Port)"
    @selenium.click "defaultFeedbackForm"
    @selenium.select "reviewDevice-id", "label=Feedback for Matrix (123Port)"
    @selenium.click "defaultEvaluationForm"
    @selenium.select "evaluationDevice-id", "label=Evaluation (123Port)"
    @selenium.click "defaultEvaluators"
    @selenium.click "//a[contains(text(),'Evaluators')]"
    #
    @selenium.click "mainForm:save_button"
    #
    @selenium.click "saveAction"
    #
    #  ######################################################################### 
    @selenium.click "//img[@alt='Reset']"
    #
    @selenium.click "link=Preview"
    #
    @selenium.click "link=Publish"
    #
    @selenium.click "continue"
    #
    @selenium.click "link=Logout"
    #
    
  end
end
