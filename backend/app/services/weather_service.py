import requests


class WeatherService:

    @staticmethod
    def get_weather(location: str):
        try:
            # Step 1: Get latitude & longitude from location name
            geo_url = f"https://geocoding-api.open-meteo.com/v1/search?name={location}&count=1"
            geo_res = requests.get(geo_url).json()

            if "results" not in geo_res:
                raise Exception("Location not found")

            lat = geo_res["results"][0]["latitude"]
            lon = geo_res["results"][0]["longitude"]

            # Step 2: Get weather data
            weather_url = (
                f"https://api.open-meteo.com/v1/forecast"
                f"?latitude={lat}&longitude={lon}"
                f"&current=temperature_2m,relative_humidity_2m,precipitation"
            )

            weather_res = requests.get(weather_url).json()

            current = weather_res["current"]

            return {
                "temperature": current["temperature_2m"],
                "humidity": current["relative_humidity_2m"],
                "rainfall": current["precipitation"]
            }

        except Exception:
            # fallback values if API fails
            return {
                "temperature": 25,
                "humidity": 60,
                "rainfall": 10
            }
