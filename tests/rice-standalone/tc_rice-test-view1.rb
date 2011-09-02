#!/usr/bin/env ruby
# load the Selenium-Client gem
require "rubygems"
require "selenium/client"

# Load Test::Unit, Ruby 1.8's default test framework.
# If you prefer RSpec, see the examples in the Selenium-Client
# documentation.
require "test/unit"
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/locators.rb"
require File.dirname(__FILE__) + "/../../lib/rice-standalone/rice_app_functions.rb"

class TestView1 < Test::Unit::TestCase

  # The setup method is called before each test.
  def setup

    # This array is used to capture errors and display them at the
    # end of the test run.
    @verification_errors = []
    
    # Get config
    @config = AutoConfig.new
    puts @config.to_s
    
    # Get locators
    @locators = RiceLocators.new
    
    # Load app methods
    @app = RiceAppFunctions.new(@config)
    @selenium = @app.selenium

    # Print a message in the browser-side log and status bar
    # (optional).
    @selenium.set_context("test_sample")

  end

  # The teardown method is called after each test.
  def teardown

    # Stop the browser session.
    @selenium.stop

    # Print the array of error messages, if any.
    #assert_equal [], @verification_errors
  end

  # This is the main body of your test.
  def test_sample_view_1

    # Open the root of the site we specified when we created the
    # new driver instance, above.
    @app.open_root_page
    
    puts "Logging in..."
    assert @app.login, "Did not login successfully"
    
    puts "Interacting with Test View 1..."
    assert @app.test_view_1_interface, "Did not interact with Test View 1 successfully"
    
    puts "Done"
    
  end
end