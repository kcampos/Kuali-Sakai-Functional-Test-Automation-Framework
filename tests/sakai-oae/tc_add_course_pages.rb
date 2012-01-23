#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCourseAddingPages < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @user2 = @config.directory['person1']['id']
    @u2password = @config.directory['person1']['password']
    @student_name = "Student One"
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @doc1 = {
      :name=>random_alphanums(20), # Probably want to switch to using "hard" strings at some point
      :visibility=>"Public",
      :pages=>"1",
      :tags=>"public, document",
      :categories=>random_categories(5)
    }
    
    @doc_delete_name = random_alphanums # Best to use "easy" strings here.
    @doc_cancel_delete = random_string(20)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end

  def test_add_new_document
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    # Find a course the user manages
    explore = dashboard.explore_courses
    explore.filter_by="Courses I manage"
    
    # Go to that course
    library = explore.open_course(explore.courses[0])
    
    library.add
    library.new_doc_name=@doc1[:name]
    library.new_doc_permissions=@doc1[:visibility]
    library.number_of_pages=@doc1[:pages]
    library.new_doc_tags_and_categories=@doc1[:tags]
    library.list_categories
    
    @doc1[:categories].each { |cat| library.check_category(cat) }
    
    library.save_categories
    library.done_add
    
    # TEST CASE: Page name appears in left-menu bar
    assert library.areas.include? @doc1[:name]
    
    login_page = @sakai.logout
    
    # TEST CASE: Verify document appears in Recent activity list...
    #assert login_page.recent_activity_list.include?(@doc1[:name]), "\n#{@doc1[:name]} not found in...\n\n#{login_page.recent_activity_list}\n"
    
    # TEST CASE: Verify document appears in Featured Content list...
    #assert login_page.featured_content_list.include?(@doc1[:name]), "\n#{@doc1[:name]} not found in...\n\n#{login_page.featured_content_list}\n"
    
    #page_profile = login_page.open_page @doc1[:name]
    
    explore = login_page.explore_content
    explore.search_for @doc1[:name]
    
    # TEST CASE: Document appears in search list of logged out user
    assert explore.results.include? @doc1[:name]
    
    content = explore.view_document @doc1[:name]

    # TEST CASE: Document opens for viewing
    assert_equal @doc1[:name], content.name
    
    # TEST CASE: Document includes expected tags
    @doc1[:tags].split(", ").each do |tag|
      assert content.tags_and_categories_list.include?(tag), "'#{tag}' not found in \n#{content.tags_and_categories_list}"
    end
    # TEST CASE: Document includes expected categories
    @doc1[:categories].each do |cat|
      assert_not_equal([], content.tags_and_categories_list.find_all{|item| item =~ /#{Regexp.escape(cat)}/ }, "#{cat}\n\n...not in...\n\n#{content.tags_and_categories_list}")
    end
    
  end

  def test_delete_page
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    # Find a course the user manages
    explore = dashboard.explore_courses
    explore.filter_by="Courses I manage"
    
    # Go to that course
    library = explore.open_course(explore.courses[0])
    
    library.add
    library.new_doc_name=@doc_delete_name
    library.done_add
    
    # TEST CASE: Page name appears in left-menu bar
    assert library.areas.include? @doc_delete_name
    
    library.delete_page @doc_delete_name
    library.delete
    
    # TEST CASE: Page is removed from Left Menu list
    assert_equal false, library.areas.include?(@doc_delete_name)
    
    explore = library.explore_content
    
    explore.search=@doc_delete_name
    
    # TEST CASE: Page does not appear in content search results... ???
    #assert_equal false, explore.results_list.include?(@doc_delete_name), "#{@doc_delete_name} was deleted but found in search!"
    
  end

  def test_cancel_delete_page
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    # Find a course the user manages
    explore = dashboard.explore_courses
    explore.filter_by="Courses I manage"
    
    # Go to that course
    library = explore.open_course(explore.courses[0])
    
    # Add a document
    library.add
    library.new_doc_name=@doc_cancel_delete
    library.done_add
    
    # Select to delete the document
    library.delete_page @doc_cancel_delete
    library.dont_delete
    
    # TEST CASE: Page name appears in left-menu bar
    assert library.areas.include? @doc_cancel_delete
    
    sleep 10
    
  end

end
