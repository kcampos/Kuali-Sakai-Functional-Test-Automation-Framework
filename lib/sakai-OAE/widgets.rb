# coding: UTF-8

# Methods related to the expandable Collector item that can appear at the top of any page.
module CollectorWidget

  include PageObject

end

# Methods associated with documents that use the TinyMCE Editor.
module DocumentWidget

  include PageObject

  # Page Objects
  button(:dont_save, :id=>"sakaidocs_edit_cancel_button")
  button(:save_button, :id=>"sakaidocs_edit_save_button")
  button(:insert, :id=>"sakaidocs_insert_dropdown_button")
  select_list(:format, :id=>/formatselect/)
  select_list(:font, :id=>/fontselect/)
  select_list(:font_size, :id=>/fontsizeselect/)
  link(:bold, :id=>/_bold/)
  link(:italic, :id=>/_italic/)
  link(:underline, :id=>/_underline/)

  # These methods click the Insert button (you must be editing the document first),
  # then select the specified menu item, to bring up the Widget settings dialog.
  # The first argument is the method name (which automatically gets pre-pended
  # with "insert_", the second is the id of the target
  # button in the Insert menu, and the last argument is the name of the module
  # to be included in the current Class object. The module name can be nil,
  # since not every item in the insert button list brings up a Pop Up dialog.
  insert_button(:files_and_documents, "embedcontent", "FilesAndDocsPopUp")
  insert_button(:discussion, "discussion", "Discussion")
  insert_button(:remote_content, "remotecontent", "RemoteContentPopUp" )
  insert_button(:inline_content, "inlinecontent", "InlineContentPopUp" )
  insert_button(:google_maps, "googlemaps", "GoogleMapsPopUp" )
  insert_button(:comments, "comments", "CommentsPopUp" )
  insert_button(:rss_feed_reader, "rss", "RSSFeedPopUp" )
  insert_button(:google_gadget, "ggadget", "GoogleGadgetPopUp" )
  insert_button(:horizontal_line, "hr")
  insert_button(:tests_and_quizzes, "sakai2samigo")
  insert_button(:calendar, "sakai2calendar")
  insert_button(:jisc_content, "jisccontent")
  insert_button(:assignments, "sakai2assignments")
  insert_button(:basic_lti, "basiclti")
  insert_button(:gradebook, "sakai2gradebook")

  # Custom Methods...

  # Clicks the Save button. Waits for Ajax calls to fall off.
  def save
    self.save_button
    sleep 1
    self.wait_for_ajax
  end

  # Erases the entire contents of the TinyMCE Editor, then
  # enters the specified string into the Editor.
  def set_content=(text)
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    self.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
    self.frame(:id=>"elm1_ifr").send_keys(text)
  end

  # Appends the specified string to the contents of the TinyMCE Editor.
  def add_content=(text)
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
    self.frame(:id=>"elm1_ifr").send_keys(text)
  end

  # Selects all the contents of the TinyMCE Editor
  def select_all
    self.frame(:id=>"elm1_ifr").send_keys( [:command, 'a'] )
  end

  # Clicks the Text Box of the TinyMCE Editor so that the edit cursor
  # will become active in the Editor.
  def insert_text
    self.frame(:id=>"elm1_ifr").body(:id=>"tinymce").fire_event("onclick")
  end

  # Other MCE Objects TBD later, maybe, though we're not in the business of testing TinyMCE...

end

