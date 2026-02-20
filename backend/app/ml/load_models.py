import pickle


# =============================
# MODEL PATHS
# =============================

CROP_MODEL_PATH = "models/crop_recommendation/model.pkl"
YIELD_MODEL_PATH = "models/yield_prediction/model.pkl"
YIELD_SCALER_PATH = "models/yield_prediction/scaler.pkl"
YIELD_ENCODER_PATH = "models/yield_prediction/encoder.pkl"

PEST_MODEL_PATH = "models/pest_risk/model.pkl"
PEST_SCALER_PATH = "models/pest_risk/scaler.pkl"
PEST_CROP_ENCODER_PATH = "models/pest_risk/crop_encoder.pkl"
PEST_LABEL_ENCODER_PATH = "models/pest_risk/label_encoder.pkl"

PRICE_MODEL_PATH = "models/price_forecasting/model.pkl"

CLIMATE_MODEL_PATH = "models/climate_risk/model.pkl"
CLIMATE_SCALER_PATH = "models/climate_risk/scaler.pkl"
CLIMATE_CROP_ENCODER_PATH = "models/climate_risk/crop_encoder.pkl"
CLIMATE_LABEL_ENCODER_PATH = "models/climate_risk/label_encoder.pkl"


# =============================
# GLOBAL VARIABLES
# =============================

crop_model = None

yield_model = None
yield_scaler = None
yield_encoder = None

pest_model = None
pest_scaler = None
pest_crop_encoder = None
pest_label_encoder = None

price_model = None

climate_model = None
climate_scaler = None
climate_crop_encoder = None
climate_label_encoder = None


# =============================
# LOAD FUNCTION
# =============================

def load_all_models():
    global crop_model

    global yield_model
    global yield_scaler
    global yield_encoder

    global pest_model
    global pest_scaler
    global pest_crop_encoder
    global pest_label_encoder

    global price_model

    global climate_model
    global climate_scaler
    global climate_crop_encoder
    global climate_label_encoder

    print("🔄 Loading ML models...")

    # Crop
    with open(CROP_MODEL_PATH, "rb") as f:
        crop_model = pickle.load(f)

    # Yield
    with open(YIELD_MODEL_PATH, "rb") as f:
        yield_model = pickle.load(f)

    with open(YIELD_SCALER_PATH, "rb") as f:
        yield_scaler = pickle.load(f)

    with open(YIELD_ENCODER_PATH, "rb") as f:
        yield_encoder = pickle.load(f)

    # Pest
    with open(PEST_MODEL_PATH, "rb") as f:
        pest_model = pickle.load(f)

    with open(PEST_SCALER_PATH, "rb") as f:
        pest_scaler = pickle.load(f)

    with open(PEST_CROP_ENCODER_PATH, "rb") as f:
        pest_crop_encoder = pickle.load(f)

    with open(PEST_LABEL_ENCODER_PATH, "rb") as f:
        pest_label_encoder = pickle.load(f)

    # Price
    with open(PRICE_MODEL_PATH, "rb") as f:
        price_model = pickle.load(f)

    # Climate
    with open(CLIMATE_MODEL_PATH, "rb") as f:
        climate_model = pickle.load(f)

    with open(CLIMATE_SCALER_PATH, "rb") as f:
        climate_scaler = pickle.load(f)

    with open(CLIMATE_CROP_ENCODER_PATH, "rb") as f:
        climate_crop_encoder = pickle.load(f)

    with open(CLIMATE_LABEL_ENCODER_PATH, "rb") as f:
        climate_label_encoder = pickle.load(f)

    print("✅ All ML models loaded successfully")
