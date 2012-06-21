
#================
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList
  include PageObject
  include ToolsMenu
  include AssessmentsListMethods
end

# Page that appears when previewing an assessment.
# It shows the basic information about the assessment.
class PreviewOverview
  include PageObject
  include ToolsMenu
  include PreviewOverviewMethods
end

# The Settings page for a particular Assessment
class AssessmentSettings
  include PageObject
  include ToolsMenu
  include AssessmentSettingsMethods
end

# Instructor's view of Students' assessment scores
class AssessmentTotalScores
  include PageObject
  include ToolsMenu
  include AssessmentTotalScoresMethods
end

# The page that appears when you're creating a new quiz
# or editing an existing one
class EditAssessment
  include PageObject
  include ToolsMenu
  include EditAssessmentMethods
end

# This is the page for adding and editing a part of an assessment
class AddEditAssessmentPart
  include PageObject
  include ToolsMenu
  include AddEditAssessmentPartMethods
end

# The review page once you've selected to Save and Publish
# the assessment
class PublishAssessment
  include PageObject
  include ToolsMenu
  include PublishAssessmentMethods
end

# The page for setting up a multiple choice question
class MultipleChoice
  include PageObject
  include ToolsMenu
  include MultipleChoiceMethods
end

# The page for setting up a Survey question
class Survey
  include PageObject
  include ToolsMenu
  include SurveyMethods
end

#  The page for setting up a Short Answer/Essay question
class ShortAnswer
  include PageObject
  include ToolsMenu
  include ShortAnswerMethods
end

#  The page for setting up a Fill-in-the-blank question
class FillInBlank
  include PageObject
  include ToolsMenu
  include FillInBlankMethods
end

#  The page for setting up a numeric response question
class NumericResponse
  include PageObject
  include ToolsMenu
  include NumericResponseMethods
end

#  The page for setting up a matching question
class Matching
  include PageObject
  include ToolsMenu
  include MatchingMethods
end

#  The page for setting up a True/False question
class TrueFalse
  include PageObject
  include ToolsMenu
  include TrueFalseMethods
end

#  The page for setting up a question that requires an audio response
class AudioRecording
  include PageObject
  include ToolsMenu
  include AudioRecordingMethods
end

# The page for setting up a question that requires
# attaching a file
class FileUpload
  include PageObject
  include ToolsMenu
  include FileUploadMethods
end

# The page that appears when you are editing a type of assessment
class EditAssessmentType
  include PageObject
  include ToolsMenu
  include EditAssessmentTypeMethods
end

# The Page that appears when adding a new question pool
class AddQuestionPool
  include PageObject
  include ToolsMenu
  include AddQuestionPoolMethods
end

# The Page that appears when editing an existing question pool
class EditQuestionPool
  include PageObject
  include ToolsMenu
  include EditQuestionPoolMethods
end

# The page with the list of existing Question Pools
class QuestionPoolsList
  include PageObject
  include ToolsMenu
  include QuestionPoolsListMethods
end

# The page that appears when you click to import
# a pool.
class PoolImport
  include PageObject
  include ToolsMenu
  include PoolImportMethods
end

# This page appears when adding a question to a pool
class SelectQuestionType
  include PageObject
  include ToolsMenu
  include SelectQuestionTypeMethods
end

# Page of Assessments accessible to a student user
#
# It may be that we want to deprecate this class and simply use
# the AssessmentsList class alone.
class TakeAssessmentList
  include PageObject
  include ToolsMenu
  include TakeAssessmentListMethods
end

# The student view of the overview page of an Assessment
class BeginAssessment
  include PageObject
  include ToolsMenu
  include BeginAssessmentMethods
end

# The confirmation page that appears when submitting an Assessment.
# The last step before actually submitting the the Assessment.
class ConfirmSubmission
  include ToolsMenu
  include ConfirmSubmissionMethods
end

# The summary page that appears when an Assessment has been submitted.
class SubmissionSummary
  include ToolsMenu
  include SubmissionSummaryMethods
end