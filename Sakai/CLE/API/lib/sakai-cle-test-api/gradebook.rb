#================
# Gradebook Pages
#================

# The topmost page in a Site's Gradebook
class Gradebook
  include PageObject
  include ToolsMenu
  include GradebookMethods
end