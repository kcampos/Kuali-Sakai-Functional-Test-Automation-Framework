# Methods related to the Forum page in Courses/Groups
class Forum

  include GlobalMethods
  include LeftMenuBar
  include HeaderBar
  include HeaderFooterBar
  include DocButtons

  # The frame that contains the CLE Forums objects
  def frm
    self.frame(:src=>/sakai2forums.launch.html/)
  end

end