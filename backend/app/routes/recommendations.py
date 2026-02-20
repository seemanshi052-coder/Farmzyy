from fastapi import APIRouter
from app.services.ml_service import MLService
from app.services.weather_service import WeatherService

router = APIRouter()

@router.post("/crop/recommend")
def crop_recommend(req: dict):

    weather = WeatherService.get_weather(req["location"])

    data = {
        **req,
        **weather
    }

    prediction, confidence = MLService.predict_crop(data)

    return {
        "success": True,
        "data": {
            "prediction": prediction,
            "confidence_score": confidence
        }
    }