# Methods related to the Library List page.
module LibraryWidget

  include PageObject

  text_field(:search_library, :id=>"mylibrary_livefilter")
  checkbox(:select_all_library_items, :id=>"mylibrary_select_checkbox")
  button(:add_selected_to_buton, :id=>"mylibrary_addpeople_button")
  button(:remove_selected_button, :id=>"mylibrary_remove")
  button(:share_selected_button, :id=>"mylibrary_content_share")
  select_list(:sort_by_list, :id=>"mylibrary_sortby")

  # Enters the specified string in the search field.
  # Note that it appends a line feed on the string, so the
  # search occurs immediately.
  def search_library_for=(text)
    self.search_library=("#{text}\n")
    self.wait_for_ajax
  end

  def sort_by=(sort_option)
    self.sort_by_list=sort_option
    self.wait_for_ajax
  end

  # Returns the checkbox element itself for the specified
  # item in the list. Use this method for checking whether or
  # not the checkbox in question is selected or not--e.g.,
  # library.checkbox("textfile.txt").should be_set
  def checkbox(item)
    name_li(item).checkbox
  end

  # Checks the specified Library item.
  def check_content(item)
    name_li(item).checkbox.set
  end

  # Unchecks the specified library item.
  def uncheck_content(item)
    name_li(item).checkbox.clear
  end

  def add_selected_to
    self.add_selected_to_button
    self.wait_for_ajax
    self.class.class_eval { include AddToGroupsPopUp }
  end

  def add_to(name)
    name_li(name)

  end

  def share_selected
    self.share_selected_button
    self.text_field(:name=>"newsharecontent_sharelist").wait_until_present
    self.class.class_eval { include ShareWithPopUp }
  end

  def remove_selected
    self.remove_selected_button
    self.div(:id=>"deletecontent_dialog").wait_until_present
    self.class.class_eval { include DeleteContentPopUp }
  end

end

# Contains methods common to all Results lists
module ListWidget

  include PageObject

  # Page Objects
  select_list(:sort_by, :id=>/sortby/)
  select_list(:filter_by, :id=>"facted_select")

  # Custom Methods...

  # Returns an array containing the text of the links (for Groups, Courses, etc.) listed
  def results_list
    list = []
    begin
      self.spans(:class=>"s3d-search-result-name").each do |element|
        list << element.text
      end
    rescue
      list = []
    end
    return list
  end

  alias courses results_list
  alias course_list results_list
  alias groups_list results_list
  alias groups results_list
  alias projects results_list
  alias documents results_list
  alias documents_list results_list
  alias content_list results_list
  alias results results_list
  alias people_list results_list
  alias contacts results_list
  alias memberships results_list

end

# Methods related to lists of Collections
module ListCollections

  include PageObject

end

# Methods related to lists of Content-type objects
module ListContent

  include PageObject

  # Returns the src text for the specified item's
  # Thumbnail image.
  def thumbnail(name)
    name_li(name).link(:title=>"View this item").image.src
  end

  # Clicks to share the specified item. Waits for the page
  # to refresh to bring up the Share Pop Up dialog.
  def share(name)
    name_li(name).button(:title=>"Share content").click
    self.wait_until { self.text.include? "Or, share it on a webservice:" }
    self.class.class_eval { include ShareWithPopUp }
  end

  # Adds the specified (listed) content to the library.
  def add_to_library(name)
    name_li(name).button(:title=>"Save content").click
    self.wait_until { self.text.include? "Save to" }
    self.class.eval_class { include SaveContentPopUp }
  end

  def delete(name)
    name_li(name).button(:title=>"Remove").click
    self.div(:id=>"deletecontent_dialog").wait_until_present
    self.class.class_eval { include DeleteContentPopUp }
  end

  # Clicks to view the owner information of the specified item.
  def view_owner_of(name)
    name_li(name).link(:class=>"s3d-regular-light-links mylibrary_item_username").click
    self.div(:id=>"entity_name").wait_until_present
    ViewPerson.new @browser
  end

  # Returns the item's owner name (as a text string).
  def content_owner(name)
    name_li(name).div(:class=>"mylibrary_item_by").link.text
  end

  # Returns an Array object containing the list of tags/categories
  # listed for the specified content item.
  def content_tags(name)
    array = []
    name_li(name).div(:class=>"mylibrary_item_tags").lis.each do |li|
      array << li.span(:class=>"s3d-search-result-tag").text
    end
    return array
  end

  # Returns the mimetype text next to the Content name--the text that describes
  # what the system thinks the content is.
  def content_type(name)
    name_li(name).span(:class=>/(mylibrary_item_|searchcontent_result_)mimetype/).text
  end

  def content_description(name)
    name_li(name).div(:class=>"mylibrary_item_description").text
  end

  def last_updated(name)
    div_text = name_li(name).div(:class=>"mylibrary_item_by").text
    return div_text[/(?<=\|.).+/]
  end
  alias last_changed last_updated

  def search_by_tag(tag)
    name_link(tag).click
    sleep 3
    self.wait_for_ajax
    ExploreAll.new @browser
  end

  def used_in_count(name)
    used_in_text(name)[/(?<=in.)\d+/].to_i
  end

  def comments_count(name)
    used_in_text(name)[/\d+(?=.comment)/].to_i
  end

  #Private methods
  private

  def used_in_text(name)
    name_li(name).div(:class=>"mylibrary_item_usedin").text
  end

