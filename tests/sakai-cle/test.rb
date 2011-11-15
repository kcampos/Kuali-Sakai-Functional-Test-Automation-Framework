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
    
    puts resources.folder_names
    puts resources.file_names
    
  end
  
end
