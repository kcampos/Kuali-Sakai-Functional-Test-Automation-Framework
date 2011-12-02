# 
# == Synopsis
#
# This script uploads resources to a test site and
# sets them all to publicly viewable status.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }
require "ci/reporter/rake/test_unit_loader"

class AddPublicResources < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses an admin login
    @username = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables...
    @files_1 = [
    "documents/accomplishment.xsd",
    "images/flower01.jpg",
    "presentations/resources.ppt",
    "audio/resources.mp3",
    "images/resources.JPG"
    ]
    @files_2 = [
    "documents/sample.pdf",
    "images/flower02.jpg",
    "documents/resources.doc"
    ]
    
    @folder_name = "Folder 1"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_adding_resources
    
    # Log in to Sakai
    workspace = @sakai.login(@username, @password)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to Resources page
    resources = home.resources
    
    # Upload files
    upload_files = resources.upload_files_to_folder("#{@site_name} Resources")
    
    filenames_1 = []
    @files_1.each do |file|
      file =~ /(?<=\/).+/
      filenames_1 << $~.to_s
      upload_files.file_to_upload=file
      upload_files.add_another_file
    end
    resources = upload_files.upload_files_now
    
    # Make sure they uploaded
    filenames_1.each do |file|
      unless resources.file_names.include?(file)
        upload_files = resources.upload_files_to_folder("#{@site_name} Resources")
        upload_files.file_to_upload=@files_1[filenames_1.index(file)]
        resources = upload_files.upload_files_now
      end
    end
    
    # Make them public
    filenames_1.each do |file|
      edit_file = resources.edit_details(file)
      edit_file.select_publicly_viewable
    
      resources = edit_file.update
      
      #TEST CASE: Access set to "Public"
      assert_equal resources.access_level(file), "Public"
      
    end
    
    # Add a folder
    create_folder = resources.create_subfolders_in("#{@site_name} Resources")
    create_folder.folder_name=@folder_name
    
    resources = create_folder.create_folders_now
    
    # Navigate to the folder
    resources.go_to_folder @folder_name
    
    # Upload files to the folder
    resources.upload_files_to_folder @folder_name
    
    filenames_2 = []
    @files_2.each do |file|
      file =~ /(?<=\/).+/
      filenames_2 << $~.to_s
      upload_files.file_to_upload=file
      upload_files.add_another_file
    end
    resources = upload_files.upload_files_now
    
    # Make them public
    filenames_2.each do |file|
      edit_file = resources.edit_details(file)
      edit_file.select_publicly_viewable
    
      resources = edit_file.update
      
      #TEST CASE: Access set to "Public"
      assert_equal resources.access_level(file), "Public"
      
    end
    
  end
  
end
