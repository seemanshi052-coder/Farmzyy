import os
import sys
import json
import pickle
import random
import pandas as pd
import numpy as np

from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score


current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../"))
sys.path.append(project_root)


MODEL_DIR = "models/pest_risk"


def ensure_dir():
    os.makedirs(MODEL_DIR, exist_ok=True)


def generate_data(samples=2000):

    crops = ["rice", "maize", "wheat", "cotton", "soybean"]

    data = []

    for _ in range(samples):

        crop = random.choice(crops)

        temperature = random.uniform(18, 38)
        humidity = random.uniform(40, 90)
        rainfall = random.uniform(20, 250)

        # Risk logic
        if humidity > 75 and rainfall > 150:
            risk = "High"
        elif humidity > 60:
            risk = "Medium"
        else:
            risk = "Low"

        data.append([temperature, humidity, rainfall, crop, risk])

    df = pd.DataFrame(data, columns=[
        "temperature",
        "humidity",
        "rainfall",
        "crop",
        "risk_level"
    ])

    return df


def train():

    ensure_dir()

    df = generate_data()

    X = df[["temperature", "humidity", "rainfall", "crop"]]
    y = df["risk_level"]

    crop_encoder = LabelEncoder()
    X["crop"] = crop_encoder.fit_transform(X["crop"])

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    label_encoder = LabelEncoder()
    y_encoded = label_encoder.fit_transform(y)

    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y_encoded, test_size=0.2, random_state=42
    )

    model = RandomForestClassifier(n_estimators=200, random_state=42)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)

    accuracy = accuracy_score(y_test, preds)

    # Save artifacts
    with open(f"{MODEL_DIR}/model.pkl", "wb") as f:
        pickle.dump(model, f)

    with open(f"{MODEL_DIR}/scaler.pkl", "wb") as f:
        pickle.dump(scaler, f)

    with open(f"{MODEL_DIR}/crop_encoder.pkl", "wb") as f:
        pickle.dump(crop_encoder, f)

    with open(f"{MODEL_DIR}/label_encoder.pkl", "wb") as f:
        pickle.dump(label_encoder, f)

    metrics = {"accuracy": float(accuracy)}

    with open(f"{MODEL_DIR}/metrics.json", "w") as f:
        json.dump(metrics, f, indent=4)

    print("✅ Pest risk model trained")
    print("Accuracy:", accuracy)


if __name__ == "__main__":
    train()
