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
  CLEElements.modularize(AssessmentsListMethods, :index=>2)
end

class PreviewOverview
  include AssessmentsFrame
  CLEElements.modularize(PreviewOverviewMethods, :index=>2)
end

class AssessmentSettings
  include AssessmentsFrame
  CLEElements.modularize(AssessmentSettingsMethods, :index=>2)
end

class AssessmentTotalScores
  include AssessmentsFrame
  include AssessmentTotalScoresMethods
end

class EditAssessment
  include AssessmentsFrame
  CLEElements.modularize(EditAssessmentMethods, :index=>2)
end

class AddEditAssessmentPart
  include AssessmentsFrame
  CLEElements.modularize(AddEditAssessmentPartMethods, :index=>2)
end

class PublishAssessment
  include AssessmentsFrame
  CLEElements.modularize(PublishAssessmentMethods, :index=>2)
end

class MultipleChoice
  include AssessmentsFrame
  CLEElements.modularize(MultipleChoiceMethods, :index=>2)
end

class Survey
  include AssessmentsFrame
  CLEElements.modularize(SurveyMethods, :index=>2)
end

class ShortAnswer
  include AssessmentsFrame
  CLEElements.modularize(ShortAnswerMethods, :index=>2)
end

class FillInBlank
  include AssessmentsFrame
  CLEElements.modularize(FillInBlankMethods, :index=>2)
end

class NumericResponse
  include AssessmentsFrame
  CLEElements.modularize(NumericResponseMethods, :index=>2)
end

class Matching
  include AssessmentsFrame
  CLEElements.modularize(MatchingMethods, :index=>2)
end

class TrueFalse
  include AssessmentsFrame
  CLEElements.modularize(TrueFalseMethods, :index=>2)
end

class AudioRecording
  include AssessmentsFrame
  CLEElements.modularize(AudioRecordingMethods, :index=>2)
end

class FileUpload
  include AssessmentsFrame
  CLEElements.modularize(FileUploadMethods, :index=>2)
end

class EditAssessmentType
  include AssessmentsFrame
  CLEElements.modularize(EditAssessmentTypeMethods, :index=>2)
end

class AddQuestionPool
  include AssessmentsFrame
  CLEElements.modularize(AddQuestionPoolMethods, :index=>2)
end

class EditQuestionPool
  include AssessmentsFrame
  CLEElements.modularize(EditQuestionPoolMethods, :index=>2)
end

class QuestionPoolsList
  include AssessmentsFrame
  CLEElements.modularize(QuestionPoolsListMethods, :index=>2)
end

class PoolImport
  include AssessmentsFrame
  include PoolImportMethods
end

class SelectQuestionType
  include AssessmentsFrame
  CLEElements.modularize(SelectQuestionTypeMethods, :index=>2)
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
  CLEElements.modularize(ConfirmSubmissionMethods, :index=>2)
end

class SubmissionSummary
  include AssessmentsFrame
  CLEElements.modularize(SubmissionSummaryMethods, :index=>2)
end