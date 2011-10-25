# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestSISTemplates < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @admin = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_sis_templates
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>$frame_index)
    end
    
    # Log in to Sakai
    workspace = @sakai.login(@admin, @password)
    # Go to Site Setup
    site_setup = workspace.site_setup
    
    # Click New
    site_type = site_setup.new
    
    # Get the academic term value...
    site_type.select_course_site
    term = site_type.academic_term_element.text
    
    site_type.select_template_site
    site_type.select_template=/Template/
    site_type.select_term=term
    
    section_info = site_type.continue
    
    section_info.subject="TST"
    section_info.course="101"
    section_info.section="100"
    section_info.authorizers_username="admin"
    
    site_setup = section_info.done
    
    sites = site_setup.sites
    
    sites.search_field="tst"
    sites.search_button
    
    tst_101 = sites.click_top_item
    
    sleep 20
    
    @selenium.click "link=Save As"
    # 
    @selenium.type "id", "template.course"
    @selenium.click "eventSubmit_doSaveas"
    # 
    @selenium.type "search", "tst"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    @selenium.click "//a[@href='" + site1 + "']"
    # 
    @selenium.click "link=Remove Site"
    # 
    @selenium.click "eventSubmit_doRemove_confirmed"
    # 
    # #####################################
    @selenium.click "link=Site Setup"
    # 
    @selenium.click "link=New"
    # 
    @selenium.click "selectTerm"
    @selenium.select "selectTerm", "label=Templates"
    @selenium.click "eventSubmit_doSite_type"
    # 
    @selenium.type "id-Subject:1", "TST2"
    @selenium.type "id-Course:1", "201"
    @selenium.type "id-Section:1", "100"
    @selenium.click "addButton"
    # 
    @selenium.click "continueButton"
    # 
    @selenium.click "sakai.announcements"
    @selenium.click "sakai.assignment.grades"
    @selenium.click "sakai.schedule"
    @selenium.click "sakai.mailbox"
    @selenium.click "sakai.forums"
    @selenium.click "sakai.gradebook.tool"
    @selenium.click "sakai.melete"
    @selenium.click "rsmart.virtual_classroom.tool"
    @selenium.click "sakai.messages"
    @selenium.click "sakai.news"
    @selenium.click "sakai.podcasts"
    @selenium.click "sakai.resources"
    @selenium.click "sakai.syllabus"
    @selenium.click "sakai.samigo"
    @selenium.click "sakai.iframe"
    @selenium.click "Continue"
    # 
    @selenium.type "emailId", "tst200"
    @selenium.type "//input[@value='http://']", "http://www.rsmart.com"
    @selenium.click "Continue"
    # 
    @selenium.click "publishunpublish"
    @selenium.click "eventSubmit_doUpdate_site_access"
    # 
    @selenium.click "addSite"
    # 
    @selenium.click "link=Sites"
    # 
    @selenium.type "search", "tst2"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    site1 = @selenium.get_eval("this.page().findElement(\"//td/a\")")
    @selenium.type "search_user", site1
    @selenium.click "//td[@headers='Id']/a"
    # 
    @selenium.click "link=Save As"
    # 
    @selenium.type "id", "template.online"
    @selenium.click "eventSubmit_doSaveas"
    # 
    @selenium.type "search", "tst2"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    @selenium.click "//a[@href='" + site1 + "']"
    # 
    @selenium.click "link=Remove Site"
    # 
    @selenium.click "eventSubmit_doRemove_confirmed"
    # 
    # #####################################
    @selenium.click "link=Site Setup"
    # 
    @selenium.click "link=New"
    # 
    @selenium.click "selectTerm"
    @selenium.select "selectTerm", "label=Templates"
    @selenium.click "eventSubmit_doSite_type"
    # 
    @selenium.type "id-Subject:1", "TST3"
    @selenium.type "id-Course:1", "301"
    @selenium.type "id-Section:1", "100"
    @selenium.click "addButton"
    # 
    @selenium.click "continueButton"
    # 
    @selenium.click "sakai.announcements"
    @selenium.click "blogger"
    @selenium.click "sakai.chat"
    @selenium.click "sakai.forums"
    @selenium.click "sakai.melete"
    @selenium.click "rsmart.virtual_classroom.tool"
    @selenium.click "sakai.mailtool"
    @selenium.click "sakai.podcasts"
    @selenium.click "sakai.news"
    @selenium.click "sakai.syllabus"
    @selenium.click "sakai.iframe"
    @selenium.click "sakai.rwiki"
    @selenium.click "Continue"
    # 
    @selenium.type "//input[@value='http://']", "http://www.rsmart.com"
    @selenium.click "Continue"
    # 
    @selenium.click "publishunpublish"
    @selenium.click "eventSubmit_doUpdate_site_access"
    # 
    @selenium.click "addSite"
    # 
    @selenium.click "link=Sites"
    # 
    @selenium.type "search", "tst3"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    site1 = @selenium.get_eval("this.page().findElement(\"//td/a\")")
    @selenium.type "search_user", site1
    @selenium.click "//td[@headers='Id']/a"
    # 
    @selenium.click "link=Save As"
    # 
    @selenium.type "id", "template.webenhanced"
    @selenium.click "eventSubmit_doSaveas"
    # 
    @selenium.type "search", "tst3"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    @selenium.click "//a[@href='" + site1 + "']"
    # 
    @selenium.click "link=Remove Site"
    # 
    @selenium.click "eventSubmit_doRemove_confirmed"
    # 
    # #####################################
    @selenium.click "link=Site Setup"
    # 
    @selenium.click "link=New"
    # 
    @selenium.click "selectTerm"
    @selenium.select "selectTerm", "label=Templates"
    @selenium.click "eventSubmit_doSite_type"
    # 
    @selenium.type "id-Subject:1", "TST4"
    @selenium.type "id-Course:1", "401"
    @selenium.type "id-Section:1", "100"
    @selenium.click "addButton"
    # 
    @selenium.click "continueButton"
    # 
    @selenium.click "all"
    @selenium.click "Continue"
    # 
    @selenium.type "emailId", "tst400"
    @selenium.type "//input[@value='http://']", "http://www.rsmart.com"
    @selenium.click "Continue"
    # 
    @selenium.click "publishunpublish"
    @selenium.click "eventSubmit_doUpdate_site_access"
    # 
    @selenium.click "addSite"
    # 
    @selenium.click "link=Sites"
    # 
    @selenium.type "search", "tst4"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    site1 = @selenium.get_eval("this.page().findElement(\"//td/a\")")
    @selenium.type "search_user", site1
    @selenium.click "//td[@headers='Id']/a"
    # 
    @selenium.click "link=Save As"
    # 
    @selenium.type "id", "1234-asdf-5678-qwer-789"
    @selenium.click "eventSubmit_doSaveas"
    # 
    @selenium.type "search", "tst4"
    @selenium.click "//a[contains(text(),'Search')]"
    # 
    @selenium.click "//a[@href='" + site1 + "']"
    # 
    @selenium.click "link=Remove Site"
    # 
    @selenium.click "eventSubmit_doRemove_confirmed"
    # 
    # #####################################
    @selenium.click "link=Home"
    # 
    @selenium.click "//a[@title='TST 101 100 TMP']"
    # 
    @selenium.click "link=Resources"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.doc"
    @selenium.click "//input[@value='Upload Files Now']"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.ppt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_1", "P:\\cjmcgarrahan\\TestingData\\resources.txt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_2", "P:\\cjmcgarrahan\\TestingData\\resources.xls"
    @selenium.click "link=Add Another File"
    @selenium.type "content_3", "P:\\cjmcgarrahan\\TestingData\\resources.mp3"
    @selenium.click "propsTrigger_2"
    @selenium.type "description_2", "This is an Excel File."
    @selenium.click "saveChanges"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.txt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.ppt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-jforum-tool']"
    # 
    @selenium.click "adminpanel"
    # 
    @selenium.click "forums"
    # 
    @selenium.click "btn_insert"
    # 
    @selenium.type "forum_name", "Gathering Place"
    @selenium.type "description", "A place to become 'one' with each other."
    @selenium.click "submit"
    # 
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Gathering Place')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-syllabus']"
    # 
    @selenium.click "link=Create/Edit"
    # 
    @selenium.click "link=Redirect"
    # 
    @selenium.type "//input[@type='text']", "http://www.rsmart.com"
    @selenium.click "//input[@accesskey='s']"
    # 
    begin
        assert @selenium.is_element_present("logo")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-melete']"
    # 
    @selenium.click "//a[@id='listauthmodulesform:authtop:addAction']"
    # 
    @selenium.type "AddModuleForm:title", "Melete 1"
    @selenium.type "AddModuleForm:description", "Melete Test Module"
    @selenium.click "AddModuleForm:addImg"
    # 
    @selenium.click "AddModuleConfirmForm:sectionsImg"
    # 
    @selenium.type "AddSectionForm:title", "Melete1-Section1"
    @selenium.select "AddSectionForm:contentType", "label=Compose content with editor"
    # 
    @selenium.type "//textarea[@id=\"AddSectionForm:otherMeletecontentEditor_inputRichText\"]", "Aliquet vitae, sollicitudin et, pretium a, dolor? Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. Duis sit amet lorem. Maecenas nec dolor. Vivamus lacus. Vivamus ante. Duis vitae quam."
    @selenium.click "AddSectionForm:addImg"
    # 
    @selenium.click "AddSectionConfirmForm:finishImg"
    # 
    begin
        assert_equal "Melete 1", @selenium.get_text("link=Melete 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert_equal "Melete1-Section1", @selenium.get_text("link=Melete1-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-assignment-grades']"
    # 
    @selenium.click "//a[contains(@href,'doNew_assignment')]"
    # 
    @selenium.type "//input[@id=\"new_assignment_title\"]", "Assignment 1"
    @selenium.click "//input[@accesskey=\"s\"]"
    # 
    @selenium.click "//input[@accesskey=\"s\"]"
    # 
    begin
        assert @selenium.is_element_present("link=Assignment 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-samigo']"
    # 
    @selenium.type "authorIndexForm:title", "Samigo Test"
    @selenium.click "//input[@accesskey='c']"
    # 
    @selenium.select "assesssmentForm:changeQType", "label=Multiple Choice"
    # 
    @selenium.type "itemForm:answerptr", "5"
    @selenium.type "//*[@class='simple_text_area']", "Who was the first US president?"
    @selenium.type "//*[contains(@name,'mcchoices:0:_id')]", "Jefferson"
    @selenium.type "//*[contains(@name,'mcchoices:1:_id')]", "Lincoln"
    @selenium.type "//*[contains(@name,'mcchoices:2:_id')]", "Grant"
    @selenium.type "//*[contains(@name,'mcchoices:3:_id')]", "Washington"
    @selenium.click "//*[contains(@name,'mcchoices:3')]"
    @selenium.click "//input[contains(@value,'Save')]"
    # 
    begin
        assert_equal "Answer Key:", @selenium.get_text("//div[1]/label")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    # 
    @selenium.click "//a[@title='TST2 201 100 TMP']"
    # 
    @selenium.click "link=Resources"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.doc"
    @selenium.click "//input[@value='Upload Files Now']"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.ppt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_1", "P:\\cjmcgarrahan\\TestingData\\resources.txt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_2", "P:\\cjmcgarrahan\\TestingData\\resources.xls"
    @selenium.click "link=Add Another File"
    @selenium.type "content_3", "P:\\cjmcgarrahan\\TestingData\\resources.mp3"
    @selenium.click "propsTrigger_2"
    @selenium.type "description_2", "This is an Excel File."
    @selenium.click "saveChanges"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.txt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.ppt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-forums']"
    # 
    @selenium.click "link=New Forum"
    # 
    @selenium.type "//input[@id=\"revise:forum_title\"]", "Test Forum"
    @selenium.type "//textarea[@id=\"revise:forum_shortDescription\"]", "Test Forum"
    @selenium.type "//textarea[contains(@id,'textarea')]", "Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    @selenium.click "//input[@value=\"Save Settings & Add Topic\"]"
    # 
    @selenium.type "//input[@id=\"revise:topic_title\"]", "Test Topic 1"
    @selenium.type "//textarea[@id=\"revise:topic_shortDescription\"]", "Test Topic"
    @selenium.type "//textarea[contains(@id,'textarea')]", "Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    @selenium.click "//input[@value=\"Add Attachment\"]"
    # 
    @selenium.click "link=Attach a copy"
    # 
    @selenium.click "attachButton"
    # 
    @selenium.click "//input[@value=\"Save Settings\"]"
    # 
    begin
        assert @selenium.is_element_present("link=Test Forum")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Test Topic 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-syllabus']"
    # 
    @selenium.click "link=Create/Edit"
    # 
    @selenium.click "link=Redirect"
    # 
    @selenium.type "//input[@type='text']", "http://www.rsmart.com"
    @selenium.click "//input[@accesskey='s']"
    # 
    begin
        assert @selenium.is_element_present("logo")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-news']"
    # 
    @selenium.click "link=Options"
    # 
    @selenium.type "address-of-channel", "http://us.lrd.yahoo.com/_ylt=Ak92jWNE9OTylc_ey104es5A4gEA;_ylu=X3oDMTE3YzQ3bTV2BHBvcwM0BHNlYwN5bl9wcm9tb3NfZnJlZV9odG1sBHNsawNpbWFnZQ--/SIG=1155jnqjm/**http%3A//rss.news.yahoo.com/rss/us"
    @selenium.type "title-of-channel", "Yahoo News"
    begin
        assert @selenium.is_element_present("//img[@alt='Yahoo! News']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "eventSubmit_doUpdate"
    # 
    @selenium.click "//a[@class='icon-sakai-iframe']"
    # 
    @selenium.click "link=Options"
    # 
    @selenium.type "title-of-page", "rSmart.com"
    @selenium.click "eventSubmit_doConfigure_update"
    # 
    begin
        assert @selenium.is_element_present("//span[contains(text(),'rSmart.com')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    # 
    @selenium.click "//a[@title='TST3 301 100 TMP']"
    # 
    @selenium.click "link=Resources"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.doc"
    @selenium.click "//input[@value='Upload Files Now']"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.ppt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_1", "P:\\cjmcgarrahan\\TestingData\\resources.txt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_2", "P:\\cjmcgarrahan\\TestingData\\resources.xls"
    @selenium.click "link=Add Another File"
    @selenium.type "content_3", "P:\\cjmcgarrahan\\TestingData\\resources.mp3"
    @selenium.click "propsTrigger_2"
    @selenium.type "description_2", "This is an Excel File."
    @selenium.click "saveChanges"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.txt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.ppt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-forums']"
    # 
    @selenium.click "link=New Forum"
    # 
    @selenium.type "//input[@id=\"revise:forum_title\"]", "Test Forum"
    @selenium.type "//textarea[@id=\"revise:forum_shortDescription\"]", "Test Forum"
    @selenium.type "//textarea[contains(@id,'textarea')]", "Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    @selenium.click "//input[@value=\"Save Settings & Add Topic\"]"
    # 
    @selenium.type "//input[@id=\"revise:topic_title\"]", "Test Topic 1"
    @selenium.type "//textarea[@id=\"revise:topic_shortDescription\"]", "Test Topic"
    @selenium.type "//textarea[contains(@id,'textarea')]", "Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo. Donec pellentesque leo in diam? Sed eget lacus sed orci rutrum porttitor. Phasellus id risus scelerisque mi consequat scelerisque. Nam at leo."
    @selenium.click "//input[@value=\"Save Settings\"]"
    # 
    begin
        assert @selenium.is_element_present("link=Test Forum")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Test Topic 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-syllabus']"
    # 
    @selenium.click "link=Create/Edit"
    # 
    @selenium.click "link=Redirect"
    # 
    @selenium.type "//input[@type='text']", "http://www.rsmart.com"
    @selenium.click "//input[@accesskey='s']"
    # 
    begin
        assert @selenium.is_element_present("logo")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-podcasts']"
    # 
    @selenium.click "link=Add"
    # 
    @selenium.type "podAdd:addDate", "01/01/2009 12:00 AM"
    @selenium.type "podAdd:podtitle", "Musi to my ears..."
    @selenium.type "podAdd:podfile.uploadId", "C:\\TestNG rSmart\\cle_test_suite\\tests\\TestingData\\resources.mp3"
    @selenium.type "podAdd:_id17", "MP3 file"
    @selenium.click "podAdd:_id19"
    # 
    begin
        assert @selenium.is_element_present("link=Download")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-rwiki']"
    # 
    @selenium.click "editLink"
    # 
    @selenium.click "content"
    @selenium.type "content", "h1 Welcome to the World of Wiki. Feel free to look around :)\n\nA wiki is a tool which allows people to create web pages individually or as a group, without needing any web skills.\n\nUsing the wiki tool, you can create and edit web pages within your worksite. If you wish, you can make all or some pages publicly viewable."
    @selenium.click "saveButton"
    # 
    begin
        assert @selenium.is_element_present("//h3[contains(text(),'Welcome to the World of Wiki. Feel free to look around')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-news']"
    # 
    @selenium.click "link=Options"
    # 
    @selenium.type "address-of-channel", "http://us.lrd.yahoo.com/_ylt=Ak92jWNE9OTylc_ey104es5A4gEA;_ylu=X3oDMTE3YzQ3bTV2BHBvcwM0BHNlYwN5bl9wcm9tb3NfZnJlZV9odG1sBHNsawNpbWFnZQ--/SIG=1155jnqjm/**http%3A//rss.news.yahoo.com/rss/us"
    @selenium.type "title-of-channel", "Yahoo News"
    @selenium.click "eventSubmit_doUpdate"
    # 
    begin
        assert @selenium.is_element_present("//img[@alt='Yahoo! News']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe']"
    # 
    @selenium.click "link=Options"
    # 
    @selenium.type "title-of-page", "rSmart.com"
    @selenium.click "eventSubmit_doConfigure_update"
    # 
    begin
        assert @selenium.is_element_present("//span[contains(text(),'rSmart.com')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    # 
    @selenium.click "//a[@title='TST4 401 100 TMP']"
    # 
    @selenium.click "link=Resources"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.doc"
    @selenium.click "//input[@value='Upload Files Now']"
    # 
    @selenium.click "//a[contains(text(),'Upload Files')]"
    # 
    @selenium.type "content_0", "P:\\cjmcgarrahan\\TestingData\\resources.ppt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_1", "P:\\cjmcgarrahan\\TestingData\\resources.txt"
    @selenium.click "link=Add Another File"
    @selenium.type "content_2", "P:\\cjmcgarrahan\\TestingData\\resources.xls"
    @selenium.click "link=Add Another File"
    @selenium.type "content_3", "P:\\cjmcgarrahan\\TestingData\\resources.mp3"
    @selenium.click "propsTrigger_2"
    @selenium.type "description_2", "This is an Excel File."
    @selenium.click "saveChanges"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.txt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.ppt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    # 
    @selenium.click "link=Administration Workspace"
    # 
    @selenium.click "link=Job Scheduler"
    # 
    @selenium.click "link=Jobs"
    # 
    @selenium.click "link=New_Job"
    # 
    @selenium.type "_id2:job_name", "SIS"
    @selenium.select "_id2:_id10", "label=SIS Synchronization"
    @selenium.click "_id2:_id14"
    # 
    @selenium.click "link=Triggers(0)"
    # 
    @selenium.click "link=Run Job Now"
    # 
    @selenium.click "_id2:_id10"
    # 
    @selenium.click "link=Home"
    # 
    @selenium.click "link=Logout"
    # 
    
  end
  
end
