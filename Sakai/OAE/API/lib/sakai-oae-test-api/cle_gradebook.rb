# TODO - describe class
class Gradebook

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # TODO - Describe method
  def gradebook_frame
    self.frame(:src=>/sakai2gradebook.launch.html/)
  end

end