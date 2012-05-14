#!/usr/bin/env ruby
# 
# == Synopsis
#
# Testing Creating and Editing Lessons in a Site.
#
# Note: This script should be fixed to use programmatically generated
# test content, such as for the start and end dates of lessons.
# Currently these are hard-coded, making this test somewhat brittle.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreateLessons < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    
    # Using instructor2 and student04 for this test case
    @instructor =@directory['person4']['id']
    @ipassword = @directory['person4']['password']
    @student = @directory["person6"]["id"]
    @spassword = @directory["person6"]["password"]
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @modules = [
      {:title=>"Lesson1",:description=>"Lesson1"},
      {:title=>"Lesson2 (Expired)", :start=>"July 6, #{last_year} 08:00 AM", :end=>"July 15, #{last_year} 08:00 AM" },
      {:title=>"Lesson3-Future", :start=>"July 15, #{next_year} 08:00 AM"},
      {:title=>"Lesson4" },
      {:title=>"Lesson5" },
      {:title=>"Lesson6" }
      ]
    
    @sections =[
      {:title=>"Lesson1-Section1", :type=>"Compose content with editor", :content=>"<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />" },
      {:title=>"Lesson1-Section2", :type=>"Link to new or existing URL resource on server", :url_title=>"rsmart", :url=>"http://www.rsmart.com" },
      {:title=>"Lesson2 - Section1", :type=>"Link to new or existing URL resource on server",:url_title=>"sakai", :url=>"http://sakaiproject.org" },
      {:title=>"Lesson3-Section1", :type=>"Compose content with editor", :content=>"<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"},
      {:title=>"Lesson4-Section1", :type=>"Compose content with editor", :content=>"<h3 style=\"color: Red;\"><b>Aliquet vitae, sollicitudin et, pretium a, dolor? </b></h3> <br /> <tt>Aenean ante risus, vehicula nec, malesuada eu, laoreet sit amet, tortor. Nunc non dui vitae lectus aliquet vehicula. Vivamus dolor turpis, elementum sed, adipiscing ac, sodales vel, felis. Aenean dui nunc, placerat in, fermentum eu, commodo nec, odio. <br /> </tt> <ol>     <li>Duis sit amet lorem.</li>     <li>Maecenas nec dolor.</li>     <li>Vivamus lacus.</li>     <li>Vivamus ante. Duis vitae quam.</li> </ol> <span style=\"background-color: rgb(255, 153, 0);\">Vestibulum posuere diam quis purus dapibus et vehicula diam mollis. Sed non erat a lacus iaculis semper. Sed quis est eget ante ornare molestie vel eget mi? Mauris mollis pulvinar diam eu aliquet.</span> <b>Morbi placerat, magna metus</b>.<br /> <br />"},
      {:title=>"Lesson5-Section1", :type=>"Upload or link to a file in Resources", :file=>"resources.ppt" },
      {:title=>"Lesson6-Section1", :type=>"Upload or link to a file in Resources", :file=>"resources.mp3" },
      {:title=>"Lesson5-Section2", :type=>"Upload or link to a file in Resources", :file=>"resources.JPG" }
    ]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_lesson_creation

    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end

    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)

    # Go to test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to lessons
    lessons = home.lessons
    
    # Add a module
    new_module = lessons.add_module
    
    # Enter module attributes
    new_module.title=@modules[0][:title]
    new_module.description=@modules[0][:description]
    
    # Add a section
    confirm = new_module.add
    new_section = confirm.add_content_sections
    
    # Enter section info
    new_section.title=@sections[0][:title]
    new_section.content_type=@sections[0][:type]
    
    new_section.clear_content
    new_section.add_content=@sections[0][:content]
    confirm = new_section.add
    # Save section and add another... 
    new_section2 = confirm.add_another_section
    
    new_section2.title=@sections[1][:title]
    new_section2.content_type=@sections[1][:type]
    
    select_content = new_section2.select_url
    
    select_content.new_url=@sections[1][:url]
    select_content.url_title=@sections[1][:url_title]
    new_section2 = select_content.continue
     
    confirm = new_section2.add
     
    lessons = confirm.finish
    
    # Add another Lesson (from the past)...
    new_module2 = lessons.add_module
    new_module2.title=@modules[1][:title]
    new_module2.start_date=@modules[1][:start]
    new_module2.end_date=@modules[1][:end]
    
    confirm = new_module2.add
    
    # Add a section to the module...
    new_section3 = confirm.add_content_sections 
    new_section3.title=@sections[2][:title]
    new_section3.content_type=@sections[2][:type]
    
    select_content2 = new_section3.select_url
     
    select_content2.new_url=@sections[2][:url]
    select_content2.url_title=@sections[2][:url_title]
    
    new_section3 = select_content2.continue

    confirm = new_section3.add
    
    lessons = confirm.finish
    
    # Add another lesson (for the future)...
    new_module3 = lessons.add_module
    
    new_module3.title=@modules[2][:title]
    new_module3.start_date=@modules[2][:start]
    
    confirm = new_module3.add
    
    # Add a section to the module
    new_section4 = confirm.add_content_sections
     
    new_section4.title=@sections[3][:title]
    new_section4.content_type=@sections[3][:type]
    
    new_section4.clear_content
    new_section4.add_content=@sections[3][:content]
    
    confirm = new_section4.add
    
    lessons = confirm.finish
    
    # Add another lesson module...
    new_module4 = lessons.add_module
    new_module4.title=@modules[3][:title]
    
    confirm = new_module4.add
     
    new_section5 = confirm.add_content_sections
    new_section5.title=@sections[4][:title]
    new_section5.content_type=@sections[4][:type]
    new_section5.clear_content
    new_section5.add_content=@sections[4][:content]
    
    confirm = new_section5.add
    
    lessons = confirm.finish
    
    # Add another lesson
    new_module5 = lessons.add_module
    new_module5.title=@modules[4][:title]
    
    confirm = new_module5.add
    
    new_section6 = confirm.add_content_sections
    
    new_section6.title=@sections[5][:title]
    new_section6.content_type=@sections[5][:type]
    add_attach = new_section6.select_or_upload_file

    add_attach.select_file @sections[5][:file]

    new_section6 = add_attach.continue
    
    confirm = new_section6.add

    lessons = confirm.finish
    
    new_module6 = lessons.add_module
    new_module6.title=@modules[5][:title]
    
    confirm = new_module6.add
    
    new_section7 = confirm.add_content_sections
    
    new_section7.title=@sections[6][:title]
    new_section7.check_auditory_content
    
    new_section7.content_type=@sections[6][:type]
     
    add_attach = new_section7.select_or_upload_file
    add_attach.select_file @sections[6][:file]
    
    new_section7 = add_attach.continue
    
    confirm = new_section7.add
    
    lessons = confirm.finish
    
    #TEST CASE: Confirm all lessons and sections are listed properly
    assert frm.link(:text, @sections[0][:title]).exist?
    assert frm.link(:text, @sections[1][:title]).exist?
    assert frm.link(:text, @modules[1][:title]).exist?
    assert frm.link(:text, @sections[2][:title]).exist?
    assert frm.link(:text, @modules[2][:title]).exist?
    assert frm.link(:text, @sections[3][:title]).exist?
    assert frm.link(:text, @modules[3][:title]).exist?
    assert frm.link(:text, @sections[4][:title]).exist?
    assert frm.link(:text, @modules[4][:title]).exist?
    assert frm.link(:text, @sections[5][:title]).exist?
    assert frm.link(:text, @modules[5][:title]).exist?
    assert frm.link(:text, @sections[6][:title]).exist?

    lessons.logout
   
    workspace = @sakai.page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    lessons = home.lessons
    
    # Make sure the student's preferences for viewing are "Expanded"...
    prefs = lessons.preferences
    prefs.select_expanded
    prefs.set
    lessons = prefs.view
    
    # TEST CASE: Make sure Lessons appear, or not, for the student
    # as expected.
    assert frm.link(:text, @modules[0][:title]).exist?
    assert_equal frm.link(:text, @modules[1][:title]).exist?, false
    assert_equal frm.link(:text, @modules[2][:title]).exist?, false
    assert frm.link(:text, @modules[3][:title]).exist?
    assert frm.link(:text, @modules[4][:title]).exist?
    assert frm.link(:text, @modules[5][:title]).exist?
    
    frm.link(:text, @modules[0][:title]).click #FIXME
    
    # TEST CASE: Verify the sections are present, as expected
    assert frm.link(:text, @sections[0][:title]).exist?
    assert frm.link(:text, @sections[1][:title]).exist?
    
    frm.link(:text=>"Next").click #FIXME
    frm.link(:text=>"Next").click #FIXME
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify the section link is present
    assert frm.link(:text, @sections[4][:title])
    
    frm.link(:text=>"Prev").click #FIXME
    
    # TEST CASE: Verify the iframe for the rsmart page is present
    assert frm.frame(:id=>"iframe1").exist? #FIXME
    
    frm.link(:text=>"Table Of Contents").click #FIXME
    frm.link(:text=>@modules[4][:title]).click #FIXME
    
    # TEST CASE: Verify the section link is available
    assert frm.link(:text=>@sections[5][:title]).exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify file link is present
    assert frm.span(:id=>"viewsectionStudentform:contentResourceLinkName").exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    #TEST CASE: Verify section link is present
    assert frm.link(:text=>@sections[6][:title]).exist?
    
    frm.link(:text=>"Next").click #FIXME
    
    # TEST CASE: Verify file link is present
    assert frm.span(:id=>"viewsectionStudentform:contentResourceLinkName").exist?
  
    lessons = Lessons.new(@browser)
    
    prefs = lessons.preferences
    prefs.select_collapsed
    prefs.set
    
    lessons = prefs.view
    
    # TEST CASE: Verify collapsed view
    assert frm.link(:text=>@modules[0][:title]).exist?
    assert_equal frm.link(:text=>@sections[0][:title]).exist?, false
    assert_equal frm.span(:id=>"listmodulesStudentform:table:1:titleTxt2").text, @modules[1][:title] #FIXME

    lessons.logout
    
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    lessons = home.lessons
    
    module_5 = lessons.open_lesson @modules[4][:title]
    
    section_2 = module_5.add_content_sections
    section_2.title=@sections[7][:title]
    section_2.content_type=@sections[7][:type]
    
    attach = section_2.select_or_upload_file
    attach.select_file @sections[7][:file]
    
    section_2 = attach.continue
    
    confirm = section_2.add
    
    lessons = confirm.finish
    
    listview = lessons.view
    
    sectionview = listview.open_section @sections[7][:title]
    
    # TEST CASE: Verify the uploaded file appears
    assert frm.link(:text, @sections[7][:file]).exist?
    
    manage = sectionview.manage
    
    sort = manage.sort
    
    sort.sort_sections
    sort.sort_modules
    sort.view

    sort.logout
    
  end
  
end
