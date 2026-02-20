import os
from openai import OpenAI

from app.core.logger import logger


class LLMService:

    def __init__(self):

        api_key = os.getenv("OPENAI_API_KEY")

        if not api_key:
            raise Exception("OPENAI_API_KEY not set")

        self.client = OpenAI(api_key=api_key)

    def generate_response(self, message: str) -> str:

        try:

            response = self.client.chat.completions.create(
                model="gpt-4.1-mini",
                messages=[
                    {
                        "role": "system",
                        "content": "You are an agricultural expert assistant helping farmers."
                    },
                    {
                        "role": "user",
                        "content": message
                    }
                ]
            )

            return response.choices[0].message.content

        except Exception as e:
            logger.error(f"LLM error: {e}")
            raise


llm_service = LLMService()
