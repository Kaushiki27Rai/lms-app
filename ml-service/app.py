from fastapi import FastAPI
from schemas.prediction_schema import StudentFeatures
from services.predictor import predict

app=FastAPI(title="LMS Intelligence Risk Service", version="1.0.0")
@app.get("/health")
def health(): return {"status":"ok"}
@app.post("/predict")
def prediction(payload: StudentFeatures): return predict(payload.model_dump())