end # ListContent

# Methods related to lists of People/Participants
module ListPeople

  include PageObject

  # Clicks the plus sign next to the specified Contact name.
  # Obviously the name must exist in the list.
  def add_contact(name)
    self.button(:title=>"Request connection with #{name}").click
    self.wait_until { @browser.button(:text=>"Invite").visible? }
    self.class.class_eval { include AddToContactsPopUp }
  end
  alias request_contact add_contact
  alias request_connection add_contact

  # Clicks the X to remove the selected person from the
  # Contacts list (in My Contacts).
  def remove(name)
    self.button(:title=>"Remove contact #{name}").click
    self.wait_for_ajax
    self.class.class_eval { include RemoveContactsPopUp }
  end
  alias remove_contact remove

  def send_message_to(name)
    name_li(name).button(:class=>"s3d-link-button s3d-action-icon s3d-actions-message searchpeople_result_message_icon sakai_sendmessage_overlay").click
    self.wait_for_ajax
    self.class.class_eval { include SendMessagePopUp }
  end

  # This method checks whether or not the listed
  # person has the "Add contact" button available.
  # To ensure the test case will be valid, it first
  # makes sure the specified person is in the list.
  # Returns true if the button is available.
  def addable?(name)
    if name_li(name).exists?
      self.button(:title=>"Request connection with #{name}").present?
    else
      puts "\n#{name} isn't in the results list. Check your script.\nThis may be a false negative.\n"
      return false
    end
  end

end

# Methods related to lists of Groups/Courses
module ListGroups

  include PageObject

  def join_button_for(name)
    name_li(name).div(:class=>/searchgroups_result_left_filler/)
  end

  # Clicks on the plus sign image for the specified group in the list.
  def add_group(name)
    name_li(name).div(:class=>/searchgroups_result_left_filler/).fire_event("onclick")
  end

  alias add_course add_group
  alias add_research add_group
  alias join_course add_group
  alias join_group add_group

  # Returns the specified item's "type", as shown next to the item name--i.e.,
  # "GROUP", "COURSE", etc.
  def group_type(item)
    self.span(:class=>"s3d-search-result-name",:text=>item).parent.span(:class=>"mymemberships_item_grouptype").text
  end

  # Clicks the Message button for the specified listed item.
  def message_course(name)
    name_li(name).button(:class=>/sakai_sendmessage_overlay/).click
    self.class.class_eval { include SendMessagePopUp }
  end

  alias message_group message_course
  alias message_person message_course
  alias message_research message_course

end

# Methods related to lists of Research Projects
module ListProjects

  include PageObject

  # Page Objects

  # Custom Methods...

  # Clicks the specified Link (will open any link that matches the
  # supplied text, but it's made for clicking on a Research item listed on
  # the page because it will instantiate the ResearchIntro class).
  def open_research(name)
    name_link(name).click
    sleep 1
    self.wait_for_ajax
    self.execute_script("$('#joinrequestbuttons_widget').css({display: 'block'})")
    ResearchIntro.new @browser
  end

  alias view_research open_research
  alias open_project open_research

end

# Methods related to the Mail Pages. (Is this needed????)
module MailWidget

  include PageObject

end

# Methods related to the Participants "Area" or "Page" in
# Groups/Courses. This is not the same thing as the ManageParticipants
# module, which relates to the "Add People" Pop Up.
module ParticipantsWidget

  include PageObject

end

# Page Elements and Custom Methods that are shared among the three Error pages
module CommonErrorElements

  include PageObject

  # TBD

end
