#
class Gradebook2
  include ToolsMenu
  CLEElements.modularize(Gradebook2Methods, :class=>"portletMainIframe")
end