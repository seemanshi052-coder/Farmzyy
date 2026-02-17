import os
from dotenv import load_dotenv

load_dotenv()

def get_env_variable(name: str, required: bool = True):
    value = os.getenv(name)
    if required and not value:
        raise RuntimeError(f"Missing required environment variable: {name}")
    return value


class Settings:
    OPENAI_API_KEY = get_env_variable("OPENAI_API_KEY")
    WEATHER_API_KEY = get_env_variable("WEATHER_API_KEY")
    MARKET_API_KEY = get_env_variable("MARKET_API_KEY")
    JWT_SECRET = get_env_variable("JWT_SECRET")

    FIREBASE_PROJECT_ID = get_env_variable("FIREBASE_PROJECT_ID")
    FIREBASE_PRIVATE_KEY = get_env_variable("FIREBASE_PRIVATE_KEY")
    FIREBASE_CLIENT_EMAIL = get_env_variable("FIREBASE_CLIENT_EMAIL")

    DATABASE_URL = get_env_variable("DATABASE_URL", required=False)

    ENVIRONMENT = os.getenv("ENVIRONMENT", "production")


settings = Settings()
