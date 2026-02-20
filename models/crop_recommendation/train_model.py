import os
import sys

# Add project root to Python path
current_dir = os.path.dirname(os.path.abspath(__file__))
project_root = os.path.abspath(os.path.join(current_dir, "../../"))
sys.path.append(project_root)

import os
import json
import pickle
import pandas as pd

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
from sklearn.model_selection import train_test_split

from models.preprocessing.preprocess import (
    clean_dataset,
    load_scaler,
    load_encoder,
    feature_order
)


MODEL_DIR = "models/crop_recommendation"


def ensure_directory():
    os.makedirs(MODEL_DIR, exist_ok=True)


def train_model(csv_path: str):

    ensure_directory()

    df = pd.read_csv(csv_path)
    df = clean_dataset(df)

    X = df[feature_order]
    y = df["crop"]

    scaler = load_scaler()
    encoder = load_encoder()

    X_scaled = scaler.transform(X)
    y_encoded = encoder.transform(y)

    X_train, X_test, y_train, y_test = train_test_split(
        X_scaled, y_encoded, test_size=0.2, random_state=42
    )

    model = RandomForestClassifier(
        n_estimators=200,
        max_depth=10,
        random_state=42
    )

    model.fit(X_train, y_train)

    preds = model.predict(X_test)

    accuracy = accuracy_score(y_test, preds)

    metrics = {
        "accuracy": float(accuracy)
    }

    # Save model
    with open(os.path.join(MODEL_DIR, "model.pkl"), "wb") as f:
        pickle.dump(model, f)

    # Save metrics
    with open(os.path.join(MODEL_DIR, "metrics.json"), "w") as f:
        json.dump(metrics, f, indent=4)

    print("✅ Crop model trained successfully")
    print("Accuracy:", accuracy)


if __name__ == "__main__":
    train_model("../../data/crop_dataset.csv")
