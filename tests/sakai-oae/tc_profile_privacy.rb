#!/usr/bin/env ruby
# encoding: UTF-8
# 
# == Synopsis
#
# Tests the user profile privacy settings.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader", "cgi" ]
gems.each { |gem| require gem }
files = [ "/../../config/OAE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-OAE/app_functions.rb", "/../../lib/sakai-OAE/page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestEditProfilePrivacy < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @sakai = SakaiOAE.new(@browser)
    
    # Test case variables...
    @user1 = @config.directory['person9']['id']
    @password1 = @config.directory['person9']['password']
    @user2 = @config.directory['person8']['id']
    @password2 = @config.directory['person8']['password']
    
    # Profile pics...
    @files = ["Mercury.gif", "Jupiter.gif"]
    
    # Basic Information...
    @basic = { :given=>random_string, :family=>random_string, :preferred=>random_string, :tags=>random_string }
    
    # Categories...
    @tree = "Natural & Physical Sciences"
    @categories = ["Biochemistry, Biophysics & Molecular Biology", "Biomathematics, Bioinformatics, & Computational Biology"]
    
    # About Me...
    @about_me = random_string(256)
    @academic_interests = random_xss_string
    @personal_interests = random_xss_string
    
    # Online...
    @online = [
      {:site=>"Twitter",:url=>"www.twitter.com"},
      {:site=>"Facebook",:url=>"www.facebook.com"},
      {:site=>"Amazon",:url=>"www.amazon.com"},
      {:site=>"Blog",:url=>"www.blogger.com"},
      {:site=>"Google",:url=>"www.google.com"}
    ]
    
    # Contact Info...
    @contact_info = [
      {:institution=>random_string, :department=>random_string, :title=>random_string, :email=>"bla@bla.com", :im=>random_string, :phone=>random_string, :mobile=>random_string, :fax=>random_string, :address=>random_string, :city=>random_string, :state=>random_string, :zip=>random_string, :country=>random_string},
      {:institution=>random_string, :department=>random_string, :title=>random_string, :email=>"bla@bla.org", :im=>random_string, :phone=>random_string, :mobile=>random_string, :fax=>random_string, :address=>random_string, :city=>random_string, :state=>random_string, :zip=>random_string, :country=>random_string},
      {:institution=>random_string, :department=>random_string, :title=>random_string, :email=>"bla@bla.edu", :im=>random_string, :phone=>random_string, :mobile=>random_string, :fax=>random_string, :address=>random_string, :city=>random_string, :state=>random_string, :zip=>random_string, :country=>random_string}
    ]
    
    # Publications...
    @publications = [
      {:main_title=>random_string, :main_author=>random_string, :co_authors=>random_string, :publisher=>random_string, :place=>random_string, :volume_title=>random_string, :volume_info=>random_string, :year=>"19#{rand(99)}", :number=>random_string, :series=>random_string, :url=>"www.#{random_nicelink}.com"},
      {:main_title=>random_string, :main_author=>random_string, :co_authors=>random_string, :publisher=>random_string, :place=>random_string, :volume_title=>random_string, :volume_info=>random_string, :year=>"19#{rand(99)}", :number=>random_string, :series=>random_string, :url=>"www.#{random_nicelink}.com"},
      {:main_title=>random_string, :main_author=>random_string, :co_authors=>random_string, :publisher=>random_string, :place=>random_string, :volume_title=>random_string, :volume_info=>random_string, :year=>"19#{rand(99)}", :number=>random_string, :series=>random_string, :url=>"www.#{random_nicelink}.com"},
      {:main_title=>random_string, :main_author=>random_string, :co_authors=>random_string, :publisher=>random_string, :place=>random_string, :volume_title=>random_string, :volume_info=>random_string, :year=>"19#{rand(99)}", :number=>random_string, :series=>random_string, :url=>"www.#{random_nicelink}.com"}
    ]
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_edit_profile_privacy
    
    dashboard = @sakai.login(@user1, @password1)
#=begin
    dashboard.change_picture
    dashboard.upload_a_new_picture @files[0]
    @thumb = dashboard.thumbnail_source
    dashboard.save_new_selection
    
    # TEST CASE: Profile image is updated
    assert_equal(@thumb, dashboard.profile_pic_element.src, "#{@thumb}\nnot the same as:\n#{dashboard.profile_pic_element.src}")
    
    dashboard.change_picture
    dashboard.upload_a_new_picture @files[1]
    @thumb = dashboard.thumbnail_source
    dashboard.save_new_selection

    # TEST CASE: Profile image is updated
    assert_equal(@thumb, dashboard.profile_pic_element.src, "#{@thumb}\nnot the same as:\n#{dashboard.profile_pic_element.src}")

    my_profile = dashboard.my_profile
    my_profile.given_name=@basic[:given]
    my_profile.family_name=@basic[:family]
    my_profile.preferred_name=@basic[:preferred]
    my_profile.tags=@basic[:tags]
    
    my_profile.update
    
    my_profile.about_me_permissions
    my_profile.can_be_seen_by="Everyone"
    my_profile.apply_permissions
    my_profile.contact_information_permissions
    my_profile.can_be_seen_by="Everyone"
    my_profile.apply_permissions
    my_profile.publications_permissions
    my_profile.can_be_seen_by="Everyone"
    my_profile.apply_permissions
    my_profile.online_permissions
    my_profile.can_be_seen_by="Everyone"
    my_profile.apply_permissions
    
    categories = my_profile.categories

    categories.add_or_remove_categories
    categories.open_tree @tree
    categories.check_category @categories[0]
    categories.check_category @categories[1]
    
    # TEST CASE: Categories are shown as selected
    assert categories.selected_categories.include?(@tree + CGI::unescapeHTML(" &#187; ") + @categories[0]), (@tree + CGI::unescapeHTML(" &#187; ") + @categories[0])
    assert categories.selected_categories.include?(CGI::unescapeHTML(@tree + " &#187; " + @categories[1])), (@tree + CGI::unescapeHTML(" &#187; ") + @categories[1])
    
    categories.save

    # TEST CASE: Categories are listed
    assert categories.listed_categories.include?(CGI::unescapeHTML(@tree + "&#187;" + @categories[0])), categories.listed_categories.join("\n")
    assert categories.listed_categories.include?(CGI::unescapeHTML(@tree + "&#187;" + @categories[1])), categories.listed_categories.join("\n")

    about_me = categories.about_me

    about_me.about_Me=@about_me
    about_me.academic_interests=@academic_interests
    about_me.personal_interests=@personal_interests
    
    about_me.update

    online = about_me.online
    
    @online.each do |on|
      
      online.add_another_online
      online.site=on[:site]
      online.url=on[:url]
      
    end
    
    online.update
    
    contact_info = online.contact_information

    @contact_info.each do |ci|
      
      contact_info.add_another
      contact_info.institution=ci[:institution]
      contact_info.department=ci[:department]
      contact_info.title_role=ci[:title]
      contact_info.email=ci[:email]
      contact_info.instant_messaging=ci[:im]
      contact_info.phone=ci[:phone]
      contact_info.mobile=ci[:mobile]
      contact_info.fax=ci[:fax]
      contact_info.address=ci[:address]
      contact_info.city=ci[:city]
      contact_info.state=ci[:state]
      contact_info.postal_code=ci[:zip]
      contact_info.country=ci[:country]
    
    end

    contact_info.update

    publications = contact_info.publications

    @publications.each do |pub|
      
      publications.add_another_publication
      publications.main_title=pub[:main_title]
      publications.main_author=pub[:main_author]
      publications.co_authors=pub[:co_authors]
      publications.publisher=pub[:publisher]
      publications.place_of_publication=pub[:place]
      publications.volume_title=pub[:volume_title]
      publications.volume_information=pub[:volume_info]
      publications.year=pub[:year]
      publications.number=pub[:number]
      publications.series_title=pub[:series]
      publications.url=pub[:url]
      
    end
    
    publications.update
#=end
    login_page = @sakai.sign_out
    
    people = login_page.explore_people
    
    view = people.open("#{@basic[:given]} #{@basic[:family]}")
    
    p view.basic_info_data
    
    view = view.categories
    
    p view.categories_data
    
    view = view.about_me
    
    p view.about_me_data
    
    view = view.online
    
    p view.online_data
    
    view = view.contact_information
    
    p view.contact_info_data
    
    view = view.publications
    
    p view.publications_data
    
  end
  
end
