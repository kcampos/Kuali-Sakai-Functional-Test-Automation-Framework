#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the creation of a new Course, adding all widgets and smoke checking
# their basic functionality.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
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
      :title=>"0zKnXMySc3", #random_alphanums, #
      :description=>random_string,
      :tags=>random_string
    }
    
    @new_document = {:name=>"stuff", :visible=>"Public", :pages=>"3"}
    @existing_document = {:name=>"Tests and Quizzes", :title=>"Existing Doc", :visible =>"Participants only", :example_content=>"Real and Hyperreal Numbers" }
    @participant_list = {:name=>"party", :visible=>"Public"}
    @content_library = {:name=>"content", :visible=>"Public"}
    @widgets = [
      {:name=>"Comment",:widget=>"Comments",:visible=>"Public"},
      {:name=>"JISC",:widget=>"JISC content",:visible=>"Public"},
      {:name=>"RSS",:widget=>"RSS feed reader",:visible=>"Public"},
      {:name=>"Map",:widget=>"Google maps",:visible=>"Public"},
      {:name=>"Tasks",:widget=>"Assignments",:visible=>"Public"},
      {:name=>"LTI",:widget=>"Basic LTI",:visible=>"Public"},
      {:name=>"Gadget",:widget=>"Google Gadget",:visible=>"Public"},
      {:name=>"Grades",:widget=>"Gradebook",:visible=>"Public"},
      {:name=>"Disc",:widget=>"Discussion",:visible=>"Public"},
      {:name=>"Remote",:widget=>"Remote content",:visible=>"Public"},
      {:name=>"Inline",:widget=>"Inline Content",:visible=>"Public"},
      {:name=>"Tests",:widget=>"Tests and Quizzes",:visible=>"Public"},
      {:name=>"Calendar",:widget=>"Calendar",:visible=>"Public"},
      {:name=>"File",:widget=>"Files and documents",:visible=>"Public"}
    ]
    @participant="Cynthia Wines"
    @doc_header=random_alphanums(32)
    @comment=random_alphanums + " This is radio clash on pirate satellite"
    @comment2=random_alphanums + " Orbiting your living room"
    @location="1375 N. Scottsdale AZ 85257"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_course
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)
=begin
    dashboard.add_widget
    dashboard.add_all_widgets
    
    create_course = dashboard.create_a_course
    
    new_course_info = create_course.use_basic_template
    new_course_info.title=@course_info[:title]
    new_course_info.description=@course_info[:description]
    new_course_info.tags=@course_info[:tags]
    @suggested_url = new_course_info.suggested_url
    
    library = new_course_info.create_basic_course
    
    library.add_new_area
    library.add_a_new_document @new_document
    library.add_new_area
    library.add_an_existing_document @existing_document
    library.add_new_area
    library.add_participants_list @participant_list
    library.add_new_area
    library.add_content_library @content_library
    
    @widgets.each do |widget|
      library.add_new_area
      library.add_widget widget
    end
    
    dashboard = library.my_dashboard
    
    # TEST CASE: Verify the new course is in recent memberships
    #assert dashboard.recent_memberships.include?(@course_info[:title]), "Expected course title: #{@course_info[:title]}\n\nList in Widget:\n\n#{dashboard.recent_memberships.join("\n")}"
=end
    membership = dashboard.my_memberships

    library = membership.go_to @course_info[:title]
=begin
    # TEST CASE: Verify pages are present
    assert library.public_pages.include? @new_document[:name]
    assert library.public_pages.include? @existing_document[:title]
    assert library.public_pages.include? @participant_list[:name]
    assert library.public_pages.include? @content_library[:name]
    
    @widgets.each do |widget|
      # TEST CASE: Verify all widgets appear in the list of pages.
      assert(library.public_pages.include?(widget[:name]), "#{widget[:name]} not found in list of Course pages.")
    end

    library.manage_participants
    library.a§dd_contact_by_search @participant
    library.save
=end
    #participants = library.open_page("Participants", "participants")

    # TEST CASE: Participants panel appears
    #assert @browser.div(:id=>"participants_list_container").visible?
#=end
# should be participants here:
    #participants.expand @new_document[:name]
    #document = participants.open_page("Page 1", "document")
=begin
    document.edit_page
    document.select_all
    document.add_content=@doc_header
    document.select_all
    document.format="Heading 1"
    document.font="Comic Sans MS"
    document.save
    #sleep 5 #FIXME
=end
    # TEST CASE HERE
    #assert @browser.text.include? @doc_header #FIXME - Try to improve this later.
    
    #document.expand @existing_document[:title]
    
    #week_1 = document.open_page("Page 1", "read_only")
    
    # TEST CASE HERE
    
    #party = week_1.open_page(@participant_list[:name], "participants")
    
    # TEST CASE: Participants panel appears
    #assert @browser.div(:id=>"participants_list_container").visible? #FIXME

    #content = party.open_page(@content_library[:name], "library")
    
    # TEST CASE HERE

    #comments = content.open_page(@widgets[0][:name], @widgets[0][:widget])
=begin
    comments.add_comment

    comments.comment=@comment
    comments.submit_comment
    comments.edit @comment
    comments.new_comment=@comment2
    comments.cancel
    comments.edit @comment
    comments.new_comment_element.send_keys [:command, 'a']
    comments.new_comment=@comment2
    comments.edit_comment
    comments.delete @comment2
=end
    #jisc = comments.open_page(@widgets[1][:name], @widgets[1][:widget])
    
    # TEST CASE
    #assert jisc.choose_a_category_element.exist?
    
    #rss = jisc.open_page(@widgets[2][:name], @widgets[2][:widget])
    
    #TEST CASE
    #assert rss.sort_by_source_element.exist?
    
    maps = library.open_page(@widgets[3][:name], @widgets[3][:widget])
    maps.map_settings
    sleep 10
    #maps.location=@location
    #maps.add_map
    maps.save
    
    tasks = maps.open_page(@widgets[4][:name], @widgets[4][:widget])
    
    # TEST CASE HERE
    
    lti = tasks.open_page(@widgets[5][:name], @widgets[5][:widget])
    
    # TEST CASE HERE
    
    gadget = lti.open_page(@widgets[6][:name], @widgets[6][:widget])
    
    # TEST CASE HERE
    
    grades = gadget.open_page(@widgets[7][:name], @widgets[7][:widget])
    
    # TEST CASE HERE
    
    disc = grades.open_page(@widgets[8][:name], @widgets[8][:widget])
    
    # TEST CASE HERE
    
    remote = disc.open_page(@widgets[9][:name], @widgets[9][:widget])
    
    # TEST CASE HERE
    
    inline = remote.open_page(@widgets[10][:name], @widgets[10][:widget])
    
    # TEST CASE HERE
    
    tests = inline.open_page(@widgets[11][:name], @widgets[11][:widget])
    
    # TEST CASE HERE
    
    calendar = tests.open_page(@widgets[12][:name], @widgets[12][:widget])
    
    # TEST CASE HERE
    
    file = calendar.open_page(@widgets[13][:name], @widgets[13][:widget])
    
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
