#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# This script tests the Given and Family name fields in a user's
# profile. Tests the problem reported in ACAD-941
#
# == Prerequisites:
#
# A valid user login.
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Name Field Tests" do

  include Utilities

  let(:basic_info) { MyProfileBasicInfo.new @browser }

  def test(first, last)
    basic_info.given_name=first
    basic_info.family_name=last
    basic_info.update
    basic_info.notification.should=="Your profile information has been updated"
    login_page = basic_info.sign_out
    dash = login_page.login(@user1, @pass1)
    dash.my_profile
    basic_info.given_name.should == first
    basic_info.family_name.should == last
    basic_info.user_options_name_element.attribute("offsetTop").should == @offset1
    basic_info.user_options_name_element.should be_visible
    basic_info.help_element.attribute("offsetTop").should == @offset2
  end

  before :all do

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @directory = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    # Test user information from directory.yml...
    @user1 = @directory['person17']['id']
    @pass1 = @directory['person17']['password']
    @first = "#{@directory['person17']['firstname']}"
    @last = "#{@directory['person17']['lastname']}"

    
    dash = @sakai.page.login(@user1, @pass1)
    @offset1 = dash.user_options_name_element.attribute_value("offsetTop")
    @offset2 = dash.help_element.attribute_value("offsetTop")
    dash.my_profile

  end

  it "User can update Name fields with strings of lowercase letters" do
    first=random_letters(36)
    last=random_letters(36)
    test(first, last)
  end

  it "User can update Name fields with mixed-case strings, with numbers" do
    first=random_alphanums(36)
    last=random_alphanums(36)
    test(first, last)
  end

  it "User can update Name fields with strings that have non-alphanum chars" do
    first=random_alphanums_plus(36)
    last=random_alphanums_plus(36)
    test(first, last)
  end

  it "User can update Name fields with strings that have European chars" do
    first=random_string(36)
    last=random_string(36)
    test(first, last)
  end

  it "User can update Name fields with strings that have High ASCII chars" do
    first=random_high_ascii(36)
    last=random_high_ascii(36)
    test(first, last)
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
