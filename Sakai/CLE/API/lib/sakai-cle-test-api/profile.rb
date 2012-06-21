#================
# Profile Pages
#================

#
class Profile
  include PageObject
  include ToolsMenu
  include ProfileMethods
end

#
class EditProfile
  include PageObject
  include ToolsMenu
  include EditProfileMethods
end