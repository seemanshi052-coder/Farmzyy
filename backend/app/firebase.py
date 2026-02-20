import firebase_admin
from firebase_admin import credentials, auth, firestore
import json
from app.core.config import settings

cred_dict = json.loads(settings.FIREBASE_CREDENTIALS)
cred = credentials.Certificate(cred_dict)

firebase_app = firebase_admin.initialize_app(cred)

db = firestore.client()
