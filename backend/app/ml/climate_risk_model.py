import pickle
import numpy as np


MODEL_PATH = "models/climate_risk/model.pkl"
SCALER_PATH = "models/climate_risk/scaler.pkl"
CROP_ENCODER_PATH = "models/climate_risk/crop_encoder.pkl"
LABEL_ENCODER_PATH = "models/climate_risk/label_encoder.pkl"


with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)

with open(SCALER_PATH, "rb") as f:
    scaler = pickle.load(f)

with open(CROP_ENCODER_PATH, "rb") as f:
    crop_encoder = pickle.load(f)

with open(LABEL_ENCODER_PATH, "rb") as f:
    label_encoder = pickle.load(f)


def generate_reasoning(input_data, risk_level):

    temperature = input_data["temperature"]
    rainfall = input_data["rainfall"]

    reasons = []

    if rainfall > 220:
        reasons.append("Excess rainfall increases flood risk.")

    if rainfall < 60:
        reasons.append("Low rainfall indicates possible drought conditions.")

    if temperature > 35:
        reasons.append("High temperature can stress crops.")

    if not reasons:
        reasons.append("Climate conditions appear stable.")

    return " ".join(reasons)


def predict_climate_risk(input_data: dict) -> dict:

    crop_encoded = crop_encoder.transform([input_data["crop"]])[0]

    features = [
        input_data["temperature"],
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
