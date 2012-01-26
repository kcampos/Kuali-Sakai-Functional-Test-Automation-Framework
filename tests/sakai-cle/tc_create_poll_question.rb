#!/usr/bin/env ruby
# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
gems = ["test/unit", "watir-webdriver", "ci/reporter/rake/test_unit_loader"]
gems.each { |gem| require gem }
files = [ "/../../config/CLE/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestPollCreation < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @student_id = @config.directory['person1']['id']
    @student_pw = @config.directory['person1']['password']    
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables...
    @poll = {
      :question => "Is this the best class ever?",
      :instructions => "Let us know what you think of this course. We are always striving to bring you the best in quality academics :)",
      :options => [
        "Yes, this is the best class ever!",
        "This is a great class, but I've had better.",
        "Not my favorite class. Not even a Top 10.",
        "This class is terrible; you should be fired."
      ]
    }
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_creating_a_poll
    
    # Log in to Sakai
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    polls = home.polls
    
    add_poll = polls.add
    add_poll.question=@poll[:question]
    add_poll.additional_instructions=@poll[:instructions]
    
    add_option1 = add_poll.save_and_add_options
    
    add_option1.answer_option=@poll[:options][0]
    
    add_option2 = add_option1.save_and_add_options
    
    add_option2.answer_option=@poll[:options][1]
    
    add_option3 = add_option2.save_and_add_options
    
    add_option3.answer_option=@poll[:options][2]
    
    add_option4 = add_option1.save_and_add_options
    
    add_option4.answer_option=@poll[:options][3]
    
    edit_poll = add_option4.save
    
    polls = edit_poll.save
    
    #TEST CASE: Verify poll saved
    assert polls.list.include? @poll[:question]
    
    @sakai.logout
    
    workspace = @sakai.login(@student_id, @student_pw)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    polls = home.polls
    
    # TEST CASE: Verify the student can see the new poll
    assert polls.list.include? @poll[:question]
    
  end
  
end
