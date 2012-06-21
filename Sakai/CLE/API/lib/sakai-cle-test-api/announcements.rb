# The Announcements list page for a Site.
class Announcements
  include ToolsMenu
  include AnnouncementsMethods
end

# Show Announcements from Another Site. On this page you select what announcements
# you want to merge into the current Site.
class AnnouncementsMerge
  include ToolsMenu
  include AnnouncementsMergeMethods
end

# This Class does double-duty. It's for the Preview page when editing an
# Announcement, plus for when you just click an Announcement to view it.
class PreviewAnnouncements
  include ToolsMenu
  include PreviewAnnouncementsMethods
end

# The page where an announcement is created or edited.
class AddEditAnnouncements
  include ToolsMenu
  include AddEditAnnouncementsMethods
end

# The page for attaching files and links to Announcements.
class AnnouncementsAttach < AddFiles

  include ToolsMenu

  def initialize(browser)
    @browser = browser

    @@classes= {
        :this => "AnnouncementsAttach",
        :parent => "AddEditAnnouncements"
    }
  end

end

# Page for merging announcements from other sites
class AnnouncementsMerge
  include ToolsMenu
  include AnnouncementsMergeMethods
end

# Page for setting up options for announcements
class AnnouncementsOptions
  include ToolsMenu
  include AnnouncementsOptionsMethods
end

# Page containing permissions options for announcements
class AnnouncementsPermissions
  include ToolsMenu
  include AnnouncementsPermissionsMethods
end