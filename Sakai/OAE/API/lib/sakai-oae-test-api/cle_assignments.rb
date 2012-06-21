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
  include  AssignmentsListMethods, :index=>2)
end

#
class AssignmentAdd
  include AssignmentsFrame
  include  AssignmentAddMethods, :index=>2)
end

#
class AssignmentsPermissions
  include AssignmentsFrame
  include  AssignmentsPermissionsMethods, :index=>2)
end

#
class AssignmentsPreview
  include AssignmentsFrame
  include  AssignmentsPreviewMethods, :index=>2)
end

#
class AssignmentsReorder
  include AssignmentsFrame
  include  AssignmentsReorderMethods, :index=>2)
end

#
class AssignmentStudent
  include AssignmentsFrame
  include  AssignmentStudentMethods, :index=>2)
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
  include  AssignmentSubmissionListMethods, :index=>2)
end

#
class AssignmentSubmission
  include AssignmentsFrame
  include  AssignmentSubmissionMethods, :index=>2)
end

#
class GradeReport
  include AssignmentsFrame
  include GradeReportMethods
end

#
class StudentView
  include AssignmentsFrame
  include  StudentViewMethods, :index=>2)
end