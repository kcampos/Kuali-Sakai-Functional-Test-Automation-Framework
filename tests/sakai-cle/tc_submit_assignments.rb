# 
# == Synopsis
#
# Tests a student user interacting with existing assignments
#
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCompleteAssignment < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case requires logging in with a student user
    @user_name = @directory['person1']['id']
    @password = @directory['person1']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test case variables
    @assignment_1_title = @directory["site1"]["assignment4"]
    @assignment_2_title = @directory["site1"]["assignment2"]
    
    @assignment_1_text = "Etiam nec tellus. Nulla semper volutpat ipsum. Cras lectus magna, convallis eget, molestie ac, pharetra vel, lorem. Etiam massa velit, vulputate ut, malesuada aliquet, pretium vitae, arcu. In ipsum libero, porttitor ac, viverra eu, feugiat et, tortor. Donec vel turpis ac tortor malesuada sollicitudin! Ut et lectus. Mauris sodales. Fusce ultrices euismod metus. Aliquam eu felis eget diam malesuada bibendum. Nunc a orci in augue condimentum blandit. Proin at dolor. Donec velit. Donec ullamcorper eros a ligula. Sed ullamcorper risus nec nisl. Nunc vel justo ut risus interdum faucibus. Sed dictum tempus ipsum! In neque dolor, auctor vel, accumsan pulvinar, feugiat sit amet, urna. Aenean sagittis luctus felis.\n\nAenean elementum pretium urna. Nullam eleifend congue nulla. Suspendisse potenti. Nullam posuere elit. Sed tellus. In facilisis. Nulla aliquet, turpis nec dictum euismod, nisl dui gravida leo, et volutpat odio eros sagittis sapien. Aliquam at purus? Nunc nibh diam; imperdiet ut, sodales ut, venenatis a, leo? Suspendisse pede. Maecenas congue risus et leo! Praesent urna purus, lobortis at; dapibus nec, dictum id, elit. Vivamus gravida odio non tellus. Aliquam non nulla."
    @assignment_2_text1 = "First submission. Proin vel arcu vestibulum mauris accumsan tristique at eget dolor. Maecenas lobortis, ligula a tincidunt fringilla, diam arcu sollicitudin lorem, id cursus erat arcu sed felis. Maecenas id magna elit, at laoreet ligula. Nam molestie, diam quis euismod mattis, mauris massa fringilla ante, non volutpat turpis velit non nisi. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus congue condimentum urna, non venenatis leo blandit quis. Phasellus rutrum scelerisque quam, et placerat elit porta id. Donec vel diam velit, id adipiscing massa. Donec ut eleifend nunc.\n\nUt mauris elit, fermentum et ultrices at, commodo sit amet arcu. Ut arcu nisi, porta in pulvinar ac, pharetra dignissim urna. Proin blandit volutpat eros, sit amet porttitor lectus accumsan non. Nullam porttitor urna at elit elementum sit amet suscipit velit convallis. Quisque at libero enim, quis facilisis tellus. Aenean orci nibh, semper vel tempor a; consectetur non erat. Pellentesque scelerisque, libero sit amet posuere gravida, ligula erat pulvinar nulla, vitae placerat arcu purus et arcu. Ut urna urna, eleifend ut sagittis et, porttitor eu elit. Pellentesque auctor massa tellus. Aliquam lacinia euismod dolor quis mollis. Vestibulum tincidunt semper semper. Nullam non lorem non augue consectetur accumsan quis a odio? Duis id tellus eget est aliquam bibendum? Fusce neque massa, volutpat eget feugiat quis, tincidunt id dui. Nunc accumsan libero sed arcu fringilla a luctus risus sollicitudin. Nulla faucibus, tellus eget consequat facilisis, arcu massa volutpat tellus, non faucibus leo nunc vitae ipsum. Pellentesque vestibulum nisi at sem molestie vel eleifend arcu condimentum."
    @assignment_2_text2 = "Second submission. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tincidunt viverra urna quis ultrices. Nulla dignissim ornare lectus, vel dictum elit malesuada a. Ut elementum venenatis volutpat. Sed at tincidunt massa. In hac habitasse platea dictumst. Aenean lobortis purus vel lorem euismod accumsan. In mi justo, pretium in semper quis, varius vel diam. Donec mattis justo vitae odio venenatis et fermentum nibh fermentum. Aliquam massa erat, vestibulum convallis ultrices non, elementum ac diam. Proin non sodales lorem. Phasellus eget nunc non erat tristique condimentum.Suspendisse commodo rhoncus magna quis aliquam. Fusce consequat sem at odio porta ultricies. Integer rutrum tincidunt tempor. Sed sagittis porta semper. Integer dictum lacus et dui mollis fringilla. Etiam a lacus ac purus facilisis faucibus. Donec et varius mauris. Fusce volutpat porta eros, a congue sem dapibus nec. Phasellus fermentum velit non erat consequat mattis ut a tellus."
    
    @assignment_1_file = "documents/768.pdf"
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_complete_assignments
    
    # Log in to Sakai
    workspace = @sakai.page.login(@user_name, @password)
    
    # Go to test site.
    home = workspace.open_my_site_by_id(@site_id)
    
    # Go to assignments page
    assignments = home.assignments
    
    # Open the first assignment
    assignment1 = assignments.open_assignment @assignment_1_title

    # Enter in assignment text
    assignment1.assignment_text=@assignment_1_text
    
    # Add a file
    assignment1.select_file=@assignment_1_file
    assignment1.add_another_file

    # Preview assignment
    preview = assignment1.preview
    
    # Verify file attachment
    assert preview.attachments.include?(get_filename(@assignment_1_file))
    
    # TEST CASE: Verify the entered text appears on the preview page
    assert_equal @assignment_1_text, preview.submission_text
    
    # Save as draft
    confirm = preview.save_draft

    # TEST CASE: Verify saved as a draft
    assert_equal "You have successfully saved your work but NOT submitted yet. To complete submission, you must select the Submit button.", confirm.confirmation_text
    
    # Go back to assignment list
    assignments = confirm.back_to_list
    
    # TEST CASE: Verify assignment shows as draft in list
    assert_equal("Draft - In progress", assignments.status_of(@assignment_1_title))
    
    # Edit assignment
    assignment1 = assignments.open_assignment(@assignment_1_title)
    
    # Submit assignment
    confirm = assignment1.submit
    
    # TEST CASE: Verify Submission confirmation message.
    assert_equal("You have successfully submitted your work. You will receive an email confirmation containing this information.", confirm.confirmation_text )
    
    assignments = confirm.back_to_list
    
    submitted_date = make_date(Time.now) #.utc)
    
    # TEST CASE: Verify list shows assignment submitted
    assert_equal("Submitted #{submitted_date}", assignments.status_of(@assignment_1_title))
  
    # Open an assignment that allows 1 resubmission
    assignment2 = assignments.open_assignment(@assignment_2_title)
    
    # Fill it out and submit
    assignment2.assignment_text=@assignment_2_text1
    
    confirm = assignment2.submit
    
    # Verify submission
    assert_equal( "You have successfully submitted your work. You will receive an email confirmation containing this information.", confirm.confirmation_text)
    
    assignments = confirm.back_to_list
   
    # Edit it and resubmit
    assignment2 = assignments.open_assignment(@assignment_2_title)
    
    # Clear out the field
    assignment2.remove_assignment_text

    # Enter the new text
    assignment2.assignment_text=@assignment_2_text2
    
    confirm = assignment2.resubmit

    # Verify submission
    assert_equal( "You have successfully submitted your work. You will receive an email confirmation containing this information.", confirm.confirmation_text )
    
    # Verify changed assignment text
    assert_equal(@assignment_2_text2, confirm.submission_text)

    # Back to list
    assignments = confirm.back_to_list

    # Edit assignment again
    assignment2 = assignments.open_assignment(@assignment_2_title)
    
    # Verify the user is not allowed to edit assignment
    assert @browser.frame(:index=>1).button(:name=>"eventSubmit_doCancel_view_grade").exist?
    assert_equal(false, @browser.frame(:index=>1).button(:name=>"post").exist?)
    
  end
 
end
