#!/usr/bin/env ruby
# coding: UTF-8
# 
# == Synopsis
#
# This script is about ‘My Library’: what you should see when you don’t
# have anything in your Library yet, what you should see for each item if you do
# have items in your Library etc
#
# == Prerequisites:
#
# The system should have various items of content--run the tc_data_seed.rb script
# before this one. See the before section starting on line 25 for specifics.
# Also ensure that user1 and user2 are contacts.
# 
# Author: Abe Heward (aheward@rSmart.com)
require '../../features/support/env.rb'
require '../../lib/sakai-oae'

describe "My Library" do
  
  include Utilities
  
  let(:library) { MyLibrary.new @browser }

  before :all do
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # Test user information from directory.yml...
    @user1 = @config.directory['person1']['id']
    @pass1 = @config.directory['person1']['password']
    @name1 = "#{@config.directory['person1']['firstname']} #{@config.directory['person1']['lastname']}"
    @user2 = @config.directory['person2']['id']
    @pass2 = @config.directory['person2']['password']
    @name2 = "#{@config.directory['person2']['firstname']} #{@config.directory['person2']['lastname']}"
    
    @sakai = SakaiOAE.new(@browser)
    dash = @sakai.login(@user1, @pass1)
    dash.my_library
    
    @file = "Earth and Moon.gif"
    @file_type = "GIF IMAGE"
    @file_description = "file description"
    @file_tag = "tag"
    @file_comment = random_alphanums
    @existing_file = "Text File"
    @ef_type = "TEXT DOCUMENT"
    
    @more_files = [
      "Venus.gif",
      "Mars.gif",
      "Earth (Americas).gif",
      "Earth (Australasia).gif",
      "Earth (Clouds).gif",
      "Extrasolar Giant.gif",
      "Jupiter.gif"
    ]
    
  end

  it "when empty it shows the empty bubble" do
    library.empty_library.should exist
  end

  it "Search box not present in an empty Library" do
    library.search_library_element.should_not be_visible
  end

  it "'Add content' button present in empty library" do
    library.empty_library_add_content_button_element.should be_visible
  end

  it "shows content user has uploaded" do
    library.add_content
    library.upload_file=@file
    library.who_can_see_file="Only me"
    library.file_description=@file_description
    library.tags_and_categories=@file_tag
    library.add
    library.done_add_collected
    library.documents.should include @file
  end

  it "Items managed by user can be removed from system" do
    library.delete @file
    library.delete_from_the_system_button_element.should be_visible
    library.cancel
  end

  it "Clicking the 'Share with' icon brings up the 'Share with' pop up dialog" do
    library.share @file
    library.share_with_field_element.should be_visible
    library.share_with=@name2
    library.share
    library.sign_out
  end

  it "shows content shared with user" do
    dash = @sakai.login(@user2, @pass2)
    library = dash.my_library
    library.documents.should include @file
  end

  it "shows content added from other libraries" do
    library.add_content
    library.all_content
    # Next line doesn't work due to a bug in the system...
    #library.search_for_content=@existing_file
    library.check_content @existing_file
    library.add
    library.done_add_collected
    library.documents.should include @existing_file
  end
  
  it "Left menu item shows count of library items" do
    library.my_library_count.should == 2
  end

  it "Items shared with user can only be removed from personal library" do
    library.delete @file
    library.delete_from_the_system_button_element.should_not be_visible
    library.cancel_deleting_content
    library.delete @existing_file
    library.delete_from_the_system_button_element.should_not be_visible
    library.cancel_deleting_content
  end
  
  it "'Remove' button disabled when no items are selected" do
    library.remove_selected_button_element.should be_disabled
  end

  it "Checkbox in Header will select all checkboxes in the list" do
    library.checkbox(@file).should_not be_set
    library.check_select_all_library_items
    library.checkbox(@file).should be_set
    library.checkbox(@existing_file).should be_set
  end
  
  it "'Remove' button becomes active when an item is selected" do
    library.remove_selected_button_element.should be_enabled
  end
  
  it "Listings display the content's mime type, if known" do
    library.content_type(@file).should == @file_type
    library.content_type(@existing_file).should == @ef_type
  end

  it "Content listing includes name of user who added the item" do
    library.content_owner(@file).should == @name1
  end
  
  it "Content listing includes information about when it was last updated" do
    library.last_updated(@file).should match(/^Changed.+ago$/)
    library.last_updated(@existing_file).should match(/^Changed.+ago$/)
  end
  
  it "Content listing includes description, if the content has it" do
    library.content_description(@file).should == @file_description
  end
  
  it "Content listing includes the number of comments made on the item" do
    document = library.open_document @file
    document.comment_text=@file_comment
    document.comment
    library = document.my_library
    library.comments_count(@file).should == 1
  end
  
  it "Content listing includes any clickable tags" do
    library.content_tags(@file).should include @file_tag
  end
  
  it "Clicking a tag takes user to search page and searches on that tag" do
    search = library.search_by_tag @file_tag
    search.results_list.should include @file
    search.my_library
  end

  it "Search box is available when the Library has contents" do
    library.search_library_element.should be_visible
  end

  it "Search returns expected results" do
    library.search_library_for=@file
    library.documents.should include @file
    library.documents.should_not include @existing_file
    library.search_library_for=" "
  end
  
  it "default sort order is 'Recently changed'" do
    library.sort_by_list.should == "Recently changed"
  end
  
  # This and the next are in a pending status because
  # the system has a bug.
  it "Sorting by 'A-Z' returns expected results" do
    @more_files.each do |file|
      library.add_content
      library.upload_file=file
      library.add
      library.done_add_collected
    end
    library.sort_by="A-Z"
    #library.documents[0].should == @more_files[2]
  end
  
  xit "Sorting by 'Z-A' returns expected results" do
    library.sort_by="Z-A"
    library.documents[0].should == @more_files[0]
  end

  it "'Remove from library' will leave the content available on the system" do
    library.remove @more_files[1]
    library.remove_from_library
    library.documents.should_not include @more_files[1]
    search = library.explore_content
    search.search_for=@more_files[1]
    search.documents.should include @more_files[1]
  end

  it "'Delete from the system' button will remove content from everywhere in the system" do
    library.my_library
    library.remove @more_files[3]
    library.delete_from_the_system
    library.documents.should_not include @more_files[3]
    search = library.explore_content
    search.search_for=@more_files[3]
    search.documents.should_not include @more_files[3]
  end

  it "Content listings have thumbnails" do
    library.my_library
    library.thumbnail(@more_files[4]).should be
  end
  
  it "Clicking content title takes user to detail page" do
    document = library.open_document @file
    document.first_comment[:message].should == @file_comment
    document.description.should == @file_description
  end

  it "Clicking content owner takes user to that owner's profile page" do
    library.my_library
    profile = library.view_owner_of @file
    profile.contact_name.should == @name1
  end

  after :all do
    # Close the browser window
    @browser.close
  end

end
