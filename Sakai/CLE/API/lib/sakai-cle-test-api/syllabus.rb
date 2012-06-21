#================
# Syllabus pages in a Site
#================

# The topmost page in the Syllabus feature.
# If there are no syllabus items it will appear
# differently than if there are.
class Syllabus
  include PageObject
  include ToolsMenu
  include SyllabusMethods
end

# This is the page that lists Syllabus sections, allows for
# moving them up or down in the list, and allows for removing
# items from the syllabus.
class SyllabusEdit
  include PageObject
  include ToolsMenu
  include SyllabusEditMethods
end

#
class AddEditSyllabusItem
  include PageObject
  include ToolsMenu
  include AddEditSyllabusItemMethods 
end

# The page for previewing a syllabus.
class SyllabusPreview
  include PageObject
  include ToolsMenu
  include SyllabusPreviewMethods 
end

#
class SyllabusRedirect
  include PageObject
  include ToolsMenu
  include SyllabusRedirectMethods 
end

# The page where Syllabus Items can be deleted.
class DeleteSyllabusItems
  include PageObject
  include ToolsMenu
  include DeleteSyllabusItemsMethods
end

class CreateEditSyllabus
  include PageObject
  include ToolsMenu
  include CreateEditSyllabusMethods
end

# TODO: This needs to be fixed!
# The page for attaching files to a Syllabus record.
class SyllabusAttach < AddFiles

  include ToolsMenu

  def initialize(browser)
    @browser = browser

    @the_classes = {
        :this => "SyllabusAttach",
        :parent => "AddEditSyllabusItem",
        :upload_files => "",
        :create_folders => "",
        :file_details => ""
    }

    set_classes_hash(@the_classes)
  end

end