import pickle
import numpy as np


MODEL_PATH = "models/pest_risk/model.pkl"
SCALER_PATH = "models/pest_risk/scaler.pkl"
CROP_ENCODER_PATH = "models/pest_risk/crop_encoder.pkl"
LABEL_ENCODER_PATH = "models/pest_risk/label_encoder.pkl"


with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)

with open(SCALER_PATH, "rb") as f:
    scaler = pickle.load(f)

with open(CROP_ENCODER_PATH, "rb") as f:
    crop_encoder = pickle.load(f)

with open(LABEL_ENCODER_PATH, "rb") as f:
    label_encoder = pickle.load(f)


def generate_reasoning(input_data, risk_level):

    humidity = input_data["humidity"]
    rainfall = input_data["rainfall"]

    reasons = []

    if humidity > 75:
        reasons.append("High humidity increases pest and fungal risk.")

    if rainfall > 150:
        reasons.append("Heavy rainfall creates favorable pest conditions.")

    if not reasons:
        reasons.append("Environmental conditions are moderately stable.")

    return " ".join(reasons)


def predict_pest_risk(input_data: dict) -> dict:

    crop_encoded = crop_encoder.transform([input_data["crop"]])[0]

    features = [
        input_data["temperature"],
        input_data["humidity"],
        input_data["rainfall"],
        crop_encoded
    ]

    scaled = scaler.transform([features])

    probs = model.predict_proba(scaled)[0]

    pred_index = int(np.argmax(probs))

    risk_level = label_encoder.inverse_transform([pred_index])[0]

    confidence_score = float(round(probs[pred_index], 2))

    reasoning = generate_reasoning(input_data, risk_level)

    return {
        "risk_level": str(risk_level),
        "confidence_score": confidence_score,
        "reasoning": reasoning
    }
