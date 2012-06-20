class Messages
  include PageObject
  include ToolsMenu
  include MessagesMethods
end

class MessagesSentList
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessagesSentListMethods, :class=>"portletMainIframe")
end

class MessagesReceivedList
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessagesSentListMethods, :class=>"portletMainIframe")
end

# Page for the Contents of a Custom Folder for Messages
class FolderList #FIXME
  include PageObject
  include ToolsMenu
  CLEElements.modularize(FolderListMethods, :class=>"portletMainIframe")
end

# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MoveMessageToMethods, :class=>"portletMainIframe")
end

# The page showing the list of deleted messages.
class MessagesDeletedList
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessagesDeletedListMethods, :class=>"portletMainIframe")
end

# The page showing the list of Draft messages.
class MessagesDraftList
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessagesDraftListMethods, :class=>"portletMainIframe")
end

# The Page where you are reading a Message.
class MessageView
  include PageObject
  include ToolsMenu
  include MessageViewMethods
end

class ComposeMessage
  include PageObject
  include ToolsMenu
  CLEElements.modularize(ComposeMessageMethods, :class=>"portletMainIframe")
end

class ReplyToMessage
  include PageObject
  include ToolsMenu
  CLEElements.modularize(ReplyToMessageMethods, :class=>"portletMainIframe")
end

# The page for composing a message
class ForwardMessage
  include PageObject
  include ToolsMenu
  CLEElements.modularize(ForwardMessageMethods, :class=>"portletMainIframe")
end

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessageDeleteConfirmationMethods, :class=>"portletMainIframe")
end

# The page for creating a new folder for Messages
class MessagesNewFolder
  include PageObject
  include ToolsMenu
  CLEElements.modularize(MessagesNewFolderMethods, :class=>"portletMainIframe")
end

# The page for editing a Message Folder's settings
class MessageFolderSettings
  include PageObject
  include ToolsMenu
  include MessageFolderSettingsMethods
end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm
  include PageObject
  include ToolsMenu
  include FolderDeleteConfirmMethods
end

# The attachment page for Messages
class MessagesAttachment < AttachPageTools

  include ToolsMenu

  def initialize(browser)
    @browser = browser

    @@classes = {
        :this => "MessagesAttachment",
        :parent => "ComposeMessage",
        :second => "ReplyToMessage"
    }
  end

end