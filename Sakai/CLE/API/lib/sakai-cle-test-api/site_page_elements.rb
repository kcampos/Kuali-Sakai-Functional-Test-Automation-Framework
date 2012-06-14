# Navigation links in Sakai's site pages
# 
# == Synopsis
#
# Defines all objects in Sakai Pages that are found in the
# context of a Course or Portfolio Site. No classes in this
# script should refer to pages that appear in the context of
# "My Workspace", even though, as in the case of Resources,
# Announcements, and Help, the page may exist in both contexts.
#
# Author :: Abe Heward (aheward@rsmart.com)
#
# Page-object is the gem that parses each of the listed objects.
# For an introduction to the tool, written by the author, visit:
# http://www.cheezyworld.com/2011/07/29/introducing-page-object-gem/
#
# For more extensive detail, visit:
# https://github.com/cheezy/page-object/wiki/page-object
#
# Also, see the bottom of this script for a Page Class template for
# copying when you create a new class.

#require 'page-object'
#require  File.dirname(__FILE__) + '/app_functions.rb'
require 'cgi'



#================
# Basic LTI Pages
#================

# 
class BasicLTI
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end


#================
# Blog Pages - NOT "Blogger"
#================

# 
class Blogs
  
  include PageObject
  include ToolsMenu

  # Returns an array containing the list of Bloggers
  # in the "All the blogs" table.
  def blogger_list
    bloggers = []
    frm.table(:class=>"listHier lines").rows.each do |row|
      bloggers << row[1].text
    end
    bloggers.delete_at(0)
    return bloggers
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end



#================
# Blogger Pages
#================

