from datetime import datetime
from typing import Dict

from app.core.firebase import firebase_client
from app.core.logger import logger
from app.services.llm_service import llm_service


class ChatService:

    def __init__(self):
        self.db = firebase_client.db

    def chat(self, user_id: str, message: str) -> Dict:

        logger.info(f"Chat request from user {user_id}")

        try:

            ai_response = llm_service.generate_response(message)

            doc = {
                "user_id": user_id,
                "user_message": message,
                "bot_response": ai_response,
                "timestamp": datetime.utcnow(),
            }

            self.db.collection("chat_history").add(doc)

            return {
                "reply": ai_response
            }

        except Exception as e:
            logger.error(f"Chat failed: {e}")
            raise


chat_service = ChatService()
