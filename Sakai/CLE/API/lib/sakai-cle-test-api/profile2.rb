#
class Profile2
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2Methods
end

#
class Profile2Preferences
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2PreferencesMethods
end

class Profile2Privacy
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2PrivacyMethods
end

class Profile2Search
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2SearchMethods
end

class Profile2Connections
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2ConnectionsMethods
end

class Profile2View
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2ViewMethods
end