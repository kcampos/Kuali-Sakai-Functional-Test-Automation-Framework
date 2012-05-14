#!/usr/bin/env ruby
# 
# == Synopsis
#
# A Very simple test of the evaluation system. Creates an evaluation, then
# a student submits it. The test confirms the evaluation status becomes
# "Completed".
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestCreateAndSubmitEvaluation < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = YAML.load_file("config.yml")
    @directory = YAML.load_file("directory.yml")
    @sakai = SakaiCLE.new(@config['browser'], @config['url'])
    @browser = @sakai.browser
    # This test case uses the logins of several users
    @instructor = @directory['person3']['id']
    @ipassword = @directory['person3']['password']
    @student = @directory['person1']['id']
    @spassword = @directory['person1']['password']
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @template_name = random_nicelink
    
    @rating_text = random_string(256)
    
    @evaluation_title = random_nicelink
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_create_and_submit_eval
    
    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    evaluations_dashboard = workspace.evaluation_system
    
    add_template = evaluations_dashboard.add_template
    add_template.title=@template_name

    edit_template = add_template.save
    edit_template.item="Rating scale"
    edit_template.add
    edit_template.item_text=@rating_text
    edit_template.save_item
    
    new_eval = edit_template.new_evaluation
    new_eval.title=@evaluation_title

    settings = new_eval.continue_to_settings
    
    assign_courses = settings.continue_to_assign_to_courses
    assign_courses.check_group @site_name
    
    confirm = assign_courses.save_assigned_groups
    
    my_evaluations = confirm.done

    my_evaluations.logout
    
    workspace = @sakai.page.login(@student, @spassword)
    
    evaluations = workspace.evaluation_system
    
    eval = evaluations.take_evaluation @evaluation_title
    
    # Click a  random radio button
    @browser.frame(:class=>"portletMainIframe").radio(:index=>rand(5)).set
    
    evaluations = eval.submit_evaluation

    # TEST CASE: Verify the evaluation status is now "Completed"
    assert_equal "Completed", evaluations.status_of(@evaluation_title)
    
  end
  
end
