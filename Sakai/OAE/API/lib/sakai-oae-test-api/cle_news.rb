module NewsFrame

  include PageObject
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

class News
  include PageObject
  include NewsFrame
  CLEElements.modularize(NewsMethods, :index=>2)
end