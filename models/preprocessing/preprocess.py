import os
import json
import pickle
import pandas as pd
from sklearn.preprocessing import StandardScaler, LabelEncoder


PREPROCESS_DIR = "models/preprocessing"

feature_order = [
    "nitrogen",
    "phosphorus",
    "potassium",
    "temperature",
    "humidity",
    "ph",
    "rainfall"
]


def ensure_directory():
    os.makedirs(PREPROCESS_DIR, exist_ok=True)


def clean_dataset(df: pd.DataFrame) -> pd.DataFrame:
    """
    Clean dataset:
    - Drop duplicates
    - Handle missing values
    - Reset index
    """

    df = df.drop_duplicates()

    numeric_cols = df.select_dtypes(include=["int64", "float64"]).columns

    for col in numeric_cols:
        df[col] = df[col].fillna(df[col].median())

    df = df.reset_index(drop=True)

    return df


def fit_scaler(X: pd.DataFrame):
    scaler = StandardScaler()
    scaler.fit(X)

    with open(os.path.join(PREPROCESS_DIR, "scaler.pkl"), "wb") as f:
        pickle.dump(scaler, f)

    return scaler


def fit_label_encoder(y):
    encoder = LabelEncoder()
    encoder.fit(y)

    with open(os.path.join(PREPROCESS_DIR, "encoders.pkl"), "wb") as f:
        pickle.dump(encoder, f)

    return encoder


def save_feature_config():
    config = {
        "feature_order": feature_order
    }

    with open(os.path.join(PREPROCESS_DIR, "feature_config.json"), "w") as f:
        json.dump(config, f, indent=4)


def load_scaler():
    with open(os.path.join(PREPROCESS_DIR, "scaler.pkl"), "rb") as f:
        return pickle.load(f)


def load_encoder():
    with open(os.path.join(PREPROCESS_DIR, "encoders.pkl"), "rb") as f:
        return pickle.load(f)


def preprocess_input(input_data: dict):
    """
    Convert dictionary input into scaled model input.
    """

    scaler = load_scaler()

    data = [input_data[feature] for feature in feature_order]

    df = pd.DataFrame([data], columns=feature_order)

    scaled = scaler.transform(df)

    return scaled
