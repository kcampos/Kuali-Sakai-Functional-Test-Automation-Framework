#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the syllabus pages in Sakai-CLE.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestSyllabusPages < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @instructor = @directory['person3']['id']
    @ipassword = @directory['person3']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @title = random_string(24)
    @content = "Integer sit amet felis vitae neque lobortis gravida. Fusce vitae ante. Morbi ac tellus eget elit mollis dictum. Nam luctus volutpat nisi. Vestibulum fringilla congue tellus. Nam velit dui, molestie a, suscipit ut, pharetra nec, ligula. Sed nisl dolor, porttitor sed, hendrerit in, gravida ultricies, eros? Nunc erat. Etiam vitae nisi. Donec cursus ullamcorper velit. Nam ipsum quam, sagittis eget, mattis sed, ornare quis, elit. Suspendisse metus dui, cursus in; tincidunt ut, sollicitudin vitae, pede? Phasellus gravida magna eu velit. Aenean tristique turpis et orci! Nulla in elit eu felis elementum vestibulum. Vivamus dictum mi vel nulla! Nam dui. In vitae nisl. Aliquam pretium, elit sed imperdiet fermentum, felis nisi rhoncus augue, sit amet consectetur odio neque fringilla sapien. Proin quis purus.  Nunc eu risus. Phasellus adipiscing ultricies ligula. Praesent ultrices tortor eu sem. Aliquam erat volutpat. Quisque suscipit, sem vel pellentesque scelerisque, odio augue pretium lorem, euismod malesuada urna nisi id nunc. Suspendisse eleifend, ligula ut semper vestibulum, erat risus porta quam; convallis sollicitudin odio risus ac enim. Pellentesque malesuada, eros eu posuere."
    @folder = "Folder 1"
    @file = "resources.doc"
    @url = "http://www.rsmart.com"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_syllabus

    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    syllabus = home.syllabus
    
    syllabus_edit = syllabus.create_edit
    
    new_syllabus = syllabus_edit.add
    
    new_syllabus.title=@title
    sleep 2
    new_syllabus.content=@content
    
    attach = new_syllabus.add_attachments
    attach.open_folder @folder
    attach.attach_a_copy @file
    
    new_syllabus = attach.continue
    
    # TEST CASE: File added to syllabus
    assert new_syllabus.files_list.include? @file
    
    new_syllabus.select_publicly_viewable
    
    preview = new_syllabus.preview
    
    new_syllabus = preview.edit
    
    syllabus = new_syllabus.post
    
    # TEST CASE: Verify syllabus appears in the list
    assert syllabus.syllabus_titles.include? @title
    
    syllabus = syllabus.reset
    
    # TEST CASE: Verify the link to the attachment displays
    assert syllabus.attachments_list.include? @file
    
    login = syllabus.logout
    
    search = login.search_public_courses_and_projects
    
    search_sites = search.search_for_sites
    
    summary = search_sites.click_site @site_name
    
    # TEST CASE: Verify the syllabus item shows the attachment
    assert summary.syllabus_attachments.include? @file
    
    search = summary.return_to_list
    
    login = search.home
    
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    syllabus = home.syllabus
    
    syllabus_list = syllabus.create_edit
    
    redirect = syllabus_list.redirect
    redirect.url=@url
    
    edit = redirect.save
    
    # TEST CASE: Verify "Redirect Syllabus" displays
    assert_equal "Redirect Syllabus", edit.header
    
  end
  
end
