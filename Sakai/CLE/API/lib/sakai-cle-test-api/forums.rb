class Forums
  include ToolsMenu
  include ForumsMethods
end

class TopicPage
  include ToolsMenu
  include TopicPageMethods
end

class ViewForumThread
  include ToolsMenu
  include ViewForumThreadMethods
end

class ComposeForumMessage
  include ToolsMenu
  include ComposeForumMessageMethods
end

class ForumTemplateSettings
  include ToolsMenu
  include ForumTemplateSettingsMethods
end

class OrganizeForums
  include ToolsMenu
  include OrganizeForumsMethods
end

class EditForum
  include ToolsMenu
  include EditForumMethods
end

class AddEditTopic
  include ToolsMenu
  include AddEditTopicMethods
end