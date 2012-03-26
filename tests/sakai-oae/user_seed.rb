#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Academic Smoke tests. Shallowly tests a broad range of features. This script will
# eventually be deprecated in favor of the more robust ts_smoke_tests.rb test suite.
# 
# Author: Abe Heward (aheward@rSmart.com)
$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")
["watir-webdriver", "../../config/OAE/config.rb",
  "utilities", "sakai-OAE/app_functions",
  "sakai-OAE/page_elements" ].each { |item| require item }

@config = AutoConfig.new
@browser = @config.browser

#Hash of user information to use
@people = YAML.load_file("#{File.dirname(__FILE__)}/../../config/OAE/directory.yml")

# Get a count of how many users will be added
count = 1
while @people["person#{count}"] != nil do
  count+=1
end
count = count-1

11.upto(count) do |x|

  login = LoginPage.new @browser
  signup = login.sign_up 
  signup.wait_for_ajax
  signup.user_name=@people["person#{x}"]["id"]
  signup.new_password=@people["person#{x}"]["password"]
  signup.retype_password=@people["person#{x}"]["password"]
  signup.title="Dr."
  signup.first_name=@people["person#{x}"]["firstname"]
  signup.last_name=@people["person#{x}"]["lastname"]
  signup.institution="Foo U"
  signup.role=@people["person#{x}"]["role"]
  signup.uncheck_contact_me_directly
  signup.uncheck_receive_tips
  signup.email=@people["person#{x}"]["email"]
  signup.email_confirm=@people["person#{x}"]["email"]
  dash = signup.create_account
  dash.sign_out
  
end

@browser.close
