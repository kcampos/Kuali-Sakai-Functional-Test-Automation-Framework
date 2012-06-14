
#================
# Assignments Pages
#================

# The page where you create a new assignment
class AssignmentAdd

  include ToolsMenu
  include AssignmentAddMethods

  AssignmentAddMethods.page_elements(:class=>"portletMainIframe")

end

# Page that appears when you first click the Assignments link
class AssignmentsList

  include ToolsMenu
  include AssignmentsListMethods

  AssignmentsListMethods.page_elements(:class=>"portletMainIframe")

end


# The Permissions Page in Assignments
class AssignmentsPermissions


  include ToolsMenu
  include AssignmentsPermissionsMethods

  AssignmentsPermissionsMethods.page_elements(:class=>"portletMainIframe")


end

# Page that appears when you click to preview an Assignment
class AssignmentsPreview

  include ToolsMenu
  include AssignmentsPreviewMethods

  AssignmentsPreviewMethods.page_elements(:class=>"portletMainIframe")

end

# The reorder page for Assignments
class AssignmentsReorder

  include ToolsMenu
  include AssignmentsReorderMethods

  AssignmentsReorderMethods.page_elements(:class=>"portletMainIframe")

end

# A Student user's page for editing/submitting/view an assignment.
class AssignmentStudent

  include ToolsMenu
  include AssignmentStudentMethods

  AssignmentStudentMethods.page_elements(:class=>"portletMainIframe")

end

# Page that appears when a Student User clicks to Preview an
# assignment that is in progress.
class AssignmentStudentPreview

  include ToolsMenu
  include AssignmentStudentPreviewMethods

  AssignmentStudentPreviewMethods.page_elements(:class=>"portletMainIframe")

end

# The page that appears when a Student user has fully submitted an assignment
# or saves it as a draft.
class SubmissionConfirmation

  include ToolsMenu
  include SubmissionConfirmationMethods

  SubmissionConfirmationMethods.page_elements(:class=>"portletMainIframe")

end

# The page that appears when you click on an assignment's "Grade" or "View Submission" link
# as an instructor. Shows the list of students and their
# assignment submission status.
class AssignmentSubmissionList

  include ToolsMenu
  include AssignmentSubmissionListMethods

  AssignmentSubmissionListMethods.page_elements(:class=>"portletMainIframe")

end

# The page that shows a student's submitted assignment to an instructor user.
class AssignmentSubmission

  include ToolsMenu
  include AssignmentSubmissionMethods

  AssignmentSubmissionMethods.page_elements(:class=>"portletMainIframe")

end

# The Grade Report page accessed from the Assignments page
class GradeReport

  include ToolsMenu
  include GradeReportMethods

  GradeReportMethods.page_elements(:class=>"portletMainIframe")

end

# The Student View page accessed from the Assignments page
class StudentViewMethods

  include ToolsMenu
  include StudentViewMethods

  StudentViewMethods.page_elements(:class=>"portletMainIframe")

end

# Page for attaching files to Assignments
class AssignmentAttachments < AttachPageTools

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

