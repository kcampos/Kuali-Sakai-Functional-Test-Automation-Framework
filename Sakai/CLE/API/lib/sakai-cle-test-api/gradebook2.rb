#
class Gradebook2
  include PageObject
  include ToolsMenu
  CLEElements.modularize(Gradebook2Methods, :class=>"portletMainIframe")
end