
#================
# Assessments pages - "Samigo", a.k.a., "Tests & Quizzes"
#================

# The Course Tools "Tests and Quizzes" page for a given site.
# (Instructor view)
class AssessmentsList
  include ToolsMenu
  CLEElements.modularize(AssessmentsListMethods, :class=>"portletMainIframe")
end

# Page that appears when previewing an assessment.
# It shows the basic information about the assessment.
class PreviewOverview
  include ToolsMenu
  CLEElements.modularize(PreviewOverviewMethods, :class=>"portletMainIframe")
end

# The Settings page for a particular Assessment
class AssessmentSettings
  include ToolsMenu
  CLEElements.modularize(AssessmentSettingsMethods, :class=>"portletMainIframe")
end

# Instructor's view of Students' assessment scores
class AssessmentTotalScores
  include ToolsMenu
  include AssessmentTotalScoresMethods
end

# The page that appears when you're creating a new quiz
# or editing an existing one
class EditAssessment
  include ToolsMenu
  CLEElements.modularize(EditAssessmentMethods, :class=>"portletMainIframe")
end

# This is the page for adding and editing a part of an assessment
class AddEditAssessmentPart
  include ToolsMenu
  CLEElements.modularize(AddEditAssessmentPartMethods, :class=>"portletMainIframe")
end

# The review page once you've selected to Save and Publish
# the assessment
class PublishAssessment
  include ToolsMenu
  CLEElements.modularize(PublishAssessmentMethods, :class=>"portletMainIframe")
end

# The page for setting up a multiple choice question
class MultipleChoice
  include ToolsMenu
  CLEElements.modularize(MultipleChoiceMethods, :class=>"portletMainIframe")
end

# The page for setting up a Survey question
class Survey
  include ToolsMenu
  CLEElements.modularize(SurveyMethods, :class=>"portletMainIframe")
end

#  The page for setting up a Short Answer/Essay question
class ShortAnswer
  include ToolsMenu
  CLEElements.modularize(ShortAnswerMethods, :class=>"portletMainIframe")
end

#  The page for setting up a Fill-in-the-blank question
class FillInBlank
  include ToolsMenu
  CLEElements.modularize(FillInBlankMethods, :class=>"portletMainIframe")
end

#  The page for setting up a numeric response question
class NumericResponse
  include ToolsMenu
  CLEElements.modularize(NumericResponseMethods, :class=>"portletMainIframe")
end

#  The page for setting up a matching question
class Matching
  include ToolsMenu
  CLEElements.modularize(MatchingMethods, :class=>"portletMainIframe")
end

#  The page for setting up a True/False question
class TrueFalse
  include ToolsMenu
  CLEElements.modularize(TrueFalseMethods, :class=>"portletMainIframe")
end

#  The page for setting up a question that requires an audio response
class AudioRecording
  include ToolsMenu
  CLEElements.modularize(AudioRecordingMethods, :class=>"portletMainIframe")
end

# The page for setting up a question that requires
# attaching a file
class FileUpload
  include ToolsMenu
  CLEElements.modularize(FileUploadMethods, :class=>"portletMainIframe")
end

# The page that appears when you are editing a type of assessment
class EditAssessmentType
  include ToolsMenu
  CLEElements.modularize(EditAssessmentTypeMethods, :class=>"portletMainIframe")
end

# The Page that appears when adding a new question pool
class AddQuestionPool
  include ToolsMenu
  CLEElements.modularize(AddQuestionPoolMethods, :class=>"portletMainIframe")
end

# The Page that appears when editing an existing question pool
class EditQuestionPool
  include ToolsMenu
  CLEElements.modularize(EditQuestionPoolMethods, :class=>"portletMainIframe")
end

# The page with the list of existing Question Pools
class QuestionPoolsList
  include ToolsMenu
  CLEElements.modularize(QuestionPoolsListMethods, :class=>"portletMainIframe")
end

# The page that appears when you click to import
# a pool.
class PoolImport
  include ToolsMenu
  include PoolImportMethods
end

# This page appears when adding a question to a pool
class SelectQuestionType
  include ToolsMenu
  CLEElements.modularize(SelectQuestionTypeMethods, :class=>"portletMainIframe")
end

# Page of Assessments accessible to a student user
#
# It may be that we want to deprecate this class and simply use
# the AssessmentsList class alone.
class TakeAssessmentList
  include ToolsMenu
  include TakeAssessmentListMethods
end

# The student view of the overview page of an Assessment
class BeginAssessment
  include ToolsMenu
  include BeginAssessmentMethods
end

# The confirmation page that appears when submitting an Assessment.
# The last step before actually submitting the the Assessment.
class ConfirmSubmission
  include ToolsMenu
  CLEElements.modularize(ConfirmSubmissionMethods, :class=>"portletMainIframe")
end

# The summary page that appears when an Assessment has been submitted.
class SubmissionSummary
  include ToolsMenu
  CLEElements.modularize(SubmissionSummaryMethods, :class=>"portletMainIframe")
end