#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Test adding various documents/pages to a course library
#
# == Prerequisites
#
# A user who manages at least one course.
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Adding Course Pages" do
  
  include Utilities

  before :all do
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @directory = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    @instructor = @directory['admin']['username']
    @ipassword = @directory['admin']['password']
    @user2 = @directory['person1']['id']
    @u2password = @directory['person1']['password']
    @student_name = "#{@directory['person1']['firstname']} #{@directory['person1']['lastname']}"
    
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

  it "page name appears in left menu" do
    # Log in to Sakai
    dashboard = @sakai.page.login(@instructor, @ipassword)

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
    library.areas.should include @doc1[:name]
  end
  
  it "Document appears in public search" do
    login_page = @sakai.logout
    
    # TEST CASE: Verify document appears in Recent activity list...
    #login_page.recent_activity_list.should include @doc1[:name]
    
    # TEST CASE: Verify document appears in Featured Content list...
    #login_page.featured_content_list.should include @doc1[:name]
    
    explore = login_page.explore_content
    explore.search_for @doc1[:name]
    
    # TEST CASE: Document appears in search list of logged out user
    explore.results.should include? @doc1[:name]
    
    content = explore.view_document @doc1[:name]

    # TEST CASE: Document opens for viewing
    content.name.should == @doc1[:name]
    
    # TEST CASE: Document includes expected tags
    @doc1[:tags].split(", ").each do |tag|
      content.tags_and_categories_list.should include tag
    end
    # TEST CASE: Document includes expected categories
    @doc1[:categories].each do |cat|
      content.tags_and_categories_list.find_all{|item| item =~ /#{Regexp.escape(cat)}/ }.should_not == [] 
    end
  end

  it "pages can be deleted" do
    # Log in to Sakai
    dashboard = @sakai.page.login(@instructor, @ipassword)

    # Find a course the user manages
    explore = dashboard.explore_courses
    explore.filter_by="Courses I manage"
    
    # Go to that course
    library = explore.open_course(explore.courses[0])
    
    library.add
    library.new_doc_name=@doc_delete_name
    library.done_add
    
    # TEST CASE: Page name appears in left-menu bar
    library.areas.should include @doc_delete_name
    
    library.delete_page @doc_delete_name
    library.delete
    
    # TEST CASE: Page is removed from Left Menu list
    library.areas.should_not include @doc_delete_name
  end
  
  xit "deleted pages are removed completely from content" do
    # These steps may not be expected behavior...
    #library = Library.new @browser
    #explore = library.explore_content
    
    #explore.search=@doc_delete_name
    
    # TEST CASE: Page does not appear in content search results... ???
    #explore.results_list.should_not include @doc_delete_name
  end

  it "page deletes can be canceled" do
    # Log in to Sakai
    dashboard = @sakai.page.login(@instructor, @ipassword)

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
    library.areas.should include @doc_cancel_delete
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
