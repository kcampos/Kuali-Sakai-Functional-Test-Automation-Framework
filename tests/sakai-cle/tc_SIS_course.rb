# 
# == Synopsis
#
# Testing the Master Course Site Setup and Copying
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
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
    
    # Test case variables
    @files_to_upload = [ "documents/resources.doc", "presentations/resources.ppt", "documents/resources.txt", "spreadsheets/resources.xls", "audio/resources.mp3" ]
    @subject = "TST"
    @course = "101"
    @section = "100"
    @authorizer = "admin"
    @email = random_alphanums
    @url = "http://www.rsmart.com"
    
    @job_name = "SIS" + random_alphanums
    @job_type = "SIS Synchronization"
    
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
    section_info.subject=@subject
    section_info.course=@course
    section_info.section=@section
    section_info.authorizers_username=@authorizer
    
    basic_site_info = section_info.continue
    
    course_tools = basic_site_info.continue
    
    # Choose the tools
    course_tools.check_all_tools

    add_mult_tools = course_tools.continue
    
    add_mult_tools.site_email_address=@email
    add_mult_tools.web_content_source=@url
    
    access = add_mult_tools.continue
    
    # Set the site to be joinable by student users
    access.select_allow
    access.joiner_role="Student" # This is not a 'variable'
    confirm = access.continue
    
    # Click to request the site
    sites_list = confirm.request_site
    
    # Go to the Sites page
    sites_page = sites_list.sites
    
    # Search for the site
    sites_page.search_field=@subject
    sites_page.search_button

    # Edit the site
    site_info = sites_page.click_top_item

    # Store the site ID so it can be used for
    # site removal later...
    tst_site_id = @browser.frame(:index=>0).table(:class=>"itemSummary").td(:class=>"shorttext", :index=>0).text

    # Change the Site ID to the master site id value
    tst_save_as = site_info.save_as
    tst_save_as.site_id=@master_course_site_id
    
    sites_page = tst_save_as.save
    
    # Search for the sites again
    sites_page.search_field=Regexp.escape(@subject)
    sites_page.search_button
    
    # Remove the original site
    
    edit_site = sites_page.edit_site_id(tst_site_id)
    remove_tst = edit_site.remove_site
    
    sites_page = remove_tst.remove
    
    # Open "My Sites" list
    home = sites_page.home
    
    # Go to the master course site
    home = home.open_my_site_by_id(@master_course_site_id)
    
    # Go to the Resources page
    tst_resources_page = home.resources
    
    # Upload files
    upload_page = tst_resources_page.upload_files_to_folder "#{@subject} #{@course} #{@section}"
    
    @files_to_upload.each do |filename|
      upload_page.file_to_upload=filename
      upload_page.add_another_file
    end
    
    resources = upload_page.upload_files_now

    # Go back to the admin workspace
    workspace = resources.my_workspace
    
    job_scheduler = workspace.job_scheduler

    jobs = job_scheduler.jobs
    jobs = JobList.new(@browser)

    new_job = jobs.new_job

    new_job.job_name=@job_name
    new_job.type=@job_type

    jobs = new_job.post

    triggers = jobs.triggers @job_name

    confirmation = triggers.run_job_now

    jobs = confirmation.run_now
    
    home = jobs.home

    @sakai.logout
    
  end
  
end
