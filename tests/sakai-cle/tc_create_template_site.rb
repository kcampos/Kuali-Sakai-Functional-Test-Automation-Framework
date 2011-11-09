# 
# == Synopsis
#
# Test the creation and usage of a Site Template
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class CreateSiteTemplate < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @template_site_id = "88888888-7777-6666-5555-abcdefghijklm"
    @template_site_name = "Template - " + random_string(16)
    @assignment_title = "Assignment - " + random_string(16)
    @test_title = "Test - " + random_string(16)
    @syllabus_title = "Syllabus - " + random_string(16)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_template_site_create
    
    # Log in to Sakai
    my_workspace = @sakai.login(@instructor, @ipassword)

    # Go to Sites and SAVE AS the test site with a new Site ID
    # and a Name that includes "Template"
    sites = my_workspace.sites
    
    edit_site = sites.edit_site_id(@site_id)
    save_as = edit_site.save_as
    save_as.site_id=@template_site_id
    sites_page = save_as.save
    
    # Edit the template site and go to its properties...
    edit_site = sites_page.edit_site_id @template_site_id
    properties = edit_site.properties
    
    # Enter property name "template"
    properties.name="template"
    
    # Enter Value "TRUE"
    properties.value="TRUE"
    
    # Save properties
    edit_site = properties.done
    edit_site.title=@template_site_name
    sites_page = edit_site.save
    
    my_workspace = sites_page.home

    # Edit the Template Site
    home = my_workspace.open_my_site_by_name @template_site_name
    
    # Add Assignments
    assignments_page = home.assignments
    assignment = assignments_page.add
    assignment.title=@assignment_title
    assignment.instructions="Do this!"
    assignments_page = assignment.post
    
    # Add Resources
    resources = assignments_page.resources
    upload = resources.upload_files_to_folder(@template_site_name + " Resources")
    upload.file_to_upload="documents/resources.doc" #FIXME
    upload.add_another_file
    upload.file_to_upload="documents/sample.pdf" #FIXME
    resources = upload.upload_files_now
    
    add_test = resources.tests_and_quizzes
    
    # Add Tests
    add_test.title=@test_title
    quiz = add_test.create
    question1 = quiz.select_question_type "Multiple Choice"
    
    # Set up the question info...
    question1.answer_point_value="5"
    question1.question_text="Who was the first US president?"
    question1.answer_a="Jefferson"
    question1.answer_b="Lincoln"
    question1.answer_c="Grant"
    question1.answer_d="Washington"
    question1.select_d_correct
    question1.feedback_for_correct="Good!"
    question1.feedback_for_incorrect="Bad!"
    
    # Save the question
    quiz = question1.save
    review = quiz.publish
    list_page = review.publish
    
    # Add Syllabus
    syllabus = list_page.syllabus
    
    item = syllabus.create_edit
    item.title=@syllabus_title
    item.content="Syllabus Content"
    
    syllabus = item.post
    
    # Add more types of stuff...
    
    # Go back to Site Setup page
    my_workspace = syllabus.my_workspace
    
    site_setup = my_workspace.site_setup

    # Add a new Site
    new_site = site_setup.new

    # Select to create site from Template
    new_site.select_create_site_from_template

    new_site.select_template=/#{Regexp.escape(@template_site_name)}/
    new_site.select_term="FALL 2011" #FIXME
    new_site.check_copy_users
    new_site.check_copy_content
    
    # Finish Setup of the new site
    section_info = new_site.continue
    
    subject = random_string(5)
    course = random_string(5)
    section = random_string(5)
    
    section_info.subject=subject
    section_info.course=course
    section_info.section=section
    section_info.authorizers_username="admin"
    
    site_setup = section_info.done_go_to_site
    
    site_setup = site_setup.search "#{subject} #{course} #{section}"
    
    # Verify the new Site shows up in Site Setup list
    assert site_setup.site_titles.include? "#{subject} #{course} #{section} F11" #FIXME!!!
    
    # Go to the site
    @browser.frame(:index=>0).link(:text, "#{subject} #{course} #{section} F11").click #FIXME
    site_home = Home.new(@browser)
    
    # Verify the Site's contents are as expected...
    assignments_page = site_home.assignments
    
    # TEST CASE: Assignments
    assert assignments_page.assignments_titles.include? @assignment_title
    
    resources = assignments_page.resources
    
    # TEST CASE: Resources
    assert resources.resource_names.include? "resources.doc"
    assert resources.resource_names.include? "sample.pdf"
    
    tests = resources.tests_and_quizzes
    
    # TEST CASE: Tests
    assert tests.published_assessment_titles.include? @test_title
    
    syllabus = tests.syllabus
    
    # TEST CASE: Syllabus
    assert syllabus.syllabus_titles.include? @syllabus_title
    
    # ...
  end
  
end
