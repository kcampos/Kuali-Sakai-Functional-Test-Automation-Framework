
#================
# Assignments Pages
#================

# The page where you create a new assignment
class AssignmentAdd
  include PageObject
  include ToolsMenu
  include AssignmentAddMethods 
end

# Page that appears when you first click the Assignments link
class AssignmentsList
  include PageObject
  include ToolsMenu
  include AssignmentsListMethods 
end


# The Permissions Page in Assignments
class AssignmentsPermissions
  include PageObject
  include ToolsMenu
  include AssignmentsPermissionsMethods 

end

# Page that appears when you click to preview an Assignment
class AssignmentsPreview
  include PageObject
  include ToolsMenu
  include AssignmentsPreviewMethods 
end

# The reorder page for Assignments
class AssignmentsReorder
  include PageObject
  include ToolsMenu
  include AssignmentsReorderMethods 
end

# A Student user's page for editing/submitting/view an assignment.
class AssignmentStudent
  include PageObject
  include ToolsMenu
  include AssignmentStudentMethods 
end

# Page that appears when a Student User clicks to Preview an
# assignment that is in progress.
class AssignmentStudentPreview
  include PageObject
  include ToolsMenu
  include AssignmentStudentPreviewMethods
end

# The page that appears when a Student user has fully submitted an assignment
# or saves it as a draft.
class SubmissionConfirmation
  include PageObject
  include ToolsMenu
  include SubmissionConfirmationMethods
end

# The page that appears when you click on an assignment's "Grade" or "View Submission" link
# as an instructor. Shows the list of students and their
# assignment submission status.
class AssignmentSubmissionList
  include PageObject
  include ToolsMenu
  include AssignmentSubmissionListMethods 
end

# The page that shows a student's submitted assignment to an instructor user.
class AssignmentSubmission
  include PageObject
  include ToolsMenu
  include AssignmentSubmissionMethods 
end

# The Grade Report page accessed from the Assignments page
class GradeReport
  include PageObject
  include ToolsMenu
  include GradeReportMethods 
end

# The Student View page accessed from the Assignments page
class StudentView
  include PageObject
  include ToolsMenu
  include StudentViewMethods 
end

# Page for attaching files to Assignments
class AssignmentAttachments < AddFiles
  include PageObject
  include ToolsMenu

  def initialize(browser)
    @browser = browser

    @@classes = {
        :this => "AssignmentAttachments",
        :parent => "AssignmentAdd",
        :second => "AssignmentStudent",
        :third => "AssignmentSubmission"
    }
  end

end

