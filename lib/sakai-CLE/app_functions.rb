#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

require 'watir-webdriver'
require File.dirname(__FILE__) + '/page_elements.rb'

class SakaiCLE
  
  def initialize(browser)
    @browser = browser
  end
  
  # Log in
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
    MyWorkspace.new(@browser)
  end
  
  # Log out
  def logout
    @browser.link(:text, "Logout").click
  end
  
  # Format a date string Sakai-style.
  # Useful for verifying creation dates and such.
  def make_date(time_object)
    month = time_object.strftime("%b ")
    day = time_object.strftime("%d").to_i
    year = time_object.strftime(", %Y ")
    mins = time_object.strftime(":%M %P")
    hour = time_object.strftime("%l").to_i
    return month + day.to_s + year + hour.to_s + mins
  end
  
end