# The top page of a Site's Blogger feature.
class Blogger
  
  include PageObject
  include ToolsMenu
  
  # Clicks the View All button, then reinstantiates the Class.
  def view_all
    frm.link(:text=>"View all").click
    Blogger.new(@browser)
  end
  
  # Clicks the View Members Blog link, then instantiates the
  # ViewMembersBlog Class.
  def view_members_blog
    frm.link(:text=>"View member's blog").click
    ViewMembersBlog.new(@browser)
  end
  
  # Returns true if the specified post title exists in the list. Otherwise returns false.
  def post_private?(post_title)
    frm.table(:class=>"tableHeader").row(:text=>/#{Regexp.escape(post_title)}/).image(:alt=>"p").exist?
  end
  
  # Clicks the Create New Post link and instantiates the CreateBloggerPost Class.
  def create_new_post
    frm.link(:text=>"Create new post").click
    CreateBloggerPost.new(@browser)
  end
  # Clicks on the specified post title, then instantiates
  # the ViewBloggerPost Class.
  def open_post(post_title)
    frm.link(:text=>post_title).click
    ViewBloggerPost.new(@browser)
  end

  # Returns an array containing the displayed post titles (as string objects).
  def post_titles
    titles = []
    if frm.table(:class=>"tableHeader").exist?
      table = frm.table(:class=>"tableHeader")
      table.rows.each do |row|
        if row.link(:class=>"aTitleHeader").exist?
          titles << row.link(:class=>"aTitleHeader").text
        end
      end
    end
    return titles
  end

  in_frame(:index=>1) do |frame|
    text_field(:search_field, :id=>"_id1:idSearch", :frame=>frame)
    checkbox(:show_comments, :id=>"_id1:showComments", :frame=>frame)
    checkbox(:show_full_content, :id=>"_id1:showFullContent", :frame=>frame)
  end
end

# The page showing contents of a user's Blog.
class ViewMembersBlog
  
  include PageObject
  include ToolsMenu
  
  # Clicks on the member name specified.
  # The name string obviously needs to match the
  # text of the link exactly.
  def member(name)
    frm.link(:text=>name).click
    Blogger.new(@browser)
  end

end

# The page where users create a Post for their Blogger blog.
class CreateBloggerPost
  
  include PageObject
  include ToolsMenu

  # Enters the specified string into the FCKEditor for the Abstract.
  def abstract=(text)
    frm.frame(:id, "PostForm:shortTextBox_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Enters the specified string into the FCKEditor for the Text of the Blog.
  def text=(text)
    frm().frame(:id, "PostForm:tab0:main_text_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  # Clicks the Add to document button in the text
  # tab. 
  def add_text_to_document
    frm.div(:id=>"PostForm:tab0").button(:value=>"Add to document").click
  end

  # Clicks the Add to Document button on the Image tab.
  #
  # This method will fail if the image tab is not the currently selected tab.
  def add_image_to_document
    frm.div(:id=>"PostForm:tab1").button(:value=>"Add to document").click
  end
  
  # Clicks the Add to Document button on the Link tab.
  #
  # This method will fail if the Link tab is not the currently selected tab.
  def add_link_to_document
    frm.div(:id=>"PostForm:tab2").button(:value=>"Add to document").click
  end
  
  # Clicks the Add to Document button on the File tab.
  #
  # This method will fail if the File tab is not the currently selected tab.
  def add_file_to_document
    frm.div(:id=>"PostForm:tab3").button(:value=>"Add to document").click
  end
  
  # Enters the specified filename in the file field for images.
  #
  # The file path can be entered as an optional second parameter.
  def image_file(filename, filepath="")
    frm.file_field(:name=>"PostForm:tab1:_id29").set(filepath + filename)
  end
  
  # Enters the specified directory/filename in the file field.
  def file_field(filename, filepath="")
    frm().file_field(:name=>"PostForm:tab3:_id51").set(filepath + filename)
  end
  
  # Clicks the Preview button and instantiates the PreviewBloggerPost Class.
  def preview
    frm().button(:value=>"Preview").click
    PreviewBloggerPost.new(@browser)
  end
  
  # Clicks the Save button and instantiates the Blogger Class.
  def save
    frm.button(:value=>"Save").click
    Blogger.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"PostForm:idTitle", :frame=>frame)
    text_field(:keywords, :id=>"PostForm:keyWords", :frame=>frame)
    select_list(:access, :id=>"PostForm:selectVisibility", :frame=>frame)
    checkbox(:read_only, :id=>"PostForm:readOnlyCheckBox", :frame=>frame)
    checkbox(:allow_comments, :id=>"PostForm:allowCommentsCheckBox", :frame=>frame)
    button(:text, :value=>"Text", :frame=>frame)
    button(:images, :value=>"Images", :frame=>frame)
    button(:links, :value=>"Links", :frame=>frame)
    text_field(:description, :id=>"PostForm:tab2:idLinkDescription", :frame=>frame)
    text_field(:url, :id=>"PostForm:tab2:idLinkExpression", :frame=>frame)
    button(:files, :value=>"Files", :frame=>frame)
    
  end
end

# The Preview page for a Blog post.
class PreviewBloggerPost
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Back button and instantiates the CreateBloggerPost Class.
  def back
    frm().button(:value=>"Back").click
    CreateBloggerPost.new(@browser)
  end
  
  # Clicks the Save button and instantiates the CreateBloggerPost Class.
  def save
    frm.button(:value=>"Save").click
    CreateBloggerPost.new(@browser)
  end

end

# The page for Viewing a blog post.
class ViewBloggerPost
  
  include PageObject
  include ToolsMenu
  
  # Clicks the button for adding a comment to a blog post, then
  # instantiates the AddBloggerComment Class.
  def add_comment
    frm.button(:value=>"Add comment").click
    AddBloggerComment.new(@browser)
  end

end

# The page for adding a comment to a Blog post.
class AddBloggerComment
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Save button and instantiates
  # The ViewBloggerPost Class.
  def save
    frm.button(:value=>"Save").click
    ViewBloggerPost.new(@browser)
  end
  
  # Enters the specified string into the FCKEditor box for the Comment.
  def your_comment=(text)
    frm.frame(:id, "_id1:_id11_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

end


#================
# Chat Room Pages
#================

# 
class ChatRoom
  
  include PageObject
  include ToolsMenu
  
  def total_messages_shown
    @browser.frame(:class=>"wcwmenu").div(:id=>"chat2_messages_shown_total").text
  end

  in_frame(:class=>"wcwmenu") do |frame|
    
  end
end


#================
# Discussion Forums Pages
#================

# This module includes page objects that are common to
# all pages in the JForums.
module JForumsResources
  
  # Clicks the Discussion Home link, then
  # instantiates the JForums page class.
  def discussion_home
    frm.link(:id=>"backtosite").click
    JForums.new(@browser)
  end
  
  # Clicks the Search button in the Main Menu, then
  # instantiates the DiscussionSearch page class.
  def search
    frm.link(:id=>"search", :class=>"mainmenu").click
    DiscussionSearch.new(@browser)
  end
  
  # Clicks the My Bookmarks link in the Main Menu,
  # then instantiates the MyBookmarks page class.
  def my_bookmarks
    frm.link(:class=>"mainmenu", :text=>"My Bookmarks").click
    MyBookmarks.new(@browser)
  end
  
  # Clicks the My Profile link in the Main Menu, then
  # instantiates the DiscussionsMyProfile page class.
  def my_profile
    frm.link(:id=>"myprofile").click
    DiscussionsMyProfile.new(@browser)
  end
  
  # Clicks the Member Listing link in the Main Menu, then
  # instantiates the DiscussionMemberListing page class.
  def member_listing
    frm.link(:text=>"Member Listing", :id=>"latest", :class=>"mainmenu").click
    DiscussionMemberListing.new(@browser)
  end
  
  # Clicks the Private Messages link in the Main Menu, then
  # instantiates the PrivateMessages page class.
  def private_messages
    frm.link(:id=>"privatemessages", :class=>"mainmenu").click
    PrivateMessages.new(@browser)
  end
  
  # Clicks the Manage link on the Main Menu, then
  # instantiates the ManageDiscussions page class.
  def manage
    frm.link(:id=>"adminpanel", :text=>"Manage").click
    ManageDiscussions.new(@browser)
  end
  
end

# The topmost page in Discussion Forums
class JForums
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Clicks on the supplied forum name
  # Then instantiates the DiscussionForum class.
  def open_forum(forum_name)
    frm.link(:text=>forum_name).click
    DiscussionForum.new(@browser)
  end
  
  # Clicks the specified Topic and instantiates
  # the ViewTopic Class.
  def open_topic(topic_title)
    frm.link(:text=>topic_title).click
    ViewTopic.new(@browser)
  end
  
  # Returns an array containing the names of the Forums listed on the page.
  def forum_list
    list = frm.table(:class=>"forumline").links.map do |link|
      if link.href =~ /forums\/show\//
        link.text
      end
    end
    list.compact!
    return list
  end
  
  # Returns the displayed count of topics for the specified
  # Forum.
  def topic_count(forum_name)
    frm.table(:class=>"forumline").row(:text=>/#{Regexp.escape(forum_name)}/)[2].text
  end

end

# The page of a particular Discussion Forum, show the list
# of Topics in the forum.
class DiscussionForum
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Clicks the New Topic button,
  # then instantiates the NewTopic class
  def new_topic
    frm.image(:alt=>"New Topic").fire_event("onclick")
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").wait_until_present
    NewTopic.new(@browser)
  end
  
  # Clicks the specified Topic Title, then
  # instantiates the ViewTopic Class.
  def open_topic(topic_title)
    frm.link(:href=>/posts.list/, :text=>topic_title).click
    ViewTopic.new(@browser)
  end
  
end

# The Discussion Forums Search page.
class DiscussionSearch
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Clicks the Search button on the page,
  # then instantiates the JForums class.
  def click_search
    frm.button(:value=>"Search").click
    JForums.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:keywords, :name=>"search_keywords", :frame=>frame)
  end
end

# The Manage Discussions page in Discussion Forums.
class ManageDiscussions
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Clicks the Manage Forums link,
  # then instantiates the ManageForums Class.
  def manage_forums
    frm.link(:text=>"Manage Forums").click
    ManageForums.new(@browser)
  end

  # Creates and returns an array of forum titles
  # which can be used for verification
  def forum_titles
    forum_titles = []
    forum_links = frm.links.find_all { |link| link.id=="forumEdit"}
    forum_links.each { |link| forum_titles << link.text }
    return forum_titles
  end

  in_frame(:index=>1) do |frame|
    
  end
end

# The page for Managing Forums in the Discussion Forums
# feature.
class ManageForums
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Clicks the Add button, then
  # instantiates the ManageForums Class.
  def add
    frm.button(:value=>"Add").click
    ManageForums.new(@browser)
  end
  
  # Clicks the Update button, then
  # instantiates the ManageDiscussions Class.
  def update
    frm.button(:value=>"Update").click
    ManageDiscussions.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:forum_name, :name=>"forum_name", :frame=>frame)
    select_list(:category, :id=>"categories_id", :frame=>frame)
    text_area(:description, :name=>"description", :frame=>frame)
  end
end

# Page for editing/creating Bookmarks in Discussion Forums.
class MyBookmarks
  
  include PageObject
  include ToolsMenu
  include JForumsResources


end

# The page for adding a new discussion topic.
class NewTopic
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Enters the specified string into the FCKEditor for the Message.
  def message_text=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  # Clicks the Submit button, then instantiates the ViewTopic Class.
  def submit
    frm.button(:value=>"Submit").click
    ViewTopic.new(@browser)
  end 
  
  # Clicks the Preview button and instantiates the PreviewDiscussionTopic Class.
  def preview
    frm.button(:value=>"Preview").click
    PreviewDiscussionTopic.new(@browser)
  end
  
  # Enters the specified filename in the file field. The path to the file can be entered as an optional second parameter
  def filename1(filename, filepath="")
    frm.file_field(:name=>"file_0").set(filepath + filename)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle-test-api folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def filename2(filename)
    frm.file_field(:name=>"file_1").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  in_frame(:index=>1) do |frame|
    text_field(:subject, :id=>"subject", :frame=>frame)
    button(:attach_files, :value=>"Attach Files", :frame=>frame)
    button(:add_another_file, :value=>"Add another file", :frame=>frame)
  end
end

# Viewing a Topic/Message
class ViewTopic
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  # Gets the text of the Topic title.
  # Useful for verification.
  def topic_name
    frm.link(:id=>"top", :class=>"maintitle").text
  end
  
  # Gets the message text for the specified message (not zero-based).
  # Useful for verification.
  def message_text(message_number)
    frm.span(:class=>"postbody", :index=>message_number.to_i-1).text
  end
  
  # Clicks the Post Reply button, then
  # instantiates the NewTopic Class.
  def post_reply
    frm.image(:alt=>"Post Reply").fire_event("onclick")
    NewTopic.new(@browser)
  end
  
  # Clicks the Quick Reply button
  # and does not instantiate any page classes.
  def quick_reply 
    frm.image(:alt=>"Quick Reply").fire_event("onclick")
  end
  
  # Clicks the submit button underneath the Quick Reply box,
  # then re-instantiates the class, due to the page update.
  def submit
    frm.button(:value=>"Submit").click
    ViewTopic.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_area(:reply_text, :name=>"quickmessage", :frame=>frame)
  end
  
end

# The Profile page for Discussion Forums
class DiscussionsMyProfile
  
  include PageObject
  include ToolsMenu
  include JForumsResources
  
  def submit
    frm.button(:value=>"Submit").click
    DiscussionsMyProfile.new(@browser)
  end
  
  # Gets the text at the top of the table.
  # Useful for verification.
  def header_text
    frm.table(:class=>"forumline").span(:class=>"gens").text
  end
  
  # Enters the specified filename in the file field.
  #
  # The method takes the filepath as an optional second parameter.
  def avatar(filename, filepath="")
    frm.file_field(:name=>"avatar").set(filepath + filename)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:icq_uin, :name=>"icq", :frame=>frame)
    text_field(:aim, :name=>"aim", :frame=>frame)
    text_field(:web_site, :name=>"website", :frame=>frame)
    text_field(:occupation, :name=>"occupation", :frame=>frame)
    radio_button(:view_email) { |page| page.radio_button_element(:name=>"viewemail", :index=>$frame_index, :frame=>frame) }
  end
end

# The List of Members of a Site's Discussion Forums
class DiscussionMemberListing
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Checks if the specified Member name appears
  # in the member listing.
  def name_present?(name)
    member_links = frm.links.find_all { |link| link.href=~/user.profile/ }
    member_names = []
    member_links.each { |link| member_names << link.text }
    member_names.include?(name)
  end

end

# The page where users go to read their private messages in the Discussion
# Forums.
class PrivateMessages
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Clicks the "New PM" button, then
  # instantiates the NewPrivateMessage Class.
  def new_pm
    frm.image(:alt=>"New PM").fire_event("onclick")
    NewPrivateMessage.new(@browser)
  end
  
  # Clicks to open the specified message,
  # then instantiates the ViewPM Class.
  def open_message(title)
    frm.link(:class=>"topictitle", :text=>title).click
    ViewPM.new(@browser)
  end
  
  # Collects all subject text strings of the listed
  # private messages and returns them in an Array.
  def pm_subjects
    anchor_objects = frm.links.find_all { |link| link.href=~/pm.read.+page/ }
    subjects = []
    anchor_objects.each { |link| subjects << link.text }
    return subjects 
  end
  
end

# The page of Viewing a particular Private Message.
class ViewPM
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Reply Quote button, then
  # instantiates the NewPrivateMessage Class.
  def reply_quote
    frm.image(:alt=>"Reply Quote").fire_event("onclick")
    NewPrivateMessage.new(@browser)
  end

end

# New Private Message page in Discussion Forums.
class NewPrivateMessage
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Enters text into the FCKEditor text area, after
  # going to the beginning of any existing text in the field.
  def message_body=(text)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "message___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  # Clicks the Submit button, then
  # instantiates the Information Class.
  def submit
    frm.button(:value=>"Submit").click
    Information.new(@browser)
  end
  
  # Enters the specified filename in the file field.
  def filename1(filename)
    frm.file_field(:name=>"file_0").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  # Enters the specified filename in the file field.
  #
  # Note that the file should be inside the data/sakai-cle-test-api folder.
  # The file or folder name used for the filename variable
  # should not include a preceding / character.
  def filename2(filename)
    frm.file_field(:name=>"file_1").set(File.expand_path(File.dirname(__FILE__)) + "/../../data/sakai-cle-test-api/" + filename)
  end

  in_frame(:index=>1) do |frame|
    select_list(:to_user, :name=>"toUsername", :frame=>frame)
    text_field(:subject, :id=>"subject", :frame=>frame)
    button(:attach_files, :value=>"Attach Files", :frame=>frame)
    button(:add_another_file, :value=>"Add another file", :frame=>frame)
  end
  
end

# The page that appears when you've done something in discussions, like
# sent a Private Message.
class Information
  
  include PageObject
  include ToolsMenu
  include JForumsResources

  # Gets the information message on the page.
  # Useful for verification.
  def information_text
    frm.table(:class=>"forumline").span(:class=>"gen").text
  end

end


#================
# Drop Box pages
#================

# 
class DropBox < AttachPageTools
  
  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this => "DropBox",
      :parent => "DropBox",
      :second => "",
      :third => ""
    }
  end
  
end


#================
# Email Archive pages
#================

# 
class EmailArchive
  
  include PageObject
  include ToolsMenu
  
  def options
    frm.link(:text=>"Options").click
    EmailArchiveOptions.new(@browser)
  end
  
  # Returns an array containing the 
  def email_list
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:search_field, :id=>"search", :frame=>frame)
    button(:search_button, :value=>"Search", :frame=>frame)
  end
end


#================
# Feedback pages
#================

# 
class Feedback
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.link(:text=>"Add").click
    AddUpdateFeedback.new(@browser)
  end
  
  # Returns an array containing the titles
  # of the Feedback items listed on the page.
  def feedback_items
    items = []
    frm.table(:class=>"listHier lines nolines").rows.each_with_index do |row, index|
      next if index == 0
      items << row[0].text
    end
    return items
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddUpdateFeedback
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"_idJsp1:title", :frame=>frame)
  end
end



#================
# Forms Pages - Portfolio Site
#================

