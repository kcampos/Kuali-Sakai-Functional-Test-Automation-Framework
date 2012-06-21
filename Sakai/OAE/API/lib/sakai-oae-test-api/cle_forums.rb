# Methods related to the Forum page in Courses/Groups
module ForumFrame
  include GlobalMethods
  include LeftMenuBar
  include HeaderBar
  include HeaderFooterBar
  include DocButtons

  # The frame that contains the CLE Forums objects
  def frm
    self.frame(:src=>/sakai2forums.launch.html/)
  end

end

class Forums
  include PageObject
  include ForumFrame
  include ForumsMethods
end

class TopicPage
  include PageObject
  include ForumFrame
  include TopicPageMethods
end

class ViewForumThread
  include PageObject
  include ForumFrame
  include ViewForumThreadMethods
end

class ComposeForumMessage
  include PageObject
  include ForumFrame
  CLEElements.modularize(ComposeForumMessageMethods, :index=>2)
end

class ForumTemplateSettings
  include PageObject
  include ForumFrame
  include ForumTemplateSettingsMethods
end

class OrganizeForums
  include PageObject
  include ForumFrame
  include OrganizeForumsMethods
end

class EditForum
  include PageObject
  include ForumFrame
  CLEElements.modularize(EditForumMethods, :index=>2)
end

class AddEditTopic
  include PageObject
  include ForumFrame
  CLEElements.modularize(AddEditTopicMethods, :index=>2)
end