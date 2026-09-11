from pydantic import BaseModel, Field

class StudentFeatures(BaseModel):
    studentId: int = Field(gt=0)
    attendancePercentage: float = Field(ge=0, le=100)
    averageQuizScore: float = Field(ge=0, le=100)
    assignmentSubmissionRate: float = Field(ge=0, le=100)
    averageAssignmentScore: float = Field(ge=0, le=100)
    courseCompletionPercentage: float = Field(ge=0, le=100)
    missedAssignments: int = Field(ge=0)
    quizAttemptCount: int = Field(ge=0)
    weeklyLearningHours: float = Field(ge=0)
    recentActivityScore: float = Field(ge=0, le=100)
