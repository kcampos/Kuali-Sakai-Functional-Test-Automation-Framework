# 
# == Synopsis
#
# Tests importing a zip file of lesson materials.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestImportLesson < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @instructor = @directory['person4']['id']
    @ipassword = @directory['person4']['password']
    @student = @directory["person6"]["id"]
    @spassword = @directory["person6"]["password"]
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables...
    @zip_file = "zips/Melete1.zip"
    @import_alert = "Imported the package successfully. Modules are created at the end of existing modules."
    @lesson_names = ["Getting Started", "Tests and Quizzes"]
    @section_names = ["The Gateway", "Sites Link", "Getting Started FAQs", "Tests FAQs"]
    @lesson_content = "Through this system, you need not create and maintain separate course web sites, discussion boards, and grade records. You can post files online for easy access by students, link to other online instructional tools, or incorporate existing course material."
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_import_lesson
    
    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to Lessons
    lessons = home.lessons
    
    # Go to the Manage page
    manage = lessons.manage
    
    # Go to the import/export page
    import = manage.import_export
    
    # File Attach
    import.upload_IMS @zip_file
    
    # TEST CASE: Verify the import occurs successfully
    assert_equal(import.alert_text, @import_alert, "Import failed")
    
    lessons = import.reset
    
    # TEST CASE: Verify imported lessons and sections appear correctly.
    assert lessons.lessons_list.include? @lesson_names[0]
    assert lessons.sections_list(@lesson_names[0]).include? @section_names[0]
    assert lessons.sections_list(@lesson_names[1]).include? @section_names[3]

    lessons.logout
    
    workspace = @sakai.page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    lessons = home.lessons
    sleep 5
    # TEST CASE: Verify student can see lessons and sections
    assert lessons.lessons_list.include?(@lesson_names[0]), "Unable to find #{@lesson_names[0]} in \n\n #{lessons.lessons_list}"
    assert lessons.sections_list(@lesson_names[0]).include?(@section_names[0]), "Unable to find #{@section_names[0]} in \n\n #{lessons.sections_list(@lesson_names[0])}"
    assert lessons.sections_list(@lesson_names[1]).include? @section_names[3]
    
    lesson = lessons.open_lesson @lesson_names[0]
    
    # TEST CASE: Verify sections appear
    assert lesson.sections_list.include? @section_names[0]
    assert lesson.sections_list.include? @section_names[1]
    assert lesson.sections_list.include? @section_names[2]
    
    section = lesson.next
    
    # TEST CASE: Verify student can see the section content
    assert_equal @lesson_names[0], section.module_title
    assert_equal @section_names[0], section.section_title
    assert section.content_include? @lesson_content
    
  end
  
end
