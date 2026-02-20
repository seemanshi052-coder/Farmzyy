import os
from dotenv import load_dotenv

import firebase_admin
from firebase_admin import credentials, firestore, auth

from app.core.logger import logger


# IMPORTANT — load .env here also
load_dotenv()


class FirebaseClient:

    def __init__(self):

        if not firebase_admin._apps:

            cred_path = os.getenv("FIREBASE_CREDENTIALS")

            if not cred_path:
                raise Exception("FIREBASE_CREDENTIALS env variable not set")

            logger.info(f"Loading Firebase credentials from: {cred_path}")

            cred = credentials.Certificate(cred_path)

            firebase_admin.initialize_app(cred)

        self.db = firestore.client()

    # =========================
    # TOKEN VERIFICATION
    # =========================

    def verify_token(self, token: str):

        try:
            decoded_token = auth.verify_id_token(token)
            return decoded_token

        except Exception as e:
            logger.error(f"Token verification failed: {e}")
            raise Exception("Invalid token")


firebase_client = FirebaseClient()
