# 
# == Synopsis
#
# Tests importing a zip file of lesson materials.
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestImportLesson < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person4']['id']
    @ipassword = @config.directory['person4']['password']
    @student = @config.directory["person6"]["id"]
    @spassword = @config.directory["person6"]["password"]
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    @zip_file = "zips/Melete1.zip"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_import_lesson
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to Lessons
    lessons = home.lessons
    
    # Go to the Manage page
    manage = lessons.manage
    
    # Go to the import/export page
    import = manage.import_export
    
    # File Attach
    import.upload_IMS @zip_file
    
    
    @selenium.type "impfile", "/Users/corey/TestNG/trunk/tests/TestingData/Melete1.zip"
    @selenium.click "importexportform:importModuleImg"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "importexportform:top:viewItem"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Getting Started")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Tests FAQs")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "eid", "student04"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@title,'1 2 3')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[@class='icon-sakai-melete']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Getting Started")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Tests and Quizzes")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Getting Started"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=The Gateway")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Sites Link")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Getting Started FAQs")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//span[@id='viewmoduleStudentform:bottommod:nextItemMsg1']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=exact:http://sakaiproject.org")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Table Of Contents"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Logout"
    @selenium.wait_for_page_to_load "30000"
    
  end
  
end
