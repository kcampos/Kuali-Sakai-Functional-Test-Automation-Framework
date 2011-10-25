# 
# == Synopsis
#
# Testing the Master Project Site Setup and Copying
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestMasterProjectSite < Test::Unit::TestCase
  
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
    @master_project_site_id = "12345678-abcd-1234-wxyz-12ab34cd56ef"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_master_portfolio_site
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
 
    # Go to the Sites page
    home = Home.new(@browser)
    sites_page = home.sites
    
    # Create a new site
    new_site = sites_page.new_site
    
    # Enter the master site id and other site attributes
    @browser.frame(:index=>0).frame(:id, "description___Frame").wait_until_present
    new_site.site_id=@master_project_site_id
    new_site.title="Test Project"
    new_site.type="project"
    new_site.short_description="Test Project"
    new_site.add_description("Project site for testers.")
    new_site.select_published
    new_site.select_public_view_yes
    
    sites_page = new_site.save
 
    edit_site = sites_page.edit_site_id(@master_project_site_id)
    
    pages = edit_site.pages
    
    new_page = pages.new_page
    new_page.title="Site Editor"
    
    tools = new_page.tools
    
    new_tool = tools.new_tool
    new_tool.select_resources
    
    edit_tool = new_tool.done
    
    edit_pages = edit_tool.save
    
    site_setup_page = edit_pages.site_setup
    
    test_proj_edit = site_setup_page.edit("Test Project")
    
    edit_tools_page = test_proj_edit.edit_tools
    
    edit_tools_page.check_announcements
    edit_tools_page.check_blogger
    edit_tools_page.check_calendar
    edit_tools_page.check_chat_room
    edit_tools_page.check_discussion_forums
    edit_tools_page.check_drop_box
    edit_tools_page.check_email_archive
    edit_tools_page.check_forums
    edit_tools_page.check_lessons
    edit_tools_page.check_email
    edit_tools_page.check_messages
    edit_tools_page.check_news
    edit_tools_page.check_podcasts
    edit_tools_page.check_polls
    edit_tools_page.check_resources
    edit_tools_page.check_roster
    edit_tools_page.check_search
    edit_tools_page.check_sections
    edit_tools_page.check_site_statistics
    edit_tools_page.check_web_content
    edit_tools_page.check_wiki
    
    add_mult = edit_tools_page.continue

    add_mult.site_email_address="testproject"
    add_mult.web_content_source="http://www.rsmart.com"
    
    confirm = add_mult.continue
    
    site_edit = confirm.finish

    home = site_edit.home
    
    home = home.open_my_site_by_id(@master_project_site_id)
    
    # Go to the Resources page
    tst_proj_resources = home.resources

    # Upload files
    upload_page = tst_proj_resources.upload_files
    
    files_to_upload = [ "documents/resources.doc", "presentations/resources.ppt", "documents/resources.txt", "spreadsheets/resources.xls", "audio/resources.mp3" ]
    
    files_to_upload.each do |filename|
      upload_page.file_to_upload(filename)
      upload_page.add_another_file
    end
    
    upload_page.upload_files_now
    # Go back to the admin workspace
    workspace = upload_page.administration_workspace
    
    job_scheduler = workspace.job_scheduler

    jobs = job_scheduler.jobs
    jobs = JobList.new(@browser)

    new_job = jobs.new_job

    new_job.job_name="SIS"
    new_job.type="SIS Synchronization"

    jobs = new_job.post

    triggers = jobs.triggers

    confirmation = triggers.run_job_now

    jobs = confirmation.run_now
    
    home = jobs.home
    
    @sakai.logout
    
  end
  
end
