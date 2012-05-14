# 
# == Synopsis
#
# Testing the Master Project Site Setup and Copying
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestMasterProjectSite < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case requires an admin user
    @user_name = @directory['admin']['username']
    @password = @directory['admin']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @master_project_site_id = "12345678-abcd-1234-wxyz-12ab34cd56ef"
    @site_title = "Test Project"
    @files_to_upload = [ "documents/resources.doc", "presentations/resources.ppt", "documents/resources.txt", "spreadsheets/resources.xls", "audio/resources.mp3" ]
    @site_description = "Project site for testers."
    @page_title = "Site Editor"
    @email = "testproject"
    @url = "http://www.rsmart.com"
    
    @job_name = "SIS" + random_alphanums
    @job_type = "SIS Synchronization"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_master_portfolio_site
    
    # Log in to Sakai
    @sakai.page.login(@user_name, @password)
 
    # Go to the Sites page
    home = Home.new(@browser)
    sites_page = home.sites
    
    # Create a new site
    new_site = sites_page.new_site
    
    # Enter the master site id and other site attributes
    new_site.editor.wait_until_present
    new_site.site_id=@master_project_site_id
    new_site.title=@site_title
    new_site.type="project"
    new_site.short_description=@site_title
    new_site.description=@site_description
    new_site.select_published
    new_site.select_public_view_yes
    
    sites_page = new_site.save

    edit_site = sites_page.edit_site_id(@master_project_site_id)
    
    pages = edit_site.pages
    
    new_page = pages.new_page
    new_page.title=@page_title
    
    tools = new_page.tools
    
    new_tool = tools.new_tool
    new_tool.select_resources
    
    edit_tool = new_tool.done
    
    edit_pages = edit_tool.save
    
    site_setup_page = edit_pages.site_setup
    
    test_proj_edit = site_setup_page.edit(@site_title)
    
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
    #edit_tools_page.check_site_statistics
    edit_tools_page.check_web_content
    edit_tools_page.check_wiki
    
    add_mult = edit_tools_page.continue

    add_mult.site_email_address=@email
    add_mult.web_content_source=@url
    
    confirm = add_mult.continue
    
    site_edit = confirm.finish

    home = site_edit.home
    
    home = home.open_my_site_by_id(@master_project_site_id)
    
    # Go to the Resources page
    tst_proj_resources = home.resources

    # Upload files
    upload_page = tst_proj_resources.upload_files_to_folder @site_title
    
    @files_to_upload.each do |filename|
      upload_page.file_to_upload=filename
      upload_page.add_another_file
    end
    
    upload_page.upload_files_now
    # Go back to the admin workspace
    workspace = upload_page.my_workspace
    
    job_scheduler = workspace.job_scheduler

    jobs = job_scheduler.jobs

    new_job = jobs.new_job

    new_job.job_name=@job_name
    new_job.type=@job_type

    jobs = new_job.post

    triggers = jobs.triggers @job_name

    confirmation = triggers.run_job_now

    jobs = confirmation.run_now
    
    home = jobs.home

    home.logout
    
  end
  
end
