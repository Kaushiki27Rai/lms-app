"""Trains a demo model on clearly labelled synthetic data; replace with consented historical outcomes in production."""
from pathlib import Path
import joblib, numpy as np, pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.model_selection import train_test_split

FEATURES = ["attendancePercentage", "averageQuizScore", "assignmentSubmissionRate", "averageAssignmentScore", "courseCompletionPercentage", "missedAssignments", "quizAttemptCount", "weeklyLearningHours", "recentActivityScore"]
def synthetic_data(n=900):
    rng=np.random.default_rng(42); data=pd.DataFrame({f:rng.uniform(0,100,n) for f in FEATURES})
    data["missedAssignments"]=rng.integers(0,7,n); data["quizAttemptCount"]=rng.integers(0,12,n); data["weeklyLearningHours"]=rng.uniform(0,18,n)
    weakness=(100-data.attendancePercentage)*.30+(100-data.averageQuizScore)*.22+(100-data.assignmentSubmissionRate)*.25+data.missedAssignments*5+(10-data.weeklyLearningHours.clip(upper=10))*1.8
    data["risk"] = np.where(weakness>=55,"HIGH",np.where(weakness>=32,"MEDIUM","LOW")); return data
def train():
    data=synthetic_data(); x_train,x_test,y_train,y_test=train_test_split(data[FEATURES],data.risk,test_size=.2,random_state=42,stratify=data.risk)
    model=RandomForestClassifier(n_estimators=180,max_depth=8,min_samples_leaf=4,random_state=42,class_weight="balanced"); model.fit(x_train,y_train)
    predictions=model.predict(x_test); print(classification_report(y_test,predictions)); print(confusion_matrix(y_test,predictions))
    joblib.dump({"model":model,"features":FEATURES,"version":"rf-synthetic-v1"},Path(__file__).parent/"student_risk_model.pkl")
if __name__ == "__main__": train()