# The topmost page of Forms in a Portfolio Site.
class Forms
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add button and instantiates
  # the AddForm Class.
  def add
    frm.link(:text=>"Add").click
    AddForm.new(@browser)
  end
  
  # Clicks the Publish buton for the specified
  # Form, then instantiates the PublishForm Class.
  def publish(form_name)
    frm.table(:class=>"listHier lines nolines").tr(:text, /#{Regexp.escape(form_name)}/).link(:text=>/Publish/).click
    PublishForm.new(@browser)
  end

  # Clicks the Import button, then
  # instantiates the ImportForms Class.
  def import
    frm.link(:text=>"Import").click
    ImportForms.new(@browser)
  end
  
end

class ImportForms
  
  include PageObject
  include ToolsMenu
  
  def import
    frm.button(:value=>"Import").click
    Forms.new(@browser)
  end

  def select_file
    frm.link(:text=>"Select File...").click
    AttachFileFormImport.new(@browser)
  end
  
end

class AttachFileFormImport < AttachPageTools
  
  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    @@classes = {
      :this => "AttachFileFormImport",
      :parent => "ImportForms"
    }
  end

end

class AddForm
  
  include PageObject
  include ToolsMenu
  
  def select_schema_file
    frm.link(:text=>"Select Schema File").click
    SelectSchemaFile.new(@browser)
  end

  def instruction=(text)
    frm.frame(:id, "instruction___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_form
    frm.button(:value=>"Add Form").click
    Forms.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:name, :id=>"description-id", :frame=>frame)
    
  end
end

class SelectSchemaFile
  
  include PageObject
  include ToolsMenu
  
  def show_other_sites
    frm.link(:title=>"Show other sites").click
    SelectSchemaFile.new(@browser)
  end
  
  def open_folder(name)
    frm.link(:text=>name).click
    SelectSchemaFile.new(@browser)
  end

  def select_file(filename)
    index = file_names.index(filename)
    frm.table(:class=>"listHier lines").tr(:text, /#{Regexp.escape(filename)}/).link(:text=>"Select").click
    SelectSchemaFile.new(@browser)
  end

  def file_names #FIXME
    names = []
    resources_table = frm.table(:class=>"listHier lines")
    1.upto(resources_table.rows.size-1) do |x|
      if resources_table[x][0].link.exist? && resources_table[x][0].a(:index=>0).title=~/File Type/
        names << resources_table[x][0].text
      end
    end
    return names
  end
  
  def continue
    frm.button(:value=>"Continue").click
    frm.frame(:id, "instruction___Frame").td(:id, "xEditingArea").wait_until_present
    AddForm.new(@browser)
  end

end

class PublishForm
  
  include PageObject
  include ToolsMenu
  
  def yes
    frm.button(:value=>"Yes").click
    Forms.new(@browser)
  end
  
end


#================
# Forum Pages - NOT "Discussion Forums"
#================

# The forums page in a particular Site
class Forums
  
  include PageObject
  include ToolsMenu
  
  # Pass this method a string that matches
  # the title of a Forum on the page, it returns
  # True if the specified forum row has "DRAFT" in it.
  def draft?(title)
    frm.table(:id=>"msgForum:forums").row(:text=>/#{Regexp.escape(title)}/).span(:text=>"DRAFT").exist?
  end
  
  def new_forum
    frm.link(:text=>"New Forum").click
    EditForum.new(@browser)
  end

  def new_topic_for_forum(name)
    index = forum_titles.index(name)
    frm.link(:text=>"New Topic", :index=>index).click
    AddEditTopic.new(@browser)
  end

  def organize
    frm.link(:text=>"Organize").click
    OrganizeForums.new(@browser)
  end

  def template_settings
    frm.link(:text=>"Template Settings").click
    ForumTemplateSettings.new(@browser)
  end

  def forums_table
    frm.div(:class=>"portletBody").table(:id=>"msgForum:forums")
  end

  def forum_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name=="title" && link.id=="" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def topic_titles
    titles = []
    title_links = frm.div(:class=>"portletBody").links.find_all { |link| link.class_name == "title" && link.id != "" }
    title_links.each { |link| titles << link.text }
    return titles
  end
  
  def forum_settings(name)
    index = forum_titles.index(name)
    frm.link(:text=>"Forum Settings", :index=>index).click
    EditForum.new(@browser)
  end
  
  def topic_settings(name)
    index = topic_titles.index(name)
    frm.link(:text=>"Topic Settings", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def delete_forum(name)
    index = forum_titles.index(name)
    frm.link(:id=>/msgForum:forums:\d+:delete/,:text=>"Delete", :index=>index).click
    EditForum.new(@browser)
  end
  
  def delete_topic(name)
    index = topic_titles.index(name)
    frm.link(:id=>/topics:\d+:delete_confirm/, :text=>"Delete", :index=>index).click
    AddEditTopic.new(@browser)
  end
  
  def open_forum(forum_title)
    frm.link(:text=>forum_title).click
    # New Class def goes here.
  end
  
  def open_topic(topic_title)
    frm.link(:text=>topic_title).click
    TopicPage.new(@browser)
  end
  
end

class TopicPage
  
  include PageObject
  include ToolsMenu
  
  def post_new_thread
    frm.link(:text=>"Post New Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def thread_titles
    titles = []
    message_table = frm.table(:id=>"msgForum:messagesInHierDataTable")
    1.upto(message_table.rows.size-1) do |x|
      titles << message_table[x][1].span(:class=>"firstChild").link(:index=>0).text
    end
    return titles
  end
  
  def open_message(message_title)
    frm.div(:class=>"portletBody").link(:text=>message_title).click
    ViewForumThread.new(@browser)
  end
  
  def display_entire_message
    frm.link(:text=>"Display Entire Message").click
    TopicPage.new(@browser)
  end
  
end

class ViewForumThread
  
  include PageObject
  include ToolsMenu
  
  def reply_to_thread
    frm.link(:text=>"Reply to Thread").click
    ComposeForumMessage.new(@browser)
  end
  
  def reply_to_message(index)
    frm.link(:text=>"Reply", :index=>(index.to_i - 1)).click
    ComposeForumMessage.new(@browser)
  end

end


class ComposeForumMessage
  
  include PageObject
  include ToolsMenu
  
  def post_message
    frm.button(:text=>"Post Message").click
    # Not sure if we need logic here...
    TopicPage.new(@browser)
  end
  
  def editor
    frm.frame(:id, "dfCompose:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def message=(text)
    editor.send_keys(text)
  end
  
  def reply_text
    @browser.frame(:index=>1).div(:class=>"singleMessageReply").text
  end
  
  def add_attachments
    #FIXME
  end
  
  def cancel
    frm.button(:value=>"Cancel").click
    # Logic for picking the correct page class
    if frm.link(:text=>"Reply to Thread")
      ViewForumThread.new(@browser)
    elsif frm.link(:text=>"Post New Thread").click
      TopicPage.new(@browser)
    end 
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"dfCompose:df_compose_title", :frame=>frame)
  end
end

class ForumTemplateSettings
  
  include PageObject
  include ToolsMenu
  
  def page_title
    frm.div(:class=>"portletBody").h3(:index=>0).text
  end
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def cancel
    frm.button(:value=>"Cancel").click
    Forums.new(@browser)
  end
=begin
    def site_role=(role)
    frm.select(:id=>"revise:role").select(role)
    0.upto(frm.select(:id=>"revise:role").length - 1) do |x|
      if frm.div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm.select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end
        
      end
    end
  end
=end  

end

class OrganizeForums
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  # These are set to so that the user
  # does not have to start the list at zero...
  def forum(index)
    frm.select(:id, "revise:forums:#{index.to_i - 1}:forumIndex")
  end
  
  def topic(forumindex, topicindex)
    frm.select(:id, "revise:forums:#{forumindex.to_i - 1}:topics:#{topicindex.to_i - 1}:topicIndex")
  end
  
end

# The page for creating/editing a forum in a Site
class EditForum
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def save_and_add
    frm.button(:value=>"Save Settings & Add Topic").click
    AddEditTopic.new(@browser)
  end
  
  def editor
    frm.div(:class=>"portletBody").frame(:id, "revise:df_compose_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def add_attachments
    frm.button(:value=>/attachments/).click
    ForumsAddAttachments.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"revise:forum_title", :frame=>frame)
    text_area(:short_description, :id=>"revise:forum_shortDescription", :frame=>frame)
    
  end
end

class AddEditTopic
  
  include PageObject
  include ToolsMenu
  
  @@table_index=0
  
  def editor
    frm.div(:class=>"portletBody").frame(:id, "revise:topic_description_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end
  
  def description=(text)
    editor.send_keys(text)
  end
  
  def save
    frm.button(:value=>"Save").click
    Forums.new(@browser)
  end
  
  def add_attachments
    frm.button(:value=>/Add.+ttachment/).click
    ForumsAddAttachments.new(@browser)
  end
  
  def roles
    roles=[]
    options = frm.select(:id=>"revise:role").options.to_a
    options.each { |option| roles << option.text }
    return roles
  end
  
  def site_role=(role)
    frm.select(:id=>"revise:role").select(role)
    0.upto(frm.select(:id=>"revise:role").length - 1) do |x|
      if frm.div(:class=>"portletBody").table(:class=>"permissionPanel jsfFormTable lines nolines", :index=>x).visible?
        @@table_index = x
        
        def permission_level=(value)
          frm.select(:id=>"revise:perm:#{@@table_index}:level").select(value)
        end
        
      end
    end
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"revise:topic_title", :frame=>frame)
    text_area(:short_description, :id=>"revise:topic_shortDescription", :frame=>frame)
  end
end

#
class ForumsAddAttachments < AttachPageTools
  
  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this => "ForumsAddAttachments",
      :parent => "AddEditTopic",
      :second => "EditForum"
    } 
  end

end


#================
# Glossary Pages - for a Portfolio Site
#================

class Glossary
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.link(:text=>"Add").click
    frm.frame(:id, "longDescription___Frame").td(:id, "xEditingArea").wait_until_present
    AddEditTerm.new(@browser)
  end
  
  def import
    frm.link(:text=>"Import").click
    GlossaryImport.new(@browser)
  end

  def edit(term)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Edit").click
    AddEditTerm.new(@browser)
  end
  
  def delete(term)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(term)}/).link(:text=>"Delete").click
    AddEditTerm.new(@browser)
  end

  def open(term)
    frm.link(:text=>term).click
    #FIXME!
    # Need to do special handling here because of the new window.
  end
  
  # Returns an array containing the string values of the terms
  # displayed in the list.
  def terms
    term_list = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      term_list << row[0].text
    end
    term_list.delete_at(0)
    return term_list
  end

end

class AddEditTerm
  
  include PageObject
  include ToolsMenu
  
  def add_term
    frm.button(:value=>"Add Term").click
    Glossary.new(@browser)
  end
  
  def save_changes
    frm.button(:value=>"Save Changes").click
    Glossary.new(@browser)
  end

  def long_description=(text)
    frm.frame(:id, "longDescription___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  in_frame(:index=>1) do |frame|
    text_field(:term, :id=>"term-id", :frame=>frame)
    text_area(:short_description, :id=>"description-id", :frame=>frame)
  end
end

# Page for importing Glossary files into a Glossary
class GlossaryImport
  
  include PageObject
  include ToolsMenu
  
  def select_file
    frm.link(:text=>"Select file...").click
    GlossaryAttach.new(@browser)
  end
  
  def import
    frm.button(:value=>"Import").click
    Glossary.new(@browser)
  end

end

# The file upload page for Glossary importing
class GlossaryFileUpload
  
  include ToolsMenu
    
  @@filex=0
  
  # Note that the file_to_upload method can be used
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path="")
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
    @@filex+=1
  end
  
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    sleep 0.5
    @@filex=0
    GlossaryAttach.new(@browser)
  end
  
  def add_another_file
    frm.link(:text=>"Add Another File").click
  end
  
end

# Page for uploading or grabbing files that will be imported to the Glossary.
class GlossaryAttach < AttachPageTools

  include ToolsMenu

  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this => "GlossaryAttach",
      :parent => "GlossaryImport",
      :upload_files => "GlossaryFileUpload",
      :create_folders => "",
      :file_details => ""
    }
  end
  
end


#================
# Gradebook Pages
#================

# The topmost page in a Site's Gradebook
class Gradebook
  
  include PageObject
  include ToolsMenu

  def items_titles
    titles = []
    items_table = frm.table(:class=>"listHier lines nolines")
    1.upto(items_table.rows.size-1) do |x|
      titles << items_table.row(:index=>x).a(:index=>0).text
    end
    return titles
  end
  
  # Returns the value of the "Released to Students" column
  # for the specified assignment title.
  def released_to_students(assignment)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(assignment)}/)[4].text
  end
  
  # Returns the due date value for the specified assignment.
  def due_date(assignment)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(assignment)}/)[3].text
  end
  
