# coding: UTF-8
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

class TestAnnouncements < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @instructor = config.directory['person3']['id']
    @ipassword = config.directory['person3']['password']
    @sakai = SakaiCLE.new(@browser)
    @site_name = config.directory["site1"]["name"]
    @site_id = config.directory["site1"]["id"]
    
    # Test Case Variables
    @announcement_1_title = random_string(64)
    @announcement_1_body = "<h3 style=\"color: Red;\">Integer commodo nibh ut dui elementum ut tempor ligula adipiscing.</h3> Mauris sollicitudin nulla at lectus dapibus elementum. Etiam lectus nibh, imperdiet molestie convallis id, convallis vel nisl. Suspendisse potenti. In ullamcorper commodo risus quis commodo. <br /> <br /> Morbi consequat, dolor accumsan tincidunt pellentesque; massa urna ultrices lacus, sed viverra velit odio luctus turpis? <span style=\"background-color: Yellow;\">Nunc eget leo ut orci convallis molestie eget sed arcu?</span> In mi sem, varius eu congue id, volutpat eu orci! Maecenas mattis vestibulum nunc vel posuere. <br /> <ul>     <li>Cras a urna neque.</li>     <li>Donec consequat interdum dolor, quis tempus dolor ornare id?</li>     <li>Aenean nibh metus, tempus et volutpat at, rhoncus nec sapien.</li>     <li>Vivamus mi nisl, varius quis placerat vitae, sollicitudin et tellus.</li> </ul>"
    @announcement_2_title = random_string(96)
    @announcement_2_body = random_string(1024)
    @announcement_2_file = "resources.JPG"
    @announcement_3_title = random_string(96)
    @announcement_3_body = "Duis sagittis mi in nisl. Etiam vitae justo sit amet justo consectetuer dapibus. Nulla facilisi. Nulla facilisi. Nam volutpat nisi nec ligula. Morbi dapibus, nulla at vestibulum sodales, elit neque porttitor ante, ut mollis urna nulla non diam. Suspendisse ligula. Pellentesque congue felis at purus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Etiam tellus quam, faucibus sit amet, sodales eget, semper vitae, urna. Vivamus commodo. Nulla id neque. Curabitur non eros eget turpis suscipit molestie. Etiam non massa. Nulla at leo."
    @announcement_4_title = %|">;<<SCRIPT>alert("XSS");//<</SCRIPT> | + random_alphanums(32)
    @announcement_4_body = "Proin a nibh a turpis blandit tincidunt. Donec nulla eros, volutpat commodo, tempor laoreet, posuere ac, odio. Donec odio. Sed vel odio. In elit lectus, eleifend viverra, congue sed, ornare ac, elit. Fusce viverra. Pellentesque eleifend scelerisque tellus. Aenean vel ante. Donec dignissim dolor sed risus. Etiam semper nisl vitae lorem. Fusce ullamcorper orci id erat."
    @announcement_5_title = random_string(96)
    @announcement_5_body = random_xss_string(100)
    
    @group1 = config.directory["site1"]["group0"]
    @group2 = config.directory["site1"]["group1"]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_announcements
    
    puts @announcement_5_body
    
    asdfasdf
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to Announcements page
    announcements = home.announcements

    # Add an announcement
    ancmnt1 = announcements.add
    ancmnt1.title=@announcement_1_title
    ancmnt1.body=@announcement_1_body
    
    announcements = ancmnt1.add_announcement
    
    # TEST CASE: Verify announcement appears in list
    assert announcements.subjects.include?(@announcement_1_title)
    
    ancmnt2 = announcements.add
    ancmnt2.title=@announcement_2_title
    ancmnt2.body=@announcement_2_body
    
    attach = ancmnt2.add_attachments
    attach = attach.attach_a_copy(@announcement_2_file)
    
    ancmnt2 = attach.continue
    ancmnt2.select_groups
    ancmnt2.check_group @group1
    
    announcements = ancmnt2.add_announcement
    
    # TEST CASE: Verify list displays the announcement has an attachment
    assert announcements.has_attachment? @announcement_2_title
    
    begin
        assert @selenium.is_element_present("//img[@alt='attachment']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=This is a Test too"
    #
    @selenium.click "//input[@value='Return to List']"
    #
    @selenium.click "//a[contains(@onclick,'doNewannouncement')]"
    #
    @selenium.type "//input[@type='text']", "This is a Test three"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Duis sagittis mi in nisl. Etiam vitae justo sit amet justo consectetuer dapibus. Nulla facilisi. Nulla facilisi. Nam volutpat nisi nec ligula. Morbi dapibus, nulla at vestibulum sodales, elit neque porttitor ante, ut mollis urna nulla non diam. Suspendisse ligula. Pellentesque congue felis at purus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Etiam tellus quam, faucibus sit amet, sodales eget, semper vitae, urna. Vivamus commodo. Nulla id neque. Curabitur non eros eget turpis suscipit molestie. Etiam non massa. Nulla at leo."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@id='hidden_true']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
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
    begin
        assert !@selenium.is_text_present("This is a Test Three")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[contains(@onclick,'doNewannouncement')]"
    #
    @selenium.type "//input[@type='text']", "This is a Test fore!"
    @selenium.click "//input[contains(@onclick,'attach')]"
    #
    @selenium.click "//a[contains(text(),'resources.mp3')]/../../../td/div/a[contains(@title,'Attach a copy')]"
    #
    @selenium.click "//input[@id='attachButton']"
    #
    @selenium.click "//input[@id='hidden_true']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    begin
        assert @selenium.is_element_present("//div[@class='alertMessage']")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Proin a nibh a turpis blandit tincidunt. Donec nulla eros, volutpat commodo, tempor laoreet, posuere ac, odio. Donec odio. Sed vel odio. In elit lectus, eleifend viverra, congue sed, ornare ac, elit. Fusce viverra. Pellentesque eleifend scelerisque tellus. Aenean vel ante. Donec dignissim dolor sed risus. Etiam semper nisl vitae lorem. Fusce ullamcorper orci id erat."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    begin
        assert @selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[contains(@onclick,'doNewannouncement')]"
    #
    @selenium.type "//input[@type='text']", "This is a Test five"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Aenean nisi. Nam sagittis. Vestibulum lorem sapien, congue at, ullamcorper vel, egestas sed, pede. Donec pretium. Ut sit amet purus et mauris tristique vestibulum. Aliquam dignissim convallis mi. Duis tempor odio et sem. Nullam vehicula. Sed sodales. Morbi facilisis, libero eget convallis porta, massa enim egestas leo, id laoreet lacus diam quis neque. Pellentesque a enim. Suspendisse sit amet lorem."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@id='pubview']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("//a[contains(normalize-space(.),'This is a Test five')]/../../../td[contains(text(),'public')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    #
    @selenium.click "//span[contains(text(),'Search Public Courses and Projects')]"
    #
    @selenium.click "//input[@name='eventSubmit_doSearch' and @value='Search for Sites' and @type='submit']"
    #
    @selenium.click "//a[contains(@title,'1 2 3')]"
    #
    begin
        assert @selenium.is_element_present("//h5[contains(normalize-space(.),'This is a Test five')]")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//input[@type='submit']"
    #
    @selenium.click "link=Search"
    #
    @selenium.click "link=Home"
    #
    @selenium.type "eid", "instructor1"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    #
    @selenium.click "//a[contains(@title,'1 2 3')]"
    #
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[@title='Edit announcement This is a Test three']"
    #
    @selenium.type "//input[@type='text']", "This is a Test three Edit"
    @selenium.click "//input[contains(@onclick,'preview')]"
    #
    @selenium.click "//input[@type='submit']"
    #
    @selenium.click "//a[@title='Edit announcement This is a Test three Edit']"
    #
    @selenium.click "//input[@id='hidden_false']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
    @selenium.click "//a[@title='Recent Announcements Options']"
    #
    @selenium.type "//input[@id='itemsEntryField']", "5"
    @selenium.click "//input[@value='Update']"
    #
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[@title='Edit announcement This is a Test']"
    #
    @selenium.click "//input[@id='hidden_true']"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@title='123Port']"
    #
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[contains(@onclick,'doMerge')]"
    #
    @selenium.click "//label[contains(text(),'1 2 3')]/../../../td/input"
    @selenium.click "//input[@name='eventSubmit_doUpdate']"
    #
    begin
        assert @selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
    @selenium.click "//a[@title='Recent Announcements Options']"
    #
    @selenium.type "//input[@id='itemsEntryField']", "5"
    @selenium.click "//input[@value='Update']"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "link=This is a Test"
    #
    @selenium.click "//input[@value='Return to List']"
    #
    @selenium.click "//a[@class='icon-sakai-iframe-site']"
    #
    @selenium.click "//a[contains(@title,'1 2 3')]"
    #
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    @selenium.click "//a[contains(@onclick,'doNewannouncement')]"
    #
    @selenium.type "//input[@type='text']", "This is an Expired Test"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Proin a nibh a turpis blandit tincidunt. Donec nulla eros, volutpat commodo, tempor laoreet, posuere ac, odio. Donec odio. Sed vel odio. In elit lectus, eleifend viverra, congue sed, ornare ac, elit. Fusce viverra. Pellentesque eleifend scelerisque tellus. Aenean vel ante. Donec dignissim dolor sed risus. Etiam semper nisl vitae lorem. Fusce ullamcorper orci id erat."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@id='hidden_specify']"
    @selenium.select "retract_year", "label=2008"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    @selenium.click "//a[contains(@onclick,'doNewannouncement')]"
    #
    @selenium.type "//input[@type='text']", "This is a Future Test"
    @selenium.click "//td[@class='TB_Button_Text']"
    sleep 1
    @selenium.type "//textarea[@class='SourceField']", "Proin a nibh a turpis blandit tincidunt. Donec nulla eros, volutpat commodo, tempor laoreet, posuere ac, odio. Donec odio. Sed vel odio. In elit lectus, eleifend viverra, congue sed, ornare ac, elit. Fusce viverra. Pellentesque eleifend scelerisque tellus. Aenean vel ante. Donec dignissim dolor sed risus. Etiam semper nisl vitae lorem. Fusce ullamcorper orci id erat."
    @selenium.click "//td[@class='TB_Button_Text']"
    @selenium.click "//input[@id='hidden_specify']"
    @selenium.select "release_year", "label=2013"
    @selenium.select "retract_year", "label=2013"
    @selenium.click "//input[contains(@onclick,'post')]"
    #
    begin
        assert @selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is an Expired Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Future Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    #
    @selenium.type "eid", "student01"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    #
    @selenium.click "//a[contains(@title,'1 2 3')]"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is an Expired Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Future Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is an Expired Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Future Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    #
    @selenium.type "eid", "student05"
    @selenium.type "pw", "password"
    @selenium.click "//input[@value='submit']"
    #
    @selenium.click "//a[contains(@title,'1 2 3')]"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is an Expired Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Future Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "//a[@class='icon-sakai-announcements']"
    #
    begin
        assert !@selenium.is_element_present("link=This is a Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test too")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test five")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert @selenium.is_element_present("link=This is a Test three Edit")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Test fore!")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is an Expired Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    begin
        assert !@selenium.is_element_present("link=This is a Future Test")
    rescue Test::Unit::AssertionFailedError
        @verification_errors << $!
    end
    @selenium.click "link=Logout"
    #
    
  end
  
end
