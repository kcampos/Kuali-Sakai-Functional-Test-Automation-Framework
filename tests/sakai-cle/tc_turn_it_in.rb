# 
# == Synopsis
#
# This test case requires that the TurnItIn service is turned on
# for the Sakai implementation.
# 
# Author: Abe Heward (aheward@rSmart.com)
gem "test-unit"
require "test/unit"
require 'sakai-cle-test-api'
require 'yaml'

class TestTurnItIn < Test::Unit::TestCase
  
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
    @admin = @directory["admin"]["username"]
    @apassword = @directory["admin"]["password"]
    @site_name = @directory['site1']['name']
    @site_id = @directory['site1']['id']
    
    # Test Case Variables
    @assignment_1_title = random_string(32)
    @assignment_1_instructions = "Nullam urna elit; placerat convallis, posuere nec, semper id, diam. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Duis dignissim pulvinar nisl. Nunc interdum vulputate eros. In nec nibh! Suspendisse potenti. Maecenas at felis. Donec velit diam, mattis ut, venenatis vehicula, accumsan et, orci. Sed leo. Curabitur odio quam, accumsan eu, molestie eu, fringilla sagittis, pede. Mauris luctus mi id ligula. Proin elementum volutpat leo. Cras aliquet commodo elit. Praesent auctor consectetuer risus!\n\nDuis euismod felis nec nunc. Ut lectus felis, malesuada consequat, hendrerit at; vestibulum et, enim. Ut nec nulla sed eros bibendum vulputate. Sed tincidunt diam eget lacus. Nulla nisl? Nam condimentum mattis dui! Aenean varius purus eget sem? Nullam odio. Donec condimentum mauris. Cras volutpat tristique lacus. Sed id dui. Mauris purus purus, tristique sed, ornare convallis, consequat a, ipsum. Donec fringilla, metus quis mollis lobortis, magna tellus malesuada augue; laoreet auctor velit lorem vitae neque. Duis augue sem, vehicula sit amet, vulputate vitae, viverra quis; dolor. Donec quis eros vel massa euismod dignissim! Aliquam quam. Nam non dolor."
    @assignment_1_student_text = "A store manager heard one of his salespeople say to a customer, &quot;No, we haven't had any for some weeks now, and it doesn't look as if we'll be getting any soon.&quot; The manager was shocked to hear these words and rushed to the customer as she was walking out. &quot;That isn't true,&quot; he said, but she just gave him an odd look and walked out. He confronted the salesperson and said, &quot;Never, never say we don't have something. If we don't have it, say we've ordered it and it's on its way. Now, what did she want?&quot;<br /> &quot;Rain,&quot; said the salesperson. <br /> How may times have you made assumptions similar to the store manager's? It's easy to do, because we all see things in different ways. We all have different paradigms or frames of reference--like eyeglasses through which we see the world. we see the world not as it is, but as we are--or sometimes we are conditioned to see it."
    @assignment_1_file = "documents/768.pdf"
    
    @job_1_name = "Job 1 name " + random_string
    @job_2_name = "Job 2 name " + random_alphanums # FIXME: I believe there's a problem with XSS names, here.
    
    @trigger_1_name = random_string
    @trigger_2_name = random_xss_string(25)
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_turn_it_in
    
    # Log in to Sakai
    workspace = @sakai.page.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    assignments = home.assignments
    
    assignment_1 = assignments.add
    sleep 4 # Needed for testing slow sites, otherwise the FCKEditor does not load.
    assignment_1.instructions=@assignment_1_instructions
    assignment_1.title=@assignment_1_title
    assignment_1.grade_scale="Letter grade"
    assignment_1.open_meridian="AM"
    assignment_1.open_hour=last_hour
    assignment_1.check_use_turnitin
    
    assignments = assignment_1.post
    
    # TEST CASE: Assignment appears in the list
    assert assignments.assignment_titles.include?(@assignment_1_title)

    assignments.logout
    
    workspace = @sakai.page.login(@student, @spassword)
    
    home = workspace.open_my_site_by_name(@site_name)
    
    assignments = home.assignments
    
    assignment_1 = assignments.open_assignment @assignment_1_title
    assignment_1.assignment_text=@assignment_1_student_text
    assignment_1.select_file=@assignment_1_file
    
    confirm = assignment_1.submit
    
    assignments = confirm.back_to_list

    assignments.logout
    
    workspace = @sakai.page.login(@admin, @apassword)
    
    scheduler = workspace.job_scheduler
    
    job_list = scheduler.jobs
    
    new_job = job_list.new_job
    new_job.job_name=@job_1_name
    new_job.type="Process Content Review Queue"
    
    job_list = new_job.post
    
    new_job = job_list.new_job
    new_job.job_name=@job_2_name
    new_job.type="Process Content Review Reports"
    
    job_list = new_job.post
    
    edit_triggers = job_list.triggers @job_1_name
    
    trigger = edit_triggers.new_trigger
    trigger.name=@trigger_1_name
    trigger.cron_expression="0 0/30 5,6,7,8,9,10,11,12,13,14,15,16,17 * * ?"
    
    edit_triggers = trigger.post
    
    job_list = edit_triggers.return_to_jobs
    
    edit_triggers = job_list.triggers @job_2_name
    
    trigger = edit_triggers.new_trigger
    trigger.name=@trigger_2_name
    trigger.cron_expression="0 0/5 5,6,7,8,9,10,11,12,13,14,15,16,17 * * ?"
    
    edit_triggers = trigger.post
    
    job_list = edit_triggers.return_to_jobs
    
    event_log = job_list.event_log
    
  end
  
end
