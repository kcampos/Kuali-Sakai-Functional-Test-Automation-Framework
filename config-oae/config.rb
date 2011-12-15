#!/usr/bin/env ruby
# 
# == Synopsis
#
# Creates an AutoConfig object that contains all configuration information for testing.

require 'yaml'

class AutoConfig
  
  attr_reader :url, :browser, :directory
  
  def initialize
    
    config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
    @directory = YAML.load_file("#{File.dirname(__FILE__)}/directory.yml")
    
    @web_browser  = config['server']['browser']
    @url          = config['server']['url']
    
    @browser = Watir::Browser.new @web_browser
    @browser.goto @url
    @browser.button(:id=>"footer_logo_button").wait_until_present
    
  end
  
end