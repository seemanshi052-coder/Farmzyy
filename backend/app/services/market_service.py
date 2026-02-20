import requests
from typing import Dict

from app.core.config import settings
from app.core.logger import logger


class MarketService:

    def __init__(self):

        self.base_url = settings.MARKET_API_URL
        self.api_key = settings.MARKET_API_KEY

    def get_market_price(self, crop: str, state: str = None) -> Dict:

        try:

            params = {
                "api-key": self.api_key,
                "format": "json",
                "filters[commodity]": crop
            }

            if state:
                params["filters[state]"] = state

            response = requests.get(self.base_url, params=params, timeout=10)

            if response.status_code != 200:
                raise Exception("Market API failed")

            data = response.json()

            records = data.get("records", [])

            if not records:
                return {
                    "crop": crop,
                    "price": None,
                    "market": None
                }

            record = records[0]

            return {
                "crop": record.get("commodity"),
                "price": record.get("modal_price"),
                "market": record.get("market"),
                "state": record.get("state"),
            }

        except Exception as e:
            logger.error(f"Market service error: {e}")
            raise


market_service = MarketService()
