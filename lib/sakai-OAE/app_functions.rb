#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

#require 'watir-webdriver'
require 'page-object'

class SakaiOAE
  
  def initialize(browser)
    @browser = browser
  end
  
  def login(username, password)
    
    @browser.div(:id=>"topnavigation_user_options_login_wrapper").fire_event("onmouseover")
    @browser.text_field(:id=>"topnavigation_user_options_login_fields_username").set username
    @browser.text_field(:name=>"topnav_login_password").set password
    @browser.button(:id=>"topnavigation_user_options_login_button_login").click
    @browser.div(:id=>/carousel/).wait_until_present
    MyDashboard.new @browser
    
  end
  
  def sign_out
    @browser.link(:id=>"topnavigation_user_options_name").fire_event("onmouseover")
    @browser.link(:id=>"subnavigation_logout_link").click
    @browser.wait_for_ajax #.div(:text=>"Recent activity").wait_until_present
    LoginPage.new @browser
  end
  
  alias logout sign_out
  alias log_out sign_out
  
end

# Contains methods that extend the PageObject module to include
# methods that are custom to OAE.
module PageObject
  
  module Accessors
    
    # Use this for menus that require floating the mouse
    # over the first link, before you click on the second
    # link...
    def float_menu(name, menu_title, link_title, target_text, target_class)   
      define_method(name) {
        @browser.link(:title=>menu_title).fire_event("onmouseover")
        @browser.link(:title=>link_title).click
        @browser.wait_for_ajax #wait_until { @browser.text.include? target_text }
        sleep 0.4
        eval(target_class).new @browser
      }
    end
    
    # Use this for menu items that are accessed via clicking
    # the div to get to the target menu item.
    def permissions_menu(name, text) #, target_class)
      define_method(name) {
        @browser.link(:text=>text).fire_event("onmouseover")
        @browser.link(:text=>text).parent.div(:class=>"lhnavigation_selected_submenu_image").fire_event("onclick")
        @browser.link(:id=>"lhnavigation_submenu_user_permissions").click
        self.class.class_eval { include PermissionsPopUp }
      }
    end
    
    # 
    def navigating_button(name, id, class_name=nil)
      define_method(name) { 
          @browser.button(:id=>id).click
          @browser.wait_for_ajax #.button(:id=>id).wait_while_present
          sleep 0.2 #FIXME
          unless class_name==nil
            eval(class_name).new @browser
          end
        }
    end
    
    def navigating_link(name, link_text, class_name=nil)
      define_method(name) { 
        @browser.link(:text=>/#{Regexp.escape(link_text)}/).click
        @browser.wait_for_ajax #wait_until { @browser.text.include? page_text }
        unless class_name==nil
          eval(class_name).new @browser
        end
      }
    end
    
  end 
end

# Need this to extend Watir to be able to attach to Sakai's non-standard tags...
module Watir
  
  class Browser
    
    def wait_for_ajax(timeout=30)
      while !(self.execute_script("return jQuery.active == 0"));end
      self.wait(timeout)
    end
    
  end
  
  class Element
    # attaches to the "headers" tags inside of the assignments table.
    def headers
      @how = :ole_object 
      return @o.headers
    end
    
    # attaches to the "for" tags in "label" tags.
    def for
      @how = :ole_object 
      return @o.for
    end
    
    def hover
     assert_exists
     driver.action.move_to(@element).perform
    end
    
  end 
end