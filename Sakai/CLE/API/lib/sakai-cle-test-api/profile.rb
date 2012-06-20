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
  CLEElements.modularize(EditProfileMethods, :class=>"portletMainIframe")
end