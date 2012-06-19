#
class Blogs
  include ToolsMenu
  CLEElements.modularize(BlogsMethods, :class=>"portletMainIframe")
end