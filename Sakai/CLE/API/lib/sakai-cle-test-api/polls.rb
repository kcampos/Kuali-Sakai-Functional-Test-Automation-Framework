#================
# Polls pages
#================

#
class Polls
  include PageObject
  include ToolsMenu
  CLEElements.modularize(PollsMethods, :class=>"portletMainIframe")
end

#
class AddEditPoll
  include PageObject
  include ToolsMenu
  CLEElements.modularize(AddEditPollMethods, :class=>"portletMainIframe")
end

#
class AddAnOption
  include PageObject
  include ToolsMenu
  include AddAnOptionMethods
end