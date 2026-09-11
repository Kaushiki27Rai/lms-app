from schemas.prediction_schema import StudentFeatures

def test_schema_rejects_invalid_attendance():
    try:
        StudentFeatures(studentId=1, attendancePercentage=101, averageQuizScore=0, assignmentSubmissionRate=0, averageAssignmentScore=0, courseCompletionPercentage=0, missedAssignments=0, quizAttemptCount=0, weeklyLearningHours=0, recentActivityScore=0)
        assert False, "Expected Pydantic validation error"
    except ValueError:
        assert True
