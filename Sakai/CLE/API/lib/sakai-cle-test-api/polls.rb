#================
# Polls pages
#================

#
class Polls
  include PageObject
  include ToolsMenu
  include PollsMethods
end

#
class AddEditPoll
  include PageObject
  include ToolsMenu
   include AddEditPollMethods
end

#
class AddAnOption
  include PageObject
  include ToolsMenu
  include AddAnOptionMethods
end