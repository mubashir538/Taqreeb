
import os
from .. import models as m
from django.http import JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from firebase_admin import messaging
from rest_framework.response import Response

def send_notification(token, title, body,image):
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body,image=image),
        token=token,
    )
    response = messaging.send(message)
    print("Notification sent:", response)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def new_message(request):
    receiverId = request.data.get('recv')
    senderId = request.data.get('send')
    message = request.data.get('message') 
    receiver_token = m.FCMTokens.objects.filter(userid=receiverId)
    user= m.User.objects.get(id=senderId)
    if receiver_token.exists():
        for token in receiver_token:
            send_notification(token.token, user.firstName+user.lastName, message,user.profilePicture)
    return Response({'status':'success'})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def saveFCMToken(request):
    token = request.data.get('token')
    userId = request.data.get('userId')
    userId = m.User.objects.get(id=userId)
    m.FCMTokens(userid=userId,token=token).save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def DeleteFCMToken(request):
    token = request.data.get('token')
    m.FCMTokens.objects.filter(token=token).delete()
    return Response({'status':'success'})