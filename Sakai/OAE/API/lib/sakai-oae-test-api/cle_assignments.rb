module AssignmentsFrame

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/sakai2assignments.launch.html/)
  end

end

#
class AssignmentsList
  include AssignmentsFrame
  CLEElements.modularize( AssignmentsListMethods, :index=>2)
end

#
class AssignmentAdd
  include AssignmentsFrame
  CLEElements.modularize( AssignmentAddMethods, :index=>2)
end

#
class AssignmentsPermissions
  include AssignmentsFrame
  CLEElements.modularize( AssignmentsPermissionsMethods, :index=>2)
end

#
class AssignmentsPreview
  include AssignmentsFrame
  CLEElements.modularize( AssignmentsPreviewMethods, :index=>2)
end

#
class AssignmentsReorder
  include AssignmentsFrame
  CLEElements.modularize( AssignmentsReorderMethods, :index=>2)
end

#
class AssignmentStudent
  include AssignmentsFrame
  CLEElements.modularize( AssignmentStudentMethods, :index=>2)
end

#
class AssignmentStudentPreview
  include AssignmentsFrame
  include AssignmentStudentPreviewMethods
end

#
class SubmissionConfirmation
  include AssignmentsFrame
  include SubmissionConfirmationMethods
end

#
class AssignmentSubmissionList
  include AssignmentsFrame
  CLEElements.modularize( AssignmentSubmissionListMethods, :index=>2)
end

#
class AssignmentSubmission
  include AssignmentsFrame
  CLEElements.modularize( AssignmentSubmissionMethods, :index=>2)
end

#
class GradeReport
  include AssignmentsFrame
  include GradeReportMethods
end

#
class StudentView
  include AssignmentsFrame
  CLEElements.modularize( StudentViewMethods, :index=>2)
end