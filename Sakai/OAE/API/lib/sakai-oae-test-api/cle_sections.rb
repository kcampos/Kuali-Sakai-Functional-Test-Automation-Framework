module SectionsFrame
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

# Topmost page for Sections in Site Management
class Sections
  include PageObject
  include SectionsFrame
  include SectionsMenu
  include SectionsMethods
end

# Methods in this class currently do not support
# adding multiple instances of sections simultaneously.
# That will be added at some future time.
# The same goes for adding days with different meeting times. This will hopefully
# be supported in the future.
class AddEditSections
  include PageObject
  include SectionsFrame
  include SectionsMenu
  include AddEditSectionsMethods, :index=>2)
end

#
class AssignTeachingAssistants
  include PageObject
  include SectionsFrame
  include SectionsMenu
  include AssignTeachingAssistantsMethods, :index=>2)
end

#
class AssignStudents
  include PageObject
  include SectionsFrame
  include SectionsMenu
  include AssignStudentsMethods, :index=>2)
end

# The Options page for Sections.
class SectionsOptions
  include PageObject
  include SectionsFrame
  include SectionsMenu
  include AssignStudentsMethods, :index=>2)
end