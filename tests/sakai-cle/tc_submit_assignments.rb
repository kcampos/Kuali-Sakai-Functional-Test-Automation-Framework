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
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case requires logging in with a student user
    @user_name = @config.directory['person1']['id']
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @password = @config.directory['person1']['password']
    @sakai = SakaiCLE.new(@browser)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
    assert_equal [], @verification_errors
  end
  
  def test_complete_assignments
    
    # Gather the assignment ids for later
    assignment_ids = []
    1.upto(5) { |x| assignment_ids << @config.directory["site1"]["assignment#{x}"]}
    
    # Log in to Sakai
    @sakai.login(@user_name, @password)
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
    
    # Go to test site.
    @browser.link(:href, /#{@site_id}/).click
    home = Home.new(@browser)
    
    # Go to assignments page
    home.assignments
    
    assignment1_title = frm.link(:href=>/#{assignment_ids[3]}/).text
 
    # Open the first assignment
    frm.link(:href=>/#{assignment_ids[3]}/).click

    # Enter in assignment text
    assignment_1_text = "Etiam nec tellus. Nulla semper volutpat ipsum. Cras lectus magna, convallis eget, molestie ac, pharetra vel, lorem. Etiam massa velit, vulputate ut, malesuada aliquet, pretium vitae, arcu. In ipsum libero, porttitor ac, viverra eu, feugiat et, tortor. Donec vel turpis ac tortor malesuada sollicitudin! Ut et lectus. Mauris sodales. Fusce ultrices euismod metus. Aliquam eu felis eget diam malesuada bibendum. Nunc a orci in augue condimentum blandit. Proin at dolor. Donec velit. Donec ullamcorper eros a ligula. Sed ullamcorper risus nec nisl. Nunc vel justo ut risus interdum faucibus. Sed dictum tempus ipsum! In neque dolor, auctor vel, accumsan pulvinar, feugiat sit amet, urna. Aenean sagittis luctus felis.\n\nAenean elementum pretium urna. Nullam eleifend congue nulla. Suspendisse potenti. Nullam posuere elit. Sed tellus. In facilisis. Nulla aliquet, turpis nec dictum euismod, nisl dui gravida leo, et volutpat odio eros sagittis sapien. Aliquam at purus? Nunc nibh diam; imperdiet ut, sodales ut, venenatis a, leo? Suspendisse pede. Maecenas congue risus et leo! Praesent urna purus, lobortis at; dapibus nec, dictum id, elit. Vivamus gravida odio non tellus. Aliquam non nulla."
    
    assignment1 = AssignmentStudent.new(@browser)
    
    assignment1.add_assignment_text(assignment_1_text)
    
    assignment1.file_field.value= File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle/documents/768.pdf"
    assignment1.add_another_file

    # Preview assignment
    assignment1.preview
    
    assignment1.file_field.wait_while_present
    
    # Verify file attachment
    assert frm.link(:text, "768.pdf").exist?
    
    # TEST CASE: Verify the entered text appears on the preview page
    assert_equal(assignment_1_text, frm.div(:class=>"portletBody").div(:class=>"textPanel").text)
    
    # Save as draft
    frm.button(:id=>"save").click
    
    # TEST CASE: Verify saved as a draft
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"success").text, "You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button.")
    # Go back to assignment list
    frm.button(:name, "eventSubmit_doConfirm_assignment_submission").click

    # turn the assignments table into an array...
    assignments_table = frm.div(:class=>"portletBody").table(:class, "listHier lines nolines").to_a
    index = assignments_table.find_index { |row| row.include?(assignment1_title)}
    
    # TEST CASE: Verify assignment shows as draft in list
    assert_equal(assignments_table[index][2], "Draft - In progress")
    
    # Edit assignment
    frm.link(:href=>/#{assignment_ids[3]}/).click
    assignment1 = AssignmentStudent.new(@browser)
    
    # Submit assignment
    assignment1.submit
    
    # TEST CASE: Verify Submission confirmation message.
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"success").text, "You have successfully submitted your work. You will receive an email confirmation containing this information.")
    
    frm.button(:name, "eventSubmit_doConfirm_assignment_submission").click
    
    submitted_date = @sakai.make_date(Time.now)
    puts submitted_date
    
    # TEST CASE: Verify list shows assignment submitted
    assert_equal(frm.div(:class=>"portletBody").table(:class, "listHier lines nolines")[index][2].text, "Submitted #{submitted_date}")
  
    # Open an assignment that allows 1 resubmission
    frm.link(:href=>/#{assignment_ids[1]}/).click

    # Fill it out and submit
    assignment_2_text1 = "First submission. Proin vel arcu vestibulum mauris accumsan tristique at eget dolor. Maecenas lobortis, ligula a tincidunt fringilla, diam arcu sollicitudin lorem, id cursus erat arcu sed felis. Maecenas id magna elit, at laoreet ligula. Nam molestie, diam quis euismod mattis, mauris massa fringilla ante, non volutpat turpis velit non nisi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus congue condimentum urna, non venenatis leo blandit quis. Phasellus rutrum scelerisque quam, et placerat elit porta id. Donec vel diam velit, id adipiscing massa. Donec ut eleifend nunc.\n\nUt mauris elit, fermentum et ultrices at, commodo sit amet arcu. Ut arcu nisi, porta in pulvinar ac, pharetra dignissim urna. Proin blandit volutpat eros, sit amet porttitor lectus accumsan non. Nullam porttitor urna at elit elementum sit amet suscipit velit convallis. Quisque at libero enim, quis facilisis tellus. Aenean orci nibh, semper vel tempor a; consectetur non erat. Pellentesque scelerisque, libero sit amet posuere gravida, ligula erat pulvinar nulla, vitae placerat arcu purus et arcu. Ut urna urna, eleifend ut sagittis et, porttitor eu elit. Pellentesque auctor massa tellus. Aliquam lacinia euismod dolor quis mollis. Vestibulum tincidunt semper semper. Nullam non lorem non augue consectetur accumsan quis a odio? Duis id tellus eget est aliquam bibendum? Fusce neque massa, volutpat eget feugiat quis, tincidunt id dui. Nunc accumsan libero sed arcu fringilla a luctus risus sollicitudin. Nulla faucibus, tellus eget consequat facilisis, arcu massa volutpat tellus, non faucibus leo nunc vitae ipsum. Pellentesque vestibulum nisi at sem molestie vel eleifend arcu condimentum."
    assignment_2_text2 = "Second submission. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tincidunt viverra urna quis ultrices. Nulla dignissim ornare lectus, vel dictum elit malesuada a. Ut elementum venenatis volutpat. Sed at tincidunt massa. In hac habitasse platea dictumst. Aenean lobortis purus vel lorem euismod accumsan. In mi justo, pretium in semper quis, varius vel diam. Donec mattis justo vitae odio venenatis et fermentum nibh fermentum. Aliquam massa erat, vestibulum convallis ultrices non, elementum ac diam. Proin non sodales lorem. Phasellus eget nunc non erat tristique condimentum.Suspendisse commodo rhoncus magna quis aliquam. Fusce consequat sem at odio porta ultricies. Integer rutrum tincidunt tempor. Sed sagittis porta semper. Integer dictum lacus et dui mollis fringilla. Etiam a lacus ac purus facilisis faucibus. Donec et varius mauris. Fusce volutpat porta eros, a congue sem dapibus nec. Phasellus fermentum velit non erat consequat mattis ut a tellus."

    assignment2 = AssignmentStudent.new(@browser)
    assignment2.add_assignment_text(assignment_2_text1)
    
    assignment2.submit
    
    # Verify submission
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"success").text, "You have successfully submitted your work. You will receive an email confirmation containing this information.")
    
    frm.button(:name, "eventSubmit_doConfirm_assignment_submission").click
   
    # Edit it and resubmit
    frm.link(:href=>/#{assignment_ids[1]}/).click

    assignment2 = AssignmentStudent.new(@browser)
    
    # Clear out the field
    assignment2.remove_assignment_text

    # Enter the new text
    assignment2.add_assignment_text(assignment_2_text2)
    
    assignment2.submit
    
    # Verify submission
    assert_equal(frm.div(:class=>"portletBody").div(:class=>"success").text, "You have successfully submitted your work. You will receive an email confirmation containing this information.")
    
    # Verify changed assignment text
    assert_equal(assignment_2_text2, frm.div(:class=>"portletBody").div(:class=>"textPanel indnt2").text)

    # Back to list
    frm.button(:name=>"eventSubmit_doConfirm_assignment_submission").click

    # Edit assignment again
    frm.link(:href=>/#{assignment_ids[1]}/).click

    # Verify the user is not allowed to edit assignment
    assert frm.button(:name=>"eventSubmit_doCancel_view_grade").exist?
    assert_equal(frm.button(:name=>"post").exist?, false)
    
  end
 
end
