# 
# == Synopsis
#
# Tests Assignments, Gradebook, and Resources while the Conditional Release option
# is set to TRUE.
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestConditionalRelease < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    
  end
  
  def test_conditional_release
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)

    home = workspace.open_my_site_by_id(@site_id)
    
    assignments = home.assignments

    assignment1 = assignments.add
    assignment1.title="CR Assignment 1"
    assignment1.open_hour=last_hour
    assignment1.open_meridian="AM"
    assignment1.student_submissions="Inline only"
    assignment1.grade_scale="Points"
    assignment1.max_points="25"
    assignment1.select_add_to_gradebook
    instruction_text="Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."
    assignment1.instructions=instruction_text
    
    assignments = assignment1.post
    
    # TEST CASE: Verify assignment posted
    assert assignments.assignments_titles.include? "CR Assignment 1"
    
    assignment2 = assignments.add
    assignment2.title="CR Assignment 2"
    assignment2.open_hour=last_hour
    assignment2.open_meridian="AM"
    assignment2.student_submissions="Inline only"
    assignment2.grade_scale="Points"
    assignment2.max_points="25"
    assignment2.check_allow_resubmission
    assignment2.select_add_to_gradebook
    assignment2.instructions=instruction_text
    assignment2.check_add_due_date
    
    assignments = assignment2.post
    
    # TEST CASE: Verify the second assignment posted
    assert assignments.assignments_titles.include? "CR Assignment 2"
    
    assignments = assignments.duplicate_assignment "CR Assignment 1"
    
    # TEST CASE: Verify duplication of assignment
    assert assignments.assignments_titles.include? "Draft - CR Assignment 1 - Copy"
    
    assignment3 = assignments.edit_assignment "Draft - CR Assignment 1 - Copy"
    assignment3.title="CR Assignment 3"
    
    assignments = assignment3.post
    
    # TEST CASE: Verify the second assignment posted
    assert assignments.assignments_titles.include? "CR Assignment 3"
    assert_equal assignments.assignments_titles.include?("Draft - CR Assignment 1 - Copy"), false
    
    gradebook = assignments.gradebook
    
    # TEST CASE: Verify all assignments appear in the gradebook
    assert gradebook.items_titles.include? "CR Assignment 1"
    assert gradebook.items_titles.include? "CR Assignment 2"
    assert gradebook.items_titles.include? "CR Assignment 3"
    
    # Create Resources for CR testing
    resources = gradebook.resources
    
    file_details = resources.edit_details "resources.doc"
    file_details.check_show_only_if_condition
    file_details.gradebook_item="CR Assignment 1 (25.0 points)"
    file_details.item_condition="grade is greater than or equal to:"
    file_details.assignment_grade="20"
    file_details.update
    
    # Shouldn't there be a test of this conditional, now?
    
  end
  
end
