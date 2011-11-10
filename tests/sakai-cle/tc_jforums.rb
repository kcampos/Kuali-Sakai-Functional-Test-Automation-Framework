# 
# == Synopsis
#
# 
# 
# Author: Abe Heward (aheward@rSmart.com)

gems = ["test/unit", "watir-webdriver"]
gems.each { |gem| require gem }
files = [ "/../../config/config.rb", "/../../lib/utilities.rb", "/../../lib/sakai-CLE/app_functions.rb", "/../../lib/sakai-CLE/admin_page_elements.rb", "/../../lib/sakai-CLE/site_page_elements.rb", "/../../lib/sakai-CLE/common_page_elements.rb" ]
files.each { |file| require File.dirname(__FILE__) + file }

class TestJForums < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    # This test case uses the logins of several users
    @student = @config.directory['person6']['id']
    @spassword = @config.directory['person6']['password']
    @student_name = @config.directory["person6"]['firstname'] + " " + @config.directory["person6"]['lastname']
    @student2 = @config.directory["person1"]["id"]
    @spassword2 = @config.directory["person1"]["password"]
    @instructor = @config.directory["person3"]["id"]
    @ipassword = @config.directory["person3"]["password"]
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    #Test case variables
    @topics = [
      {:subject=>"Topic " + random_alphanums, :file=>"documents/resources.doc", :message=>"<h3 style=\"color: Red;\">Integer commodo nibh ut dui elementum ut tempor ligula adipiscing.</h3> Mauris sollicitudin nulla at lectus dapibus elementum. Etiam lectus nibh, imperdiet molestie convallis id, convallis vel nisl. Suspendisse potenti. In ullamcorper commodo risus quis commodo. <br /> <br /> Morbi consequat, dolor accumsan tincidunt pellentesque; massa urna ultrices lacus, sed viverra velit odio luctus turpis? <span style=\"background-color: Yellow;\">Nunc eget leo ut orci convallis molestie eget sed arcu?</span> In mi sem, varius eu congue id, volutpat eu orci! Maecenas mattis vestibulum nunc vel posuere. <br /> <ul>     <li>Cras a urna neque.</li>     <li>Donec consequat interdum dolor, quis tempus dolor ornare id?</li>     <li>Aenean nibh metus, tempus et volutpat at, rhoncus nec sapien.</li>     <li>Vivamus mi nisl, varius quis placerat vitae, sollicitudin et tellus.</li> </ul>" },
      {:subject=> "Question 1", :message=>"Sed in massa at mi luctus aliquet. Nulla facilisi. Integer congue leo! Fusce aliquet lacinia ipsum. Suspendisse interdum justo vel leo! Cras neque lectus, condimentum non, facilisis dapibus, porttitor vel, justo. Proin dolor. Phasellus pretium sem in ligula? Maecenas dignissim, pede in mollis sodales, sapien leo varius tortor; sollicitudin venenatis pede enim eu nisl. Sed tristique consequat leo. Curabitur nec odio in felis scelerisque fringilla. Nullam eget neque. Suspendisse faucibus amet." },
      {:subject=>"New Possibilities" , :category=>"Main" , :description=>"Lets talk about something that could change the world... like popcorn..." }
    ]
    
    @icq_uin = random_alphanums
    @aim = random_xss_string(40)
    @web_site = "http://www.rsmart.com"
    @occupation = "Tester"
    @avatar = "images/resources.JPG"
    
    @count_of_persons = 13 # Count of site participants (from the directory.yml file)
    
    @pm_to = @config.directory["person1"]['lastname'] + ", " + @config.directory["person1"]['firstname']
    @pm_subject = random_alphanums
    @pm_text = "Aenean magna augue, porta et, molestie et, rutrum id, turpis. <script>alert('xss');</script> Praesent hendrerit posuere justo. Nunc id odio at purus bibendum rutrum? Integer id nunc. Donec blandit metus sed urna. Nunc consequat libero non lorem. Maecenas venenatis urna sit amet est. Nullam sit amet metus imperdiet massa tempor bibendum. Ut eleifend, orci non vulputate imperdiet, mi ante dictum urna, quis pellentesque libero pede non lacus. Ut ultrices tempor lacus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos amet."
    
    @r_msg_text="Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. <script>alert('xss');</script> Suspendisse potenti. Nam lacus erat, egestas a, viverra a, pretium nec, dolor. Nam libero est; porttitor vel, cursus id, aliquet vel, sapien? Sed tristique, diam nec molestie luctus, velit sem bibendum nibh, eget faucibus velit leo eu massa! Fusce sed nisi. Vivamus faucibus blandit urna. Vestibulum enim ipsum, consectetuer eu, accumsan a, gravida sit amet, enim. Mauris nec nisi in enim malesuada eleifend. Quisque iaculis metus."
    
    @keywords = "Sed vehicula suscipit dolor"
    @msg_txt2 = "Integer varius scelerisque tellus. Nulla facilisi. Mauris turpis tortor, pharetra vitae, tincidunt at, malesuada sit amet, orci. Vestibulum tempor pretium ipsum? Duis tincidunt magna sed sapien. Aenean sed nunc eget urna varius lacinia. Nulla tincidunt enim a dui. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec accumsan pede sed turpis posuere ultricies? Etiam volutpat ipsum viverra nibh! Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cras amet."
    
    @xss = random_xss_string
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_jforums
    
    # some code to simplify writing steps in this test case
    def frm
      @browser.frame(:index=>1)
    end
 
    # Log in to Sakai
    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    # Open JForum
    forums_list = home.discussion_forums

    student_lounge = forums_list.open_forum "Student Lounge" # Not a test variable
    
    topic = student_lounge.new_topic
   
    topic.subject=@topics[0][:subject]
    topic.message_text=@topics[0][:message]
    topic.attach_files
    topic.filename1 @topics[0][:file]
    
    view = topic.submit
    
    # TEST CASE: Verify the topic posted.
    assert_equal view.topic_name, @topics[0][:subject]
    
    # TEST CASE: Verify the edit button is present
    assert frm.image(:alt, "edit icon").exist?
    
    # TEST CASE: Verify the message displays as "unread".
    assert frm.td(:class=>"rowUnread").exist?
    
    # TEST CASE: Verify the message text displays.
    assert_equal view.message_text(1), @topics[0][:message]
    
    my_profile = view.my_profile
    
    my_profile.icq_uin=@icq_uin
    my_profile.aim=@aim
    my_profile.web_site=@web_site
    my_profile.occupation=@occupation
    my_profile.select_view_email
    my_profile.avatar=@avatar
    my_profile = my_profile.submit
    
    # TEST CASE: Verify information was saved
    assert_equal 'Information updated', my_profile.header_text
    
    member_list = my_profile.member_listing

    # TEST CASE: Verify members are listed
    1.upto(@count_of_persons) do |x|
      assert member_list.name_present? @config.directory["person#{x}"]['lastname'] + ", " + @config.directory["person#{x}"]['firstname']
    end
    
    private_msg = member_list.private_messages
    
    new_priv_msg = private_msg.new_pm
    new_priv_msg.to_user=@pm_to
    new_priv_msg.subject=@pm_subject
    new_priv_msg.message_body=@pm_text
    
    info = new_priv_msg.submit
    
    #TEST CASE: Verify the message is sent
    assert info.information_text.include?("Your message was successfully sent")
    
    @sakai.logout
    
    workspace = @sakai.login(@student2, @spassword2)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    discussions = home.discussion_forums
    
    priv_msgs = discussions.private_messages
    
    # TEST CASE: The private message appears as expected
    assert priv_msgs.pm_subjects.include?(@pm_subject)
    
    view_msg = priv_msgs.open_message(@pm_subject)
    
    # TEST CASE: Message test displays
    assert_equal @pm_text, frm.span(:class=>"postbody").text
    
    # TEST CASE: Page shows who sent the message
    assert frm.link(:text=>@student_name).exist?
    
    reply_msg = view_msg.reply_quote
    
    reply_msg.message_body=@r_msg_text
    
    info = reply_msg.submit
    
    #TEST CASE: Verify the message is sent
    assert info.information_text.include?("Your message was successfully sent")
    
    search_page = info.search
    search_page.keywords=@keywords
    
    forums_page = search_page.click_search
    
    # TEST CASE: Verify a topic was found
    assert_match(/topic.+found/i, frm.span(:class=>"maintitle").text) # FIXME
    
    topic_page = forums_page.open_topic @topics[0][:subject]
    
    reply_page = topic_page.post_reply
    
    reply_page.message_text=@msg_txt2
    
    view_topic = reply_page.submit
    
    @sakai.logout
    
    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    discussions = home.discussion_forums
    
    questions_page = discussions.open_forum "Questions"
    
    q_topic = questions_page.new_topic
    q_topic.subject=@topics[1][:subject]
    q_topic.message_text=@topics[1][:message]
    
    view_q_topic = q_topic.submit
    
    # TEST CASE: Verify the message text appears
    assert_equal view_q_topic.message_text(1), @topics[1][:message]
    
    @sakai.logout
    
    workspace = @sakai.login(@student2, @spassword2)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    discussions = home.discussion_forums

    questions_page = discussions.open_forum "Questions"
    
    q_1_topic_page = questions_page.open_topic @topics[1][:subject]
    q_1_topic_page.quick_reply

    q_1_topic_page.reply_text=@xss
    
    q_1_topic_page = q_1_topic_page.submit
    
    @sakai.logout
 
    workspace = @sakai.login(@student, @spassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    discussions = home.discussion_forums

    questions_page = discussions.open_forum "Questions"
    
    q_topic_page = questions_page.open_topic @topics[1][:subject]
    
    # TEST CASE: Verify XSS text appears as text only.
    assert_equal @xss, q_topic_page.message_text(2)

    q_topic_page.my_bookmarks
    
    # TEST CASE: Verify message about no bookmarks
    assert_equal frm.span(:class=>"gen").text, 'There are no bookmark entries for this user.'
    
    @sakai.logout
 
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    discussions = home.discussion_forums
    
    admin_panel = discussions.manage
    
    manage_forums_page = admin_panel.manage_forums
    
    manage_forums_page = manage_forums_page.add
    manage_forums_page.forum_name=@topics[2][:subject]
    manage_forums_page.category=@topics[2][:category]
    manage_forums_page.description=@topics[2][:description]
    
    manage_discussions = manage_forums_page.update
    
    # TEST CASE: Verify the new discussion is created.
    assert manage_discussions.forum_titles.include? @topics[2][:subject]
    
  end
  
end
