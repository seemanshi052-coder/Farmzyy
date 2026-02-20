import os
import pandas as pd

from preprocess import (
    clean_dataset,
    fit_scaler,
    fit_label_encoder,
    save_feature_config,
    ensure_directory
)


def get_dataset_path():
    """
    Dynamically locate dataset from project root
    """

    current_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(current_dir, "../../"))

    dataset_path = os.path.join(project_root, "data", "crop_dataset.csv")

    return dataset_path


def prepare_crop_dataset():

    ensure_directory()

    csv_path = get_dataset_path()

    print("Dataset path:", csv_path)

    if not os.path.exists(csv_path):
        raise FileNotFoundError(
            f"Dataset not found at: {csv_path}\n"
            f"Please place crop_dataset.csv inside the data/ folder."
        )

    df = pd.read_csv(csv_path)

    df = clean_dataset(df)

    feature_order = [
        "nitrogen",
        "phosphorus",
        "potassium",
        "temperature",
        "humidity",
        "ph",
        "rainfall"
    ]

    X = df[feature_order]
    y = df["crop"]

    fit_scaler(X)
    fit_label_encoder(y)

    save_feature_config()

    print("✅ Data preparation completed")
    print("Samples:", len(df))


if __name__ == "__main__":
    prepare_crop_dataset()
