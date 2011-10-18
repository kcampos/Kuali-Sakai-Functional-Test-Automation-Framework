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
    # Using instructor2 for this test case
    @instructor =@config.directory['person4']['id']
    @ipassword = @config.directory['person4']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_lesson_creation
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
  
    # Go to test site
    home = workspace.open_site_by_id(@site_id)
    
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
    new_section.add_content="<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
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
    new_section4.add_content="<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    
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
    new_section5.add_content="<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    
    confirm = new_section5.add
    
    lessons = confirm.finish
    
    # Add another lesson
    new_module5 = lessons.add_module
    new_module5.title="Lesson5"
    
    confirm = new_module5.add
    
    new_section6 = confirm.add_content_sections
    
    new_section6.title="Lesson5-Section1"
    new_section6.content_type="Upload or link to a file in Resources"
    new_section6.select_or_upload_file

    @selenium.click "link=Select"
     
    @selenium.click "attachButton"
     
    @selenium.click "AddSectionForm:addImg2"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    @selenium.click "listauthmodulesform:authtop:addAction"
     
    @selenium.type "AddModuleForm:title", "Lesson6"
    @selenium.click "AddModuleForm:addImg"
     
    @selenium.click "AddModuleConfirmForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson6-Section1"
    @selenium.click "AddSectionForm:contentaudio"
    @selenium.select "AddSectionForm:contentType", "label=Upload or link to a file in Resources"
     
    @selenium.click "link=Select"
     
    @selenium.click "//h4[@title='resources.mp3']/../../td/div/a[@title='Select']"
     
    @selenium.click "attachButton"
     
    @selenium.click "AddSectionForm:addImg2"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    begin
        assert @selenium.is_element_present("link=Lesson1-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson1-Section2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson2 (Expired)")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson2 - Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson3-Future")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson3-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson5")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson5-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson6")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson6-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
     
    @selenium.type "eid", "student04"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
     
    @selenium.click "//a[contains(@title,'1 2 3 ')]"
     
    @selenium.click "//a[@class='icon-sakai-melete']"
     
    begin
        assert @selenium.is_element_present("link=Lesson1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson2 (Expired)")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson3-Future")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson5")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson6")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Lesson1"
     
    begin
        assert @selenium.is_element_present("link=Lesson1-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson1-Section2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
     
    @selenium.click "link=Next"
     
    @selenium.click "link=Next"
     
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Prev"
     
    begin
        assert @selenium.is_element_present("//img[@alt='rSmart']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Table Of Contents"
     
    @selenium.click "link=Lesson5"
     
    begin
        assert @selenium.is_element_present("link=Lesson5-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
     
    begin
        assert @selenium.is_element_present("//a[@id='viewsectionStudentform:contentResourceLink']/span")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
     
    begin
        assert @selenium.is_element_present("link=Lesson6-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
     
    begin
        assert @selenium.is_element_present("//a[@id='viewsectionStudentform:contentResourceLink']/span")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Preferences"
     
    @selenium.click "//input[@name='UserPreferenceForm:_id5' and @value='true']"
    @selenium.click "//img[@id='UserPreferenceForm:setImg']"
     
    @selenium.click "link=View"
     
    begin
        assert @selenium.is_element_present("link=Lesson1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson1-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson1-Section2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson2-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson2 (Expired)')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=Lesson3-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson5")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson5-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson6")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson6-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
     
    @selenium.type "eid", "instructor2"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
     
    @selenium.click "//a[contains(@title,'1 2 3 ')]"
     
    @selenium.click "//a[@class='icon-sakai-melete']"
     
    @selenium.click "link=Lesson5"
     
    @selenium.click "EditModuleForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson5-Section2"
    @selenium.select "AddSectionForm:contentType", "label=Upload or link to a file in Resources"
     
    @selenium.click "AddSectionForm:ResourceHelperLinkView:serverViewButton"
     
    @selenium.click "//h4[@title='resources.jpg']/../../td/div/a[@title='Select']"
     
    @selenium.click "attachButton"
     
    @selenium.click "AddSectionForm:addImg2"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    @selenium.click "listauthmodulesform:top:viewItem"
     
    @selenium.click "listmodulesform:table:4:tablesec:1:sectitleLink"
     
    begin
        assert @selenium.is_element_present("link=resources.JPG")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "viewsectionform:top:manageItem"
     
    @selenium.click "ManageModuleForm:sort"
     
    @selenium.click "SortModuleForm:sortSectionsImg"
     
    @selenium.click "SortSectionForm:sortModulesImg"
     
    @selenium.click "SortModuleForm:top:viewItem"
     
    @selenium.select_frame "relative=up"
    @selenium.click "link=Logout"
     
    
  end
  
end
