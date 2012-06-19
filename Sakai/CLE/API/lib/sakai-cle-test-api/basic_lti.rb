#
class BasicLTI
  include ToolsMenu
  CLEElements.modularize(BasicLTIMethods, :class=>"portletMainIframe")
end