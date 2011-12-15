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
    
  end
  
end


# Need this to extend Watir to be able to attach to Sakai's non-standard tags...
module Watir 
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
    
  end 
end