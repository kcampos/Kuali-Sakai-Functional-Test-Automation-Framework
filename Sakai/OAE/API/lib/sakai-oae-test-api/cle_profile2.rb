module Profile2Frame
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
class Profile2
  include PageObject
  include Profile2Frame
  include Profile2Nav
  CLEElements.modularize(Profile2Methods, :index=>2)
end

#
class Profile2Preferences
  include PageObject
  include Profile2Frame
  include Profile2Nav
  CLEElements.modularize(Profile2PreferencesMethods, :index=>2)
end

class Profile2Privacy
  include PageObject
  include Profile2Frame
  include Profile2Nav
  CLEElements.modularize(Profile2PrivacyMethods, :index=>2)
end

class Profile2Search
  include PageObject
  include Profile2Frame
  include Profile2Nav
  CLEElements.modularize(Profile2SearchMethods, :index=>2)
end

class Profile2Connections
  include PageObject
  include Profile2Frame
  include Profile2Nav
  CLEElements.modularize(Profile2ConnectionsMethods, :index=>2)
end

class Profile2View
  include PageObject
  include Profile2Frame
  include Profile2Nav
  include Profile2ViewMethods
end