
import json
import os
from django.http import JsonResponse
from firebase_admin import credentials, firestore, initialize_app,messaging

cred = credentials.Certificate(os.getenv('firebase_PATH'))
firebase_app = initialize_app(cred)
db = firestore.client()


def send_notification(token, title, body):
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body),
        token=token,
    )
    response = messaging.send(message)
    print("Notification sent:", response)

def new_message(request):
    data = json.loads(request.body)
    receiver_token = get_user_fcm_token(data["receiver_id"])  # Fetch token from DB
    send_notification(receiver_token, "New Message", "You have a new chat message")
    return JsonResponse({"success": True})