end


#================
# Gradebook2 Pages
#================

# 
class Gradebook2
  
  include PageObject
  include ToolsMenu

  # Returns an array of names of Gradebook items
  def gradebook_items
    items = []
    frm.div(:class=>"x-grid3-scroller").spans.each do |span|
      if span.class_name =~ /^x-tree3-node-text/
        items << span.text
      end
    end
    return items
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end


#================
# Lesson Pages
#================

# Contains items common to most Lessons pages.
module LessonsMenu
  
  # Clicks on the Preferences link on the Lessons page,
  # then instantiates the LessonPreferences class.
  def preferences
    frm.link(:text=>"Preferences").click
    LessonPreferences.new(@browser)
  end
  
  def view
    frm.link(:text=>"View").click
    if frm.div(:class=>"meletePortletToolBarMessage").text=="Viewing student side..."
      ViewModuleList.new(@browser)
    else
      #FIXME
    end
  end
  
  def manage
    frm.link(:text=>"Manage").click
    LessonManage.new(@browser)
  end
  
  def author
    #FIXME
  end
  
end

# The Lessons page in a site ("icon-sakai-melete")
#
# Note that this class is inclusive of both the
# Instructor/Admin and the Student views of this page
# many methods will error out if used when in the
# Student view.
class Lessons
  
  include PageObject
  include ToolsMenu
  include LessonsMenu
  
  # Clicks the Add Module link, then
  # instantiates the AddModule class.
  #
  # Assumes the Add Module link is present
  # and will error out if it is not.
  def add_module
    frm.link(:text=>"Add Module").click
    AddEditModule.new(@browser)
  end
  
  # Clicks on the link that matches the supplied
  # name value, then instantiates the
  # AddEditLesson, or ViewLesson class, depending
  # on which page loads.
  #
  # Will error out if there is no
  # matching link in the list.
  def open_lesson(name)
    frm.link(:text=>name).click
    if frm.div(:class=>"meletePortletToolBarMessage").exist? && frm.div(:class=>"meletePortletToolBarMessage").text=="Editing module..."
      AddEditModule.new(@browser)
    else
      ViewModule.new(@browser)
    end
  end
  
  # Returns an array of the Module titles displayed on the page.
  def lessons_list
    list = []
    frm.table(:id=>/lis.+module.+form:table/).links.each do |link|
      if link.id=~/lis.+module.+form:table:.+:(edit|view)Mod/
        list << link.text
      end
    end
    return list
  end
  
  # Returns and array containing the list of section titles for the
  # specified module.
  def sections_list(module_name)
    list = []
    if frm.table(:id=>/lis.+module.+form:table/).row(:text=>/#{Regexp.escape(module_name)}/).table(:id=>/tablesec/).exist?
      frm.table(:id=>/lis.+module.+form:table/).row(:text=>/#{Regexp.escape(module_name)}/).table(:id=>/tablesec/).links.each do |link|
        if link.id=~/Sec/
          list << link.text
        end
      end
    end
    return list
  end

end

# The student user's view of a Lesson Module or Section.
class ViewModule
  
  include PageObject
  include ToolsMenu

  def sections_list
    list = []
    frm.table(:id=>"viewmoduleStudentform:tablesec").links.each { |link| list << link.text }
    return list
  end

  def next
    frm.link(:text=>"Next").click
    ViewModule.new(@browser)
  end
  
  # Returns the text of the Module title row
  def module_title
    frm.span(:id=>/modtitle/).text
  end
  
  # Returns the text of the Section title row
  def section_title
    frm.span(:id=>/form:title/).text
  end
  
  def content_include?(content)
    frm.form(:id=>"viewsectionStudentform").text.include?(content)
  end

end

# This is the Instructor's preview of the Student's view
# of the list of Lesson Modules.
class ViewModuleList
  
  include PageObject
  include ToolsMenu
  
  def open_lesson(name)
    frm.link(:text=>name).click
    LessonStudentSide.new(@browser)
  end
  
  def open_section(name)
    frm.link(:text=>name).click
    SectionStudentSide.new(@browser)
  end
  
end

# The instructor's preview of the student view of the lesson.
class LessonStudentSide
  
  include PageObject
  include ToolsMenu
  include LessonsMenu
  
end

# The instructor's preview of the student's view of the section.
class SectionStudentSide
  
  include PageObject
  include ToolsMenu
  include LessonsMenu
  
end

# The Managing Options page for Lessons
class LessonManage
  
  include PageObject
  include ToolsMenu
  include LessonsMenu
  
  def manage_content
    frm.link(:text=>"Manage Content").click
    LessonManageContent.new(@browser)
  end
  
  def sort
    frm.link(:text=>"Sort").click
    LessonManageSort.new(@browser)
  end

  # Clicks the Import/Export button and
  # instantiates the LessonImportExport class.
  def import_export
    frm.link(:text=>"Import/Export").click
    LessonImportExport.new(@browser)
  end

end

# The Sorting Modules and Sections page in Lessons
class LessonManageSort
  
  include PageObject
  include ToolsMenu

  def view
    frm.link(:text=>"View").click
    if frm.div(:class=>"meletePortletToolBarMessage").text=="Viewing student side..."
      ViewModuleList.new(@browser)
    else
      #FIXME
    end
  end

  in_frame(:index=>1) do |frame|
    link(:sort_modules, :id=>"SortSectionForm:sortmod", :frame=>frame)
    link(:sort_sections, :id=>"SortModuleForm:sortsec", :frame=>frame)
    
  end
end

# The Import/Export page in Manage Lessons for a Site
class LessonImportExport
  
  include PageObject
  include ToolsMenu
  include LessonsMenu

  # Uploads the file specified - meaning that it enters
  # the target file information, then clicks the import
  # button.
  # 
  # The file path is an optional parameter.
  def upload_IMS(file_name, file_path="")
    frm.file_field(:name, "impfile").set(file_path + file_name)
    frm.link(:id=>"importexportform:importModule").click
    frm.table(:id=>"AutoNumber1").div(:text=>"Processing...").wait_while_present
  end
  
  # Returns the text of the alert box.
  def alert_text
    frm.span(:class=>"BlueClass").text
  end

end

# The User preference options page for Lessons.
#
# Note that this class is inclusive of Student
# and Instructor views of the page. Thus,
# not all methods in the class will work
# at all times.
class LessonPreferences
  
  include PageObject
  include ToolsMenu
  
  # Clicks the View button
  # then instantiates the Lessons class.
  def view
    frm.link(:text=>"View").click
    Lessons.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    radio_button(:expanded) { |page| page.radio_button_element(:name=>"UserPreferenceForm:_id5", :index=>0, :frame=>frame) }
    radio_button(:collapsed) { |page| page.radio_button_element(:name=>"UserPreferenceForm:_id5", :index=>1, :frame=>frame) }
    link(:set, :id=>"UserPreferenceForm:SetButton", :frame=>frame)
  end
end

# This Class encompasses methods for both the Add and the Edit pages for Lesson Modules.
class AddEditModule
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add button for the Lesson Module
  # then instantiates the ConfirmModule class.
  def add
    frm.link(:id=>/ModuleForm:submitsave/).click
    ConfirmModule.new(@browser)
  end

  def add_content_sections
    frm.link(:id=>/ModuleForm:sectionButton/).click
    AddEditSection.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>/ModuleForm:title/, :frame=>frame)
    text_area(:description, :id=>/ModuleForm:description/, :frame=>frame)
    text_area(:keywords, :id=>/ModuleForm:keywords/, :frame=>frame)
    text_field(:start_date, :id=>/ModuleForm:startDate/, :frame=>frame)
    text_field(:end_date, :id=>/ModuleForm:endDate/, :frame=>frame)
  end
end

# The confirmation page when you are saving a Lesson Module.
class ConfirmModule
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Content Sections button and
  # instantiates the AddEditSection class.
  def add_content_sections
    frm.link(:id=>/ModuleConfirmForm:sectionButton/).click
    AddEditSection.new(@browser)
  end
  
  # Clicks the Return to Modules button, then
  # instantiates the AddEditModule class.
  def return_to_modules
    frm.link(:id=>"AddModuleConfirmForm:returnModImg").click
    AddEditModule.new(@browser)
  end

end

# Page for adding a section to a Lesson.
class AddEditSection
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add button on the page
  # then instantiates the ConfirmSectionAdd class.
  def add
    frm.link(:id=>/SectionForm:submitsave/).click
    ConfirmSectionAdd.new(@browser)
  end

  # Pointer to the Edit Text box of the FCKEditor
  # on the page.
  def content_editor
    frm.frame(:id, "AddSectionForm:fckEditorView:otherMeletecontentEditor_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0)
  end

  def add_content=(text)
    content_editor.send_keys(text)
  end

  def clear_content
    frm.frame(:id, "AddSectionForm:fckEditorView:otherMeletecontentEditor_inputRichText___Frame").div(:title=>"Select All").fire_event("onclick")
    content_editor.send_keys :backspace
  end

  def select_url
    frm.link(:id=>"AddSectionForm:ContentLinkView:serverViewButton").click
    SelectingContent.new(@browser)
  end
  
  # This method clicks the Select button that appears on the page
  # then calls the LessonAddAttachment class.
  #
  # It assumes that the Content Type selection box has
  # already been updated to "Upload or link to a file in Resources".
  def select_or_upload_file
    frm.link(:id=>"AddSectionForm:ResourceHelperLinkView:serverViewButton").click
    LessonAddAttachment.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"AddSectionForm:title", :frame=>frame)
    select_list(:content_type, :id=>"AddSectionForm:contentType", :frame=>frame)
    checkbox(:auditory_content, :id=>"AddSectionForm:contentaudio", :frame=>frame)
  end
end

# Confirmation page for Adding (or Editing)
# a Section to a Module in Lessons.
class ConfirmSectionAdd
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Another Section button
  # then instantiates the AddSection class.
  def add_another_section
    frm.link(:id=>/SectionConfirmForm:saveAddAnotherbutton/).click
    AddEditSection.new(@browser)
  end
  
  # Clicks the Finish button
  # then instantiates the Lessons class.
  def finish
    frm.link(:id=>/Form:FinishButton/).click
    Lessons.new(@browser)
  end

end

# 
class SelectingContent
  
  include PageObject
  include ToolsMenu
  
  def continue
    frm.link(:id=>"ServerViewForm:addButton").click
    AddEditSection.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:new_url, :id=>"ServerViewForm:link", :frame=>frame)
    text_field(:url_title, :id=>"ServerViewForm:link_title", :frame=>frame)
  end
