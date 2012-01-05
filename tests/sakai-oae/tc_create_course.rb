#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the creation of a new Course.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-oae/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCreateCourse < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @course_info = {
      :title=>"4cz6xwm56N",#random_alphanums
      :description=>random_string,
      :tags=>random_string
    }
    
    @new_document = {:name=>"stuff", :visible=>"Visible to anyone", :pages=>"3"}
    @existing_document = {:name=>"Syllabus", :title=>"Existing Doc", :visible =>"All participants", :example_content=>"Real and Hyperreal Numbers" }
    @participant_list = {:name=>"party", :visible=>"Visible to anyone"}
    @content_library = {:name=>"content", :visible=>"Visible to anyone"}
    @widgets = [
      {:name=>"Disc",:widget=>"Discussion",:visible=>"Visible to anyone"},
      {:name=>"Remote",:widget=>"Remote Content",:visible=>"Visible to anyone"},
      {:name=>"Inline",:widget=>"Inline Content",:visible=>"Visible to anyone"},
      {:name=>"Tests",:widget=>"Tests and Quizzes",:visible=>"Visible to anyone"},
      {:name=>"Calendar",:widget=>"Calendar",:visible=>"Visible to anyone"},
      {:name=>"Map",:widget=>"Google maps",:visible=>"Visible to anyone"},
      {:name=>"File",:widget=>"Files and documents",:visible=>"Visible to anyone"},
      {:name=>"Comment",:widget=>"Comments",:visible=>"Visible to anyone"},
      {:name=>"JISC",:widget=>"JISC Content",:visible=>"Visible to anyone"},
      {:name=>"Tasks",:widget=>"Assignments",:visible=>"Visible to anyone"},
      {:name=>"RSS",:widget=>"RSS Feed Reader",:visible=>"Visible to anyone"},
      {:name=>"LTI",:widget=>"Basic LTI",:visible=>"Visible to anyone"},
      {:name=>"Gadget",:widget=>"Google Gadget",:visible=>"Visible to anyone"},
      {:name=>"Grades",:widget=>"Gradebook",:visible=>"Visible to anyone"}
    ]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_course
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
=begin
    dashboard.add_all_widgets
    
    create_course = dashboard.create_courses
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@course_info[:title]
    new_course_info.description=@course_info[:description]
    new_course_info.tags=@course_info[:tags]
    @suggested_url = new_course_info.suggested_url
    
    library = new_course_info.create_basic_course
    
    library.add_a_new_document @new_document
    library.add_an_existing_document @existing_document
    library.add_a_participant_list @participant_list
    library.add_content_library @content_library
    
    @widgets.each do |widget|
      library.add_widget widget
    end
    
    dashboard = library.my_dashboard
    
    # TEST CASE: Verify the new course is in recent memberships
    #assert dashboard.recent_memberships.include?(@course_info[:title]), "Expected course title: #{@course_info[:title]}\n\nList in Widget:\n\n#{dashboard.recent_memberships.join("\n")}"
=end
    membership = dashboard.my_memberships
    #sleep 5
    library = membership.go_to @course_info[:title]
=begin
    # TEST CASE: Verify pages are present
    assert library.public_pages.include? @new_document[:name]
    assert library.public_pages.include? @existing_document[:title]
    assert library.public_pages.include? @participant_list[:name]
    assert library.public_pages.include? @content_library[:name]
    
    @widgets.each do |widget|
      assert library.public_pages.include? widget[:name]
    end
    
    library.open_page("Participants", "participants")
    sleep 2
    # TEST CASE: Participants panel appears
    assert @browser.div(:id=>"participants_list_container").visible?
=end
    library.expand @new_document[:name]
    document = library.open_page("Page 1", "document")
=begin
    document.edit_page
    sleep 5
    document.select_all
    document.add_content=random_string(32)
    document.select_all
    document.format="Heading 1"
    document.font="Comic Sans MS"
    sleep 1
    document.save
=end
    # TEST CASE HERE
    
    document.expand @existing_document[:title]
    
    week_1 = document.open_page("Week 1", "read_only")
    
    # TEST CASE HERE
    party = week_1.open_page(@participant_list[:name], "participants")
    
    # TEST CASE: Participants panel appears
    #assert @browser.div(:id=>"participants_list_container").visible? #FIXME

    content = party.open_page(@content_library[:name], "library")
    
    # TEST CASE HERE
    
    comments = content.open_page(@widgets[7][:name], @widgets[7][:widget])
    
    comments.add_comment
    @text=random_alphanums + " This is radio clash on pirate satellite"
    @text2=random_alphanums + " Orbiting your living room"
    comments.comment=@text
    comments.submit_comment
    comments.edit @text
    comments.new_comment=@text2
    comments.cancel
    comments.edit @text
    comments.new_comment_element.send_keys [:command, 'a']
    comments.new_comment=@text2
    comments.edit_comment
    comments.delete @text2

    sleep 5
    
=begin
    @widgets.each do | widget |
      
      page = content.open_page(widget[:name], widget[:widget])
      
      # TEST CASE HERE
      
      content = page.open_page(@content_library[:name], "library")
      
    end
=end 
  end
  
end
