from datetime import datetime
from typing import Dict, Any

from app.core.firebase import firebase_client
from app.core.logger import logger


class PredictionService:

    def __init__(self):
        self.db = firebase_client.db

    def save_prediction(
        self,
        user_id: str,
        prediction_type: str,
        input_data: Dict[str, Any],
        prediction: str,
        confidence_score: float,
    ):

        try:

            doc = {
                "user_id": user_id,
                "prediction_type": prediction_type,
                "input_data": input_data,
                "prediction": prediction,
                "confidence_score": confidence_score,
                "timestamp": datetime.utcnow(),
            }

            self.db.collection("predictions").add(doc)

            logger.info(f"Prediction saved for user {user_id}")

        except Exception as e:
            logger.error(f"Save prediction failed: {e}")


prediction_service = PredictionService()
