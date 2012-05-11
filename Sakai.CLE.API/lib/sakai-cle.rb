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
    @test_data_path = "#{File.dirname(__FILE__)}/../data"
    
    @web_browser  = config['server']['browser']
    @url          = config['server']['url']
    
    @browser = Watir::Browser.new @web_browser
    @browser.goto @url
    $frame_index = 0
    
  end
  
end