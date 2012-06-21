# Topmost page for Sections in Site Management
class Sections
  include PageObject
  include ToolsMenu
  include SectionsMenu
  include SectionsMethods
end

# Methods in this class currently do not support
# adding multiple instances of sections simultaneously.
# That will be added at some future time.
# The same goes for adding days with different meeting times. This will hopefully
# be supported in the future.
class AddEditSections

  identifier = {:class=>"portletMainIframe"}

  include PageObject
  include ToolsMenu
  include SectionsMenu
  include AddEditSectionsMethods
  #include AddEditSectionsMethods
end

#
class AssignTeachingAssistants
  include PageObject
  include ToolsMenu
  include SectionsMenu
  include AssignTeachingAssistantsMethods
end

#
class AssignStudents
  include PageObject
  include ToolsMenu
  include SectionsMenu
  include AssignStudentsMethods
end

# The Options page for Sections.
class SectionsOptions
  include PageObject
  include ToolsMenu
  include SectionsMenu
  include AssignStudentsMethods
end