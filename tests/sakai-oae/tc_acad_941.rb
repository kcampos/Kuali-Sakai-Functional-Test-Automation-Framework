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
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "Name Field Tests" do

  include Utilities

  let(:basic_info) { MyProfileBasicInfo.new @browser }

  def test(first, last)
    basic_info.given_name=first
    basic_info.family_name=last
    basic_info.update
    basic_info.notification.should=="Your profile information has been updated"
    @sakai.sign_out
    dash = @sakai.login(@user1, @pass1)
    dash.my_profile
    basic_info.given_name.should == first
    basic_info.family_name.should == last
    basic_info.user_options_name_element.attribute("offsetTop").should == @offset1
    basic_info.user_options_name_element.should be_visible
    basic_info.help_element.attribute("offsetTop").should == @offset2
  end

  before :all do

    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user information from directory.yml...
    @user1 = @config.directory['person17']['id']
    @pass1 = @config.directory['person17']['password']
    @first = "#{@config.directory['person17']['firstname']}"
    @last = "#{@config.directory['person17']['lastname']}"

    @sakai = SakaiOAE.new(@browser)
    dash = @sakai.login(@user1, @pass1)
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
