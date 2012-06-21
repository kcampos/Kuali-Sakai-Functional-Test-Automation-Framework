module PollsFrame
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/TBD/)
  end

end

#
class Polls
  include PageObject
  include PollsFrame
  include PollsMethods
end

#
class AddEditPoll
  include PageObject
  include PollsFrame
  include AddEditPollMethods
end

#
class AddAnOption
  include PageObject
  include PollsFrame
  include AddAnOptionMethods
end