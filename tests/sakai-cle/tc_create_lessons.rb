# 
# == Synopsis
#
# Testing Creating and Editing Lessons in a Site.
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
    @sakai.login(@instructor, @ipassword)
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Go to test site
    @selenium.click "//a[contains(@title,'1 2 3 ')]"
    # Go to lessons
    @selenium.click "//a[@class='icon-sakai-melete']"
    # Add a module
    @selenium.click "//a[@id='listauthmodulesform:authtop:addAction']"
    # Enter module attributes
    @selenium.type "AddModuleForm:title", "Lesson1"
    @selenium.type "AddModuleForm:description", "Lesson1"
    @selenium.click "AddModuleForm:addImg"
    # Add a section
    @selenium.click "AddModuleConfirmForm:sectionsImg"
    # Enter section info
    @selenium.type "AddSectionForm:title", "Lesson1-Section1"
    @selenium.select "AddSectionForm:contentType", "label=Compose content with editor"
     
    @selenium.click "//td[@class='TB_Button_Text']"
    
    @selenium.type "//textarea[@class='SourceField']", "<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "AddSectionForm:addImg"
    # Save section and add another... 
    @selenium.click "AddSectionConfirmForm:saveAddAnotherImg"
     
    @selenium.type "AddSectionForm:title", "Lesson1-Section2"
    @selenium.select "AddSectionForm:contentType", "label=Link to new or existing URL resource on server"
     
    @selenium.click "AddSectionForm:ContentLinkView:serverViewButton"
     
    @selenium.type "//input[@id='ServerViewForm:link']", "http://www.rsmart.com"
    @selenium.type "//input[@id='ServerViewForm:link_title']", "rsmart"
    @selenium.click "ServerViewForm:addImg2"
     
    @selenium.click "AddSectionForm:addImg2"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
    # Add another Lesson...
    @selenium.click "listauthmodulesform:authtop:addAction"
     
    @selenium.type "AddModuleForm:title", "Lesson2 (Expired)"
    @selenium.type "AddModuleForm:startDate", "July 6, 2008 08:00 AM"
    @selenium.type "AddModuleForm:endDate", "July 15, 2008 08:00 AM"
    @selenium.click "AddModuleForm:addImg"
     
    @selenium.click "AddModuleConfirmForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson2 - Section1"
    @selenium.select "AddSectionForm:contentType", "label=Link to new or existing URL resource on server"
     
    @selenium.click "AddSectionForm:ContentLinkView:serverViewButton"
     
    @selenium.type "//input[@id='ServerViewForm:link']", "http://sakaiproject.org"
    @selenium.type "//input[@id='ServerViewForm:link_title']", "sakai"
    @selenium.click "ServerViewForm:addImg2"
     
    @selenium.click "AddSectionForm:addImg2"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    @selenium.click "listauthmodulesform:authtop:addAction"
     
    @selenium.type "AddModuleForm:title", "Lesson3-Future"
    @selenium.type "AddModuleForm:startDate", "July 15, 2011 08:00 AM"
    @selenium.click "AddModuleForm:addImg"
     
    @selenium.click "AddModuleConfirmForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson3-Section1"
    @selenium.select "AddSectionForm:contentType", "label=Compose content with editor"
     
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "AddSectionForm:addImg"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    @selenium.click "listauthmodulesform:authtop:addAction"
     
    @selenium.type "AddModuleForm:title", "Lesson4"
    @selenium.click "AddModuleForm:addImg"
     
    @selenium.click "AddModuleConfirmForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson4-Section1"
    @selenium.select "AddSectionForm:contentType", "label=Compose content with editor"
     
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "AddSectionForm:addImg"
     
    @selenium.click "AddSectionConfirmForm:finishImg"
     
    @selenium.click "listauthmodulesform:authtop:addAction"
     
    @selenium.type "AddModuleForm:title", "Lesson5"
    @selenium.click "AddModuleForm:addImg"
     
    @selenium.click "AddModuleConfirmForm:sectionsImg"
     
    @selenium.type "AddSectionForm:title", "Lesson5-Section1"
    @selenium.select "AddSectionForm:contentType", "label=Upload or link to a file in Resources"
     
    @selenium.click "AddSectionForm:ResourceHelperLinkView:serverViewButton"
     
    begin
        assert @selenium.is_element_present("//h3[contains(@title,'1 2 3')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
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
