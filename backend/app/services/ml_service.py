import os
import joblib
import numpy as np
from typing import Dict, Any

from app.core.logger import logger


class MLService:

    def __init__(self):

        BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

        crop_model_path = os.path.join(BASE_DIR, "ml_models", "crop_model.pkl")
        self.crop_model = joblib.load(crop_model_path)

        self.crop_mapping = {
            0: "rice",
            1: "maize",
            2: "chickpea",
            3: "kidneybeans",
            4: "pigeonpeas",
            5: "mothbeans",
            6: "mungbean",
            7: "blackgram",
            8: "lentil",
            9: "pomegranate",
            10: "banana",
            11: "mango",
            12: "grapes",
            13: "watermelon",
            14: "muskmelon",
            15: "apple",
            16: "orange",
            17: "papaya",
            18: "coconut",
            19: "cotton",
            20: "jute",
            21: "coffee",
        }

        logger.info("ML models loaded successfully")

    def _get_confidence(self, model, features):

        try:
            if hasattr(model, "predict_proba"):
                probs = model.predict_proba(features)
                return float(np.max(probs))
        except Exception as e:
            logger.warning(f"Confidence error: {e}")

        return 0.0

    def predict_crop(self, data: Dict[str, Any]):

        logger.info("Crop prediction started")

        try:

            feature_order = [
                "nitrogen",
                "phosphorus",
                "potassium",
                "temperature",
                "humidity",
                "ph",
                "rainfall",
            ]

            features = np.array([[data[f] for f in feature_order]])

            pred = self.crop_model.predict(features)[0]
            confidence = self._get_confidence(self.crop_model, features)

            crop_name = self.crop_mapping.get(int(pred), "unknown")

            logger.info(f"Crop predicted: {crop_name}")

            return {
                "prediction": crop_name,
                "confidence_score": confidence,
            }

        except Exception as e:
            logger.error(f"Crop prediction failed: {e}")
            raise


ml_service = MLService()
