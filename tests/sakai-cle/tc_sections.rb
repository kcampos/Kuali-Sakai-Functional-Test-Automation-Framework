# 
# == Synopsis
#
# This is the Sakai-CLE test case template file. Use it as the starting
# point for a new test case.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestSectionCreation < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    @user_name = @directory['person3']['id']
    @password = @directory['person3']['password']
    @site_name = @directory['site1']['name']
    
    # Test case variables
    @sections = [
      {:name=>random_string, :category=>"Lecture", :days=>["monday", "wednesday", "friday"],
        :start_time=>"10", :end_time=>"11",
        :location=>"Home Room"},
      {:name=>random_xss_string(25),:category=>"Lab", :days=>["tuesday","thursday"],
        :start_time=>"9", :end_time=>"11",
        :location=>"Lab 12", :max_enrollment=>6}
    ]
    
    @ta = @directory["person9"]["lastname"] + ", " + @directory["person9"]["firstname"]
    
    @students = [
      @directory["person2"]["lastname"] + ", " + @directory["person2"]["firstname"],
      @directory["person10"]["lastname"] + ", " + @directory["person10"]["firstname"],
      @directory["person12"]["lastname"] + ", " + @directory["person12"]["firstname"],
      @directory["person5"]["lastname"] + ", " + @directory["person5"]["firstname"],
      @directory["person13"]["lastname"] + ", " + @directory["person13"]["firstname"],
      @directory["person8"]["lastname"] + ", " + @directory["person8"]["firstname"]
    ]
    
    @total_student_count = 10
    @student_count = '5'
    
    @alert_1 = "There were problems with the last action. Please see details below."
    @alert_2 = "Students in #{@sections[1][:name]} were updated successfully!"
    @alert_3 = "#{@sections[1][:name]} now includes #{@total_student_count.to_s} students, #{@total_student_count - @sections[1][:max_enrollment]} over the Max size limit!"
    
  end
  
  def teardown
    
    @directory["site1"]["section1"] = @sections[0][:name]
    @directory["site1"]["section2"] = @sections[1][:name]
    
    # Save new assignment info for later scripts to use
    File.open("directory.yml", "w+") { |out|
      YAML::dump(@directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_section_creation
    
    # Log in to Sakai
    workspace = @sakai.page.login(@user_name, @password)
    
    # Go to test site
    home = workspace.open_my_site_by_name(@site_name)
    
    # Go to sections page
    sections = home.sections
    
    # Add a section
    lecture = sections.add_sections
    lecture.category=@sections[0][:category]
    lecture.name=@sections[0][:name]
    lecture.check_days @sections[0][:days]
    lecture.start_time=@sections[0][:start_time]
    lecture.end_time=@sections[0][:start_time] # NOT a typo.
    
    lecture = lecture.add_sections
    
    # TEST CASE: Verify you can't save a Section where start time == end time.
    assert_equal @alert_1, lecture.alert_text

    lecture.end_time=@sections[0][:end_time]
    
    sections = lecture.add_sections
    
    # TEST CASE: Section was saved and appears in the list
    assert sections.section_names.include?(@sections[0][:name])
    
    # TEST CASE: Verify scheduled time is correct
    assert_equal "#{@sections[0][:start_time]}:00 am,#{@sections[0][:end_time]}:00 am", sections.time_for(@sections[0][:name])
    
    site_editor = sections.site_editor
    site_editor.set_role(@ta, "Teaching Assistant")
    site_editor = site_editor.update_participants
    
    sections = site_editor.sections
    
    assign_tas = sections.assign_tas @sections[0][:name]
    assign_tas.available_tas=@ta
    assign_tas.assign
    
    sections = assign_tas.assign_TAs 
    
    assign_students = sections.assign_students @sections[0][:name]
    assign_students.available_students=@students[0]
    assign_students.assign
    assign_students.assign_all
    
    assign_students.assigned_students=@students[1]
    assign_students.assigned_students=@students[2]
    assign_students.assigned_students=@students[3]
    assign_students.assigned_students=@students[4]
    assign_students.assigned_students=@students[5]
    assign_students.unassign
    
    sections = assign_students.assign_students
    
    # TEST CASE: Verify TA assigned
    assert_equal @ta, sections.tas_for(@sections[0][:name])
    
    # TEST CASE: Verify section count
    assert_equal @student_count, sections.current_size_for(@sections[0][:name])
    
    lab = sections.add_sections
    lab.category=@sections[1][:category]
    lab.name=@sections[1][:name]
    lab.start_time=@sections[1][:start_time]
    lab.end_time=@sections[1][:end_time]
    lab.location=@sections[1][:location]
    lab.check_days @sections[1][:days]
    lab.select_limited_students
    
    lab = lab.add_sections
    
    # TEST CASE: Verify alert message when no student count is entered
    assert_equal @alert_1, lab.alert_text
    
    lab.max_students=@sections[1][:max_enrollment]
    
    sections = lab.add_sections
    
    # TEST CASE: Verify section appears correctly
    assert sections.section_names.include? @sections[1][:name]
    
    # TEST CASE: Verify schedule is correct
    assert_equal "#{@sections[1][:start_time]}:00 am,#{@sections[1][:end_time]}:00 am", sections.time_for(@sections[1][:name])
   
    # TEST CASE: Verify the enrollment limit shows
    assert_equal @sections[1][:max_enrollment].to_s, sections.availability_for(@sections[1][:name])
    
    assign_tas = sections.assign_tas @sections[1][:name]
    assign_tas.available_tas=@ta
    assign_tas.assign
    
    sections = assign_tas.assign_TAs 
    
    options = sections.options
    options.check_students_can_sign_up
    
    sections = options.update
    
    assign_students = sections.assign_students @sections[1][:name]
    assign_students.assign_all
    
    sections = assign_students.assign_students
    
    # TEST CASE: Verify success text
    assert_equal @alert_2, sections.success_text
    
    # TEST CASE: Verify warning text
    assert_equal @alert_3, sections.alert_text
    
    remove_students = sections.assign_students @sections[1][:name]
    remove_students.assigned_students=@students[2]
    remove_students.assigned_students=@students[3]
    remove_students.assigned_students=@students[4]
    remove_students.assigned_students=@students[5]
    remove_students.unassign
    
    sections = remove_students.assign_students
    
    # TEST CASE: Verify success text
    assert_equal @alert_2, sections.success_text
    
  end
  
end
