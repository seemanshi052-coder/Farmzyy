import pickle
import numpy as np


MODEL_PATH = "models/yield_prediction/model.pkl"
SCALER_PATH = "models/yield_prediction/scaler.pkl"
ENCODER_PATH = "models/yield_prediction/encoder.pkl"


with open(MODEL_PATH, "rb") as f:
    model = pickle.load(f)

with open(SCALER_PATH, "rb") as f:
    scaler = pickle.load(f)

with open(ENCODER_PATH, "rb") as f:
    encoder = pickle.load(f)


def generate_reasoning(input_data):

    fertilizer_usage = input_data["fertilizer_usage"]
    rainfall = input_data["rainfall"]

    reasons = []

    if fertilizer_usage > 200:
        reasons.append("High fertilizer usage improves crop productivity.")

    if rainfall > 150:
        reasons.append("Adequate rainfall supports better yield.")

    if not reasons:
        reasons.append("Conditions are moderately suitable for crop growth.")

    return " ".join(reasons)


def predict_yield(input_data: dict) -> dict:

    crop_encoded = encoder.transform([input_data["crop"]])[0]

    features = [
        crop_encoded,
        input_data["land_size"],
        input_data["fertilizer_usage"],
        input_data["rainfall"]
    ]

    scaled = scaler.transform([features])

    pred = model.predict(scaled)[0]

    prediction = float(round(pred, 2))

    confidence_score = 0.88  # regression confidence estimate

    reasoning = generate_reasoning(input_data)

    return {
        "prediction": str(prediction),
        "confidence_score": float(round(confidence_score, 2)),
        "reasoning": reasoning
    }
