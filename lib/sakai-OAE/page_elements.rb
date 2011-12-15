#!/usr/bin/env ruby
# 
# == Synopsis
# 
# Sakai-OAE Page Object definitionstext_field(:name, :tag=>"identifier")

#
require 'page-object'

# The top menu bar, present on most pages
module TopMenuBar
  
  include PageObject
  
  def self.menu(name, menu_id, link_id, target_class)   
    define_method(name) {
      @browser.link(:id=>menu_id).fire_event("onmouseover")
      @browser.link(:id=>link_id).click
      eval(target_class).new @browser
    }
  end

  menu(:my_dashboard, "navigation_you_link", "subnavigation_home_link", "MyDashboard")
  menu(:my_messages, "navigation_you_link", "subnavigation_messages_link", "MyMessages")
  menu(:my_profile, "navigation_you_link", "subnavigation_profile_link", "MyProfile")
  menu(:my_library, "navigation_you_link", "subnavigation_content_link", "MyLibrary")
  menu(:my_memberships, "navigation_you_link", "subnavigation_memberships_link", "MyMemberships") 
  menu(:my_contacts, "navigation_you_link", "subnavigation_contacts_link", "MyContacts")
  menu(:add_content, "navigation_create_and_add_link", "subnavigation_add_content_link", "AddContent")  
  menu(:add_contacts, "navigation_create_and_add_link", "subnavigation_add_contacts_link", "AddContacts")  
  menu(:create_groups, "navigation_create_and_add_link", "subnavigation_group_link", "CreateGroups")
  menu(:create_courses, "navigation_create_and_add_link", "subnavigation_courses_link", "CreateCourses")
  menu(:create_research, "navigation_create_and_add_link", "subnavigation_research_link", "CreateResearch")  
  menu(:explore_all_categories, "navigation_explore_link_dropdown", "subnavigation_explore_categories_link", "ExploreCategories")
  menu(:explore_content,"navigation_explore_link_dropdown","subnavigation_explore_content_link","ExploreContent")
  menu(:explore_people,"navigation_explore_link_dropdown","subnavigation_explore_people_link","ExplorePeople")
  menu(:explore_groups,"navigation_explore_link_dropdown","subnavigation_explore_group_link","ExploreGroups")
  menu(:explore_courses,"navigation_explore_link_dropdown","subnavigation_explore_courses_link","ExploreCourses")
  menu(:explore_research,"navigation_explore_link_dropdown","subnavigation_explore_research_link","ExploreResearch")
  menu(:my_preferences,"topnavigation_user_options_name","subnavigation_preferences_link","MyPreferences")
  menu(:sign_out,"topnavigation_user_options_name","subnavigation_logout_link","LoginPage")
  
  link(:help, :id=>"help_tab")
  
  # Define global search later
  
end

# The Login page for OAE.
class LoginPage
  
  include PageObject
  
  def sign_up
    link(:id=>"navigation_anon_signup_link").click
    CreateNewAccount.new @browser
  end
  
  
  
end

# The page for creating a new user account
class CreateNewAccount
  
  include PageObject
  
  text_field(:user_name, :id=>"username")
  text_field(:institution, :id=>"institution")
  text_field(:password, :id=>"password")
  text_field(:retype_password, :id=>"password_repeat")
  select_list(:role, :id=>"role")
  text_field(:first_name,:id=>"firstName")
  text_field(:last_name,:id=>"lastName")
  text_field(:email,:id=>"email")
  text_field(:phone_number,:id=>"phone")

end

#
class MyDashboard
  
  include PageObject
  include TopMenuBar

  button(:edit_layout, :text=>"Edit Layout")
  radio_button(:one_column, :id=>"layout-picker-onecolumn")
  radio_button(:two_column, :id=>"layout-picker-dev")
  radio_button(:three_column, :id=>"layout-picker-threecolumn")
  button(:save_layout, :id=>"select-layout-finished")
  button(:add_widgets, :text=>"Add Widget")

  def close_add_widget
    @browser.div(:class=>"s3d-dialog-close jqmClose").fire_event("onclick")
    sleep 1
    MyDashboard.new @browser
  end
  
  def add_all_widgets
    @browser.div(:id=>"add_goodies_body").lis.each do |li|
      if li.visible? && li.id=~/_add_/
        li.button.click
      end
    end
  end
  
  def remove_all_widgets
    @browser.div(:id=>"add_goodies_body").lis.each do |li|
      if li.visible? && li.id=~/_remove_/
        li.button.click
      end
    end
  end
  
  def add_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_add_/).button.click
  end
  
  def remove_widget(name)
    @browser.div(:id=>"add_goodies_body").li(:text=>/#{Regexp.escape(name)}/, :id=>/_remove_/).button.click
  end
  
  def displayed_widgets
    list = []
    @browser.div(:class=>"fl-container-flex widget-content").divs.each do |div|
      if div.class_name=="s3d-contentpage-title"
        list << div.text
      end
    end
    return list
  end

end

#
class MyMessages
  
  include TopMenuBar
 
end

#
class MyProfile
  
  include TopMenuBar
  

end

#
class MyLibrary
  
  include TopMenuBar
  

end

#
class MyMemberships

  include TopMenuBar
  

end

#
class MyContacts

  include TopMenuBar
  

end

#
class AddContent
  
  include PageObject
  

end