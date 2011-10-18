# 
# == Synopsis
#
# Testing Creating and Editing Lessons in a Site.
#
# Note: This script should be fixed to use programmatically generated
# test content, such as for the start and end dates of lessons.
# Currently these are hard-coded, making this test somewhat brittle.
#
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCreateLessons < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Using instructor2 and student04 for this test case
    @instructor =@config.directory['person4']['id']
    @ipassword = @config.directory['person4']['password']
    @student = @config.directory["person6"]["id"]
    @spassword = @config.directory["person6"]["password"]
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_lesson_creation
      
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
  
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)

    # Go to test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to lessons
    lessons = home.lessons
    
    # Add a module
    new_module = lessons.add_module
    
    # Enter module attributes
    new_module.title="Lesson1"
    new_module.description="Lesson1"
    
    # Add a section
    confirm = new_module.add
    new_section = confirm.add_content_sections
    
    # Enter section info
    new_section.title="Lesson1-Section1"
    new_section.content_type="Compose content with editor"
    
    new_section.clear_content
    new_section.add_content="<h3" # style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    confirm = new_section.add
    # Save section and add another... 
    new_section2 = confirm.add_another_section
    
    new_section2.title="Lesson1-Section2"
    new_section2.content_type="Link to new or existing URL resource on server"
    
    select_content = new_section2.select_url
    
    select_content.new_url="http://www.rsmart.com"
    select_content.url_title="rsmart"
    new_section2 = select_content.continue
     
    confirm = new_section2.add
     
    lessons = confirm.finish
    
    # Add another Lesson (from the past)...
    new_module2 = lessons.add_module
    new_module2.title="Lesson2 (Expired)"
    new_module2.start_date="July 6, 2008 08:00 AM"
    new_module2.end_date="July 15, 2008 08:00 AM"
    
    confirm = new_module2.add
    
    # Add a section to the module...
    new_section3 = confirm.add_content_sections 
    new_section3.title="Lesson2 - Section1"
    new_section3.content_type="Link to new or existing URL resource on server"
    
    select_content2 = new_section3.select_url
     
    select_content2.new_url="http://sakaiproject.org"
    select_content2.url_title="sakai"
    
    new_section3 = select_content2.continue

    confirm = new_section3.add
    
    lessons = confirm.finish
    
    # Add another lesson (for the future)...
    new_module3 = lessons.add_module
    
    new_module3.title="Lesson3-Future"
    new_module3.start_date="July 15, 2012 08:00 AM"
    
    confirm = new_module3.add
    
    # Add a section to the module
    new_section4 = confirm.add_content_sections
     
    new_section4.title="Lesson3-Section1"
    new_section4.content_type="Compose content with editor"
    
    new_section4.clear_content
    new_section4.add_content="<h3"# style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    
    confirm = new_section4.add
    
    lessons = confirm.finish
    
    # Add another lesson module...
    new_module4 = lessons.add_module
    new_module4.title="Lesson4"
    
    confirm = new_module4.add
     
    new_section5 = confirm.add_content_sections
    new_section5.title="Lesson4-Section1"
    new_section5.content_type="Compose content with editor"
    new_section5.clear_content
    new_section5.add_content="<h3"# style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    
    confirm = new_section5.add
    
    lessons = confirm.finish
    
    # Add another lesson
    new_module5 = lessons.add_module
    new_module5.title="Lesson5"
    
    confirm = new_module5.add
    
    new_section6 = confirm.add_content_sections
    
    new_section6.title="Lesson5-Section1"
    new_section6.content_type="Upload or link to a file in Resources"
    add_attach = new_section6.select_or_upload_file

    add_attach.select_file "resources.ppt"

    new_section6 = add_attach.continue

    confirm = new_section6.add

    lessons = confirm.finish
    
    new_module6 = lessons.add_module
    new_module6.title="Lesson6"
    
    confirm = new_module6.add
    
    new_section7 = confirm.add_content_sections
    
    new_section7.title="Lesson6-Section1"
    new_section7.check_auditory_content
    
    new_section7.content_type="Upload or link to a file in Resources"
     
    add_attach = new_section7.select_or_upload_file
    add_attach.select_file "resources.mp3"
    
    new_section7 = add_attach.continue
    
    confirm = new_section7.add
    
    lessons =confirm.finish
    
    #TEST CASE: Confirm all lessons and sections are listed properly
    assert frm.link(:text, "Lesson1-Section1").exist?
    assert frm.link(:text, "Lesson1-Section2").exist?
    assert frm.link(:text, "Lesson2 (Expired)").exist?
    assert frm.link(:text, "Lesson2 - Section1").exist?
    assert frm.link(:text, "Lesson3-Future").exist?
    assert frm.link(:text, "Lesson3-Section1").exist?
    assert frm.link(:text, "Lesson4").exist?
    assert frm.link(:text, "Lesson4-Section1").exist?
    assert frm.link(:text, "Lesson5").exist?
    assert frm.link(:text, "Lesson5-Section1").exist?
    assert frm.link(:text, "Lesson6").exist?
    assert frm.link(:text, "Lesson6-Section1").exist?
    
    @sakai.logout
   
    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    lessons = home.lessons
    
    # TEST CASE: Make sure Lessons appear, or not, for the student
    # as expected.
    assert frm.link(:text, "Lesson1").exist?
    assert_equal frm.link(:text, "Lesson2 (Expired)").exist?, false
    assert_equal frm.link(:text, "Lesson3-Future").exist?, false
    assert frm.link(:text, "Lesson4").exist?
    assert frm.link(:text, "Lesson5").exist?
    assert frm.link(:text, "Lesson6").exist?
    
    frm.link(:text, "Lesson1").click #FIXME
    
    # TEST CASE: Verify the sections are present, as expected
    assert frm.link(:text, "Lesson1-Section1").exist?
    assert frm.link(:text, "Lesson1-Section2").exist?
    
    frm.link(:text=>"Next").click #FIXME
    frm.link(:text=>"Next").click #FIXME
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify the section link is present
    assert frm.link(:text, "Lesson4-Section1")
    
    frm.link(:text=>"Prev").click #FIXME
    
    # TEST CASE: Verify the iframe for the rsmart page is present
    assert frm.frame(:id=>"iframe1").exist? #FIXME
    
    frm.link(:text=>"Table Of Contents").click #FIXME
    frm.link(:text=>"Lesson5").click #FIXME
    
    # TEST CASE: Verify the section link is available
    assert frm.link(:text=>"Lesson5-Section1").exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify file link is present
    assert frm.span(:id=>"viewsectionStudentform:contentResourceLinkName").exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    #TEST CASE: Verify section link is present
    assert frm.link(:text=>"Lesson6-Section1").exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify file link is present
    assert frm.span(:id=>"viewsectionStudentform:contentResourceLinkName").exist?
  
    lessons = Lessons.new(@browser)
    
    prefs = lessons.preferences
    prefs.select_collapsed
    prefs.set
    
    lessons = prefs.view
    
    # TEST CASE: Verify collapsed view
    assert frm.link(:text=>"Lesson1").exist?
    assert_equal frm.link(:text=>"Lesson1-Section1").exist?, false
    assert_equal frm.span(:id=>"listmodulesStudentform:table:1:titleTxt2").text, "Lesson2 (Expired)" #FIXME
    
    @sakai.logout
    
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    lessons = home.lessons
    
    module_5 = lessons.open_lesson "Lesson5"
    
    section_2 = module_5.add_content_sections
    section_2.title="Lesson5-Section2"
    section_2.content_type="Upload or link to a file in Resources"
    
    attach = section_2.select_or_upload_file
    attach.select_file "resources.JPG"
    
    section_2 = attach.continue
    
    confirm = section_2.add
    
    lessons = confirm.finish
    
    listview = lessons.view
    
    sectionview = listview.open_section "Lesson5-Section2"
    
    # TEST CASE: Verify the uploaded file appears
    assert frm.link(:text, "resources.JPG").exist?
    
    manage = sectionview.manage
    
    sort = manage.sort
    
    sort.sort_sections
    sort.sort_modules
    sort.view
    
    @sakai.logout
    
  end
  
end
