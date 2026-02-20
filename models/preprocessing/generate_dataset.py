import os
import random
import pandas as pd


def get_project_root():
    current_dir = os.path.dirname(os.path.abspath(__file__))
    return os.path.abspath(os.path.join(current_dir, "../../"))


def get_output_path():
    project_root = get_project_root()
    return os.path.join(project_root, "data", "crop_dataset.csv")


crops = [
    "rice",
    "maize",
    "cotton",
    "wheat",
    "barley",
    "soybean",
    "groundnut",
    "millets",
    "sugarcane",
    "pulses"
]


def generate_sample(crop):

    if crop == "rice":
        return [random.randint(80,100), random.randint(40,60), random.randint(40,60),
                random.uniform(20,30), random.uniform(75,90), random.uniform(5.5,7.0),
                random.uniform(180,250), crop]

    if crop == "maize":
        return [random.randint(60,80), random.randint(30,50), random.randint(30,50),
                random.uniform(24,32), random.uniform(60,75), random.uniform(5.5,7.5),
                random.uniform(100,180), crop]

    if crop == "cotton":
        return [random.randint(40,60), random.randint(30,50), random.randint(30,50),
                random.uniform(28,35), random.uniform(50,65), random.uniform(6.0,7.5),
                random.uniform(60,120), crop]

    if crop == "wheat":
        return [random.randint(20,40), random.randint(40,60), random.randint(20,40),
                random.uniform(18,26), random.uniform(60,75), random.uniform(6.0,7.5),
                random.uniform(100,150), crop]

    if crop == "barley":
        return [random.randint(30,50), random.randint(30,45), random.randint(30,45),
                random.uniform(20,26), random.uniform(65,80), random.uniform(6.0,7.0),
                random.uniform(150,220), crop]

    if crop == "soybean":
        return [random.randint(60,80), random.randint(40,60), random.randint(40,60),
                random.uniform(24,30), random.uniform(60,70), random.uniform(6.0,7.0),
                random.uniform(120,160), crop]

    if crop == "groundnut":
        return [random.randint(30,50), random.randint(20,30), random.randint(20,30),
                random.uniform(28,34), random.uniform(50,60), random.uniform(6.5,7.5),
                random.uniform(50,90), crop]

    if crop == "millets":
        return [random.randint(30,45), random.randint(25,35), random.randint(25,35),
                random.uniform(26,32), random.uniform(55,65), random.uniform(6.0,7.0),
                random.uniform(80,120), crop]

    if crop == "sugarcane":
        return [random.randint(50,70), random.randint(50,70), random.randint(35,50),
                random.uniform(24,30), random.uniform(70,80), random.uniform(6.0,6.8),
                random.uniform(150,200), crop]

    if crop == "pulses":
        return [random.randint(20,35), random.randint(20,35), random.randint(20,35),
                random.uniform(28,34), random.uniform(50,60), random.uniform(6.5,7.5),
                random.uniform(40,70), crop]


def generate_dataset(samples_per_crop=220):

    output_path = get_output_path()

    data = []

    for crop in crops:
        for _ in range(samples_per_crop):
            data.append(generate_sample(crop))

    df = pd.DataFrame(data, columns=[
        "nitrogen",
        "phosphorus",
        "potassium",
        "temperature",
        "humidity",
        "ph",
        "rainfall",
        "crop"
    ])

    os.makedirs(os.path.dirname(output_path), exist_ok=True)

    df.to_csv(output_path, index=False)

    print("✅ Dataset generated successfully")
    print("Path:", output_path)
    print("Samples:", len(df))


if __name__ == "__main__":
    generate_dataset()
