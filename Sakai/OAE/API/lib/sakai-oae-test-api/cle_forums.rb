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
  include ForumFrame
  include ForumsMethods
end

class TopicPage
  include ForumFrame
  include TopicPageMethods
end

class ViewForumThread
  include ForumFrame
  include ViewForumThreadMethods
end

class ComposeForumMessage
  include ForumFrame
  CLEElements.modularize(ComposeForumMessageMethods, :index=>2)
end

class ForumTemplateSettings
  include ForumFrame
  include ForumTemplateSettingsMethods
end

class OrganizeForums
  include ForumFrame
  include OrganizeForumsMethods
end

class EditForum
  include ForumFrame
  CLEElements.modularize(EditForumMethods, :index=>2)
end

class AddEditTopic
  include ForumFrame
  CLEElements.modularize(AddEditTopicMethods, :index=>2)
end