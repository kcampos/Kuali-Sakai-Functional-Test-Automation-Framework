# coding: UTF-8
# 
# == Synopsis
#
# 
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestAnnouncements < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    @instructor = config.directory['person3']['id']
    @ipassword = config.directory['person3']['password']
    @student = config.directory['person1']['id']
    @spassword = config.directory['person1']['password']
    @sakai = SakaiCLE.new(@browser)
    @site_name = config.directory["site1"]["name"]
    @site_id = config.directory["site1"]["id"]
    
    # Test Case Variables
    @announcement_1_title = random_string(64)
    @announcement_1_body = "<h3 style=\"color: Red;\">Integer commodo nibh ut dui elementum ut tempor ligula adipiscing.</h3> Mauris sollicitudin nulla at lectus dapibus elementum. Etiam lectus nibh, imperdiet molestie convallis id, convallis vel nisl. Suspendisse potenti. In ullamcorper commodo risus quis commodo. <br /> <br /> Morbi consequat, dolor accumsan tincidunt pellentesque; massa urna ultrices lacus, sed viverra velit odio luctus turpis? <span style=\"background-color: Yellow;\">Nunc eget leo ut orci convallis molestie eget sed arcu?</span> In mi sem, varius eu congue id, volutpat eu orci! Maecenas mattis vestibulum nunc vel posuere. <br /> <ul>     <li>Cras a urna neque.</li>     <li>Donec consequat interdum dolor, quis tempus dolor ornare id?</li>     <li>Aenean nibh metus, tempus et volutpat at, rhoncus nec sapien.</li>     <li>Vivamus mi nisl, varius quis placerat vitae, sollicitudin et tellus.</li> </ul>"
    @announcement_2_title = random_string(31) + " " + random_string(32)
    @announcement_2_body = random_string(1024)
    @announcement_2_file = "resources.JPG"
    @announcement_3_title = random_string(15) + " " + random_string(15) + " " + random_string(16)
    @announcement_3_body = "Duis sagittis mi in nisl. Etiam vitae justo sit amet justo consectetuer dapibus. Nulla facilisi. Nulla facilisi. Nam volutpat nisi nec ligula. Morbi dapibus, nulla at vestibulum sodales, elit neque porttitor ante, ut mollis urna nulla non diam. Suspendisse ligula. Pellentesque congue felis at purus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Etiam tellus quam, faucibus sit amet, sodales eget, semper vitae, urna. Vivamus commodo. Nulla id neque. Curabitur non eros eget turpis suscipit molestie. Etiam non massa. Nulla at leo."
    @announcement_4_title = %|">;<<SCRIPT>alert("XSS");//<</SCRIPT> | + random_alphanums(31)
    @announcement_4_body = "Proin a nibh a turpis blandit tincidunt. Donec nulla eros, volutpat commodo, tempor laoreet, posuere ac, odio. Donec odio. Sed vel odio. In elit lectus, eleifend viverra, congue sed, ornare ac, elit. Fusce viverra. Pellentesque eleifend scelerisque tellus. Aenean vel ante. Donec dignissim dolor sed risus. Etiam semper nisl vitae lorem. Fusce ullamcorper orci id erat."
    @announcement_4_file = "resources.mp3"
    @announcement_5_title = random_string(96)
    @announcement_5_body = random_xss_string(100)
    @announcement_6_title = random_xss_string(50)
    @announcement_6_body = random_xss_string(100)
    @announcement_7_title = random_xss_string(50)
    @announcement_7_body = random_xss_string(100)
    
    @group1 = config.directory["site1"]["group0"]
    @group2 = config.directory["site1"]["group1"]
    
    @portfolio_site = config.directory["site2"]["name"]
    
    # Validation text -- These contain page content that will be used for
    # test asserts.
    @body_alert = "Alert: You need to fill in the body of the announcement!"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_announcements

    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    # Go to the test site
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to Announcements page
    announcements = home.announcements

    # Add an announcement
    ancmnt1 = announcements.add
    ancmnt1.body=@announcement_1_body
    ancmnt1.title=@announcement_1_title
    
    announcements = ancmnt1.add_announcement
    
    # TEST CASE: Verify announcement appears in list
    assert announcements.subjects.include?(@announcement_1_title)
    
    ancmnt2 = announcements.add
    ancmnt2.title=@announcement_2_title
    ancmnt2.body=@announcement_2_body
    
    attach = ancmnt2.add_attachments
    attach = attach.attach_a_copy(@announcement_2_file)

    ancmnt2 = attach.continue
    ancmnt2.select_groups
    ancmnt2.check_group @group1
    
    announcements = ancmnt2.add_announcement
    
    # TEST CASE: Verify list displays the announcement has an attachment
    assert announcements.has_attachment? @announcement_2_title
    
    preview = announcements.preview_announcement @announcement_2_title
    
    announcements = preview.return_to_list
    
    ancmnt3 = announcements.add
    ancmnt3.body=@announcement_3_body
    ancmnt3.title=@announcement_3_title
    
    ancmnt3.select_hide
    
    announcements = ancmnt3.add_announcement
    
    home = announcements.home

    # TEST CASE: Verify announcements appear as expected
    assert home.announcements_list.include?(@announcement_1_title)
    assert home.announcements_list.include?(@announcement_2_title)
    assert_equal false, home.announcements_list.include?(@announcement_3_title)
    
    announcements = home.announcements
    
    ancmnt4 = announcements.add
    ancmnt4.title=@announcement_4_title
    
    attach = ancmnt4.add_attachments
    attach = attach.attach_a_copy(@announcement_4_file)
    
    ancmnt4 = attach.continue
    ancmnt4.select_hide
    
    ancmnt4 = ancmnt4.add_announcement
    
    # TEST CASE: Verify Alert Message
    assert_equal @body_alert, ancmnt4.alert_message
    
    ancmnt4.body=@announcement_4_body
    
    announcements = ancmnt4.add_announcement
    
    # TEST CASE: Verify the new announcement appears in the list
    assert announcements.subjects.include? @announcement_4_title
    
    home = announcements.home
    
    # TEST CASE: Verify the new announcement does not appear in the list
    assert_equal false, home.announcements_list.include?(@announcement_4_title)
    
    announcements = home.announcements
    
    ancmnt5 = announcements.add
    ancmnt5.title=@announcement_5_title
    ancmnt5.body=@announcement_5_body
    ancmnt5.select_publicly_viewable
    
    announcements = ancmnt5.add_announcement
    
    # TEST CASE: Verify the new announcement is in the list
    assert announcements.subjects.include? @announcement_5_title
    
    # TEST CASE: Verify the announcement is "For Public"
    assert_equal "public", announcements.for_column(@announcement_5_title)
    
    login_page = announcements.logout
    
    site_search = login_page.search_public_courses_and_projects
    site_search.search_for=@site_name[0..3]
    
    results = site_search.search_for_sites

    summary_page = results.click_site @site_name
    
    # TEST CASE: Verify public announcement appears
    assert @browser.text.include? @announcement_5_title
    
    results = summary_page.return_to_list
    
    login_page = results.home
    
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    announcements = home.announcements
    
    ancmnt3 = announcements.edit @announcement_3_title
    ancmnt3.title="Edit " + @announcement_3_title
    
    preview = ancmnt3.preview
    
    announcements = preview.save_changes
    
    ancmnt3 = announcements.edit("Edit " + @announcement_3_title)
    ancmnt3.select_show
    
    announcements = ancmnt3.save_changes
    
    home = announcements.home
    home.recent_announcements_options
    home.number_of_announcements="5"
    home.update_announcements
    
    # TEST CASE: Verify Announcement 3 appears in the list
    assert home.announcements_list.include?("Edit " + @announcement_3_title)
    
    announcements = home.announcements
    
    ancmnt1 = announcements.edit @announcement_1_title
    ancmnt1.title=("Edit " + @announcement_1_title)
    ancmnt1.select_hide
    
    announcements = ancmnt1.save_changes
    
    home = announcements.home
    
    # TEST CASE: Verify announcements appear as expected
    assert_equal false, home.announcements_list.include?("Edit " + @announcement_1_title)
    assert_equal false, home.announcements_list.include?(@announcement_1_title)
    assert home.announcements_list.include? @announcement_2_title
    assert home.announcements_list.include? @announcement_5_title
    assert home.announcements_list.include?("Edit " + @announcement_3_title)
    assert_equal false, home.announcements_list.include?(@announcement_4_title)

    # Open a Portfolio Site and Merge the Announcements
    home = home.open_my_site_by_name @portfolio_site
    
    announcements = home.announcements
    
    merge = announcements.merge
    merge.check @site_name
    
    announcements = merge.save
    
    # TEST CASE: Verify announcements appear in the list.
    assert announcements.subjects.include?("Edit " + @announcement_1_title)
    assert announcements.subjects.include? @announcement_2_title
    assert announcements.subjects.include? @announcement_4_title
    assert announcements.subjects.include?("Edit " + @announcement_3_title)
    assert announcements.subjects.include? @announcement_5_title
    assert announcements.has_attachment? @announcement_2_title
    assert announcements.has_attachment? @announcement_4_title
    
    home = announcements.home
    home.recent_announcements_options
    home.number_of_announcements="5"
    home.update_announcements
    
    # TEST CASE: Verify announcements appear as expected
    assert_equal false, home.announcements_list.include?("Edit " + @announcement_1_title)
    assert_equal false, home.announcements_list.include?(@announcement_1_title)
    assert home.announcements_list.include? @announcement_2_title
    assert home.announcements_list.include? @announcement_5_title
    assert home.announcements_list.include?("Edit " + @announcement_3_title)
    assert_equal false, home.announcements_list.include?(@announcement_4_title)
    
    announcements = home.announcements
    
    view = announcements.preview_announcement("Edit " + @announcement_1_title)
    
    announcements = view.return_to_list
    
    home = announcements.open_my_site_by_name @site_name
    
    announcements = home.announcements
    
    ancmnt6 = announcements.add
    ancmnt6.body=@announcement_6_body
    ancmnt6.title=@announcement_6_title
    ancmnt6.select_specify_dates
    ancmnt6.check_ending
    ancmnt6.ending_year=last_year
    
    announcements = ancmnt6.add_announcement
    
    ancmnt7 = announcements.add
    ancmnt7.body=@announcement_7_body
    ancmnt7.title=@announcement_7_title
    ancmnt7.select_specify_dates
    ancmnt7.check_beginning
    ancmnt7.check_ending
    ancmnt7.beginning_year=next_year
    ancmnt7.ending_year=next_year
    
    announcements = ancmnt7.add_announcement
    
    # TEST CASE: Verify new announcements appear in the list
    assert announcements.subjects.include? @announcement_6_title
    assert announcements.subjects.include? @announcement_7_title
    
    login_page = announcements.logout
    
    # Log in with a student user
    workspace = login_page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name @site_name
    
    # TEST CASE: Verify the student can see the appropriate announcements
    assert_equal false, home.announcements_list.include?("Edit " + @announcement_1_title)
    assert_equal false, home.announcements_list.include?(@announcement_1_title)
    assert home.announcements_list.include? @announcement_2_title
    assert home.announcements_list.include? @announcement_5_title
    assert home.announcements_list.include?("Edit " + @announcement_3_title), home.announcements_list.join("\n")
    assert_equal false, home.announcements_list.include?(@announcement_4_title)
    assert_equal false, home.announcements_list.include?(@announcement_6_title)
    assert_equal false, home.announcements_list.include?(@announcement_7_title)

    announcements = home.announcements
    
    # TEST CASE: Verify the student can see/not see the announcements
    assert_equal false, announcements.subjects.include?("Edit " + @announcement_1_title)
    assert announcements.subjects.include? @announcement_2_title
    assert_equal false, announcements.subjects.include?(@announcement_4_title)
    assert announcements.subjects.include?("Edit " + @announcement_3_title)
    assert announcements.subjects.include? @announcement_5_title
    assert announcements.has_attachment? @announcement_2_title
    assert_equal false, announcements.subjects.include?(@announcement_6_title)
    assert_equal false, announcements.subjects.include?(@announcement_7_title)
    
  end
  
end
