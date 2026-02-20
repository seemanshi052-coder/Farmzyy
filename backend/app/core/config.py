import os
from dotenv import load_dotenv

# Load .env file
load_dotenv()


class Settings:

    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

    FIREBASE_CREDENTIALS = os.getenv("FIREBASE_CREDENTIALS")

    MARKET_API_URL = os.getenv("MARKET_API_URL")
    MARKET_API_KEY = os.getenv("MARKET_API_KEY")

    ENVIRONMENT = os.getenv("ENVIRONMENT", "development")


settings = Settings()
