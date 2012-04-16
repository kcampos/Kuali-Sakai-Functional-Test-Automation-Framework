# coding: UTF-8

# This module contains methods that will be almost
# universally useful, and don't pertain to any specific
# area or widget or pop up on a given page.
module GlobalMethods

  include PageObject

  # These create methods of the form
  # open_<name>('target link text')
  # Example usage in a script on a page where there's a calendar link
  # with the text "Moon Phases" ...
  #
  # calendar_page = current_page.open_calendar("Moon Phases")
  #
  # Once the link is clicked, the method
  # returns the specified class object.
  #
  # It's important to note that the methods created
  # assume that the target page will be opened in the
  # same tab. If a new tab is opened, these methods will not work.
  #
  # In addition, the page classes that are instantiated for the
  # target pages assume that the user has editing
  # rights.
  open_link(:document, "ContentDetailsPage")
  open_link(:content, "ContentDetailsPage")
  open_link(:remote_content, "Remote")
  open_link(:library, "Library")
  open_link(:participants, "Participants")
  open_link(:discussions, "Discussions")
  open_link(:inline_content, "InlineContent")
  open_link(:tests_and_quizzes, "Tests")
  open_link(:assessments, "Tests")
  open_link(:calendar, "Calendar")
  open_link(:map, "GoogleMaps")
  open_link(:file, "Files")
  open_link(:comments, "Comments")
  open_link(:jisc, "JISC")
  open_link(:assignments, "Assignments")
  open_link(:feed, "RSS")
  open_link(:rss_feed, "RSS")
  open_link(:rss, "RSS")
  open_link(:lti, "LTI")
  open_link(:basic_lti, "LTI")
  open_link(:gadget, "Gadget")
  open_link(:gradebook, "Gradebook")

  alias open_group open_library
  alias open_course open_library
  alias go_to open_library

  # The "gritter" notification that appears to confirm
  # when something has happened (like updating a user profile
  # or sending a message).
  div(:notification, :class=>"gritter-with-image")

  # This method is essentially
  # identical with the
  # open_link methods listed above.
  # It opens page/document items that are listed on the page--for example
  # in the Recent activity box.
  # There is an important distinction, however:
  # This method should be used in cases when clicking the
  # link results in a new browser tab/window being generated.
  # May ultimately convert this to open_public_<object>
  # if that seems the best generic way to handle things.
  #
  # THIS METHOD MAY SOON BE DEPRECATED (if so, it
  # will be included as an alias of open_content)
  def open_page(name)
    name_link(name).click
    self.wait_for_ajax
    self.window(:title=>"rSmart | Content Profile").use
    ContentDetailsPage.new @browser
  end

  # Clicks the link of the specified name (It will click any link on the page,
  # really, but it should be used for Person links only, because it
  # instantiates the ViewPerson Class)
  def view_person(name)
    name_link(name).click
    sleep 3
    self.wait_for_ajax
    ViewPerson.new @browser
  end

  alias view_profile view_person

  def close_notification
    self.notification_element.fire_event "onmouseover"
    self.div(:class=>"gritter-close").fire_event "onclick"
  end

  # This method exposes the "draggable" menu items in the left-hand
  # menus, so that you can use Watir's <X>.drag_and_drop_on <Y> method.
  # Note that not all matching menu items are necessarily draggable.
  # Also useful if you just want to see if the menu item is visible
  # on the page
  def menu_item(name)
    self.div(:class=>/lhnavigation(_subnav|)_item_content/, :text=>name)
  end

end