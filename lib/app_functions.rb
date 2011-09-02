#!/usr/bin/env ruby
# 
# == Synopsis
#
# Creates a locator object that contains all locator information for selenium testing.
#
# Author:: Kyle Campos (mailto:kcampos@rsmart.com)
#

require "test/unit"

class AppFunctions
  
  # Let clients access selenium object to handle direct selenium calls
  attr_reader :selenium
  
  def initialize(config)
    @config = config
    @selenium = @config.selenium
  end
  
  # Open root app context
  def open_root_page
    @selenium.open "/#{@config.app_context}"
    @selenium.wait_for_page_to_load
  end
  
  # Login
  def login()
    @selenium.type "__login_user", "admin"
    @selenium.key_press "__login_user", '\13'    
    @selenium.wait_for_element "link=Test View 1"
    
    # Returns TRUE if login was successful
    @selenium.is_text_present("Logged in User")
  end
  
end