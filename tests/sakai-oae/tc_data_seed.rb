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
# The test data files (see line 41 and following) should exist locally in the
# relative path /../../data/sakai-oae/ directory.
# 
# Author: Abe Heward (aheward@rSmart.com)
$: << File.expand_path(File.dirname(__FILE__) + "/../../lib/")
["rspec", "watir-webdriver", "../../config/OAE/config.rb",
  "utilities", "sakai-OAE/app_functions",
  "sakai-OAE/page_elements" ].each { |item| require item }

describe "Data Seeding" do
  
  include Utilities

  let(:dashboard) { MyDashboard.new @browser }

  before :all do
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @username = @config.directory['admin']['username']
    @password = @config.directory['admin']['password']
    
    @sakai = SakaiOAE.new(@browser)
    
    # Test Data...
    @files = [
    {:filename=>"documents/resources.doc", :title=>"Word Doc", :description=>"A Word Document", :tag=>"Word", :mime=>"WORD DOCUMENT"},
    {:filename=>"audio/resources.mp3", :title=>"Podcast", :description=>"An mp3 file", :tag=>"Audio", :mime=>"SOUND FILE"},
    {:filename=>"images/flower01.jpg", :title=>"JPG Image", :description=>"A JPG image file", :tag=>"Image", :mime=>"JPG IMAGE"},
    {:filename=>"documents/768.pdf", :title=>"PDF File", :description=>"A sample PDF file", :tag=>"PDF", :mime=>"PDF DOCUMENT"},
    {:filename=>"movies/Spring.swf",:title=>"Flash Movie",:description=>"A flash movie",:tag=>"Flash", :mime=>"FLASH PLAYER FILE"},
    {:filename=>"movies/guit.avi", :title=>"Movie", :description=>"An AVI video file", :tag=>"Video", :mime=>"VIDEO FILE"},
    {:filename=>"spreadsheets/resources.xls", :title=>"Excel Spreadsheet", :description=>"An Excel Spreadsheet file", :tag=>"XLS", :mime=>"SPREADSHEET DOCUMENT"},
    {:filename=>"zips/Chronological Resume Template.zip", :title=>"Zip File", :description=>"A compressed file", :tag=>"Zip", :mime=>"ARCHIVE FILE"},
    {:filename=>"documents/Lorem.txt", :title=>"Text File", :description=>"A Text File", :tag=>"Text", :mime=>"TEXT DOCUMENT"}
    ]
    
  end

  it "logs in" do
    @sakai.login(@username, @password)
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
