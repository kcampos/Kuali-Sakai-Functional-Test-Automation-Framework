#!/usr/bin/env ruby

# 
# == Synopsis
#
# Creates an AutoConfig object that contains all configuration information for selenium testing.
#
# Author:: Kyle Campos (mailto:kcampos@rsmart.com)
#

class AutoConfig
  
  attr_reader :host, :port, :browser, :url, :app_context, :user, :selenium
  
  def initialize
    
    puts "Dir: #{}"
    config = YAML.load_file("#{File.dirname(__FILE__)}/config.yml")
    
    @host          = config['server']['host']
    @port          = config['server']['port']
    @browser       = config['server']['browser']
    @url           = config['server']['url']
    @app_context   = config['server']['app_context']
    @user          = config['user']['username']
    @user_password = config['user']['password']
    
    # Create a new instance of the Selenium-Client driver.
    @selenium = Selenium::Client::Driver.new(
      :host => @host,
      :port => @port,
      :browser => @browser,
      :url => @url,
      :timeout_in_second => 60
    )
      
    # Start the browser session
    @selenium.start
    @selenium.set_timeout 0
    @selenium.set_speed 2000
    
  end
  
  def to_s
    "Host: #{@host}\nPort: #{@port}\nBrowser: #{@browser}\nURL: #{@url}\nApp Context: #{@app_context}\nUser: #{user}\nUser Password: #{@user_password}"
  end
  
end