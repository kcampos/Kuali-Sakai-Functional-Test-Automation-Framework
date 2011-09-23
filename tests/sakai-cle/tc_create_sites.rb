# 
# == Synopsis
#
# This case sets up a Site for testing
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCreatingSites < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @user_name = config.directory['admin']['username']
    @password = config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_create_sites
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    #Go to Site Setup page
    workspace = MyWorkspace.new(@browser)
    workspace.site_setup
    
    # TEST CASE: Check the Site Setup page contents
    assert @browser.frame(:index=>0).span(:class, "instruction").text.include?("Check box(es) to take action on a site. Click column title to sort.")
    
    # TEST CASE: Check that the Edit button is not active
    # (because no sites are checked)
    assert_equal(@browser.link(:text, "Edit").exists?, false)
    
    site_setup = SiteSetup.new(@browser)
    site_setup.new
    
    # TEST CASE: Check the Site Type page
    assert @browser.text.include?("Choose the type of site you want to create.")
    
    site_type = SiteType.new(@browser)
    # Select the Course Site radio button
    site_type.select_course_site
    
    #TEST CASE: Check that the academic term selection appeared
    assert @browser.text.include?("Academic term:")
    assert site_type.academic_term_element.visible?
    
    site_type.continue
    
    #TEST CASE: Check the Course/Section Information page
    assert @browser.text.include?("You have thus far selected the following course/section(s) for this course site:")
    
    course_section = CourseSectionInfo.new(@browser)
    
    # Fill in those fields
    course_section.subject='1'
    course_section.course='2'
    course_section.section='3'
    
    # Click continue button
    course_section.continue
    
    # TEST CASE: Check that authorizer is required.
    assert @browser.text.include?("Alert: Please enter the authorizers {0}.")
    
    # Add an invalid authorizer
    course_section.authorizers_username=random_alphanums
    
    # Click continue button
    course_section.continue
    
    # TEST CASE: Check that authorizer's name must be valid
    assert @browser.text.include?("Alert: Please enter a valid Username for the instructor of record.")
    
    # Add a valid instructor id
    course_section.authorizers_username="admin"
    
    # Click continue button
    course_section.continue
    
    # TEST CASE: Check the Course Site Information page
    assert @browser.text.include?("Enter basic information about the course site...")
    
    course_site = CourseSiteInfo.new(@browser)
    
    # Enter an invalid email address
    address = random_alphanums
    course_site.site_contact_email=address
    
    course_site.continue
    
    # TEST CASE: Check that an invalid email address is not allowed
    assert @browser.text.include?("Alert: #{address} is an invalid email address."), "Should have given an alert about the invalid Email."
    
    # Blank out the email field
    course_site.site_contact_email=""
    
    # Click Continue
    course_site.continue
    
    # TEST CASE: Check the Course Site Tools page
    assert @browser.text.include?("Choose tools to include on your site...")
    
    course_tools = CourseSiteTools.new(@browser)
    
    # TEST CASE: Check that the Site Editor can't be edited
    assert(course_tools.site_editor_cb_element.disabled?, "Site Editor checkbox is not read-only.")
    
    # TEST CASE: Check that the Home checkbox is selected by default
    assert course_tools.home_cb_checked?
    # TEST CASE: Check that the Announcements checkbox is NOT checked by default
    assert_equal(course_tools.announcements_cb_checked?, false)
    # TEST CASE: Check that "No, thanks" is selected by default
    assert course_tools.no_thanks_selected?
    
    #Check All Tools
    course_tools.check_all_tools_cb
    
    #TEST CASE: Check that the All Tools checkbox worked
    assert course_tools.announcements_cb_checked?
    
    course_tools.continue
    
    # TEST CASE: Check the Add Multiple Tool page
    assert @browser.text.include?("Add multiple tool instances or configure tool options.")
    
    # Click the continue button
    @browser.frame(:index=>0).button(:name, "Continue").click
    
    # TEST CASE: Site email address is required to continue
    assert @browser.text.include?("Alert: Please specify an email address for Email Archive tool.")
    
    add_tools = AddMultipleTools.new(@browser)
    add_tools.site_email_address=random_alphanums
    add_tools.web_content_source="http://www.rsmart.com"
    
    # Click the Continue button
    # Note that I am calling this element directly rather than using its Class definition
    # because of an inexplicable ObsoleteElementError occuring in Selenium-Webdriver
    @browser.frame(:index=>0).button(:name, "Continue").click
    
    access = CourseSiteAccess.new(@browser)
    
    # TEST CASE: Joiner Role selection list is not visible by default
    assert_equal(access.joiner_role_element.visible?, false)
    access.select_allow
    access.joiner_role="Student"
    
    access.continue
    
    # TEST CASE: Verify the text on the Review page
    assert @browser.text.include?("Please review the following information about your site.")
    
    review = SiteSetupReview.new(@browser)
    review.request_site
    
    #TEST CASE: 
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
