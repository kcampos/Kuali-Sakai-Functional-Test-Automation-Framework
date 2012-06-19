#================
# Messages Pages
#================

# The Messages page for a Site
class Messages

  include PageObject
  include ToolsMenu

  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    sleep 1 #FIXME
    ComposeMessage.new(@browser)
  end

  def received
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

  def sent
    frm.link(:text=>"Sent").click
    MessagesSentList.new(@browser)
  end

  def deleted
    frm.link(:text=>"Deleted").click
    MessagesDeletedList.new(@browser)
  end

  def draft
    frm.link(:text=>"Draft").click
    MessagesDraftList.new(@browser)
  end

  def open_folder(foldername)
    frm.link(:text=>foldername).click
    FolderList.new(@browser)
  end

  def new_folder
    frm.link(:text=>"New Folder").click
    MessagesNewFolder.new(@browser)
  end

  def settings
    frm.link(:text=>"Settings").click
    MessagesSettings.new(@browser)
  end

  # Gets the count of messages
  # in the specified folder
  # and returns it as a string
  def total_messages_in_folder(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:class=>"textPanelFooter", :index=>0).text =~ /\d+/
    return $~.to_s
  end

  # Gets the count of unread messages
  # in the specified folder and returns it
  # as a string
  def unread_messages_in_folder(folder_name)
    frm.table(:id=>"msgForum:_id23:0:privateForums").row(:text=>/#{Regexp.escape(folder_name)}/).span(:text=>/unread/).text =~ /\d+/
    return $~.to_s
  end

  # Gets all the folder names
  def folders
    links = frm.table(:class=>"hierItemBlockWrapper").links.find_all { |link| link.title != /Folder Settings/ }
    folders = []
    links.each { |link| folders << link.text }
    return folders
  end

  def folder_settings(folder_name)
    frm.table(:class=>"hierItemBlockWrapper").row(:text=>/#{Regexp.escape(folder_name)}/).link(:text=>"Folder Settings").click
    MessageFolderSettings.new(@browser)
  end

end

# The page showing the user's Sent Messages.
class MessagesSentList

  include PageObject
  include ToolsMenu

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end

  # Clicks the Compose Message button,
  # then instantiates the
  # ComposeMessage class.
  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of received messages.
class MessagesReceivedList

  include PageObject
  include ToolsMenu

  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set
  end

  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  # Returns an Array object containing the
  # subjects of the displayed messages that are
  # marked unread.
  def unread_messages
    # TODO - Write this method
  end

  # Clicks the Move link, then
  # instantiates the MoveMessageTo Class.
  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end

# Page for the Contents of a Custom Folder for Messages
class FolderList #FIXME

  include PageObject
  include ToolsMenu

  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Clicks on the specified message subject
  # then instantiates the MessageView class.
  def open_message(subject)
    frm.link(:text, /#{Regexp.escape(subject)}/).click
    MessageView.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set
  end

  # Clicks the Messages link in the
  # Breadcrumb bar at the top of the
  # page, then instantiates the Messages
  # class
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  # Clicks the "Mark Read" link, then
  # reinstantiates the class because
  # the page partially refreshes.
  def mark_read
    frm.link(:text=>"Mark Read").click
    MessagesReceivedList.new(@browser)
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages.row(:index=>x).a.title
    end
    return titles
  end

  def unread_messages
    # TODO - Write this method
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    select_list(:view, :id=>"prefs_pvt_form:viewlist", :frame=>frame)
    link(:check_all, :text=>"Check All", :frame=>frame)
    link(:delete, :text=>"Delete", :frame=>frame)
  end
end


# Page that appears when you want to move a message
# from one folder to another.
class MoveMessageTo

  include PageObject
  include ToolsMenu

  def move_messages
    frm.button(:value=>"Move Messages").click
    Messages.new(@browser)
  end

  # Method for selecting any custom folders
  # present on the screen--and *only* the custom
  # folders. Count begins with "1" for the first custom
  # folder listed.
  def select_custom_folder_num(num)
    frm.radio(:index=>num.to_i+3).set
  end

  in_frame(:index=>1) do |frame|
    radio_button(:received, :name=>"pvtMsgMove:_id16:0:privateForums:0:_id19", :frame=>frame)
    radio_button(:sent, :name=>"pvtMsgMove:_id16:0:privateForums:1:_id19", :frame=>frame)
    radio_button(:deleted, :name=>"pvtMsgMove:_id16:0:privateForums:2:_id19", :frame=>frame)
    radio_button(:draft, :name=>"pvtMsgMove:_id16:0:privateForums:3:_id19", :frame=>frame)
  end
end


# The page showing the list of deleted messages.
class MessagesDeletedList

  include PageObject
  include ToolsMenu

  # Returns a string consisting of the content of the
  # page header--or "breadcrumb", as it's called.
  def header
    frm.div(:class=>"breadCrumb specialLink").text
  end

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  # Creates an array consisting of the
  # message subject lines.
  def subjects
    titles = []
    messages = frm.table(:id=>"prefs_pvt_form:pvtmsgs")
    1.upto(messages.rows.size-1) do |x|
      titles << messages[x][2].text
    end
    return titles
  end

  # Checks the checkbox for the specified
  # message in the list.
  #
  # Will throw an error if the specified
  # subject is not present.
  def check_message(subject)
    index=subjects.index(subject)
    frm.checkbox(:name=>"prefs_pvt_form:pvtmsgs:#{index}:_id122").set
  end

  def move
    frm.link(:text, "Move").click
    MoveMessageTo.new(@browser)
  end

  def delete
    frm.link(:text=>"Delete").click
    MessageDeleteConfirmation.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The page showing the list of Draft messages.
class MessagesDraftList

  include PageObject
  include ToolsMenu

  def compose_message
    frm.link(:text=>"Compose Message").click
    ComposeMessage.new(@browser)
  end

  # Grabs the text from the message
  # box that appears after doing some
  # action.
  #
  # Use this method to simplify writing
  # Test::Unit asserts
  def alert_message_text
    frm.span(:class=>"success").text
  end

  in_frame(:index=>1) do |frame|
    link(:check_all, :text=>"Check All", :frame=>frame)
  end
end

# The Page where you are reading a Message.
class MessageView

  include PageObject
  include ToolsMenu

  # Returns the contents of the message body.
  def message_text
    frm.div(:class=>"textPanel").text
  end

  def reply
    frm.button(:value=>"Reply").click
    ReplyToMessage.new(@browser)
  end

  def forward
    frm.button(:value=>"Forward ").click
    ForwardMessage.new(@browser)
  end

  def received
    frm.link(:text=>"Received").click
    MessagesReceivedList.new(@browser)
  end

  # Clicks the "Messages" breadcrumb link to return
  # to the top level of Messages. Then instantiates
  # the Messages class.
  def messages
    frm.link(:text=>"Messages").click
    Messages.new(@browser)
  end

end

# The page for composing a message
class ComposeMessage

  include PageObject
  include ToolsMenu

  def send
    frm.button(:value=>"Send ").click
    Messages.new(@browser)
  end

  def message_text=(text)
    frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame").td(:id, "xEditingArea").wait_until_present
    sleep 0.3
    frm.frame(:id, "compose:pvt_message_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end

  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end

  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:send_to, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)

  end
end

# The page for composing a message
class ReplyToMessage

  include PageObject
  include ToolsMenu

  def send
    frm.button(:value=>"Send ").click
    # Need logic here to ensure the
    # right class gets called...
    if frm.div(:class=>/breadCrumb/).text=~ /Messages.\/.Received/
      MessagesReceivedList.new(@browser)
    else #FIXME
      Messages.new(@browser)
    end
  end

  def message_text=(text)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgReply:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end

  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end

  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_additional_recipients, :id=>"compose:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)

  end
end

# The page for composing a message
class ForwardMessage

  include PageObject
  include ToolsMenu

  def send
    frm.button(:value=>"Send ").click
    MessagesReceivedList.new(@browser) #FIXME!
  end

  def message_text=(text)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(:home)
    frm.frame(:id, "pvtMsgForward:df_compose_body_inputRichText___Frame").td(:id, "xEditingArea").frame(:index=>0).send_keys(text)
  end

  def add_attachments
    frm.button(:value=>"Add attachments").click
    MessagesAttachment.new(@browser)
  end

  def preview
    frm.button(:value=>"Preview").click
    MessagesPreview.new(@browser)
  end

  def save_draft
    frm.button(:value=>"Save Draft").click
    xxxxxxxxx.new(@browser) #FIXME
  end

  in_frame(:index=>1) do |frame|
    select_list(:select_forward_recipients, :id=>"pvtMsgForward:list1", :frame=>frame)
    checkbox(:send_cc, :id=>"compose:send_email_out", :frame=>frame)
    text_field(:subject, :id=>"compose:subject", :frame=>frame)

  end
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

# The page that appears when you select to
# Delete a message that is already inside
# the Deleted folder.
class MessageDeleteConfirmation

  include PageObject
  include ToolsMenu

  def alert_message_text
    frm.span(:class=>"alertMessage").text
  end

  def delete_messages
    frm.button(:value=>"Delete Message(s)").click
    MessagesDeletedList.new(@browser)
  end

  #FIXME
  # Want eventually to have a method that will return
  # an array of Message subjects

end

# The page for creating a new folder for Messages
class MessagesNewFolder

  include PageObject
  include ToolsMenu

  def add
    frm.button(:value=>"Add").click
    Messages.new(@browser)
  end

  in_frame(:index=>1) do |frame|
    text_field(:title, :id=>"pvtMsgFolderAdd:title", :frame=>frame)
  end
end

# The page for editing a Message Folder's settings
class MessageFolderSettings

  include PageObject
  include ToolsMenu

  def rename_folder
    frm.button(:value=>"Rename Folder").click
    RenameMessageFolder.new(@browser)
  end

  def add
    frm.button(:value=>"Add").click
    MessagesNewFolder.new(@browser)
  end

  def delete
    frm.button(:value=>"Delete").click
    FolderDeleteConfirm.new(@browser)
  end

end

# Page that confirms you want to delete the custom messages folder.
class FolderDeleteConfirm

  include PageObject
  include ToolsMenu

  def delete
    frm.button(:value=>"Delete").click
    Messages.new(@browser)
  end
end