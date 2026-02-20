FEATURE_ORDER = [
    "nitrogen",
    "phosphorus",
    "potassium",
    "temperature",
    "humidity",
    "ph",
    "rainfall"
]

def prepare_features(data: dict):
    return [data[feature] for feature in FEATURE_ORDER]
