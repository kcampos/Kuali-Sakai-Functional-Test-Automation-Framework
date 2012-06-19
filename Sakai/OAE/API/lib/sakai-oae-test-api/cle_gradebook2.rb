# TODO - describe class
module Gradebook2Frame

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

#
class Gradebook2
  include Gradebook2Frame
  CLEElements.modularize(Gradebook2Methods, :index=>2)
end