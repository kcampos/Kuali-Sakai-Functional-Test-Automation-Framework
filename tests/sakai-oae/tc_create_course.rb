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
      :title=>random_alphanums,
      :description=>random_string,
      :tags=>random_string
    }
    
    @new_document = {:name=>random_alphanums, :visible=>"Public", :pages=>"3"}
    @existing_document = {:name=>"Tests and Quizzes", :title=>"Existing Doc", :visible =>"Participants only", :example_content=>"Real and Hyperreal Numbers" }
    @participant_list = {:name=>random_alphanums, :visible=>"Public"}
    @content_library = {:name=>random_alphanums, :visible=>"Public"}
    @widgets = [
      {:name=>random_alphanums,:widget=>"Comments",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"JISC content",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"RSS feed reader",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Google maps",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Assignments",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Basic LTI",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Google Gadget",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Gradebook",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Discussion",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Remote content",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Inline Content",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Tests and Quizzes",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Calendar",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Files and documents",:visible=>"Public"}
    ]
    @participant="Cynthia Wines"
    @doc_header=random_alphanums(32)
    @comment=random_alphanums + " This is radio clash on pirate satellite"
    @comment2=random_alphanums + " Orbiting your living room"
    @location="1375 N Scottsdale Rd, Scottsdale, AZ 85257, USA"
    
    @url_error_text="This URL has been taken"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_course
    
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    dashboard.add_widget
    dashboard.add_all_widgets
    
    @existing_course_title = dashboard.recent_membership_item
    
    create_course = dashboard.create_a_course
    
    new_course_info = create_course.use_basic_template
    
    new_course_info.title=@existing_course_title
    new_course_info.create_basic_course
    
    # TEST CASE: Verify creation of duplicate title not allowed
    assert_equal @url_error_text, new_course_info.url_error
    
    new_course_info.title=@course_info[:title]
    new_course_info.description=@course_info[:description]
    new_course_info.tags=@course_info[:tags]
    
    library = new_course_info.create_basic_course
    
    library.add_new_area
    library.new_doc_name=@new_document[:name]
    library.new_doc_permissions=@new_document[:visible]
    library.number_of_pages=@new_document[:pages]
    library.done_add
    
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
    
    # TEST CASE: Verify the new course is in My Memberships
    assert dashboard.my_memberships_list.include?(@course_info[:title]), "Expected course title: #{@course_info[:title]}\n\nList in My memberships:\n\n#{dashboard.my_memberships_list.join("\n")}"

    membership = dashboard.my_memberships

    library = membership.go_to @course_info[:title]

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
    library.add_contact_by_search @participant
    library.save

    participants = library.open_page("Participants", "participants")

    # TEST CASE: Participants search field appears
    assert participants.search_participants_element.visible?

    participants.expand @new_document[:name]
    document = participants.open_page("Page 1", "document")

    document.edit_page
    document.select_all
    document.add_content=@doc_header
    document.select_all
    document.format="Heading 1"
    document.font="Comic Sans MS"
    document.save
    sleep 2 #FIXME

    # TEST CASE: Updated document text appears
    assert @browser.text.include? @doc_header #FIXME - Try to improve this later.
    
    existing = document.open_page(@existing_document[:title], "tests and quizzes")
    
    # TEST CASE: Existing document is as expected
    assert existing.tests_frame.exists?
    
    party = existing.open_page(@participant_list[:name], "participants")

    # TEST CASE: Participants panel appears
    assert party.search_participants_element.exists?

    content = party.open_page(@content_library[:name], "library")
    
    # TEST CASE: Library page is empty
    assert @browser.div(:id=>"mylibrary_empty").exists?

    comments = content.open_page(@widgets[0][:name], @widgets[0][:widget])

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

    jisc = comments.open_page(@widgets[1][:name], @widgets[1][:widget])
    
    # TEST CASE: JISC frame appears correctly
    assert jisc.jisc_frame.exists?
    
    rss = jisc.open_page(@widgets[2][:name], @widgets[2][:widget])
    
    #TEST CASE: RSS Page appears correctly
    assert rss.sort_by_source_element.exists?

    maps = library.open_page(@widgets[3][:name], @widgets[3][:widget])

    maps.map_settings
    maps.location=@location
    maps.search
    maps.add_map
    maps.save

    # TEST CASE: Map location is updated as specified
    assert maps.map_frame.html.include? @location

    tasks = maps.open_page(@widgets[4][:name], @widgets[4][:widget])
    
    # TEST CASE: Assignments frame exists.
    assert tasks.cle_frame.exists?
    
    lti = tasks.open_page(@widgets[5][:name], @widgets[5][:widget])
    
    # TEST CASE: LTI URL field is present
    assert lti.url_element.visible?
    
    gadget = lti.open_page(@widgets[6][:name], @widgets[6][:widget])
    
    # TEST CASE: Gadget frame exists
    assert gadget.gadget_frame.exists?
    
    grades = gadget.open_page(@widgets[7][:name], @widgets[7][:widget])
    
    # TEST CASE: Gradebook frame exists
    assert grades.gradebook_frame.exists?
    
    disc = grades.open_page(@widgets[8][:name], @widgets[8][:widget])
    
    # TEST CASE: "Add new topic" button exists
    assert disc.add_new_topic_element.exists?
    
    remote = disc.open_page(@widgets[9][:name], @widgets[9][:widget])
    
    # TEST CASE: Remote frame exists
    assert remote.remote_frame.exists?
    
    inline = remote.open_page(@widgets[10][:name], @widgets[10][:widget])
    
    # TEST CASE: Year field is present
    assert inline.year_element.exists?
    
    tests = inline.open_page(@widgets[11][:name], @widgets[11][:widget])
    
    # TEST CASE: Assessments frame exists?
    assert tests.tests_frame.exists?
    
    calendar = tests.open_page(@widgets[12][:name], @widgets[12][:widget])
    
    # TEST CASE: Calendar frame exists?
    assert calendar.calendar_frame.exists?
    
    file = calendar.open_page(@widgets[13][:name], @widgets[13][:widget])
    file.files_settings
    
    # TEST CASE: Verify the Files and Documents pop-up
    assert file.name_element.visible?

  end
  
end