end

# 
class LessonAddAttachment < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    @@classes = {
      :this => "LessonAddAttachment",
      :parent => "AddEditSection"
    }
  end

end

#================
# Matrix Pages for a Portfolio Site
#================

# 
class Matrices
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add link and instantiates
  # the AddEditMatrix Class.
  def add
    frm.link(:text=>"Add").click
    AddEditMatrix.new(@browser)
  end
  
  # Clicks the "Edit" link for the specified
  # Matrix item, then instantiates the EditMatrixCells.
  def edit(matrixname)
    frm.table(:class=>"listHier lines nolines").tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>"Edit").click
    EditMatrixCells.new(@browser)
  end

  # Clicks the "Preview" link for the specified
  # Matrix item.
  def preview(matrixname)
    frm.table(:class=>"listHier lines nolines").tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>"Preview").click
  end

  # Clicks the "Publish" link for the specified
  # Matrix item, then instantiates the ConfirmPublishMatrix Class.
  def publish(matrixname)
    frm.table(:class=>"listHier lines nolines").tr(:text=>/#{Regexp.escape(matrixname)}/).link(:text=>"Publish").click
    ConfirmPublishMatrix.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddEditMatrix
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Create Matrix" button and
  # instantiates the Matrices Class.
  def create_matrix
    frm.button(:value=>"Create Matrix").click
    Matrices.new(@browser)
  end

  # Clicks the "Save Changes" butotn and
  # instantiates the EditMatrixCells Class.
  def save_changes
    frm.button(:value=>"Save Changes").click
    EditMatrixCells.new(@browser)
  end

  # Clicks the "Select Style" link and
  # instantiates the SelectMatrixStyle Class.
  def select_style
    frm.link(:text=>"Select Style").click
    SelectMatrixStyle.new(@browser)
  end
  
  # Clicks the "Add Column" link and
  # instantiates the AddEditColumn Class.
  def add_column
    frm.link(:text=>"Add Column").click
    AddEditColumn.new(@browser)
  end
  
  # Clicks the "Add Row" link and instantiates
  # the AddEditRow Class.
  def add_row
    frm.link(:text=>"Add Row").click
    AddEditRow.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title-id", :frame=>frame)
  end
end

# 
class SelectMatrixStyle
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Go Back" button and
  # instantiates the AddEditMatrix Class.
  def go_back
    frm.button(:value=>"Go Back").click
    AddEditMatrix.new(@browser)
  end

  # Clicks the "Select" link for the specified
  # Style, then instantiates the AddEditMatrix Class.
  def select_style(stylename)
    frm.table(:class=>/listHier lines/).tr(:text=>/#{Regexp.escape(stylename)}/).link(:text=>"Select").click
    AddEditMatrix.new(@browser)
  end
  
end

# 
class AddEditColumn
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Update" button, then
  # instantiates the AddEditMatrix Class.
  def update
    frm.button(:value=>"Update").click
    AddEditMatrix.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:name, :name=>"description", :frame=>frame)
  end
end

# 
class AddEditRow
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Update" button, then
  # instantiates the AddEditMatrix Class.
  def update
    frm.button(:value=>"Update").click
    AddEditMatrix.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:name, :name=>"description", :frame=>frame)
    text_field(:background_color, :id=>"color-id", :frame=>frame)
    text_field(:font_color, :id=>"textColor-id", :frame=>frame)
  end
end

#
class EditMatrixCells
  
  include PageObject
  include ToolsMenu
  
  # Clicks on the cell that is specified, based on
  # the row number, then the column number.
  #
  # Note that the numbering begins in the upper left
  # of the Matrix, with (1, 1) being the first EDITABLE
  # cell, NOT the first cell in the table itself.
  #
  # In other words, ignore the header row and header column
  # in your count (or, if you prefer, consider those
  # to be numbered "0").
  def edit(row, column)
    frm.div(:class=>"portletBody").table(:summary=>"Matrix Scaffolding (click on a cell to edit)").tr(:index=>row).td(:index=>column-1).fire_event("onclick")
    EditCell.new(@browser)
  end

  # Clicks the "Return to List" link and
  # instantiates the Matrices Class.
  def return_to_list
    frm.link(:text=>"Return to List").click
    Matrices.new(@browser)
  end

end

# 
class EditCell
  
  include PageObject
  include ToolsMenu

  # Clicks the "Select Evaluators" link
  # and instantiates the SelectEvaluators Class.
  def select_evaluators
    frm.link(:text=>"Select Evaluators").click
    SelectEvaluators.new(@browser)
  end

  # Clicks the Save Changes button and instantiates
  # the EditMatrixCells Class.
  def save_changes
    frm.button(:value=>"Save Changes").click
    EditMatrixCells.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"title-id", :frame=>frame)
    checkbox(:use_default_reflection_form, :id=>"defaultReflectionForm", :frame=>frame)
    select_list(:reflection, :id=>"reflectionDevice-id", :frame=>frame)
    checkbox(:use_default_feedback_form, :id=>"defaultFeedbackForm", :frame=>frame)
    select_list(:feedback, :id=>"reviewDevice-id", :frame=>frame)
    checkbox(:use_default_evaluation_form, :id=>"defaultEvaluationForm", :frame=>frame)
    select_list(:evaluation, :id=>"evaluationDevice-id", :frame=>frame)
    checkbox(:use_default_evaluators, :id=>"defaultEvaluators", :frame=>frame)
  end
end

# 
class SelectEvaluators
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Save" button and
  # instantiates the EditCell Class.
  def save
    frm.button(:value=>"Save").click
    EditCell.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    select_list(:users, :id=>"mainForm:availableUsers", :frame=>frame)
    select_list(:selected_users, :id=>"mainForm:selectedUsers", :frame=>frame)
    select_list(:roles, :id=>"mainForm:audSubV11:availableRoles", :frame=>frame)
    select_list(:selected_roles, :id=>"mainForm:audSubV11:selectedRoles", :frame=>frame)
    button(:add_users, :id=>"mainForm:add_user_button", :frame=>frame)
    button(:remove_users, :id=>"mainForm:remove_user_button", :frame=>frame)
    button(:add_roles, :id=>"mainForm:audSubV11:add_role_button", :frame=>frame)
    button(:remove_roles, :id=>"mainForm:audSubV11:remove_role_button", :frame=>frame)
  end
end

# 
class ConfirmPublishMatrix

  include ToolsMenu
  
  # Clicks the "Continue" button and
  # instantiates the Matrices Class.
  def continue
    frm.button(:value=>"Continue").click
    Matrices.new(@browser)
  end

end


#================
# Media Gallery Pages
#================

# 
class MediaGallery
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end



#================
# Messages Pages
#================

