from pydantic import BaseModel


# =========================================================
# CROP PREDICTION
# =========================================================

class CropPredictionRequest(BaseModel):
    nitrogen: float
    phosphorus: float
    potassium: float
    temperature: float
    humidity: float
    ph: float
    rainfall: float


# =========================================================
# PEST PREDICTION
# =========================================================

class PestPredictionRequest(BaseModel):
    temperature: float
    humidity: float
    rainfall: float


# =========================================================
# YIELD PREDICTION
# =========================================================

class YieldPredictionRequest(BaseModel):
    crop: str
    land_size: float
    fertilizer_usage: float
    temperature: float
    rainfall: float
