# 
# == Synopsis
#
# This case tests the setting up of a Course site.
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCreatingCourseSite < Test::Unit::TestCase
  
  include Utilities

  def setup

    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Save new site info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/directory.yml", "w+") { |out|
      YAML::dump(@config.directory, out)
    }
    # Close the browser window
    @browser.close
  end
  
  def test_create_site1
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    #Go to Site Setup page
    workspace = MyWorkspace.new(@browser)
    site_setup = workspace.site_setup
    
    # TEST CASE: Check the Site Setup page contents
    assert @browser.frame(:index=>0).span(:class, "instruction").text.include?("Check box(es) to take action on a site. Click column title to sort.")
    
    # TEST CASE: Check that the Edit button is not active
    # (because no sites are checked)
    assert_equal(@browser.link(:text, "Edit").exists?, false)
    
    site_type = site_setup.new
    
    # TEST CASE: Check the Site Type page
    assert @browser.text.include?("Choose the type of site you want to create.")
    
    # Select the Course Site radio button
    
    site_type.select_course_site
    
    #TEST CASE: Check that the academic term selection appeared
    assert @browser.text.include?("Academic term:")
    assert site_type.academic_term_element.visible?
    
    # Store the selected term value for use later
    term = site_type.academic_term
    
    # Click continue
    course_section = site_type.continue
    
    #TEST CASE: Check the Course/Section Information page
    assert @browser.text.include?("You have thus far selected the following course/section(s) for this course site:")
    
    # Fill in those fields, storing the entered values for later verification steps
    subject = random_string(8)
    course_section.subject = subject
    
    course = random_string(8)
    course_section.course = course
    
    section = random_string(8)
    course_section.section = section
    
    # Store site name for ease of coding and readability later
    site_name = "#{subject} #{course} #{section} #{term}"
    
    @config.directory['site1']['name'] = site_name
    
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
    course_site = course_section.continue
    
    # TEST CASE: Check the Course Site Information page
    assert @browser.text.include?("Enter basic information about the course site...")
    assert @browser.frame(:index, 0).p(:class, /shorttext/).text.include?("*\nSite Title\n#{site_name}")
    
    # Enter an invalid email address
    address = random_alphanums
    course_site.site_contact_email=address
    
    course_site.continue
    
    # TEST CASE: Check that an invalid email address is not allowed
    assert_equal course_site.alert_box_text, "Alert: #{address} is an invalid email address. The Email id must be made up of alpha numeric characters or any of !\#$&*+-=?^_`{|}~. (no spaces).", "Should have given an alert about the invalid Email."
    
    # Blank out the email field
    course_site.site_contact_email=""
    
    # Click Continue
    course_tools = course_site.continue
    
    # TEST CASE: Check the Course Site Tools page
    assert @browser.text.include?("Choose tools to include on your site...")
    
    # TEST CASE: Check that the Site Editor can't be edited
    assert(course_tools.site_editor_element.disabled?, "Site Editor checkbox is not read-only.")
    
    # TEST CASE: Check that the Home checkbox is selected by default
    assert course_tools.home_checked?
    # TEST CASE: Check that the Announcements checkbox is NOT checked by default
    assert_equal(course_tools.announcements_checked?, false)
    # TEST CASE: Check that "No, thanks" is selected by default
    assert course_tools.no_thanks_selected?
    
    #Check All Tools
    course_tools.check_all_tools
    
    #TEST CASE: Check that the All Tools checkbox worked
    assert course_tools.announcements_checked?
    
    add_tools = course_tools.continue
    
    # TEST CASE: Check the Add Multiple Tool page
    assert @browser.text.include?("Add multiple tool instances or configure tool options.")
    
    # Click the continue button
    @browser.frame(:index=>0).button(:name, "Continue").click
    
    # TEST CASE: Site email address is required to continue
    assert @browser.text.include?("Alert: Please specify an email address for Email Archive tool.")
    
    # Create a random email address and store the string for later
    email_address = random_alphanums
    
    add_tools.site_email_address = email_address
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
    
    review = access.continue
    
    # TEST CASE: Verify the text on the Review page
    assert @browser.text.include?("Please review the following information about your site.")
    assert @browser.text.include?("#{site_name}"), "Review page not showing site name #{site_name}"

    review.request_site
    
    # Create a string that will match the new Site's "creation date" string
    creation_date = @sakai.make_date(Time.now)
    
    #Sort the list of sites so the newest site appears at the top
    2.times { @browser.frame(:index=>0).link(:href, /criterion=created%20on&panel=Main&sakai_action=doSort_sites/).click }
    
    link_text = @browser.frame(:index=>0).link(:href=>/xsl-portal.site/, :index=>0).text
    
    #TEST CASE: Verify the creation of the site by the name
    assert_equal(link_text, site_name, "#{link_text} does not match #{site_name}")
    
    #TEST CASE: Verify the creation date
    # Fix this code later. It's buggy...
    #begin
    #  assert @browser.text.include?("#{creation_date}")
    #rescue 
    #  assert @browser.text.include?("#{@sakai.make_date(Time.now)}"), "Could not find a site with a creation date of #{creation_date} or #{@sakai.make_date(Time.now)}"
    #end
    
    # Get the site id for storage
    @browser.frame(:index=>0).link(:href=>/xsl-portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
    @config.directory['site1']['id'] = $~.to_s
    
  end
  
end
