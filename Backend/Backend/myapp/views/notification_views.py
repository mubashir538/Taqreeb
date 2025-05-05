
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from .. import models as m
from firebase_admin import messaging

def send_notification(token, title, body,image):
    print(token)
    print(title)
    message = messaging.Message(
        notification=messaging.Notification(title=title, body=body,image=image),
        token=token,
    )
    response = messaging.send(message)
    print("Notification sent:", response)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def send_notification(request):
    try:
        receiver_id = request.data.get('recv')
        sender_id = request.data.get('send')
        message = request.data.get('message')
        
        if not all([receiver_id, sender_id, message]):
            return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)
        
        try:
            sender = m.User.objects.get(id=sender_id)
            sender_name = f"{sender.firstName} {sender.lastName}".strip()
        except m.User.DoesNotExist:
            return Response({'status': 'error', 'message': 'Sender not found'}, status=404)
        
        receiver_tokens = m.FCMTokens.objects.filter(userid=receiver_id)
        if not receiver_tokens.exists():
            return Response({'status': 'success', 'message': 'No tokens found for receiver'})
        
        success_count = 0
        for token in receiver_tokens:
            try:
                if not token.token or len(token.token) < 50: 
                    continue
                    
                notification = messaging.Notification(
                    title=sender_name,
                    body=message,
                    image=sender.profilePicture if sender.profilePicture else None
                )
                
                message = messaging.Message(
                    notification=notification,
                    token=token.token,
                    data={
                        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                        'type': 'message',
                        'senderId': str(sender_id),
                        'receiverId': str(receiver_id)
                    }
                )
                
                response = messaging.send(message)
                success_count += 1
                print(f"Notification sent to {token.token}: {response}")
                
            except Exception as e:
                print(f"Failed to send notification to {token.token}: {str(e)}")
        
        return Response({
            'status': 'success',
            'sent_count': success_count,
            'total_tokens': receiver_tokens.count()
        })
        
    except Exception as e:
        print(f"Error in send_notification: {str(e)}")
        return Response({'status': 'error', 'message': str(e)}, status=500)

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