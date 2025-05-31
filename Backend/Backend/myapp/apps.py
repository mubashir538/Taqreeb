from django.apps import AppConfig
from firebase_admin import credentials, firestore, initialize_app, messaging
import firebase_admin
import os

class MyappConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'myapp'

    def ready(self):
        if not firebase_admin._apps:
            cred = credentials.Certificate(os.getenv('firebase_PATH'))
            firebase_app = initialize_app(cred)
            from myapp import firebase_db
            firebase_db.db = firestore.client()
        from .Chatbot.chatbot import EventBookingChatbot
        from .chatbotConfig import chatbot
        chatbot = EventBookingChatbot()