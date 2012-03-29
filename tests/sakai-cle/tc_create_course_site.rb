# 
# == Synopsis
#
# This case tests the setting up of a Course site.
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestCreatingCourseSite < Test::Unit::TestCase
  
  include Utilities

  def setup

    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @user_name = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @subject = random_string(8)
    @course = random_string(8)
    @section = random_string(8)
    @authorizer = "admin"
    @web_content_source = "http://www.rsmart.com"
    @bad_address = random_string(32)
    @email=random_nicelink(32)
    @joiner_role = "Student"
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @choose_site_text = "Choose the type of site you want to create."
    @course_text = "You have thus far selected the following course/section(s) for this course site:"
    #@authorizer_alert = "Alert: Please enter the authorizers {0}."
    @username_alert = "Alert: Please enter a valid Username for the instructor of record."
    @basic_info_text = "Enter basic information about the course site..."
    @invalid_email_alert = "Alert: #{@bad_address} is an invalid email address. The Email id must be made up of alpha numeric characters or any of !\#$&*+-=?^_`{|}~. (no spaces)."
    @choose_tools_text = "Choose tools to include on your site..."
    @multiple_tools_text = "Add multiple tool instances or configure tool options."
    @archive_alert = "Alert: Please specify an email address for Email Archive tool."
    @review_text = "Please review the following information about your site."
    
  end
  
  def teardown
    # Save new site info for later scripts to use
    File.open("#{File.dirname(__FILE__)}/../../config/CLE/directory.yml", "w+") { |out|
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
    assert @browser.text.include?(@choose_site_text)
    
    # Select the Course Site radio button
    
    site_type.select_course_site
    
    #TEST CASE: Check that the academic term selection appeared
    assert site_type.academic_term_element.visible?
    
    # Store the selected term value for use later
    term = site_type.academic_term_element.value
    
    # Click continue
    course_section = site_type.continue

    #TEST CASE: Check the Course/Section Information page
    assert @browser.text.include?(@course_text), "Course text not found:\n#{@course_text}"
    
    # Fill in those fields, storing the entered values for later verification steps
    course_section.subject = @subject
    
    course_section.course = @course
    
    course_section.section = @section
    
    # Store site name for ease of coding and readability later
    site_name = "#{@subject} #{@course} #{@section} #{term}"
    
    @config.directory['site1']['name'] = site_name
    
    # Click continue button
    #course_section.continue
    
    # TEST CASE: Check that authorizer is required.
    #assert @browser.text.include?(@authorizer_alert)
    
    # Add an invalid authorizer
    #course_section.authorizers_username=random_alphanums
    
    # Click continue button
    #course_section.continue
    
    # TEST CASE: Check that authorizer's name must be valid
    #assert @browser.text.include?(@username_alert)
    
    # Add a valid instructor id
    #course_section.authorizers_username=@authorizer
    
    # Click continue button
    course_site = course_section.continue
    
    # TEST CASE: Check the Course Site Information page
    assert @browser.text.include?(@basic_info_text)
    
    # Enter an invalid email address
    course_site.site_contact_email=@bad_address

    course_site.continue
    sleep 1
    # TEST CASE: Check that an invalid email address is not allowed
    assert_equal @invalid_email_alert, course_site.alert_box_text
    
    # Blank out the email field
    course_site.site_contact_email=""
    
    # Click Continue
    course_tools = course_site.continue
    
    # TEST CASE: Check the Course Site Tools page
    assert @browser.text.include?(@choose_tools_text)
    
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
    assert @browser.text.include?(@multiple_tools_text)
    
    # Click the continue button
    @browser.frame(:index=>0).button(:name, "Continue").click
    
    # TEST CASE: Site email address is required to continue
    assert @browser.text.include?(@archive_alert)
    
    add_tools.site_email_address = @email
    add_tools.web_content_source=@web_content_source
    
    # Click the Continue button
    # Note that I am calling this element directly rather than using its Class definition
    # because of an inexplicable ObsoleteElementError occuring in Selenium-Webdriver
    @browser.frame(:index=>0).button(:name, "Continue").click
    
    access = SiteAccess.new(@browser)
    
    # TEST CASE: Joiner Role selection list is not visible by default
    assert_equal false, access.joiner_role_div.visible?
    
    access.select_allow
    access.joiner_role=@joiner_role
    
    review = access.continue
    sleep 5
    
    # TEST CASE: Verify the text on the Review page
    assert @browser.text.include?(@review_text)
    #assert @browser.text.include?("#{site_name}"), "Review page not showing site name #{site_name}"

    site_setup = review.request_site
    
    # Create a string that will match the new Site's "creation date" string
    creation_date = @sakai.make_date(Time.now)
    
    site_setup.search(Regexp.escape(@subject))

    link_text = @browser.frame(:class=>"portletMainIframe").link(:href=>/xsl-portal.site/, :index=>0).text #FIXME
    
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
    @browser.frame(:class=>"portletMainIframe").link(:href=>/xsl-portal.site/, :index=>0).href =~ /(?<=\/site\/).+/
    @config.directory['site1']['id'] = $~.to_s
    
  end
  
end
