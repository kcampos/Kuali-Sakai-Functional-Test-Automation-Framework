module ProfileFrame
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
class Profile
  include PageObject
  include ProfileFrame
  include ProfileMethods
end

#
class EditProfile
  include PageObject
  include ProfileFrame
  CLEElements.modularize(EditProfileMethods, :index=>2)
end