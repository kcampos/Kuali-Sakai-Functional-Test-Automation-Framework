# 
# == Synopsis
#
# Testing the Master Portfolio Site Setup and Copying
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestMasterPortfolioSite < Test::Unit::TestCase
  
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
    @master_portfolio_site_id = "87654321-abcd-1234-wxyz-ab12cd34ef56"
    
    # Test case variables
    @site_title = "Test Portfolio"
    @site_description  = "Portfolio Site For Testing"
    @files_to_upload = [ "documents/resources.doc", "presentations/resources.ppt", "documents/resources.txt", "spreadsheets/resources.xls", "audio/resources.mp3" ]
    @page_title = "Site Editor"
    
    @job_name = "SIS" + random_alphanums
    @job_type = "SIS Synchronization"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_master_portfolio_site
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # Go to the Site Setup page
    home = Home.new(@browser)
 
    sites_page = home.sites
   
    # Make a new Portfolio Site
    new_site = sites_page.new_site
    
    new_site.site_id=@master_portfolio_site_id
    new_site.title=@site_title
    new_site.type='portfolio'
    new_site.short_description=@site_title
    new_site.description=@site_description
    new_site.select_published
    new_site.select_public_view_yes
    
    sites_page = new_site.save
 
    sites_page.search_site_id=@master_portfolio_site_id
    sites_page.search_site_id_button
    
    edit_site = sites_page.click_top_item
    pages = edit_site.pages
    
    new_page = pages.new_page
    
    new_page.title=@page_title
    
    tools = new_page.tools
    
    new_tool = tools.new_tool
    
    new_tool.select_resources
    
    tools = new_tool.done
    
    sites_page = tools.save
    
    site_setup_page = sites_page.site_setup
    
    site_edit = site_setup_page.edit(@site_title)
    
    edit_tools = site_edit.edit_tools
    
    edit_tools.check_home
    edit_tools.check_announcements
    edit_tools.check_assignments
    edit_tools.check_calendar
    edit_tools.check_email_archive
    edit_tools.check_evaluations
    #edit_tools.check_forms
    edit_tools.check_glossary
    edit_tools.check_matrices
    edit_tools.check_news
    edit_tools.check_portfolio_layouts
    edit_tools.check_portfolio_showcase
    edit_tools.check_portfolio_templates
    edit_tools.check_portfolios
    edit_tools.check_resources
    edit_tools.check_roster
    edit_tools.check_search
    edit_tools.check_styles
    edit_tools.check_web_content
    edit_tools.check_wizards
    
    add_mult = edit_tools.continue
    
    add_mult.site_email_address="testportfolio"
    add_mult.web_content_source="http://www.rsmart.com"
    
    confirm = add_mult.continue
    
    site_edit = confirm.finish
    
    home = site_edit.home
    
    home = home.open_my_site_by_id(@master_portfolio_site_id)
    
    # Go to the Resources page
    port_resources_page = home.resources
    
    # Upload files
    upload_page = port_resources_page.upload_files_to_folder @site_title
    
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
    
    @sakai.logout
  
  end
  
end
