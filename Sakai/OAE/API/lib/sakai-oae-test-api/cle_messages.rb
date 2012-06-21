module MessagesFrame
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/TBD/)
  end

end

class Messages
  include PageObject
  include MessagesFrame
  include MessagesMethods
end

class MessagesSentList
  include PageObject
  include MessagesFrame
  include MessagesSentListMethods
end

class MessagesReceivedList
  include PageObject
  include MessagesFrame
  include MessagesSentListMethods
end

# Page for the Contents of a Custom Folder for Messages
class FolderList #FIXME
  include PageObject
  include MessagesFrame
  include FolderListMethods
end

# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo
  include PageObject
  include MessagesFrame
  include MoveMessageToMethods
end

# The page showing the list of deleted messages.
class MessagesDeletedList
  include PageObject
  include MessagesFrame
  include MessagesDeletedListMethods
end

# The page showing the list of Draft messages.
class MessagesDraftList
  include PageObject
  include MessagesFrame
  include MessagesDraftListMethods
end

# The Page where you are reading a Message.
class MessageView
  include PageObject
  include MessagesFrame
  include MessageViewMethods
end

class ComposeMessage
  include PageObject
  include MessagesFrame
  include ComposeMessageMethods
end

class ReplyToMessage
  include PageObject
  include MessagesFrame
  include ReplyToMessageMethods
end

# The page for composing a message
class ForwardMessage
  include PageObject
  include MessagesFrame
  include ForwardMessageMethods
end

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation
  include PageObject
  include MessagesFrame
  include MessageDeleteConfirmationMethods
end

# The page for creating a new folder for Messages
class MessagesNewFolder
  include PageObject
  include MessagesFrame
  include MessagesNewFolderMethods
end

# The page for editing a Message Folder's settings
class MessageFolderSettings
  include PageObject
  include MessagesFrame
  include MessageFolderSettingsMethods
end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm
  include PageObject
  include MessagesFrame
  include FolderDeleteConfirmMethods
end

# The attachment page for Messages
class MessagesAttachment < AddFiles

  include MessagesFrame

  def initialize(browser)
    @browser = browser

    @@classes = {
        :this => "MessagesAttachment",
        :parent => "ComposeMessage",
        :second => "ReplyToMessage"
    }
  end

end