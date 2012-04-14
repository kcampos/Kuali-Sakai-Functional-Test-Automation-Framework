#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# This script tests all of a users's Profile pages.
#
# == Prerequisites:
#
# A valid user login.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "My Profile" do
  
  include Utilities

  let(:basic_info) { MyProfileBasicInfo.new @browser }
  let(:about_me) { MyProfileAboutMe.new @browser }
  let(:online) { MyProfileOnline.new @browser }
  let(:contact_info) { MyProfileContactInfo.new @browser }
  let(:publications) { MyProfilePublications.new @browser }
  let(:profile) { ViewPerson.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user information from directory.yml...
    @user1 = @config.directory['person17']['id']
    @pass1 = @config.directory['person17']['password']
    @user1_name = "#{@config.directory['person17']['firstname']} #{@config.directory['person17']['lastname']}"
    @first = "#{@config.directory['person17']['firstname']}"
    @last = "#{@config.directory['person17']['lastname']}"
    @user2 = @config.directory['person2']['id']
    @pass2 = @config.directory['person2']['password']
    @user2_name = "#{@config.directory['person2']['firstname']} #{@config.directory['person2']['lastname']}"
    
    @sakai = SakaiOAE.new(@browser)
    dash = @sakai.login(@user1, @pass1)
    dash.my_profile
    
    # Test case variables...
    @given_name = random_alphanums
    @given_name2 = random_alphanums
    @family_name = random_alphanums
    @family_name2 = random_alphanums
    @preferred_name = random_alphanums
    @preferred_name2 = random_alphanums
    @title = "Postgraduate student"
    @title2 = "Research staff"
    @dept = random_alphanums
    @dept2 = random_alphanums
    @institution = random_alphanums
    @institution2 = random_alphanums
    @categories = random_categories(3)
    @categories2 = random_categories(3)
    @about_me = random_multiline(50, 4)
    @about_me2 = random_multiline(100, 10)
    @academic_interests = random_multiline(20, 10)
    @academic_interests2 = random_multiline(10, 5)
    @personal_interests = random_multiline(20, 10)
    @personal_interests2 = random_multiline(15, 8)
    @hobbies = random_alphanums
    @hobbies2 = random_alphanums
    @site = "Facebook"
    @url = "www.facebook.com"
    @site2 = "Google"
    @url2 = "www.lmgtfy.com"
    @site3 = "Twitter"
    @url3 = "www.twitter.com"
    
    @contact_info = {
      :institution=>random_alphanums, 
      :department=>random_alphanums,
      :title=>random_alphanums,
      :email=>random_alphanums,
      :im=>random_alphanums,
      :phone=>random_alphanums,
      :mobile=>random_alphanums,
      :fax=>random_alphanums,
      :address=>random_alphanums,
      :city=>random_alphanums,
      :state=>random_alphanums,
      :zip=>random_alphanums,
      :country=>random_alphanums
    }
    
    @contact_info2 = {
      :institution=>random_alphanums, 
      :department=>random_alphanums,
      :title=>random_alphanums,
      :email=>random_alphanums,
      :im=>random_alphanums,
      :phone=>random_alphanums,
      :mobile=>random_alphanums,
      :fax=>random_alphanums,
      :address=>random_alphanums,
      :city=>random_alphanums,
      :state=>random_alphanums,
      :zip=>random_alphanums,
      :country=>random_alphanums
    }
    
    @publications = {
      :main_title=>random_alphanums,
      :main_author=>random_alphanums,
      :co_authors=>random_alphanums,
      :publisher=>random_alphanums,
      :place=>random_alphanums,
      :volume_title=>random_alphanums,
      :volume_info=>random_alphanums,
      :year=>"1999",
      :number=>random_alphanums,
      :series=>random_alphanums,
      :url=>"http://www.rsmart.com"
    }
    
    @publications2 = {
      :main_title=>random_alphanums,
      :main_author=>random_alphanums,
      :co_authors=>random_alphanums,
      :publisher=>random_alphanums,
      :place=>random_alphanums,
      :volume_title=>random_alphanums,
      :volume_info=>random_alphanums,
      :year=>random_alphanums,
      :number=>random_alphanums,
      :series=>random_alphanums,
      :url=>"http://www.youtube.com"
    }
    
    @publications3 = {
      :main_title=>random_alphanums,
      :main_author=>random_alphanums,
      :co_authors=>random_alphanums,
      :publisher=>random_alphanums,
      :place=>random_alphanums,
      :volume_title=>random_alphanums,
      :volume_info=>random_alphanums,
      :year=>random_alphanums,
      :number=>random_alphanums,
      :series=>random_alphanums,
      :url=>"http://sakaiproject.org/commercial-support"
    }
    
    @empty_info = {}
    
  end

  it "First name is a required field" do
    basic_info.given_name=""
    basic_info.update
    basic_info.first_name_error_element.should be_visible
  end
  
  it "Last name is a required field" do
    basic_info.given_name=@given_name
    basic_info.family_name=""
    basic_info.update
    basic_info.last_name_error_element.should be_visible
  end

  it "User can add Basic Information" do
    basic_info.family_name=@family_name
    basic_info.preferred_name=@preferred_name
    basic_info.title=@title
    basic_info.department=@dept
    basic_info.institution=@institution
    basic_info.list_categories
    @categories.each do |cat|
      basic_info.check_category cat
    end
    basic_info.save_categories
    basic_info.update
    basic_info.family_name.should == @family_name
    basic_info.preferred_name.should == @preferred_name
    basic_info.title.should == @title
    basic_info.department.should == @dept
    basic_info.institution.should == @institution
    @categories.each do |cat|
      basic_info.categories.should include cat
    end
  end
 
  it "update Basic Info" do
    basic_info.given_name=@given_name2
    basic_info.family_name=@family_name2
    basic_info.preferred_name=@preferred_name2
    basic_info.title=@title2
    basic_info.department=@dept2
    basic_info.institution=@institution2
    basic_info.list_categories
    @categories2.each { |cat| basic_info.check_category cat }
    basic_info.save_categories
    basic_info.update
    basic_info.given_name.should == @given_name2
    basic_info.family_name.should == @family_name2
    basic_info.preferred_name.should == @preferred_name2
    basic_info.title.should == @title2
    basic_info.department.should == @dept2
    basic_info.institution.should == @institution2
    @categories2.each { |cat| basic_info.categories.should include cat }
  end
  
  it "add about me" do
    basic_info.about_me
    about_me.about_Me_element.send_keys( [:command, 'a'] )
    about_me.about_Me=@about_me
    about_me.academic_interests_element.send_keys( [:command, 'a'] )
    about_me.academic_interests=@academic_interests
    about_me.personal_interests_element.send_keys( [:command, 'a'] )
    about_me.personal_interests=@personal_interests
    about_me.hobbies=@hobbies
    about_me.update
    about_me.about_Me.should == @about_me
    about_me.academic_interests.should == @academic_interests
    about_me.personal_interests.should == @personal_interests
    about_me.hobbies.should == @hobbies
  end
  
  it "update about me" do
    about_me.about_Me_element.send_keys( [:command, 'a'] )
    about_me.about_Me=@about_me2
    about_me.academic_interests_element.send_keys( [:command, 'a'] )
    about_me.academic_interests=@academic_interests2
    about_me.personal_interests_element.send_keys( [:command, 'a'] )
    about_me.personal_interests=@personal_interests2
    about_me.hobbies=@hobbies2
    about_me.update
    about_me.about_Me.should == @about_me2
    about_me.academic_interests.should == @academic_interests2
    about_me.personal_interests.should == @personal_interests2
    about_me.hobbies.should == @hobbies2
  end
  
  it "Add an Online" do
    about_me.online
    online.add_another_online
    online.site=@site
    online.url=@url
    online.update
    online.site.should == @site
    online.url.should == @url
  end
  
  it "Add a second Online" do
    online.add_another_online
    online.site=@site2
    online.url=@url2
    online.update
    online.site.should == @site2
    online.url.should == @url2
  end
 
  it "update Online" do
    online.site=@site3
    online.url=@url3
    online.update
    online.site.should == @site3
    online.url.should == @url3
  end

  it "add Contact Info" do
    online.contact_info
    contact_info.fill_out_form @contact_info
    contact_info.update
    contact_info.institution.should==@contact_info[:institution]
    contact_info.department.should==@contact_info[:department]
    contact_info.role.should==@contact_info[:title]
    contact_info.email.should==@contact_info[:email]
    contact_info.instant_messaging.should==@contact_info[:im]
    contact_info.phone.should==@contact_info[:phone]
    contact_info.mobile.should==@contact_info[:mobile]
    contact_info.fax.should==@contact_info[:fax]
    contact_info.address.should==@contact_info[:address]
    contact_info.city.should==@contact_info[:city]
    contact_info.state.should==@contact_info[:state]
    contact_info.postal_code.should==@contact_info[:zip]
    contact_info.country.should==@contact_info[:country]
  end
  
  it "update Contact Info" do
    contact_info.fill_out_form @contact_info2
    contact_info.update
    contact_info.institution.should==@contact_info2[:institution]
    contact_info.department.should==@contact_info2[:department]
    contact_info.role.should==@contact_info2[:title]
    contact_info.email.should==@contact_info2[:email]
    contact_info.instant_messaging.should==@contact_info2[:im]
    contact_info.phone.should==@contact_info2[:phone]
    contact_info.mobile.should==@contact_info2[:mobile]
    contact_info.fax.should==@contact_info2[:fax]
    contact_info.address.should==@contact_info2[:address]
    contact_info.city.should==@contact_info2[:city]
    contact_info.state.should==@contact_info2[:state]
    contact_info.postal_code.should==@contact_info2[:zip]
    contact_info.country.should==@contact_info2[:country]
  end

  it "add a Publication" do
    contact_info.publications
    publications.add_another_publication
    publications.fill_out_form @publications
    publications.update
    publications.main_title.should==@publications[:main_title]
    publications.main_author.should==@publications[:main_author]
    publications.co_authors.should==@publications[:co_authors]
    publications.publisher.should==@publications[:publisher]
    publications.place_of_publication.should==@publications[:place]
    publications.volume_title.should==@publications[:volume_title]
    publications.volume_information.should==@publications[:volume_info]
    publications.year.should==@publications[:year]
    publications.number.should==@publications[:number]
    publications.series_title.should==@publications[:series]
    publications.url.should==@publications[:url]
  end

  it "add a second Publication" do
    publications.add_another_publication
    publications.fill_out_form @publications2
    publications.update
    publications.main_title.should==@publications2[:main_title]
    publications.main_author.should==@publications2[:main_author]
    publications.co_authors.should==@publications2[:co_authors]
    publications.publisher.should==@publications2[:publisher]
    publications.place_of_publication.should==@publications2[:place]
    publications.volume_title.should==@publications2[:volume_title]
    publications.volume_information.should==@publications2[:volume_info]
    publications.year.should==@publications2[:year]
    publications.number.should==@publications2[:number]
    publications.series_title.should==@publications2[:series]
    publications.url.should==@publications2[:url]
  end

  it "Main title is a required field" do
    publications.main_title=""
    publications.update
    publications.title_error.should == "This field is required."
  end
  
  it "Main author is a required field" do
    publications.main_title=@publications2[:main_title]
    publications.main_author=""
    publications.update
    publications.author_error.should == "This field is required."
  end

  it "Publisher is a required field" do
    publications.main_author=@publications2[:main_author]
    publications.publisher=""
    publications.update
    publications.publisher_error.should == "This field is required."
  end
  
  it "Place of publication is a required field" do
    publications.publisher=@publications2[:publisher]
    publications.place_of_publication=""
    publications.update
    publications.place_error.should == "This field is required."
  end

  it "Year is a required field" do
    publications.place_of_publication=@publications2[:place]
    publications.year=""
    publications.update
    publications.year_error.should == "This field is required."
  end
  
  it "Publication URL must be valid" do
    publications.year=@publications2[:year]
    publications.url=random_string(25)
    publications.update
    publications.url_error.should == "Please enter a valid URL."
  end

  it "update a Publication" do
    publications.fill_out_form @publications3
    publications.update
    publications.main_title.should==@publications3[:main_title]
    publications.main_author.should==@publications3[:main_author]
    publications.co_authors.should==@publications3[:co_authors]
    publications.publisher.should==@publications3[:publisher]
    publications.place_of_publication.should==@publications3[:place]
    publications.volume_title.should==@publications3[:volume_title]
    publications.volume_information.should==@publications3[:volume_info]
    publications.year.should==@publications3[:year]
    publications.number.should==@publications3[:number]
    publications.series_title.should==@publications3[:series]
    publications.url.should==@publications3[:url]
  end

  it "user view Basic Info" do
    @sakai.logout
    dash = @sakai.login(@user2, @pass2)
    explore = dash.explore_people
    explore.search_for="#{@given_name2} #{@family_name2}"
    profile = explore.view_person "#{@given_name2} #{@family_name2}"
    profile.basic_info_data["Given Name:"].should == @given_name2
    profile.basic_info_data["Family Name:"].should == @family_name2
    profile.basic_info_data["Preferred Name:"].should == @preferred_name2
    profile.basic_info_data["Title/Role:"].should == @title2
    profile.basic_info_data["Department:"].should == @dept2
    profile.basic_info_data["Institution:"].should == @institution2
    @categories2.each { |cat| profile.tags_and_categories_list.should include cat }
  end
  
  it "user view about me" do
    profile.about_me
    profile.about_me_data["About Me:"].should==@about_me2.gsub("\n", " ")
    profile.about_me_data["Academic interests:"].should==@academic_interests2.gsub("\n", " ")
    profile.about_me_data["Personal Interests:"].should==@personal_interests2.gsub("\n", " ")
    profile.about_me_data["Hobbies:"].should==@hobbies2
  end
  
  it "user view Online" do
    profile.online
    profile.online_data["Site:1"].should==@site
    profile.online_data["URL:1"].should==@url
    profile.online_data["Site:2"].should==@site3
    profile.online_data["URL:2"].should==@url3
  end
    
  it "user view Contact Info" do
    profile.contact_info
    profile.expected_contact_info?(@contact_info2).should be true
  end
  
  it "user view Publications" do
    profile.publications
    profile.expected_publications_data?([ @publications, @publications3 ]).should be true
  end

  it "public view Basic Info" do
    login_page = @sakai.logout
    explore = login_page.explore_people
    explore.search_for="#{@given_name2} #{@family_name2}"
    profile = explore.view_person "#{@given_name2} #{@family_name2}"
    profile.basic_info_data["Given Name:"].should == @given_name2
    profile.basic_info_data["Family Name:"].should == @family_name2
    profile.basic_info_data["Preferred Name:"].should == @preferred_name2
    profile.basic_info_data["Title/Role:"].should == @title2
    profile.basic_info_data["Department:"].should == @dept2
    profile.basic_info_data["Institution:"].should == @institution2
    @categories2.each { |cat| profile.tags_and_categories_list.should include cat }
  end
  
  it "public view about me" do
    profile.about_me
    profile.about_me_data["About Me:"].should==@about_me2.gsub("\n", " ")
    profile.about_me_data["Academic interests:"].should==@academic_interests2.gsub("\n", " ")
    profile.about_me_data["Personal Interests:"].should==@personal_interests2.gsub("\n", " ")
    profile.about_me_data["Hobbies:"].should==@hobbies2
  end
  
  it "public view Online" do
    profile.online
    profile.online_data["Site:1"].should==@site
    profile.online_data["URL:1"].should==@url
    profile.online_data["Site:2"].should==@site3
    profile.online_data["URL:2"].should==@url3
  end
    
  it "public view Contact Info" do
    profile.contact_info
    profile.expected_contact_info?(@contact_info2).should be true
  end
  
  it "public view Publications" do
    profile.publications
    profile.expected_publications_data?([ @publications, @publications3 ]).should be true
  end
  
  it "delete Basic Info" do
    dash = @sakai.sign_in(@user1, @pass1)
    dash.my_profile
    basic_info.given_name=@first
    basic_info.family_name=@last
    basic_info.preferred_name=""
    basic_info.title=""
    basic_info.department=""
    basic_info.institution=""
    @categories2.each { |cat| basic_info.remove_category cat }
    basic_info.update
    basic_info.preferred_name.should == ""
    basic_info.title.should == ""
    basic_info.department.should == ""
    basic_info.institution.should == ""
    @categories2.each { |cat| basic_info.categories.should_not include cat }
  end
  
  it "delete About Me" do
    basic_info.about_me
    about_me.about_Me_element.send_keys( [:command, 'a'] )
    about_me.about_Me_element.send_keys( [:backspace] )
    about_me.academic_interests_element.send_keys( [:command, 'a'] )
    about_me.academic_interests_element.send_keys( [:backspace] )
    about_me.personal_interests_element.send_keys( [:command, 'a'] )
    about_me.personal_interests_element.send_keys( [:backspace] )
    about_me.hobbies=""
    about_me.update
    about_me.about_Me.should == ""
    about_me.academic_interests.should == ""
    about_me.personal_interests.should == ""
    about_me.hobbies.should == ""
  end
  
  it "delete Online" do
    about_me.online
    online.remove_this_online @site
    online.update
    online.sites_list[@site].should be nil
    online.sites_list[@site3].should == @url3
  end
  
  it "delete Contact Info" do
    online.contact_info
    contact_info.fill_out_form @empty_info
    contact_info.update
    contact_info.institution.should==""
    contact_info.department.should==""
    contact_info.role.should==""
    contact_info.email.should==""
    contact_info.instant_messaging.should==""
    contact_info.phone.should==""
    contact_info.mobile.should==""
    contact_info.fax.should==""
    contact_info.address.should==""
    contact_info.city.should==""
    contact_info.state.should==""
    contact_info.postal_code.should==""
    contact_info.country.should==""
  end

  it "delete a Publication" do
    contact_info.publications
    publications.remove_this_publication @publications[:main_title]
    publications.remove_this_publication @publications3[:main_title]
    publications.update
    publications.publication_titles.should_not include @publications[:main_title]
    publications.publication_titles.should_not include @publications3[:main_title]
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
