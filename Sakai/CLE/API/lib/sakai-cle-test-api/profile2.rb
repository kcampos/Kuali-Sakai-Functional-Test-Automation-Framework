#
class Profile2
  include PageObject
  include ToolsMenu
  include Profile2Nav
  CLEElements.modularize(Profile2Methods, :class=>"portletMainIframe")
end

#
class Profile2Preferences
  include PageObject
  include ToolsMenu
  include Profile2Nav
  CLEElements.modularize(Profile2PreferencesMethods, :class=>"portletMainIframe")
end

class Profile2Privacy
  include PageObject
  include ToolsMenu
  include Profile2Nav
  CLEElements.modularize(Profile2PrivacyMethods, :class=>"portletMainIframe")
end

class Profile2Search
  include PageObject
  include ToolsMenu
  include Profile2Nav
  CLEElements.modularize(Profile2SearchMethods, :class=>"portletMainIframe")
end

class Profile2Connections
  include PageObject
  include ToolsMenu
  include Profile2Nav
  CLEElements.modularize(Profile2ConnectionsMethods, :class=>"portletMainIframe")
end

class Profile2View
  include PageObject
  include ToolsMenu
  include Profile2Nav
  include Profile2ViewMethods
end