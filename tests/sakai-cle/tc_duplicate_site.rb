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

class TestDuplicateSite < Test::Unit::TestCase
  
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
  
  def test_duplicate_site
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    
    @selenium.click "//a[@class='icon-sakai-siteinfo']"
    # 
    @selenium.click "link=Duplicate Site"
    # 
    @selenium.type "title", "4 5 6"
    @selenium.click "duplicateSite"
    # 
    @selenium.click "//a[contains(@title,'4 5 6')]"
    # 
    @selenium.click "//a[@class='icon-sakai-announcements']"
    # 
    begin
        assert @selenium.is_element_present("link=exact:Assignment: Open Date for Assignment 3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-schedule']"
    # 
    @selenium.select "view", "label=List of Events"
    # 
    @selenium.select "timeFilterOption", "label=All events"
    # 
    begin
        assert @selenium.is_element_present("link=Spring Formal")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-jforum-tool']"
    # 
    begin
        assert @selenium.is_element_present("link=New Possibilities")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-forums']"
    # 
    begin
        assert @selenium.is_element_present("link=Forum 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Topic 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Forum 2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Topic For Group 2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Topic For Group 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-chat']"
    # 
    @selenium.click "link=Change Room"
    # 
    assert !60.times{ break if (@selenium.is_element_present("link=New chat room") rescue false); sleep 1 }
    @selenium.click "//a[@class='icon-sakai-poll']"
    # 
    assert !60.times{ break if (@selenium.is_element_present("link=exact:Is this the best class ever?") rescue false); sleep 1 }
    @selenium.click "//a[@class='icon-sakai-syllabus']"
    # 
    @selenium.click "link=Create/Edit"
    # 
    @selenium.click "link=Redirect"
    # 
    begin
        assert_equal "http://www.rsmart.com", @selenium.get_value("_id2:urlValue")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-melete']"
    # 
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
        assert @selenium.is_element_present("//span[contains(text(),'Lesson1-Section1')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson1-Section2')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson4-Section1')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson5')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson4-Section1')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Lesson1-Section2')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
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
    @selenium.click "listauthmodulesform:top:viewItem"
    # 
    @selenium.click "link=Lesson1"
    # 
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
    # 
    @selenium.click "link=Next"
    # 
    @selenium.click "link=Next"
    # 
    begin
        assert @selenium.is_element_present("link=Lesson4-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Prev"
    # 
    begin
        assert @selenium.is_element_present("//a[contains(text(),'Client Login')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Table Of Contents"
    # 
    @selenium.click "link=Lesson5"
    # 
    begin
        assert @selenium.is_element_present("link=Lesson5-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
    # 
    begin
        assert @selenium.is_element_present("link=resources.jpg")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
    # 
    begin
        assert @selenium.is_element_present("link=Lesson6-Section1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Next"
    # 
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-resources']"
    # 
    begin
        assert @selenium.is_element_present("link=resources.doc")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.jpg")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.txt")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.mp3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=resources.xls")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-assignment-grades']"
    # 
    begin
        assert @selenium.is_element_present("link=Draft - Assignment 2")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Draft - Assignment 4")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Draft - Assignment 1")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Draft - Assignment 3")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=Draft - Assignment 5")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-samigo']"
    # 
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Test 1')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Test 2')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-gradebook-tool']"
    # 
    # CLE-4008
    @selenium.click "link=All Grades"
    # 
    begin
        assert @selenium.is_element_present("link=Student Name")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-podcasts']"
    # 
    # Create Podcasts in 1 2 3
    @selenium.click "//a[@class='icon-sakai-rwiki']"
    # 
    # Create Wiki settings in 1 2 3
    begin
        assert @selenium.is_element_present("//span[contains(text(),'rSmart.com')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//span[contains(text(),'Sakaiproject.org')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    # 
    @selenium.click "link=Logout"
    # 
    
  end
  
end
