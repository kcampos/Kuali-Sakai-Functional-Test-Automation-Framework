# 
# == Synopsis
#
# This case tests the setting up of a Course site.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreatingPortfolioSite < Test::Unit::TestCase
  
  include Utilities

  def setup

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @user_name = @directory['admin']['username']
    @password = @directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @site_name = random_alphanums
    @description = random_string(256)
    @email = random_nicelink

    @web_content_source = "http://www.rsmart.com"
    @bad_address = random_string(32)
    @email=random_nicelink(32)
    @joiner_role = "Student"
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    
  end
  
  def teardown
    # Save new site info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/CLE/directory.yml", "w+") { |out|
      YAML::dump(@directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_create_portfolio_site
    
    # Log in to Sakai
    @sakai.page.login(@user_name, @password)
    
    #Go to Site Setup page
    workspace = MyWorkspace.new(@browser)
    site_setup = workspace.site_setup

    site_type = site_setup.new
    
    # Select the Portfolio Site radio button
    
    site_type.select_portfolio_site
    
    # Click continue
    port_site_info = site_type.continue

    port_site_info.title=@site_name
    port_site_info.description=@description
    
    @directory['site2']['name'] = @site_name
    
    site_tools = port_site_info.continue
    site_tools.check_all_tools
    
    tool_options = site_tools.continue
    tool_options.email=@email
    
    site_access = tool_options.continue
    
    confirm = site_access.continue
    
    site_setup = confirm.create_site
    
    site_setup.search(Regexp.escape(@site_name))
    
    #TEST CASE: Verify the creation of the site by the name
    assert site_setup.site_titles.include? @site_name
    
  end
  
end
