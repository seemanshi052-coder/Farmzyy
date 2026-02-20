from fastapi import APIRouter
from app.services.weather_service import WeatherService

router = APIRouter()

@router.get("/weather")
def get_weather(location: str):

    data = WeatherService.get_weather(location)

    return {
        "success": True,
        "data": data
    }
