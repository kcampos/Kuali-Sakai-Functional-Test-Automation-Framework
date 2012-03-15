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
# courses, which contain content. See lines 30, 31, and 42.
# At least one other "participant" in the site, visible to the admin/instructor
# user. See line 61.
# 
# Author: Abe Heward (aheward@rSmart.com)
$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")
["rspec", "watir-webdriver", "../../config/OAE/config.rb",
  "utilities", "sakai-OAE/app_functions",
  "sakai-OAE/page_elements" ].each { |item| require item }

describe "Create Course" do
  
  include Utilities

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

    dashboard.add_widget
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
    library = Library.new @browser
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
    library = Library.new @browser
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
    library = Library.new @browser
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
    @browser.text.should include @doc_header #FIXME - Try to improve this later by defining the containing div.
  end
  
  it "pages appear as expected" do
    document = ContentDetailsPage.new @browser
    existing = document.open_tests_and_quizzes @existing_document[:title]
    
    # TEST CASE: Existing document is as expected
    existing.tests_frame.should exist
    
    party = existing.open_participants @participant_list[:name]

    # TEST CASE: Participants panel appears
    party.search_participants_element.should exist

    content = party.open_library @content_library[:name]
    
    # TEST CASE: Library page is empty
    content.empty_library_element.should be_visible
  end

  it "the comments page works as expected" do
    content = Library.new @browser
    comments = content.open_comments @widgets[0][:name]

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

  it "JISC page is as expected" do
    comments = Comments.new @browser
    jisc = comments.open_jisc @widgets[1][:name]
    
    # TEST CASE: JISC frame appears correctly
    jisc.jisc_frame.should exist
  end
  
  it "RSS Feed page is as expected" do
    jisc = JISC.new @browser
    rss = jisc.open_rss_feed @widgets[2][:name]
    
    #TEST CASE: RSS Page appears correctly
    rss.sort_by_source_element.should exist
  end
  
  it "Google Maps page is as expected" do
    library = Library.new @browser
    maps = library.open_map @widgets[3][:name]

    maps.map_settings
    maps.location=@location
    maps.search
    maps.add_map
    maps.save

    # TEST CASE: Map location is updated as specified
    maps.map_frame.html.should include @location
  end

  it "Tasks page is as expected" do
    maps = GoogleMaps.new @browser
    tasks = maps.open_assignments @widgets[4][:name]
    
    # TEST CASE: Assignments frame exists.
    tasks.cle_frame.should exist
  end
  
  it "lti page is as expected" do
    tasks = Assignments.new @browser
    lti = tasks.open_lti @widgets[5][:name]
    
    # TEST CASE: LTI URL field is present
    lti.url_element.should be_visible
  end
  
  it "Gadget page is as expected" do
    lti = LTI.new @browser
    gadget = lti.open_gadget @widgets[6][:name]
    
    # TEST CASE: Gadget frame exists
    gadget.gadget_frame.should exist
  end
  
  it "gradebook page is as expected" do
    gadget = Gadget.new @browser
    grades = gadget.open_gradebook @widgets[7][:name]
    
    # TEST CASE: Gradebook frame exists
    grades.gradebook_frame.should exist
  end
  
  it "discussion page is as expected" do
    grades = Gradebook.new @browser
    disc = grades.open_discussions @widgets[8][:name]
    
    # TEST CASE: "Add new topic" button exists
    disc.add_new_topic_element.should exist
  end
  
  it "remote content page is as expected" do
    disc = Discussions.new @browser
    remote = disc.open_remote_content @widgets[9][:name]
    
    # TEST CASE: Remote frame exists
    remote.remote_frame.should exist
  end
  
  it "stuff" do
    remote = Remote.new @browser
    inline = remote.open_page(@widgets[10][:name], @widgets[10][:widget])
    
    # TEST CASE: Year field is present
    inline.year_element.should exist
    
    tests = inline.open_page(@widgets[11][:name], @widgets[11][:widget])
    
    # TEST CASE: Assessments frame exists?
    tests.tests_frame.should exist
    
    calendar = tests.open_page(@widgets[12][:name], @widgets[12][:widget])
    
    # TEST CASE: Calendar frame exists?
    calendar.calendar_frame.should exist
    
    file = calendar.open_page(@widgets[13][:name], @widgets[13][:widget])
    file.files_settings
    
    # TEST CASE: Verify the Files and Documents pop-up
    file.name_element.should be_visible

  end

  after :all do
    # Close the browser window
    @browser.close
  end
   
end
