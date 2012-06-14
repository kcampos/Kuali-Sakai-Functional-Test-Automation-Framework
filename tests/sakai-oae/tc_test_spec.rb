#!/usr/bin/env ruby
# coding: UTF-8
#
# == Synopsis
#
# Tests the My Memberships page for basic UI functionality.
#
# == Prerequisites:
#
# See lines 28-35 for required user information
#
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Test" do

  include Utilities

  let(:memberships) { MyMemberships.new @browser }

  before :all do

    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @sakai = SakaiOAE.new(@config['browser'], @config['url'])
    @directory = YAML.load_file("directory.yml")
    @browser = @sakai.browser
    # Test user information from directory.yml...


  end

  it "Test" do
    dash = @sakai.page.login("test_user_1", "password")

    memberships = dash.my_memberships
    course = memberships.open_course "Test_1_Course"
    assignments = course.open_assignments "Assignments"
    puts assignments.assignment_titles
    assignments.student_view
    sleep 1
    assignments.options
    sleep 1
    assignments.select_page_size "Show 5 items..."
    sleep 5

  end

end
