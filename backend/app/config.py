import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "FarmZyy"
    API_V1_STR: str = "/api/v1"

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    WEATHER_API_KEY = os.getenv("WEATHER_API_KEY")
    MARKET_API_KEY = os.getenv("MARKET_API_KEY")

    FIREBASE_CREDENTIALS = os.getenv("FIREBASE_CREDENTIALS")

settings = Settings()
