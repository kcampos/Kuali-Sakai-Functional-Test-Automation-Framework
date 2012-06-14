module AssignmentsFrame

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/sakai2assignments.launch.html/)
  end

end

#
class AssignmentsList

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentsListMethods

  AssignmentsListMethods.page_elements(:index=>2)

end

#
class AssignmentAdd

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentAddMethods

  AssignmentAddMethods.page_elements(:index=>2)

end

#
class AssignmentsPermissions

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentsPermissionsMethods

  AssignmentsPermissionsMethods.page_elements(:index=>2)

end

#
class AssignmentsPreview

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentsPreviewMethods

  AssignmentsPreviewMethods.page_elements(:index=>2)

end

#
class AssignmentsReorder

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentsReorderMethods

  AssignmentsReorderMethods.page_elements(:index=>2)

end

#
class AssignmentStudent

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentStudentMethods

  AssignmentStudentMethods.page_elements(:index=>2)

end

#
class AssignmentStudentPreview

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentStudentPreviewMethods

end

#
class SubmissionConfirmation

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include SubmissionConfirmationMethods

end

#
class AssignmentSubmissionList

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentSubmissionListMethods

  AssignmentSubmissionListMethods.page_elements(:index=>2)

end

#
class AssignmentSubmission

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include AssignmentSubmissionMethods

  AssignmentSubmissionMethods.page_elements(:index=>2)

end

#
class GradeReport

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include GradeReportMethods

end

#
class StudentView

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons
  include AssignmentsFrame
  include StudentViewMethods

  StudentViewMethods.page_elements(:index=>2)

end