# The Messages page for a Site
class Messages

  include PageObject
  include ToolsMenu
  
  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    sleep 1 #FIXME
    ComposeMessage.new(@browser)
  end
  
  def received 
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

  def sent
    frm.link(:text=>"Sent").click
    MessagesSentList.new(@browser)
  end
  
  def deleted
    frm.link(:text=>"Deleted").click
    MessagesDeletedList.new(@browser)
  end
  
  def draft
    frm.link(:text=>"Draft").click
    MessagesDraftList.new(@browser)
  end

  def open_folder(foldername)
    frm.link(:text=>foldername).click
    FolderList.new(@browser)
  end

  def new_folder
    frm.link(:text=>"New Folder").click
    MessagesNewFolder.new(@browser)
  end
  
  def settings
    frm.link(:text=>"Settings").click
    MessagesSettings.new(@browser)
  end
  
  # Gets the count of messages
  # in the specified folder
  # and returns it as a string
  def total_messages_in_folder(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:class=>"textPanelFooter", :index=>0).text =~ /\d+/
    return $~.to_s
  end
  
  # Gets the count of unread messages
  # in the specified folder and returns it
  # as a string
  def unread_messages_in_folder(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:text=>/unread/).text =~ /\d+/
    return $~.to_s
  end
  
  # Gets all the folder names
  def folders
    links = frm.table(:class=>"hierItemBlockWrapper").links.find_all { |link| link.title != /Folder Settings/ }
    folders = []
    links.each { |link| folders << link.text }
    return folders
  end
  
  def folder_settings(folder_name)
    frm.table(:class=>"hierItemBlockWrapper").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Folder Settings").click
    MessageFolderSettings.new(@browser)
  end
  
end

# The page showing the user's Sent Messages.
class MessagesSentList
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end
  
  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end
  
  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end
  
  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end
  
  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of received messages.
class MessagesReceivedList
  
  include PageObject
  include ToolsMenu
  
  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end
  
  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end
  
  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  # Returns an Array object containing the
  # subjects of the displayed messages that are
  # marked unread.
  def unread_messages
    # TODO - Write this method
  end

  # Clicks the Move link, then
  # instantiates the MoveMessageTo Class.
  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end

# Page for the Contents of a Custom Folder for Messages
class FolderList #FIXME
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end
  
  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end
  
  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end
  
  # Clicks the Messages link in the
  # Breadcrumb bar at the top of the
  # page, then instantiates the Messages
  # class
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  def unread_messages
    # TODO - Write this method
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end


# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo
  
  include PageObject
  include ToolsMenu
  
  def move_messages
    frm.button(:value=>"Move Messages").click
    Messages.new(@browser)
  end

  # Method for selecting any custom folders
  # present on the screen--and *only* the custom
  # folders. Count begins with "1" for the first custom
  # folder listed.
  def select_custom_folder_num(num)
    frm.radio(:index=>num.to_i+3).set 
  end

  in_frame(:index=>1) do |frame|
    radio_button(:received, :name=>"pvtMsgMove:_id16:0:privateForums:0:_id19", :frame=>frame)
    radio_button(:sent, :name=>"pvtMsgMove:_id16:0:privateForums:1:_id19", :frame=>frame)
    radio_button(:deleted, :name=>"pvtMsgMove:_id16:0:privateForums:2:_id19", :frame=>frame)
    radio_button(:draft, :name=>"pvtMsgMove:_id16:0:privateForums:3:_id19", :frame=>frame)
  end
end


# The page showing the list of deleted messages.
class MessagesDeletedList
  
  include PageObject
  include ToolsMenu
  
  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end
  
  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages[x][2].text
    end
    return titles
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set 
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end
  
  def delete
    frm.link(:text=>"Delete").click
    MessageDeleteConfirmation.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of Draft messages.
class MessagesDraftList
  
  include PageObject
  include ToolsMenu
  
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The Page where you are reading a Message.
class MessageView
  
  include PageObject
  include ToolsMenu
  
  # Returns the contents of the message body.
  def message_text
    frm.div(:class=>"textPanel").text
  end
  
  def reply
    frm.button(:value=>"Reply").click
    ReplyToMessage.new(@browser)
  end
  
  def forward
    frm.button(:value=>"Forward ").click
    ForwardMessage.new(@browser)
  end

  def received
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

end

# The page for composing a message
class ComposeMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click
    Messages.new(@browser)
  end
  
  def message_text=(text)
    frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame").td(:id, "xEditingArea").wait_until_present
    sleep 0.3
    frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:send_to, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The page for composing a message
class ReplyToMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click
    # Need logic here to ensure the
    # right class gets called...
    if frm.div(:class=>/breadCrumb/).text=~ /Messages.\/.Received/
      MessagesReceivedList.new(@browser)
    else #FIXME
      Messages.new(@browser)
    end
  end
  
  def message_text=(text)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_additional_recipients, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The page for composing a message
class ForwardMessage
  
  include PageObject
  include ToolsMenu
  
  def send
    frm.button(:value=>"Send ").click 
    MessagesReceivedList.new(@browser) #FIXME!
  end
  
  def message_text=(text)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end
  
  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end
  
  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_forward_recipients, :id=>"pvtMsgForward:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)
    
  end
end

# The attachment page for Messages
class MessagesAttachment < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this => "MessagesAttachment",
      :parent => "ComposeMessage",
      :second => "ReplyToMessage"
    }
  end

end

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation
  
  include PageObject
  include ToolsMenu
  
  def alert_message_text
    frm.span(:class=>"alertMessage").text
  end
  
  def delete_messages
    frm.button(:value=>"Delete Message(s)").click
    MessagesDeletedList.new(@browser)
  end

  #FIXME
  # Want eventually to have a method that will return
  # an array of Message subjects

end

# The page for creating a new folder for Messages
class MessagesNewFolder
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.button(:value=>"Add").click
    Messages.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"pvtMsgFolderAdd:title", :frame=>frame)
  end
end

# The page for editing a Message Folder's settings
class MessageFolderSettings
  
  include PageObject
  include ToolsMenu

  def rename_folder
    frm.button(:value=>"Rename Folder").click
    RenameMessageFolder.new(@browser)
  end

  def add
    frm.button(:value=>"Add").click
    MessagesNewFolder.new(@browser)
  end

  def delete
    frm.button(:value=>"Delete").click
    FolderDeleteConfirm.new(@browser)
  end

end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm
  
  include PageObject
  include ToolsMenu
  
  def delete
    frm.button(:value=>"Delete").click
    Messages.new(@browser)
  end
end


#================
# News pages
#================

# 
class News
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end



#================
# Podcast pages
#================

# 
class Podcasts
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.link(:text=>"Add").click
    AddEditPodcast.new(@browser)
  end

  def podcast_titles
    titles = []
      frm.spans.each do |span|
        if span.class_name == "podTitleFormat"
          titles << span.text
        end
      end
    return titles
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end



#================
# Polls pages
#================

# 
class Polls
  
  include PageObject
  include ToolsMenu
  
  def add
    frm.link(:text=>"Add").click
    frm.frame(:id, "newpolldescr::input___Frame").td(:id, "xEditingArea").wait_until_present
    AddEditPoll.new(@browser)
  end
  
  #
  def edit(poll)
  
  end
  
  def questions
    questions = []
      frm.table(:id=>"sortableTable").rows.each do |row|
        questions << row[0].link.text
      end
    return questions
  end

  # Returns an array containing the list of poll questions displayed.
  def list
    list = []
    frm.table(:id=>"sortableTable").rows.each_with_index do |row, index|
      next if index==0
      list << row[0].link(:href=>/voteQuestion/).text
    end
    return list
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddEditPoll
  
  include PageObject
  include ToolsMenu

  def additional_instructions=(text)
    frm.frame(:id, "newpolldescr::input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end
  
  def save_and_add_options
    frm.button(:value=>"Save and add options").click
    AddAnOption.new(@browser)
  end
  
  def save
    frm.button(:value=>"Save").click
    Polls.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:question, :id=>"new-poll-text", :frame=>frame)
  end
end

# 
class AddAnOption
  
  include PageObject
  include ToolsMenu
  
  def answer_option=(text)
    frm.frame(:id, "optText::input___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def save
    frm.button(:value=>"Save").click
    AddEditPoll.new(@browser)
  end
  
  def save_and_add_options
    frm.button(:value=>"Save and add options").click
    AddAnOption.new(@browser)
  end
  
end


#================
# Portfolios pages
#================

# 
class Portfolios
  
  include PageObject
  include ToolsMenu
  
  def create_new_portfolio
    frm.link(:text=>"Create New Portfolio").click
    AddPortfolio.new(@browser)
  end

  def list
    list = []
    frm.table(:class=>"listHier ospTable").rows.each do |row|
      list << row[0].text
    end
    list.delete_at(0)
    return list
  end
  
  def shared(portfolio_name)
    frm.table(:class=>"listHier ospTable").row(:text=>/#{Regexp.escape(portfolio_name)}/)[5].text
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class AddPortfolio
  
  include PageObject
  include ToolsMenu
  
  def create
    frm.button(:value=>"Create").click
    EditPortfolio.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:name, :name=>"presentationName", :frame=>frame)
    radio_button(:design_your_own_portfolio, :id=>"templateId-freeForm", :frame=>frame)
  end
end

# 
class EditPortfolio
  
  include PageObject
  include ToolsMenu
  
  def add_edit_content
    frm.link(:text=>"Add/Edit Content").click
    AddEditPortfolioContent.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    link(:edit_title, :text=>"Edit Title", :frame=>frame)
    link(:save_changes, :text=>"Save Changes", :frame=>frame)
    radio_button(:active, :id=>"btnActive", :frame=>frame)
    radio_button(:inactive, :id=>"btnInactive", :frame=>frame)
  end
end

# 
class AddEditPortfolioContent
  
  include PageObject
  include ToolsMenu
  
  def add_page
    frm.link(:text=>"Add Page").click
    AddEditPortfolioPage.new(@browser)
  end

  def share_with_others
    frm.link(:text=>"Share with Others").click
    SharePortfolio.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    button(:save_changes, :value=>"Save Changes", :frame=>frame)
  end
end

# 
class AddEditPortfolioPage
  
  include PageObject
  include ToolsMenu
  
  def add_page
    frm.button(:value=>"Add Page").click
    AddEditPortfolioContent.new(@browser)
  end
  
  def select_layout
    frm.link(:text=>"Select Layout").click
    ManagePortfolioLayouts.new @browser
  end
  
  def select_style
    frm.link(:text=>"Select Style").click
    SelectPortfolioStyle.new @browser
  end

  def simple_html_content=(text)
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").div(:title=>"Select All").fire_event("onclick")
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys :backspace
    frm.frame(:id, "_id1:arrange:_id49_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"_id1:title", :frame=>frame)
    text_area(:description, :id=>"_id1:description", :frame=>frame)
    text_area(:keywords, :id=>"_id1:keywords", :frame=>frame)
    
  end
end

# 
class ManagePortfolioLayouts
  
  include PageObject
  include ToolsMenu

  def select(layout_name)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(layout_name)}/).link(:text=>"Select").click
    AddEditPortfolioPage.new @browser
  end

  def go_back
    frm.button(:value=>"Go Back").click
    AddEditPortfolioPage.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

