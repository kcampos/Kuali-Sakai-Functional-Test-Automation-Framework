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
  
  # Login
  def login(username, password)
    frame = @browser.frame(:id, "ifrm")
    frame.text_field(:id, "eid").set username
    frame.text_field(:id, "pw").set password
    frame.form(:method, "post").submit
  end
  
end