import os
import sys
import json
import pickle
import random
import pandas as pd
import numpy as np

from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder


current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../"))
sys.path.append(project_root)


MODEL_DIR = "models/yield_prediction"


def ensure_dir():
    os.makedirs(MODEL_DIR, exist_ok=True)


def generate_synthetic_data(samples=1500):

    crops = ["rice", "maize", "wheat", "cotton", "soybean"]

    data = []

    for _ in range(samples):

        crop = random.choice(crops)

        land_size = random.uniform(0.5, 5.0)
        fertilizer_usage = random.uniform(50, 300)
        rainfall = random.uniform(50, 250)

        base_yield = {
            "rice": 4.5,
            "maize": 3.8,
            "wheat": 3.2,
            "cotton": 2.5,
            "soybean": 2.8
        }[crop]

        yield_value = (
            base_yield
            + 0.02 * fertilizer_usage
            + 0.01 * rainfall
            + random.uniform(-0.5, 0.5)
        )

        data.append([crop, land_size, fertilizer_usage, rainfall, yield_value])

    df = pd.DataFrame(data, columns=[
        "crop",
        "land_size",
        "fertilizer_usage",
        "rainfall",
        "yield"
    ])

    return df


def train():

    ensure_dir()

    df = generate_synthetic_data()

    X = df[["crop", "land_size", "fertilizer_usage", "rainfall"]]
    y = df["yield"]

    encoder = LabelEncoder()
    X["crop"] = encoder.fit_transform(X["crop"])

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y, test_size=0.2, random_state=42
    )

    model = RandomForestRegressor(n_estimators=200, random_state=42)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)

    r2 = r2_score(y_test, preds)

    # Save model
    with open(f"{MODEL_DIR}/model.pkl", "wb") as f:
        pickle.dump(model, f)

    with open(f"{MODEL_DIR}/scaler.pkl", "wb") as f:
        pickle.dump(scaler, f)

    with open(f"{MODEL_DIR}/encoder.pkl", "wb") as f:
        pickle.dump(encoder, f)

    metrics = {"r2_score": float(r2)}

    with open(f"{MODEL_DIR}/metrics.json", "w") as f:
        json.dump(metrics, f, indent=4)

    print("✅ Yield model trained")
    print("R2:", r2)


if __name__ == "__main__":
    train()
