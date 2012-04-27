#!/usr/bin/env ruby
# 
# == Synopsis
#
# Tests the creation of a new Course, adding all widgets and smoke checking
# their basic functionality.
#
# == Prerequisites
#
# An admin user or an 'instructor' user who is in multiple existing
# courses, which contain content. See lines 28, 29, and 40.
# At least one other "participant" in the site, visible to the admin/instructor
# user. See line 58.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Create Course" do
  
  include Utilities

  let(:library) { Library.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['admin']['username']
    @ipassword = @config.directory['admin']['password']
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @course_info = {
      :title=>random_alphanums,
      :description=>random_string,
      :tags=>random_string
    }
    
    @new_document = {:name=>random_alphanums, :visible=>"Public", :pages=>"3"}
    @existing_document = {:name=>"References", :title=>"Existing Doc", :visible =>"Participants only", :example_content=>"Research holding the torch of knowledge" }
    @participant_list = {:name=>random_alphanums, :visible=>"Public"}
    @content_library = {:name=>random_alphanums, :visible=>"Public"}
    @widgets = [
      {:name=>random_alphanums,:widget=>"Comments",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"RSS feed reader",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Google maps",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Assignments",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Basic LTI",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Google Gadget",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Gradebook",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Discussion",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Remote content",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Tests and Quizzes",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Calendar",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Forum",:visible=>"Public"},
      {:name=>random_alphanums,:widget=>"Files and documents",:visible=>"Public"}
    ]
    @participant="#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @doc_header=random_alphanums(32)
    @comment=random_multiline(30, 5)
    @comment2=random_multiline(20, 5)
    @location="1375 N Scottsdale Rd, Scottsdale, AZ 85257, USA"
    
    @url_error_text="This URL has been taken"
    
  end

  it "prevents creation of duplicate course title" do 
    # Log in to Sakai
    dashboard = @sakai.login(@instructor, @ipassword)

    dashboard.add_widgets
    dashboard.add_all_widgets
    
    @existing_course_title = dashboard.recent_membership_item
    
    create_course = dashboard.create_a_course
    
    new_course_info = create_course.use_basic_template
    
    new_course_info.title=@existing_course_title
    new_course_info.create_basic_course
    
    # TEST CASE: Verify creation of duplicate title not allowed
    new_course_info.url_error.should == @url_error_text
  end
  
  it "creates new course" do
    new_course_info = CreateGroups.new @browser
    new_course_info.title=@course_info[:title]
    new_course_info.description=@course_info[:description]
    new_course_info.tags=@course_info[:tags]
    
    new_course_info.create_basic_course
  end
  
  it "adds areas to the course" do
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
      lambda { library.add_widget widget }.should_not raise_error
    end
  end
  
  it "new course appears in My Memberships" do
    dashboard = library.my_dashboard
    # TEST CASE: Verify the new course is in My Memberships
    dashboard.my_memberships_list.should include @course_info[:title]
  end

  it "course pages appear as expected" do
    dashboard = MyDashboard.new @browser
    membership = dashboard.my_memberships

    library = membership.go_to @course_info[:title]

    # TEST CASE: Verify pages are present
    library.public_pages.should include @new_document[:name]
    library.public_pages.should include @existing_document[:title]
    library.public_pages.should include @participant_list[:name]
    library.public_pages.should include @content_library[:name]
    
    @widgets.each do |widget|
      # TEST CASE: Verify all widgets appear in the list of pages.
      library.public_pages.should include widget[:name] 
    end
  end

  it "participants can be added to course" do
    library.manage_participants
    library.add_contact_by_search @participant
    library.save

    participants = library.open_participants("Participants")

    # TEST CASE: Participants search field appears
    participants.search_participants_element.should be_visible
  end

  it "library document is editable" do
    participants = Participants.new @browser
    participants.expand @new_document[:name]
    document = participants.open_document("Page 1")

    document.edit_page
    document.select_all
    document.add_content=@doc_header
    document.select_all
    document.format="Heading 1"
    document.font="Comic Sans MS"
    document.save
    sleep 2 #FIXME

    # TEST CASE: Updated document text appears
    @browser.text.should include @doc_header #TODO - Try to improve this later by defining the containing div.
  end
  
  it "pages appear as expected" do
    existing = library.open_tests_and_quizzes @existing_document[:title]
    
    # TEST CASE: Existing document is as expected
    existing.text.should include @existing_document[:example_content]
    
    party = existing.open_participants @participant_list[:name]

    # TEST CASE: Participants panel appears
    party.search_participants_element.should exist

    content = party.open_library @content_library[:name]
    
    # TEST CASE: Library page is empty
    content.empty_library_element.should be_visible
  end

  it "the comments page works as expected" do
    comments = library.open_comments @widgets[0][:name]

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
    lambda {comments.delete @comment2}.should_not raise_error
  end

  it "RSS Feed page is as expected" do
    rss = library.open_rss_feed @widgets[1][:name]
    
    #TEST CASE: RSS Page appears correctly
    rss.sort_by_source_element.should exist
  end
  
  it "Google Maps page is as expected" do
    maps = library.open_map @widgets[2][:name]

    maps.map_settings
    maps.location=@location
    maps.search
    maps.add_map
    maps.save
    sleep 1 # Wait a bit for the map to re-constitute itself
    # TEST CASE: Map location is updated as specified
    maps.map_frame.html.should include @location
  end

  it "Tasks page is as expected" do
    tasks = library.open_assignments @widgets[3][:name]
    
    # TEST CASE: Assignments frame exists.
    tasks.assignments_frame.should be_visible
  end
  
  it "lti page is as expected" do
    lti = library.open_lti @widgets[4][:name]
    
    # TEST CASE: LTI URL field is present
    lti.url_element.should be_visible
  end
  
  it "Gadget page is as expected" do
    gadget = library.open_gadget @widgets[5][:name]
    
    # TEST CASE: Gadget frame exists
    gadget.gadget_frame.should be_visible
  end
  
  it "gradebook page is as expected" do
    grades = library.open_gradebook @widgets[6][:name]
    
    # TEST CASE: Gradebook frame exists
    grades.gradebook_frame.should be_visible
  end
  
  it "discussion page is as expected" do
    disc = library.open_discussions @widgets[7][:name]
    
    # TEST CASE: "Add new topic" button exists
    disc.add_new_topic_element.should be_visible
  end
  
  it "remote content page is as expected" do
    remote = library.open_remote_content @widgets[8][:name]
    
    # TEST CASE: Remote frame exists
    remote.remote_frame.should be_visible
  end
  
  it "Tests & Quizzes page is as expected" do
    tests = library.open_tests_and_quizzes(@widgets[9][:name])
    tests.execute_script("$('div#basiclti_main_container').css('style', 'block')")
    tests.linger_for_ajax
    # TEST CASE: Assessments frame exists?
    tests.tests_frame.should be_visible
  end

  it "Calendar page is as expected" do
    calendar = library.open_calendar(@widgets[10][:name])
    
    # TEST CASE: Calendar frame exists?
    calendar.calendar_frame.should be_visible
  end

  it "Files and Documents page appears as expected" do
    file = library.open_file(@widgets[12][:name])
    file.files_settings
    
    # TEST CASE: Verify the Files and Documents pop-up
    file.name_element.should be_visible
  end

  it "Forum page appears as expected" do
    forum = library.open_forum(@widgets[11][:name])
    forum.forum_frame.should be_visible
  end

  after :all do
    # Close the browser window
    @browser.close
  end
   
end
