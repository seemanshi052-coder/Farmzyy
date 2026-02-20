import os
import pickle
import numpy as np

from models.preprocessing.preprocess import preprocess_input, load_encoder


MODEL_PATH = "models/crop_recommendation/model.pkl"


def load_model():
    with open(MODEL_PATH, "rb") as f:
        return pickle.load(f)


model = load_model()
encoder = load_encoder()


def generate_reasoning(input_data: dict, prediction: str) -> str:

    nitrogen = input_data["nitrogen"]
    humidity = input_data["humidity"]
    rainfall = input_data["rainfall"]

    reasons = []

    if nitrogen > 80:
        reasons.append("High nitrogen supports leafy crop growth.")

    if humidity > 70:
        reasons.append("High humidity favors moisture-loving crops.")

    if rainfall > 150:
        reasons.append("Adequate rainfall supports water-intensive crops.")

    if not reasons:
        reasons.append("Soil and climate conditions are suitable for the predicted crop.")

    return " ".join(reasons)


def predict_crop(input_data: dict) -> dict:

    scaled = preprocess_input(input_data)

    probs = model.predict_proba(scaled)[0]
    pred_index = int(np.argmax(probs))

    prediction = encoder.inverse_transform([pred_index])[0]
    confidence_score = float(round(probs[pred_index], 2))

    reasoning = generate_reasoning(input_data, prediction)

    return {
        "prediction": str(prediction),
        "confidence_score": confidence_score,
        "reasoning": reasoning
    }
