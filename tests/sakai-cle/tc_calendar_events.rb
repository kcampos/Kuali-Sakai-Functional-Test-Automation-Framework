# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCalendarEvents < Test::Unit::TestCase
  
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
  
  def test_calendar_events
    
    # Log in to Sakai
    workspace = @sakai.login(@student1, @spassword)
    
    calendar = home.workspace
    
    
    
    @selenium.type "eid", "student02"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    # 
    @selenium.click "//a[@class='icon-sakai-schedule']"
    # 
    @selenium.click "eventSubmit_doNext"
    # 
    @selenium.click "//a[contains(@title,'Due Assignment')]"
    # 
    begin
        assert @selenium.is_element_present("//th[contains(text(),'Site')]/../td[contains(text(),'1 2 3')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Back to Calendar']"
    # 
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
    # 
    begin
        assert @selenium.is_element_present("//div/h3[contains(text(),'Calendar by Day')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[contains(@onclick,'doNew')]"
    # 
    @selenium.type "//input[@id='activitytitle']", "Test1"
    @selenium.select "//select[@id='startHour']", @selenium.get_eval("addhour()")
    @selenium.select "//select[@id='startAmpm']", @selenium.get_eval("ampmAH()")
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Donec nec felis nec enim porttitor euismod? Proin feugiat elit sit amet arcu. Quisque porttitor."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.type "//textarea[@id='location']", "Test location."
    @selenium.click "//input[@accesskey='s']"
    # 
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='< Previous Day']"
    # 
    begin
        assert !@selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Next Day >']"
    # 
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Week"
    # 
    begin
        assert @selenium.is_element_present("//div/h3[contains(text(),'Calendar by Week')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='< Previous Week']"
    # 
    begin
        assert !@selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Next Week >']"
    # 
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.select "//select[@id='view']", "label=Calendar by Month"
    # 
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
    # 
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
    # 
    @selenium.select "timeFilterOption", "label=All events"
    # 
    @selenium.click "link=Test1"
    # 
    begin
        assert @selenium.is_element_present("//td[contains(text(),'Donec nec felis nec enim porttitor euismod? Proin feugiat elit sit amet arcu. Quisque porttitor.')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@accesskey='e']"
    # 
    @selenium.click "//input[@value='Add Attachments']"
    # 
    @selenium.click "link=Show other sites"
    # 
    @selenium.click "//a[contains(normalize-space(.),'1 2 3') and contains(normalize-space(.),'Resources')]"
    # 
    @selenium.click "link=Attach a copy"
    # 
    @selenium.click "//input[@value='Continue']"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Add/remove attachments']"
    # 
    @selenium.click "//a[contains(@href,'doRemoveitem')]"
    # 
    @selenium.click "//input[@value='Continue']"
    # 
    begin
        assert !@selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@value='Add Attachments']"
    # 
    @selenium.type "//input[@id='url']", "http://www.rsmart.com"
    # 
    @selenium.click "//input[@value='Continue']"
    # 
    @selenium.click "//input[@value='Frequency ']"
    # 
    @selenium.select "//select[@id='frequencySelect']", "label=daily"
    # 
    @selenium.select "//select[@id='interval']", "label=10"
    @selenium.click "//input[@accesskey='s']"
    # 
    @selenium.click "//input[@value='Save Event']"
    # 
    @selenium.click "//input[@name='eventSubmit_doToday']"
    # 
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
    # 
    @selenium.click "//a[contains(@onclick,'doNpagew')]"
    # 
    @selenium.click "//a[contains(@onclick,'doCustomize')]"
    # 
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
    # 
    begin
        assert @selenium.is_element_present("addedFields1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@name='eventSubmit_doUpdate']"
    # 
    @selenium.select "//select[@id='view']", "label=List of Events"
    # 
    @selenium.click "link=Test1"
    # 
    @selenium.click "//input[@accesskey='e']"
    # 
    @selenium.type "//textarea[@name='Test Field']", "Ho, ho, ho"
    @selenium.click "//input[@value='Save Event']"
    # 
    @selenium.click "link=Test1"
    # 
    begin
        assert @selenium.is_element_present("//td[contains(text(),'Ho, ho, ho')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[contains(@onclick,'doCustomize')]"
    # 
    @selenium.click "addedFields1"
    @selenium.click "eventSubmit_doUpdate"
    # 
    begin
        assert @selenium.is_element_present("//div[@class='alertMessage']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "eventSubmit_doUpdate"
    # 
    begin
        assert !@selenium.is_element_present("//td[contains(text(),'Ho, ho, ho')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-motd']"
    # 
    begin
        assert @selenium.is_element_present("link=Test1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    # 
    @selenium.type "eid", "instructor2"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    # 
    @selenium.click "//a[contains(@title,'1 2 3')]"
    # 
    @selenium.click "//a[@class='icon-sakai-schedule']"
    # 
    @selenium.select "//select[@id='view']", "label=Calendar by Month"
    # 
    @selenium.click "link=Set as Default View"
    # 
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
    # 
    @selenium.type "eid", "student02"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    # 
    @selenium.click "//a[contains(@title,'1 2 3')]"
    # 
    @selenium.click "//a[@class='icon-sakai-schedule']"
    # 
    begin
        assert @selenium.is_element_present("//input[@value='< Previous Month']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    # 
    
  end
  
end