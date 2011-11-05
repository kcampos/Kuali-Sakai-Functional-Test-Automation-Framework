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
    
    @assignments = [
      {:title=>"CR Assignment 1", :open_hour=>last_hour, :open_meridian=>"AM", :student_submissions=>"Inline only", :grade_scale=>"Points", :max_points=>"25", :instructions=>"Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor." },
      {:title=>"CR Assignment 2", :open_hour=>last_hour, :open_meridian=>"AM", :student_submissions=>"Inline only", :grade_scale=>"Points", :max_points=>"25", :instructions=>random_xss_string},
      {:title=>"CR Assignment 3",}
    ]
    
    @file_name = "resources.doc"
    @item_condition = "grade is greater than or equal to:"
    @assignment_grade = "20"
    
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
    assignment1.title=@assignments[0][:title]
    assignment1.open_hour=@assignments[0][:open_hour]
    assignment1.open_meridian=@assignments[0][:open_meridian]
    assignment1.student_submissions=@assignments[0][:student_submissions]
    assignment1.grade_scale=@assignments[0][:grade_scale]
    assignment1.max_points=@assignments[0][:max_points]
    assignment1.select_add_to_gradebook
    assignment1.instructions=@assignments[0][:instructions]
    
    assignments = assignment1.post
    
    # TEST CASE: Verify assignment posted
    assert assignments.assignments_titles.include? @assignments[0][:title]
    
    assignment2 = assignments.add
    assignment2.title=@assignments[1][:title]
    assignment2.open_hour=@assignments[1][:open_hour]
    assignment2.open_meridian=@assignments[1][:open_meridian]
    assignment2.student_submissions=@assignments[1][:student_submissions]
    assignment2.grade_scale=@assignments[1][:grade_scale]
    assignment2.max_points=@assignments[1][:max_points]
    assignment2.check_allow_resubmission
    assignment2.select_add_to_gradebook
    assignment2.instructions=@assignments[1][:instructions]
    assignment2.check_add_due_date
    
    assignments = assignment2.post
    
    # TEST CASE: Verify the second assignment posted
    assert assignments.assignments_titles.include? @assignments[1][:title]
    
    assignments = assignments.duplicate_assignment @assignments[0][:title]
    
    # TEST CASE: Verify duplication of assignment
    assert assignments.assignments_titles.include? "Draft - #{@assignments[0][:title]} - Copy"
    
    assignment3 = assignments.edit_assignment "Draft - #{@assignments[0][:title]} - Copy"
    assignment3.title=@assignments[2][:title]
    
    assignments = assignment3.post
    
    # TEST CASE: Verify the second assignment posted
    assert assignments.assignments_titles.include? @assignments[2][:title]
    assert_equal assignments.assignments_titles.include?("Draft - #{@assignments[0][:title]} - Copy"), false
    
    gradebook = assignments.gradebook
    
    # TEST CASE: Verify all assignments appear in the gradebook
    assert gradebook.items_titles.include? @assignments[0][:title]
    assert gradebook.items_titles.include? @assignments[1][:title]
    assert gradebook.items_titles.include? @assignments[2][:title]
    
    # Create Resources for CR testing
    resources = gradebook.resources
    
    file_details = resources.edit_details @file_name
    file_details.check_show_only_if_condition
    file_details.gradebook_item="#{@assignments[0][:title]} (#{@assignments[0][:max_points]}.0 points)"
    file_details.item_condition=@item_condition
    file_details.assignment_grade=@assignment_grade
    file_details.update
    
    # Shouldn't there be a test of this conditional, now?
    
  end
  
end
