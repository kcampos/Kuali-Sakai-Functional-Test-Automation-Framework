#!/usr/bin/env ruby
# 
# == Synopsis
#
# Executes the editing of a user profile2; email, picture and names 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config-cle/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestUpdatingProfile2 < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @student = @config.directory['person7']['id']
    @password = @config.directory['person7']['password']
    @student_lastname = @config.directory['person7']['lastname']
    @student_firstname = @config.directory['person7']['firstname']
    @student2 = @config.directory['person1']['id']
    @password2 = @config.directory['person1']['password']
    @student2_lastname = @config.directory['person1']['lastname']
    @student2_firstname = @config.directory['person1']['firstname']
    @site_name = @config.directory['site1']['name']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables...
    @nickname = random_string
    @personal_summary = random_string(255)
    random_date = Time.random(:year_range=>70)
    @day = random_date.strftime("%d").to_i
    @month = random_date.strftime("%B")
    @year = random_date.strftime("%Y")
    @picture_file = "images/flower0#{rand(8)+1}.jpg"
    @email = random_alphanums(2) + random_nicelink + "@" + random_alphanums + ".com"
    @home_page = "http://www.rsmart.com"
    @work_phone = rand(9999999999).to_s
    @home_phone = "(" + rand(999).to_s + ") " + rand(999).to_s + "-" + rand(9999).to_s
    @mobile_phone = rand(999).to_s + "." + rand(999).to_s + "." + rand(9999).to_s
    @fax = rand(999).to_s + "-" + rand(999).to_s + "-" + rand(9999).to_s
    @degree = random_string(24)
    @subject = random_string(48)
    @favorite_books = "The Hunger Games, Catching Fire, Zen and the Art of Motorcycle Maintenance"
    @favorite_tv_shows = "A-Team, Kojack"
    @favorite_movies = "Fight Club, Army of Darkness"
    @favorite_quotes = "\"Any of you boys seen an Aircraft Carrier around here?\""
    @common_interest = "Catching Fire"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_updating_profile2

    # Log in to Sakai
    workspace = @sakai.login(@student, @password)
    
    # Set up data in Profile2
    profile = workspace.profile2
    
    basic = profile.edit_basic_info
    basic.nickname=@nickname
    basic.personal_summary=@personal_summary
    basic.birthday(@day, @month, @year)
    
    profile = basic.save_changes
    
    picture = profile.change_picture
    picture.image_file=@picture_file
    
    profile = picture.upload
    
    contact = profile.edit_contact_info
    contact.email=@email
    contact.home_page=@home_page
    contact.work_phone=@work_phone
    contact.home_phone=@home_phone
    contact.mobile_phone=@mobile_phone
    contact.facsimile=@fax
    
    profile = contact.save_changes

    student = profile.edit_student_info
    student.degree_course=@degree
    student.subjects=@subject
    
    profile = student.save_changes
    
    personal = profile.edit_personal_info
    personal.favorite_books=@favorite_books
    personal.favorite_tv_shows=@favorite_tv_shows
    personal.favorite_movies=@favorite_movies
    personal.favorite_quotes=@favorite_quotes
    
    profile = personal.save_changes
    
    # Set Privacy so that only connections can see data...
    privacy = profile.privacy
    privacy.profile_image="Only my connections"
    privacy.basic_info="Only my connections"
    privacy.contact_info="Only my connections"
    privacy.staff_info="Only my connections"
    privacy.student_info="Only my connections"
    privacy.social_info="Only my connections"
    privacy.personal_info="Only my connections"
    privacy.view_connections="Only my connections"
    privacy.see_status="Only my connections"
    privacy.view_pictures="Only my connections"
    privacy.see_kudos_rating="Only my connections"
    privacy.save_settings
    
    # View the roster to confirm user can see own data...
    home = privacy.open_my_site_by_name(@site_name)
    
    roster = home.roster

    student = roster.view(@student_lastname + ", " + @student_firstname)
    
    # TEST CASE: Verify Roster's page data is as expected...
    assert_equal @nickname, student.public_information["Nickname"]
    assert_equal @email, student.personal_information["Email"]
    assert_equal @home_page, student.personal_information["Home Page"]
    assert_equal @work_phone, student.personal_information["Work Phone"]
    assert_equal @personal_summary, student.personal_information["Other Information"]
    
    # Log in as another student...
    @sakai.logout

    workspace = @sakai.login(@student2, @password2)
    
    profile = workspace.profile2
    
    search = profile.search_for_connections
    search.persons_name_or_email="#{@student_lastname}"
    search = search.search_by_name_or_email

    # TEST CASE: Student 1 appears in search results when searching by name
    assert search.results.include?("#{@student_firstname} #{@student_lastname}")
    
    # Add first student as a connection...
    search = search.add_as_connection "#{@student_firstname} #{@student_lastname}"
    
    # Verify that Student 2 cannot see any of Student 1's profile data in either
    # Profile2 or the Roster pages...
    
    #Profile2
    view = search.view "#{@student_firstname} #{@student_lastname}"
    
    # TEST CASE: Student 2 cannot see any of Student 1's profile info
    assert_equal({}, view.basic_information)
    assert_equal({}, view.contact_information)
    assert_equal({}, view.student_information)
    assert_equal({}, view.personal_information)
    
    #Roster
    home = view.open_my_site_by_name @site_name
    
    roster = home.roster
    
    view = roster.view(@student_lastname + ", " + @student_firstname)
    
    # TEST CASE: Student 2 cannot see any of student 1's profile info (except name and email)...
    assert_equal "", student.public_information["Nickname"]
    assert_equal @email, student.personal_information["Email"]
    #assert_equal nil, student.personal_information["Home page"]
    #assert_equal nil, student.personal_information["Work phone"] Need to double-check the capitalization here.
    assert_equal "", student.personal_information["Other Information"]
    assert_equal @student_firstname, student.personal_information["First Name"]
    assert_equal @student_lastname, student.personal_information["Last Name"]
    
    # Log back in with Student 1, accept the connection request
    @sakai.logout

    workspace = @sakai.login(@student, @password)
    
    profile = workspace.profile2
    
    # TEST CASE: The new connection request appears in the menu
    assert_equal "1", profile.connection_requests
    
    connections = profile.connections
    connections = connections.confirm_request("#{@student2_firstname} #{@student2_lastname}")
    
    # TEST CASE: The student is listed as a connection
    assert connections.connections.include?("#{@student2_firstname} #{@student2_lastname}")
    
    # Log in as student 2, verify that Student 1's information is now visible...
    @sakai.logout
    
    workspace = @sakai.login(@student2, @password2)
    
    # ...in Profile2
    profile = workspace.profile2
    
    search = profile.search_for_connections
    search.common_interest=@common_interest
    search = search.search_by_common_interest 
    
    # TEST CASE: Student 1 appears in search results when searching on common interest
    assert search.results.include?("#{@student_firstname} #{@student_lastname}")
    
    view = search.view
    
    view = search.view "#{@student_firstname} #{@student_lastname}"
    
    # TEST CASE: Student 2 can now see Student 1's profile info
    assert_equal(@nickname, view.basic_information["Nickname"])
    assert_equal(@personal_summary, view.basic_information["Personal summary"])
    assert_equal(@email, view.contact_information["Email"])
    assert_equal(@home_page, view.contact_information["Home page"])
    assert_equal(@work_phone, view.contact_information["Work phone"])
    assert_equal(@home_phone, view.contact_information["Home phone"])
    assert_equal(@mobile_phone, view.contact_information["Mobile phone"])
    assert_equal(@fax, view.contact_information["Facsimile"])
    assert_equal(@degree, view.student_information["Degree/Course"])
    assert_equal(@subject, view._information["Subject"])
    assert_equal(@favorite_books, view.personal_information["Favorite books"])
    assert_equal(@favorite_tv_shows, view.personal_information["Favorite TV shows"])
    assert_equal(@favorite_movies, view.personal_information["Favorite movies"])
    assert_equal(@favorite_quotes, view.personal_information["Favorite quotes"])
    
    # ...in Roster
    home = view.open_my_site_by_name(@site_name)
    
    roster = home.roster
    
    sleep 20
    
  end
  
end
