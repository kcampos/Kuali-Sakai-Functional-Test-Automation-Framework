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

class }}ClassName{{ < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @student1 = @config.directory['person2']['id']
    @spassword = @config.directory['person2']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_))casename((
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Log in to Sakai
    workspace = @sakai.login(@student1, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    calendar = home.calendar
    
    
    
    @selenium.type "eid", "student02"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[@class='icon-sakai-schedule']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "eventSubmit_doNext"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@title,'Due Assignment')]"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//th[contains(text(),'Site')]/../td[contains(text(),'1 2 3')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Back to Calendar']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//div/h3[contains(text(),'Calendar by Week')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//img[@alt='Help']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Day"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//div/h3[contains(text(),'Calendar by Day')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[contains(@onclick,'doNew')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "//input[@id='activitytitle']", "Test1"
    @selenium.select "//select[@id='startHour']", @selenium.get_eval("addhour()")
    @selenium.select "//select[@id='startAmpm']", @selenium.get_eval("ampmAH()")
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Donec nec felis nec enim porttitor euismod? Proin feugiat elit sit amet arcu. Quisque porttitor."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.type "//textarea[@id='location']", "Test location."
    @selenium.click "//input[@accesskey='s']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='< Previous Day']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert !@selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Next Day >']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Week"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//div/h3[contains(text(),'Calendar by Week')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='< Previous Week']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert !@selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Next Week >']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Month"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//input[@value='< Previous Month']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//input[@value='Next Month >']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Year"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//input[@value='< Previous Year']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//input[@value='Next Year >']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=List of Events"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "timeFilterOption", "label=All events"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Test1"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//td[contains(text(),'Donec nec felis nec enim porttitor euismod? Proin feugiat elit sit amet arcu. Quisque porttitor.')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@accesskey='e']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Add Attachments']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Show other sites"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(normalize-space(.),'1 2 3') and contains(normalize-space(.),'Resources')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Attach a copy"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Continue']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Add/remove attachments']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@href,'doRemoveitem')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Continue']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert !@selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Add Attachments']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "//input[@id='url']", "http://www.rsmart.com"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Continue']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Frequency ']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "//select[@id='frequencySelect']", "label=daily"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "//select[@id='interval']", "label=10"
    @selenium.click "//input[@accesskey='s']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@value='Save Event']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@name='eventSubmit_doToday']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Printable Version")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//img[@alt='Reset']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@onclick,'doNpagew')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@onclick,'doCustomize')]"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//input[@name='eventSubmit_doAddfield']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("eventSubmit_doUpdate")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.type "textfield", "Test Field"
    @selenium.click "//input[@name='eventSubmit_doAddfield']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("addedFields1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@name='eventSubmit_doUpdate']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "//select[@id='view']", "label=List of Events"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Test1"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//input[@accesskey='e']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "//textarea[@name='Test Field']", "Ho, ho, ho"
    @selenium.click "//input[@value='Save Event']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Test1"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//td[contains(text(),'Ho, ho, ho')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[contains(@onclick,'doCustomize')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "addedFields1"
    @selenium.click "eventSubmit_doUpdate"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//div[@class='alertMessage']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "eventSubmit_doUpdate"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert !@selenium.is_element_present("//td[contains(text(),'Ho, ho, ho')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-motd']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "eid", "instructor2"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@title,'1 2 3')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[@class='icon-sakai-schedule']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.select "//select[@id='view']", "label=Calendar by Month"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "link=Set as Default View"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//div[contains(text(),'Alert:  This is now the default view')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//input[@value='< Previous Month']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    @selenium.wait_for_page_to_load "30000"
    @selenium.type "eid", "student02"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[contains(@title,'1 2 3')]"
    @selenium.wait_for_page_to_load "30000"
    @selenium.click "//a[@class='icon-sakai-schedule']"
    @selenium.wait_for_page_to_load "30000"
    begin
        assert @selenium.is_element_present("//input[@value='< Previous Month']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    @selenium.wait_for_page_to_load "30000"
    
  end
  
end
