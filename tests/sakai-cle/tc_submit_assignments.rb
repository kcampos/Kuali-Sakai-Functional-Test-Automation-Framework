# 
# == Synopsis
#
# Tests a student user interacting with existing assignments
#
# Author: Abe Heward (aheward@rSmart.com)

require "test/unit"
require 'watir-webdriver'
require File.dirname(__FILE__) + "/../../config/config.rb"
require File.dirname(__FILE__) + "/../../lib/utilities.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/page_elements.rb"
require File.dirname(__FILE__) + "/../../lib/sakai-CLE/app_functions.rb"

class TestCompleteAssignment < Test::Unit::TestCase
  
  include Utilities

  def setup
    @verification_errors = []
    
    # Get the test configuration data
    config = AutoConfig.new
    @browser = config.browser
    # This test case requires logging in with a student user
    @user_name = config.directory['person1']['id']
    @password = config.directory['person1']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_complete_assignments
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Go to test site.
    # Note that this test site is currently hard-coded.
    # This should be corrected as soon as possible.
    @browser.link(:text, "1 2 3 F11").click
    home = Home.new(@browser)
    
    # Go to assignments page
    home.assignments
    
    # Open the first assignment
    # Note that we should eventually set up persistent test data for this test
    # Until then, we're just going to pick the first assigment listed...
    frm.link(:href=>/sakai_action=doView_submission/, :index=>0).click

    # Enter in assignment text
    assignment_1_text = "Etiam "#nec tellus. Nulla semper volutpat ipsum. Cras lectus magna, convallis eget, molestie ac, pharetra vel, lorem. Etiam massa velit, vulputate ut, malesuada aliquet, pretium vitae, arcu. In ipsum libero, porttitor ac, viverra eu, feugiat et, tortor. Donec vel turpis ac tortor malesuada sollicitudin! Ut et lectus. Mauris sodales. Fusce ultrices euismod metus. Aliquam eu felis eget diam malesuada bibendum. Nunc a orci in augue condimentum blandit. Proin at dolor. Donec velit. Donec ullamcorper eros a ligula. Sed ullamcorper risus nec nisl. Nunc vel justo ut risus interdum faucibus. Sed dictum tempus ipsum! In neque dolor, auctor vel, accumsan pulvinar, feugiat sit amet, urna. Aenean sagittis luctus felis.\n\nAenean elementum pretium urna. Nullam eleifend congue nulla. Suspendisse potenti. Nullam posuere elit. Sed tellus. In facilisis. Nulla aliquet, turpis nec dictum euismod, nisl dui gravida leo, et volutpat odio eros sagittis sapien. Aliquam at purus? Nunc nibh diam; imperdiet ut, sodales ut, venenatis a, leo? Suspendisse pede. Maecenas congue risus et leo! Praesent urna purus, lobortis at; dapibus nec, dictum id, elit. Vivamus gravida odio non tellus. Aliquam non nulla."
    
    assignment1 = AssignmentStudent.new(@browser)
    
    assignment1.add_assignment_text(assignment_1_text)
    
    # Preview assignment
    assignment1.preview
    
    # TEST CASE: Verify the entered text appears on the preview page
    assert_equal(assignment_1_text, frm.div(:class=>"portletBody").div(:class=>"textPanel").text)
    
    # Save as draft
    frm.button(:id=>"save").click
    
    # TEST CASE: Verify saved as a draft
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"success").text, "You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button. ")
    
    # Go back to assignment list
    frm.button(:name, "eventSubmit_doConfirm_assignment_submission").click
    
    # TEST CASE: Verify assignment shows as draft in list
    assert_equal(frm.div(:class=>"portletBody").table(:class, "listHier lines nolines")[1][1].text, "Draft - In progress")
    
    # Edit assignment
    
    # Submit assignment
    
    # Verify submitted
    
    #===============
    # Need to add tests for adding attachments here
    # But first we need to have properly set up resources
    # on the test site
    #===============
    
    # Open an assignment that allows 1 resubmission
    
    # Fill it out and submit
    
    # Verify submission
    
    # Edit it and resubmit
    
    # Verify submission
    
    # Edit assignment again
    
    # Verify the user is not allowed to edit assignment
    
    
  end
  
  def verify(&blk)
    yield
  rescue Test::Unit::AssertionFailedError => ex
    @verification_errors << ex
  end
  
end
