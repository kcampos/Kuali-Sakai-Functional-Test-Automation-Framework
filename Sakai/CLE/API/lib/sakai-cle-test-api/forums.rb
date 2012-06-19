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
  CLEElements.modularize(ComposeForumMessageMethods, :class=>"portletMainIframe")
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
  CLEElements.modularize(EditForumMethods, :class=>"portletMainIframe")
end

class AddEditTopic
  include ToolsMenu
  CLEElements.modularize(AddEditTopicMethods, :class=>"portletMainIframe")
end