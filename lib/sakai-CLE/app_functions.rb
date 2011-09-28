#!/usr/bin/env ruby
# 
# == Synopsis
#
# This file contains custom methods used throughout the Sakai test scripts

require 'watir-webdriver'

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
  end
  
  # Log out
  def logout
    @browser.link(:text, "Logout").click
  end
  
  # Format a date string Sakai-style.
  # Useful for verifying creation dates and such.
  def make_date(time_object)
    front = time_object.strftime("%b %d, %Y ")
    back = time_object.strftime(":%M %P")
    hour = time_object.strftime("%l").to_i
    return front + hour.to_s + back
  end
  
end