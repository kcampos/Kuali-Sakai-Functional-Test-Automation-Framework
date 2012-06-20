#================
# News pages
#================
#
class News
  include PageObject
  include ToolsMenu
  CLEElements.modularize(NewsMethods, :class=>"portletMainIframe")
end