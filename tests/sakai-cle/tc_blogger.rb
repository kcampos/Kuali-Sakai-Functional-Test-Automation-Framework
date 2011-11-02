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

class TestBlogger < Test::Unit::TestCase
  
  include Utilities

  def setup
    
    # Get the test configuration data
    @config = AutoConfig.new
    @browser = @config.browser
    @instructor = @config.directory['person3']['id']
    @ipassword = @config.directory['person3']['password']
    @student1 = @config.directory["person1"]["id"]
    @spass1 = @config.directory["person1"]["password"]
    @student2 = @config.directory["person2"]["id"]
    @spass2 = @config.directory["person2"]["password"]
    @student3 = @config.directory["person5"]["id"]
    @spass3 = @config.directory["person5"]["password"]
    @student3_name = @config.directory["person5"]["firstname"] + " " + @config.directory["person5"]["lastname"]
    @student4 = @config.directory["person6"]["id"]
    @spass4 = @config.directory["person6"]["password"]
    
    @site_name = @config.directory['site1']['name']
    @site_id = @config.directory['site1']['id']
    @sakai = SakaiCLE.new(@browser)
    
    # Test case variables
    @post_1_title = random_alphanums
    @post_1_keywords = "blog, blogger"
    @post_1_imagefile = "images/resources.JPG"
    @post_1_link_description = random_xss_string(25)
    @post_1_link = "http://www.rsmart.com"
    
    @comment_1 = "Nulla ullamcorper adipiscing lectus. Etiam nisi ligula, ornare nec, ullamcorper ut, elementum ut, magna. Pellentesque vulputate semper nisl. Fusce diam odio, euismod quis, condimentum vitae, volutpat ut; odio. Etiam nisl massa, ornare nec, porta at, commodo vel, lectus. Aenean dictum. Cras dictum, lectus sed aliquet iaculis, nibh magna vestibulum augue, non sagittis orci lacus vitae sapien. Vestibulum nisl dolor, suscipit eu, suscipit semper, consequat ac, metus! Suspendisse convallis lectus vel quam! Ut porttitor enim non odio! Etiam interdum quam a nibh. Morbi in ligula. Nunc sit amet tortor nec pede luctus varius. Praesent tristique dolor sit amet odio. Nam convallis metus vel urna.\n\nMauris vel tellus vitae lectus mattis placerat! Nullam accumsan fermentum libero. Sed quis tellus sed nunc imperdiet ultrices. Integer luctus nulla eu nisi cursus pretium. Vestibulum condimentum. Duis ac leo. Etiam et mauris. Sed eu nulla. Proin rutrum tempus orci. Cras tincidunt. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Integer nulla magna, sagittis et, feugiat sit amet, bibendum fringilla, tellus. Curabitur tempor amet.\n\nNulla ullamcorper adipiscing lectus. Etiam nisi ligula, ornare nec, ullamcorper ut, elementum ut, magna. Pellentesque vulputate semper nisl. Fusce diam odio, euismod quis, condimentum vitae, volutpat ut; odio. Etiam nisl massa, ornare nec, porta at, commodo vel, lectus. Aenean dictum. Cras dictum, lectus sed aliquet iaculis, nibh magna vestibulum augue, non sagittis orci lacus vitae sapien. Vestibulum nisl dolor, suscipit eu, suscipit semper, consequat ac, metus! Suspendisse convallis lectus vel quam! Ut porttitor enim non odio! Etiam interdum quam a nibh. Morbi in ligula. Nunc sit amet tortor nec pede luctus varius. Praesent tristique dolor sit amet odio. Nam convallis metus vel urna.\n\nMauris vel tellus vitae lectus mattis placerat! Nullam accumsan fermentum libero. Sed quis tellus sed nunc imperdiet ultrices. Integer luctus nulla eu nisi cursus pretium. Vestibulum condimentum. Duis ac leo. Etiam et mauris. Sed eu nulla. Proin rutrum tempus orci. Cras tincidunt. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Integer nulla magna, sagittis et, feugiat sit amet, bibendum fringilla, tellus. Curabitur tempor amet.\n\nNulla ullamcorper adipiscing lectus. Etiam nisi ligula, ornare nec, ullamcorper ut, elementum ut, magna. Pellentesque vulputate semper nisl. Fusce diam odio, euismod quis, condimentum vitae, volutpat ut; odio. Etiam nisl massa, ornare nec, porta at, commodo vel, lectus. Aenean dictum. Cras dictum, lectus sed aliquet iaculis, nibh magna vestibulum augue, non sagittis orci lacus vitae sapien. Vestibulum nisl dolor, suscipit eu, suscipit semper, consequat ac, metus! Suspendisse convallis lectus vel quam! Ut porttitor enim non odio! Etiam interdum quam a nibh. Morbi in ligula. Nunc sit amet tortor nec pede luctus varius. Praesent tristique dolor sit amet odio. Nam convallis metus vel urna.\n\nMauris vel tellus vitae lectus mattis placerat! Nullam accumsan fermentum libero. Sed quis tellus sed nunc imperdiet ultrices. Integer luctus nulla eu nisi cursus pretium. Vestibulum condimentum. Duis ac leo. Etiam et mauris. Sed eu nulla. Proin rutrum tempus orci. Cras tincidunt. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Integer nulla magna, sagittis et, feugiat sit amet, bibendum fringilla, tellus. Curabitur tempor amet."

    @post_2_title = random_string
    @post_2_keywords = random_xss_string
    @post_2_file = "images/resources.JPG"
    @post_2_text = "In pulvinar neque id dui! Proin luctus magna. Nulla velit. Nulla facilisi. Vivamus suscipit convallis augue. Sed eget purus. Nam consequat rutrum pede. Integer condimentum congue augue? Maecenas euismod eros lobortis diam? Suspendisse potenti. Maecenas dictum, elit at porta porttitor, mauris est dignissim mi, ut ornare nisl tortor aliquet velit. In et nulla! Aenean tempor. Maecenas dapibus iaculis pede. Aenean ante odio, pretium ornare, venenatis eu, suscipit id, pede. Cras blandit nulla quis lorem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec quam. Morbi in nisl!"
    
    @post_3_title = random_xss_string(30)
    @post_3_keywords = "blog, blogger"
    @post_3_text = random_xss_string
    
  end
  
  def teardown
    # Close the browser window
    @browser.close
  end
  
  def test_blogger
  
    # Log in to Sakai as student 1
    workspace = @sakai.login(@student1, @spass1)
    
    home = workspace.open_my_site_by_id(@site_id)
    
    blogger = home.blogger
    
    # Create a Site-viewable post
    post1 = blogger.create_new_post
    post1.title=@post_1_title
    post1.keywords=@post_1_keywords
    post1.access="SITE"
    post1.check_allow_comments
    post1.images
    post1.image_file=@post_1_imagefile
    post1.add_image_to_document
    post1.links
    post1.description=@post_1_link_description
    post1.url=@post_1_link
    post1.add_link_to_document

    preview = post1.preview

    post1 = preview.save

    blogger = post1.save

    # TEST CASE: New Blog post appears on the list page
    assert blogger.post_titles.include? @post_1_title
    
    @sakai.logout
    
    # Log in as student 2
    workspace = @sakai.login(@student2, @spass2)
    
    home = workspace.open_my_site_by_name @site_name
    
    blogger = home.blogger
    
    post1 = blogger.open_post @post_1_title
    
    # Comment on the post
    comment = post1.add_comment
    comment.your_comment=@comment_1
    
    post1 = comment.save
    
    @sakai.logout
    
    # Log in as student 3
    workspace = @sakai.login(@student3, @spass3)
    
    home = workspace.open_my_site_by_name(@site_name)
    
    blogger = home.blogger
    
    # Create a Private post
    post2 = blogger.create_new_post
    post2.title=@post_2_title
    post2.text
    post2.text=@post_2_text
    post2.add_text_to_document
    post2.access="PRIVATE"
    post2.keywords=@post_2_keywords
    post2.files
    post2.file_field=@post_2_file
    post2.add_file_to_document
    
    blogger = post2.save
    
    # TEST CASE: Verify the private post appears in the list
    assert blogger.post_titles.include? @post_2_title
    
    # TEST CASE: Verify the new post is flagged as private
    assert blogger.post_private?(@post_2_title)
    
    # TEST CASE: Verify student 1's post also appears in the list
    assert blogger.post_titles.include? @post_1_title

    @sakai.logout
    
    # Log in as student 4
    workspace = @sakai.login(@student4, @spass4)
    
    home = workspace.open_my_site_by_name(@site_name)
    
    blogger = home.blogger
    
    # TEST CASE: Verify post 1 is visible and post 2 is not
    assert blogger.post_titles.include? @post_1_title
    assert_equal false, blogger.post_titles.include?(@post_2_title)
    
    view = blogger.view_members_blog
    
    blogger = view.member @student3_name
    
    # TEST CASE: Verify the Private message does not
    # appear even in the specific student's list
    assert_equal false, blogger.post_titles.include?(@post_2_title)
    
    post3 = blogger.create_new_post
    post3.title=@post_3_title
    post3.text
    post3.text=@post_3_text
    post3.add_text_to_document
    post3.keywords=@post_3_keywords
    post3.access="TUTOR"
    
    blogger = post3.save
    
    blogger = blogger.view_all
    
    # TEST CASE: Verify new message appears
    assert blogger.post_titles.include?(@post_3_title)
    
    @sakai.logout
    
    workspace = @sakai.login(@instructor, @ipassword)
    
    home = workspace.open_my_site_by_name(@site_name)
    
    blogger = home.blogger
    
    # TEST CASE: Verify the instructor can see the "TUTOR" post
    assert blogger.post_titles.include?(@post_3_title)
    
    # TEST CASE: Verify the instructor can see the Site post
    assert blogger.post_titles.include?(@post_1_title)
    
    # TEST CASE: Verify the instructor can't see the "Private" post
    assert_equal false, blogger.post_titles.include?(@post_2_title)
    
  end
  
end