#
class SharePortfolio
  
  include PageObject
  include ToolsMenu
  
  def click_here_to_share_with_others
    frm.link(:text=>"Click here to share with others").click
    AddPeopleToShare.new(@browser)
  end

  def summary
    frm.link(:text=>"Summary").click
    EditPortfolio.new @browser
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    checkbox(:everyone_on_the_internet, :id=>"public_checkbox", :frame=>frame)
  end
end

# 
class AddPeopleToShare
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end


#================
# Portfolio Templates pages
#================

# 
class PortfolioTemplates
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add link and instantiates the
  # AddPortfolioTemplate class.
  def add
    frm.link(:text=>"Add").click
    AddPortfolioTemplate.new(@browser)
  end

  # Clicks the "Publish" link for the specified Template.
  def publish(templatename)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Publish").click
  end

  # Clicks the "Edit" link for the specified Template.
  def edit(templatename)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Edit").click
  end

  # Clicks the "Delete" link for the specified Template.
  def delete(templatename)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Delete").click
  end

  # Clicks the "Copy" link for the specified Template.
  def copy(templatename)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Copy").click
  end

  # Clicks the "Export" link for the specified Template.
  def export(templatename)
    frm.table(:class=>"listHier lines nolines").row(:text=>/#{Regexp.escape(templatename)}/).link(:text=>"Export").click
  end

end

# 
class AddPortfolioTemplate
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Continue button and instantiates the BuildTemplate Class.
  def continue
    frm.button(:value=>"Continue").click
    BuildTemplate.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:name, :id=>"name-id", :frame=>frame)
    text_area(:description, :id=>"description", :frame=>frame)
    
  end
end

#
class BuildTemplate
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Select File link and instantiates the
  # PortfolioAttachFiles Class.
  def select_file
    frm.link(:text=>"Select File").click
    PortfolioAttachFiles.new(@browser)
  end
  
  # Clicks the Continue button and instantiates
  # PortfolioContent Class.
  def continue
    frm.button(:value=>"Continue").click
    PortfolioContent.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:outline_options_form_type, :id=>"propertyFormType-id", :frame=>frame)
  end
end

#
class PortfoliosUploadFiles # TODO - This class is not DRY. Identical methods in multiple classes
  
  include PageObject
  include ToolsMenu
  
  @@filex=0
  
  # Note that the file_to_upload method can be used
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path)
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
    @@filex+=1
  end
  
  # Clicks the Upload Files Now button and instantiates the
  # PortfolioAttachFiles Class.
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    sleep 1 # TODO - use a wait clause here
    @@filex=0
    PortfolioAttachFiles.new(@browser)
  end
  
  # Clicks the Add Another File link.
  def add_another_file
    frm.link(:text=>"Add Another File").click
  end
  
end

# 
class PortfolioContent
  
  include PageObject
  include ToolsMenu

  # Clicks the Continue button and instantiates the
  # SupportingFilesPortfolio Class.
  def continue
    frm.button(:value=>"Continue").click
    SupportingFilesPortfolio.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:type, :id=>"item.type", :frame=>frame)
    text_field(:name, :id=>"item.name-id", :frame=>frame)
    text_field(:title, :id=>"item.title-id", :frame=>frame)
    text_area(:description, :id=>"item.description-id", :frame=>frame)
    button(:add_to_list, :value=>"Add To List", :frame=>frame)
    checkbox(:image, :id=>"image-id", :frame=>frame)
  end
end

# 
class SupportingFilesPortfolio
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Finish button and instantiates
  # the PortfolioTemplates Class.
  def finish
    frm.button(:value=>"Finish").click
    PortfolioTemplates.new(@browser)
  end
  
  # Clicks the Select File link and instantiates
  # the PortfolioAttachFiles Class.
  def select_file
    frm.link(:text=>"Select File").click
    PortfolioAttachFiles.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    button(:add_to_list, :value=>"Add To List", :frame=>frame)
    text_field(:name, :id=>"fileRef.usage-id", :frame=>frame)
  end
end

# 
class PortfolioAttachFiles < AttachPageTools

  include ToolsMenu
  
  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this =>          "PortfolioAttachFiles",
      :parent =>        "BuildTemplate",
      :second =>        "SupportingFilesPortfolio",
      :upload_files =>  "PortfoliosUploadFiles",
      :create_folders =>"",
      :file_details =>  ""
    }
  end
  
end


#================
# Roster Pages for a Site
#================

# 
class Roster
  
  include PageObject
  include ToolsMenu

  def find
    frm.button(:value=>"Find").click
    Roster.new @browser
  end
  
  def names
    list = []
    frm.table(:id=>"roster_form:rosterTable").rows.each do |row|
      list << row[0].text
    end
    list.delete_at(0)
    return list
  end
  
  # Clicks on the link on the page that matches the specified name.
  # Then instantiates the RosterProfileView class.
  # Note that it expects an exact match for the name string, otherwise
  # the script will error out.
  def view(name)
    frm.link(:text=>name).click
    RosterProfileView.new @browser
  end 

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:name_or_id, :id=>"roster_form:search", :frame=>frame)
    
  end
end

#
class RosterProfileView
  
  include PageObject
  include ToolsMenu
    
  def back
    frm.button(:value=>"Back").click
    Roster.new(@browser)
  end

  # Returns a hash containing the contents of the Public Information
  # table on the page, with the keys being the row headers and the values
  # being the row's data contents.
  def public_information
    hash = {}
    frm.table(:class=>"chefEditItem", :index=>0).rows.each do |row|
      hash.store(row[0].text, row[1].text)
    end
    return hash
  end
  
  # Returns a hash containing the contents of the Personal Information
  # table on the page, with the keys being the row headers and the values
  # being the row's data contents.
  def personal_information
    hash = {}
    frm.table(:class=>"chefEditItem", :index=>1).rows.each do |row|
      hash.store(row[0].text, row[1].text)
    end
    return hash
  end

end


#================
# Sections Pages for a Site
#================

module SectionsMenu
  
  # Clicks the Add Sections button/link and instantiates
  # the AddEditSections Class.
  def add_sections
    frm.link(:text=>"Add Sections").click
    AddEditSections.new(@browser)
  end
  
  def overview
    frm.link(:text=>"Overview").click
    Sections.new(@browser)
  end
  
  def student_memberships
    frm.link(:text=>"Student Memberships").click
    StudentMemberships.new(@browser)
  end
  
  def options
    frm.link(:text=>"Options").click
    SectionsOptions.new(@browser)
  end
  
end

# Topmost page for Sections in Site Management
class Sections
  
  include PageObject
  include ToolsMenu
  include SectionsMenu
  
  # Clicks the Edit link for the specified section.
  # Then instantiates the AddEditSections class.
  def edit(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Edit/).click
    AddEditSections.new(@browser)
  end
  
  def assign_tas(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Assign TAs/).click
    AssignTeachingAssistants.new(@browser)
  end

  def assign_students(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).link(:text=>/Assign Students/).click
    AssignStudents.new(@browser)
  end
  
  def check(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/).checkbox(:name=>/remove/).set
  end

  def section_names
    names = []
    frm.table(:class=>/listHier/).rows.each do |row|
      if row.td(:class=>"leftIndent").exist?
        names << row.td(:class=>"leftIndent").div(:index=>0).text
      end
    end
    return names
  end

  def remove_sections
    frm.button(:value=>"Remove Sections").click
    Sections.new(@browser)
  end

  # Returns the text of the Teach Assistant cell for the specified
  # Section.
  def tas_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[1].text
  end

  #
  def days_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[2].text
  end

  #
  def time_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[3].text
  end
  
  #
  def location_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[4].text
  end
  
  #
  def current_size_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[5].text
  end

  #
  def availability_for(title)
    frm.table(:class=>/listHier/).row(:text=>/#{Regexp.escape(title)}/)[6].text
  end

  def alert_text
    frm.div(:class=>"validation").text
  end

  def success_text
    frm.div(:class=>"success").text
  end

end

# Methods in this class currently do not support
# adding multiple instances of sections simultaneously.
# That will be added at some future time.
# The same goes for adding days with different meeting times. This will hopefully
# be supported in the future.
class AddEditSections
  
  include PageObject
  include ToolsMenu
  include SectionsMenu
  
  # Clicks the Add Sections button then instantiates the Sections Class,
  # unless there's an Alert message, in which case it will reinstantiate
  # the class.
  def add_sections
    frm.button(:value=>"Add Sections").click
    if frm.div(:class=>"validation").exist?
      AddEditSections.new(@browser)
    else
      Sections.new(@browser)
    end
  end
  
  def alert_text
    frm.div(:class=>"validation").text
  end
  
  # The Update button is only available when editing an existing Sections record.
  def update
    frm.button(:value=>"Update").click
    if frm.div(:class=>"validation").exist?
      AddEditSections.new(@browser)
    else
      Sections.new(@browser)
    end
  end
  
  # This method takes an array object containing strings of the
  # days of the week and then clicks the appropriate checkboxes, based
  # on those strings.
  def check_days(array)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:monday/).set if array.include?(/mon/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:tuesday/).set if array.include?(/tue/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:wednesday/).set if array.include?(/wed/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:thursday/).set if array.include?(/thu/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:friday/).set if array.include?(/fri/i) 
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:saturday/).set if array.include?(/sat/i)
    frm.checkbox(:id=>/SectionsForm:sectionTable:0:meetingsTable:0:sunday/).set if array.include?(/sun/i)
  end
  
  in_frame(:index=>1) do |frame|
    select_list(:category, :id=>/SectionsForm:category/, :frame=>frame)
    text_field(:name, :id=>/SectionsForm:sectionTable:0:titleInput/, :frame=>frame)
    checkbox(:monday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:monday/, :frame=>frame)
    checkbox(:tuesday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:tuesday/, :frame=>frame)
    checkbox(:wednesday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:wednesday/, :frame=>frame)
    checkbox(:thursday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:thursday/, :frame=>frame)
    checkbox(:friday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:friday/, :frame=>frame)
    checkbox(:saturday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:saturday/, :frame=>frame)
    checkbox(:sunday, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:sunday/, :frame=>frame)
    text_field(:start_time, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:startTime/, :frame=>frame)
    text_field(:end_time, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:endTime/, :frame=>frame)
    text_field(:location, :id=>/SectionsForm:sectionTable:0:meetingsTable:0:location/, :frame=>frame)
    radio_button(:startAM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:startTimeAm/, :index=>0, :frame=>frame) }
    radio_button(:startPM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:startTimeAm/, :index=>1, :frame=>frame) }
    radio_button(:endAM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:endTimeAm/, :index=>0, :frame=>frame) }
    radio_button(:endPM) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:meetingsTable:0:endTimeAm/, :index=>1, :frame=>frame) }
    radio_button(:unlimited_students) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:limit/, :index=>0, :frame=>frame) }
    radio_button(:limited_students) { |page| page.radio_button_element(:name=>/SectionsForm:sectionTable:0:limit/, :index=>1, :frame=>frame) }
    text_field(:max_students, :id=>/SectionsForm:sectionTable:0:maxEnrollmentInput/, :frame=>frame)
  end
