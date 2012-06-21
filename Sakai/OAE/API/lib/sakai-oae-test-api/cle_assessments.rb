# TODO - describe class
module AssessmentsFrame

  include PageObject
  include GlobalMethods
  include HeaderFooterBar
  include LeftMenuBar
  include HeaderBar
  include DocButtons

  # The frame object that contains all of the CLE Tests and Quizzes objects
  def frm
    self.frame(:src=>/sakai2samigo.launch.html/)
  end

end

class AssessmentsList
  include AssessmentsFrame
  include AssessmentsListMethods, :index=>2)
end

class PreviewOverview
  include AssessmentsFrame
  include PreviewOverviewMethods, :index=>2)
end

class AssessmentSettings
  include AssessmentsFrame
  include AssessmentSettingsMethods, :index=>2)
end

class AssessmentTotalScores
  include AssessmentsFrame
  include AssessmentTotalScoresMethods
end

class EditAssessment
  include AssessmentsFrame
  include EditAssessmentMethods, :index=>2)
end

class AddEditAssessmentPart
  include AssessmentsFrame
  include AddEditAssessmentPartMethods, :index=>2)
end

class PublishAssessment
  include AssessmentsFrame
  include PublishAssessmentMethods, :index=>2)
end

class MultipleChoice
  include AssessmentsFrame
  include MultipleChoiceMethods, :index=>2)
end

class Survey
  include AssessmentsFrame
  include SurveyMethods, :index=>2)
end

class ShortAnswer
  include AssessmentsFrame
  include ShortAnswerMethods, :index=>2)
end

class FillInBlank
  include AssessmentsFrame
  include FillInBlankMethods, :index=>2)
end

class NumericResponse
  include AssessmentsFrame
  include NumericResponseMethods, :index=>2)
end

class Matching
  include AssessmentsFrame
  include MatchingMethods, :index=>2)
end

class TrueFalse
  include AssessmentsFrame
  include TrueFalseMethods, :index=>2)
end

class AudioRecording
  include AssessmentsFrame
  include AudioRecordingMethods, :index=>2)
end

class FileUpload
  include AssessmentsFrame
  include FileUploadMethods, :index=>2)
end

class EditAssessmentType
  include AssessmentsFrame
  include EditAssessmentTypeMethods, :index=>2)
end

class AddQuestionPool
  include AssessmentsFrame
  include AddQuestionPoolMethods, :index=>2)
end

class EditQuestionPool
  include AssessmentsFrame
  include EditQuestionPoolMethods, :index=>2)
end

class QuestionPoolsList
  include AssessmentsFrame
  include QuestionPoolsListMethods, :index=>2)
end

class PoolImport
  include AssessmentsFrame
  include PoolImportMethods
end

class SelectQuestionType
  include AssessmentsFrame
  include SelectQuestionTypeMethods, :index=>2)
end

class TakeAssessmentList
  include AssessmentsFrame
  include TakeAssessmentListMethods
end

class BeginAssessment
  include AssessmentsFrame
  include BeginAssessmentMethods
end

class ConfirmSubmission
  include AssessmentsFrame
  include ConfirmSubmissionMethods, :index=>2)
end

class SubmissionSummary
  include AssessmentsFrame
  include SubmissionSummaryMethods, :index=>2)
end