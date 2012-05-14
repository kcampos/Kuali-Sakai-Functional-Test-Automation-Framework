#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the creation of a new presentation inside a Portfolio Site.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreateNewPortfolio < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @student = @directory['person1']['id']
    @password = @directory['person1']['password']
    @site_name = @directory['site2']['name']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @name = random_string
    @page_title = random_string
    @page_description = random_string(255)
    @layout_name = "Simple HTML"
    @page_content = random_string(1024)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_new_portfolio
    
    # Log in to Sakai
    workspace = @sakai.page.login(@student, @password)
    
    home = workspace.open_my_site_by_name(@site_name)
    
    portfolios = home.portfolios
    
    new = portfolios.create_new_portfolio
    new.name=@name
    new.select_design_your_own_portfolio
    
    edit = new.create
    
    content = edit.add_edit_content
    
    add_page = content.add_page
    add_page.title=@page_title
    add_page.description=@page_description
    
    layout = add_page.select_layout

    edit_page = layout.select @layout_name
    edit_page.simple_html_content=@page_content
    
    edit_content = edit_page.add_page
    edit_content.save_changes
    
    share = edit_content.share_with_others
    share.check_everyone_on_the_internet
    
    summary = share.summary
    
    portfolios = summary.reset
    
    # TEST CASE: The portfolio appears in the list
    assert portfolios.list.include?(@name), "#{@name} is not included in \n\n #{portfolios.list}"
    
    # TEST CASE: The portfolio is public
    assert_equal "Public", portfolios.shared(@name), "Share: #{portfolios.shared(@name)}"
    
  end
  
end
