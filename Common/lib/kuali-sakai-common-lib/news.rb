#================
# News pages
#================

#
class News

  include PageObject
  include ToolsMenu

  in_frame(:class=>"portletMainIframe") do |frame|

  end
end