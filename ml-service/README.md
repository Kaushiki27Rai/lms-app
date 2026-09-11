# LMS risk service

FastAPI hosts a Random Forest prediction endpoint. `model/train_model.py` creates **synthetic demo data** and prints precision, recall, F1, and a confusion matrix when training. Its metrics must not be represented as production accuracy. Replace synthetic labels with consented, audited course outcomes before real interventions.

Run: `pip install -r requirements.txt && python model/train_model.py && uvicorn app:app --port 8001`
