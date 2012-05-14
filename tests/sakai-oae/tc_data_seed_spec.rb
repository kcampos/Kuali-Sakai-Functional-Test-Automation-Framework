#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# Tests uploading various files to the system. Verifies that
# the file descriptions are as expected. The files uploaded in
# this script will be used by other scripts in the test suite, so
# this script should be run early in the suite of tests.
#
# == Prerequisites
#
# There must be a valid user for logging in to the system.
#
# 
# Author: Abe Heward (aheward@rSmart.com)
require 'sakai-oae-test-api'
require 'yaml'

describe "Data Seeding" do
  
  include Utilities

  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    # Get the test configuration data
    config = YAML.load_file("config.yml")
    @file_path = config['data_directory']

    @directory = YAML.load_file("directory.yml")

    @username = @directory['admin']['username']
    @password = @directory['admin']['password']
    
    @sakai = SakaiOAE.new(config['browser'], config['url'])
    @login_page = @sakai.page
    @browser = @sakai.browser
    # Test Data...
    @files = [
    {:filename=>"#{@file_path}documents/resources.doc", :title=>"Word Doc", :description=>"A Word Document", :tag=>"Word", :mime=>"WORD DOCUMENT"},
    {:filename=>"#{@file_path}audio/resources.mp3", :title=>"Podcast", :description=>"An mp3 file", :tag=>"Audio", :mime=>"SOUND FILE"},
    {:filename=>"#{@file_path}images/flower01.jpg", :title=>"JPG Image", :description=>"A JPG image file", :tag=>"Image", :mime=>"JPG IMAGE"},
    {:filename=>"#{@file_path}documents/768.pdf", :title=>"PDF File", :description=>"A sample PDF file", :tag=>"PDF", :mime=>"PDF DOCUMENT"},
    {:filename=>"#{@file_path}movies/Spring.swf",:title=>"Flash Movie",:description=>"A flash movie",:tag=>"Flash", :mime=>"FLASH PLAYER FILE"},
    {:filename=>"#{@file_path}movies/Gage1.wmv", :title=>"Windows Meta Vid", :description=>"An AVI video file", :tag=>"Video", :mime=>"VIDEO FILE"},
    {:filename=>"#{@file_path}spreadsheets/resources.xls", :title=>"Excel Spreadsheet", :description=>"An Excel Spreadsheet file", :tag=>"XLS", :mime=>"SPREADSHEET DOCUMENT"},
    {:filename=>"#{@file_path}zips/Chronological Resume Template.zip", :title=>"Zip File", :description=>"A compressed file", :tag=>"Zip", :mime=>"ARCHIVE FILE"},
    {:filename=>"#{@file_path}documents/Lorem.txt", :title=>"Text File", :description=>"A Text File", :tag=>"Text", :mime=>"TEXT DOCUMENT"}
    ]
    
  end

  it "logs in" do
    @login_page.login(@username, @password)
  end

  it "uploads public test data" do

    @files.each do |file|
      dashboard = MyDashboard.new @browser
      dashboard.add_content
      dashboard.upload_file=file[:filename]
      dashboard.file_title=file[:title]
      dashboard.file_description=file[:description]
      dashboard.tags_and_categories=file[:tag]
      dashboard.add
      dashboard.done_add_collected
    end
    
    explore = dashboard.explore_content
    
    @files.each do |file|
      explore.search_for=file[:title]
      explore = ExploreContent.new @browser 
      explore.results.should include file[:title]
      explore.content_type(file[:title]).should == file[:mime]
    end
  end
  
  after :all do
    # Close the browser window
    @browser.close
  end

end
