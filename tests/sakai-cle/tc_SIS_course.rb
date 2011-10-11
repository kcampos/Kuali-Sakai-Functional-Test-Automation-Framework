# 
# == Synopsis
#
# Testing the Master Course Site Setup and Copying
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/page_elements.rb", "/../../lib/sakai-CLE/app_functions.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestMasterCourseSite < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case requires an admin user
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    @master_course_site_id = "87654321-abcd-1234-wxyz-12ab34cd56ef"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_master_course_site
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
 
    # Go to the Site Setup page
    home = Home.new(@browser)
 
    site_setup = home.site_setup
    
    # Make a new Course Site
    site_type = site_setup.new
    site_type.select_course_site

    section_info = site_type.continue

    # Give the site a name
    section_info.subject="TST"
    section_info.course="101"
    section_info.section="100"
    section_info.authorizers_username="admin"
    
    basic_site_info = section_info.continue
    
    course_tools = basic_site_info.continue
    
    # Choose the tools
    course_tools.check_all_tools_cb

    add_mult_tools = course_tools.continue
    
    add_mult_tools.site_email_address="tst100"
    add_mult_tools.web_content_source="http://www.rsmart.com"
    
    access = add_mult_tools.continue
    
    # Set the site to be joinable by student users
    access.select_allow
    access.joiner_role="Student"
    confirm = access.continue
    
    # Click to request the site
    sites_list = confirm.request_site
    
    # Go to the Sites page
    sites_page = sites_list.sites
    
    # Search for the site
    sites_page.search_field="TST"
    sites_page.search_button
    
    # Edit the site
    site_info = sites_page.click_top_item
    
    # Store the site ID so it can be used for
    # site removal later...
    tst_site_id = site_info.site_id
  
    # Change the Site ID to the master site id value
    tst_save_as = site_info.save_as
    tst_save_as.site_id=@master_course_site_id
    
    sites_page = tst_save_as.save
    
    # Search for the sites again
    sites_page.search_field="TST"
    sites_page.search_button
    
    # Remove the original site
    
    edit_site = sites_page.edit_site_id(tst_site_id)
    remove_tst = edit_site.remove_site
    
    sites_page = remove_tst.remove
    
    # Open "My Sites" list
    home = sites_page.home
    home.my_sites
    
    # Go to the master course site
    @browser.link(:href, /#{@master_course_site_id}/).click
    
    # Go to the Resources page
    home = Home.new(@browser)
    tst_resources_page = home.resources
    
    # Upload files
    upload_page = tst_resources_page.upload_files
    
    files_to_upload = [ "documents/resources.doc", "presentations/resources.ppt", "documents/resources.txt", "spreadsheets/resources.xls", "audio/resources.mp3" ]
    
    files_to_upload.each do |filename|
      upload_page.file_to_upload(filename)
      upload_page.add_another_file
    end
    
    upload_page.upload_files_now
    
    @sakai.logout
    
  end
  
end