end

#
class AssignTeachingAssistants
  
  include PageObject
  include ToolsMenu
  include SectionsMenu

  def assign_TAs
    frm.button(:value=>"Assign TAs").click
    Sections.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:available_tas, :id=>"memberForm:availableUsers", :frame=>frame)
    select_list(:assigned_tas, :id=>"memberForm:selectedUsers", :frame=>frame)
    button(:assign, :value=>">", :frame=>frame)
    button(:unassign, :value=>"<", :frame=>frame)
    button(:assign_all, :value=>">>", :frame=>frame)
    button(:unassign_all, :value=>"<<", :frame=>frame)
    
  end
end

# 
class AssignStudents
  
  include PageObject
  include ToolsMenu
  include SectionsMenu
  
  def assign_students
    frm.button(:value=>"Assign students").click
    Sections.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:available_students, :id=>"memberForm:availableUsers", :frame=>frame)
    select_list(:assigned_students, :id=>"memberForm:selectedUsers", :frame=>frame)
    button(:assign, :value=>">", :frame=>frame)
    button(:unassign, :value=>"<", :frame=>frame)
    button(:assign_all, :value=>">>", :frame=>frame)
    button(:unassign_all, :value=>"<<", :frame=>frame)
    
  end
end

# The Options page for Sections.
class SectionsOptions
  
  include PageObject
  include ToolsMenu
  include SectionsMenu
  
  def update
    frm().button(:value=>"Update").click
    Sections.new(@browser)
  end
  
  in_frame(:index=>1) do |frame|
    checkbox(:students_can_sign_up, :id=>"optionsForm:selfRegister", :frame=>frame)
    checkbox(:students_can_switch, :id=>"optionsForm:selfSwitch", :frame=>frame)
  end
  
end



#================
# Styles pages in a Portfolio Site
#================

# 
class Styles
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add link and
  # instantiates the AddStyle Class.
  def add
    frm.link(:text=>"Add").click
    AddStyle.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    
  end
end

# 
class AddStyle
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Add Style button and
  # instantiates the Styles Class.
  def add_style
    frm.button(:value=>"Add Style").click
    Styles.new(@browser)
  end
  
  # Clicks the "Select File" link and
  # instantiates the StylesAddAttachment Class.
  def select_file
    frm.link(:text=>"Select File").click
    StylesAddAttachment.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:name, :id=>"name-id", :frame=>frame)
    text_area(:description, :id=>"descriptionTextArea", :frame=>frame)
    
  end
end

# 
class StylesUploadFiles
  
  include ToolsMenu
  
  @@filex=0
  
  # Note that the file_to_upload method can be used
  # multiple times, but it assumes
  # that the add_another_file method is used
  # before it, every time except before the first time.
  def file_to_upload(file_name, file_path="")
    frm.file_field(:id, "content_#{@@filex}").set(file_path + file_name)
    @@filex+=1
  end
  
  # Clicks the "Upload Files Now" button
  # then instantiates the StylesAddAttachment Class.
  def upload_files_now
    frm.button(:value=>"Upload Files Now").click
    sleep 0.5
    @@filex=0
    StylesAddAttachment.new(@browser)
  end
  
  # Clicks the "Add Another File" link.
  def add_another_file
    frm.link(:text=>"Add Another File").click
  end
  
end

# 
class StylesAddAttachment < AttachPageTools

  include ToolsMenu

  def initialize(browser)
    @browser = browser
    
    @@classes = {
      :this => "StylesAddAttachment",
      :parent => "AddStyle",
      :upload_files => "StylesUploadFiles",
      :create_folders => "",
      :file_details => ""
    }
  end
  
end


#================
# Syllabus pages in a Site
#================

# The topmost page in the Syllabus feature.
# If there are no syllabus items it will appear
# differently than if there are.
class Syllabus
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Create/Edit" button on the page,
  # then instantiates the SyllabusEdit class.
  def create_edit
    frm.link(:text=>"Create/Edit").click
    SyllabusEdit.new(@browser)
  end
  
  # Clicks the "Add" button, then
  # instantiates the AddEditSyllabusItem Class.
  def add
    frm.link(:text=>"Add").click
    AddEditSyllabusItem.new(@browser)
  end
  
  def attachments_list
    list = []
    frm.div(:class=>"portletBody").links.each { |link| list << link.text }
    return list
  end
  
end

# This is the page that lists Syllabus sections, allows for
# moving them up or down in the list, and allows for removing
# items from the syllabus.
class SyllabusEdit
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Add" button, then
  # instantiates the AddEditSyllabusItem Class.
  def add
    frm.link(:text=>"Add").click
    AddEditSyllabusItem.new(@browser)
  end
  
  def redirect
    frm.link(:text=>"Redirect").click
    SyllabusRedirect.new(@browser)
  end
  
  # Returns the text of the page header
  def header
    frm.div(:class=>"portletBody").h3.text
  end
  
  # Clicks the checkbox for the item with the
  # specified title.
  def check_title(title)
    index=syllabus_titles.index(title)
    frm.checkbox(:index=>index).set
  end
  
  # 
  def move_title_up(title)
    #FIXME
  end
  
  # 
  def move_title_down(title)
    #FIXME
  end
  
  # Clicks the "Update" button and instantiates
  # the DeleteSyllabusItems Class.
  def update
    frm.button(:value=>"Update").click
    DeleteSyllabusItems.new(@browser)
  end
  
  # Opens the specified item and instantiates the XXXX Class.
  def open_item(title)
    frm.link(:text=>title).click
    Class.new(@browser)
  end
  
  # Returns an array containing the titles of the syllabus items
  # displayed on the page.
  def syllabus_titles
    titles = []
    s_table = frm.table(:class=>"listHier lines nolines")
    1.upto(s_table.rows.size-1) do |x|
      titles << s_table[x][0].text
    end
    return titles
  end
  
end

# 
class AddEditSyllabusItem
  
  include PageObject
  include ToolsMenu
  
  # Clicks the "Post" button and instantiates
  # the Syllabus Class.
  def post
    frm.button(:value=>"Post").click
    SyllabusEdit.new(@browser)
  end
  
  # Defines the text area of the FCKEditor that appears on the page for
  # the Syllabus content.
  def editor
    frm.frame(:id, /_textarea___Frame/).td(:id, "xEditingArea").frame(:index=>0)
  end
  
  # Sends the specified string to the FCKEditor text area on the page.
  def content=(text)
    editor.send_keys(text)
  end
  
  # Clicks the Add attachments button and instantiates the
  # SyllabusAttach class.
  def add_attachments
    frm.button(:value=>"Add attachments").click
    SyllabusAttach.new(@browser)
  end
  
  # Returns an array of the filenames in the attachments
  # table
  def files_list
    names = []
    frm.table(:class=>"listHier lines nolines").rows.each do |row|
      if row.td(:class=>"item").exist?
        names << row.td(:class=>"item").h4.text
      end
    end
    return names
  end
  
  # Clicks the preview button and
  # instantiates the SyllabusPreview class
  def preview
    frm.button(:value=>"Preview").click
    SyllabusPreview.new(@browser)
  end
  
  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:title, :id=>"_id4:title", :frame=>frame)
    radio_button(:only_members_of_this_site) { |page| page.radio_button_element(:name=>/_id\d+:_id\d+/, :value=>"no", :frame=>frame) }
    radio_button(:publicly_viewable) { |page| page.radio_button_element(:name=>/_id\d+:_id\d+/, :value=>"yes", :frame=>frame) }
  end
  
end

# The page for previewing a syllabus.
class SyllabusPreview
  
  include PageObject
  include ToolsMenu
  
  def edit
    frm.button(:value=>"Edit").click
    AddEditSyllabusItem.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end

# 
class SyllabusRedirect
  
  include PageObject
  include ToolsMenu
  
  def save
    frm.button(:value=>"Save").click
    SyllabusEdit.new(@browser)
  end

  in_frame(:class=>"portletMainIframe") do |frame|
    text_field(:url, :id=>"redirectForm:urlValue", :frame=>frame)
  end
end


# The page where Syllabus Items can be deleted.
class DeleteSyllabusItems
  
  include PageObject
  include ToolsMenu
  
  # Clicks the Delete button, then
  # instantiates the CreateEditSyllabus Class.
  def delete
    frm.button(:value=>"Delete").click
    CreateEditSyllabus.new(@browser)
  end
  
end

# The page for attaching files to a Syllabus record.
class SyllabusAttach < AttachPageTools
  
  include ToolsMenu

  def initialize(browser)
    @browser = browser
    
    @the_classes = {
      :this => "SyllabusAttach",
      :parent => "AddEditSyllabusItem",
      :upload_files => "",
      :create_folders => "",
      :file_details => ""
    }
    
    set_classes_hash(@the_classes)
  end
  
end


#================
# Web Content pages in a Site
#================

# 
class WebContent
  
  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end


#================
# Wikis pages in a Site
#================

# 
class Wikis
  
  include PageObject
  include ToolsMenu
  
  in_frame(:class=>"portletMainIframe") do |frame|
    
  end
end
