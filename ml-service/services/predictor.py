from pathlib import Path
import joblib, numpy as np
from model.train_model import FEATURES, train

MODEL_PATH=Path(__file__).parent.parent/"model"/"student_risk_model.pkl"
def load_model():
    if not MODEL_PATH.exists(): train()
    return joblib.load(MODEL_PATH)
def predict(features: dict):
    artifact=load_model(); model=artifact["model"]; row=np.array([[features[f] for f in FEATURES]])
    probabilities=model.predict_proba(row)[0]; level=model.classes_[probabilities.argmax()]; risk=float(probabilities[list(model.classes_).index(level)])
    factors=[]
    if features["attendancePercentage"]<75: factors.append("Low attendance")
    if features["assignmentSubmissionRate"]<80: factors.append("Incomplete assignments")
    if features["averageQuizScore"]<65: factors.append("Low quiz performance")
    if not factors: factors.append("Consistent learning activity")
    return {"studentId":features["studentId"],"riskLevel":level,"riskScore":round(risk,3),"confidence":round(risk,3),"keyFactors":factors,"modelVersion":artifact["version"]}
