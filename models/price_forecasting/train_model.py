import os
import sys
import json
import pickle
import random
import numpy as np
import pandas as pd

from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import r2_score


current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../"))
sys.path.append(project_root)


MODEL_DIR = "models/price_forecasting"


def ensure_dir():
    os.makedirs(MODEL_DIR, exist_ok=True)


def generate_data(samples=2000):

    data = []

    for _ in range(samples):

        base = random.uniform(1500, 3000)

        prices = [
            base + random.uniform(-100, 100)
            for _ in range(5)
        ]

        trend = random.uniform(-50, 80)

        next_price = prices[-1] + trend

        data.append(prices + [next_price])

    df = pd.DataFrame(data, columns=[
        "p1", "p2", "p3", "p4", "p5", "target"
    ])

    return df


def train():

    ensure_dir()

    df = generate_data()

    X = df[["p1", "p2", "p3", "p4", "p5"]]
    y = df["target"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=42
    )

    model = RandomForestRegressor(
        n_estimators=200,
        random_state=42
    )

    model.fit(X_train, y_train)

    preds = model.predict(X_test)

    r2 = r2_score(y_test, preds)

    with open(f"{MODEL_DIR}/model.pkl", "wb") as f:
        pickle.dump(model, f)

    metrics = {"r2_score": float(r2)}

    with open(f"{MODEL_DIR}/metrics.json", "w") as f:
        json.dump(metrics, f, indent=4)

    print("✅ Price forecasting model trained")
    print("R2:", r2)


if __name__ == "__main__":
    train()
