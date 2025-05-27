
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from firebase_admin import messaging,exceptions
from django.utils import timezone
from datetime import timedelta
from ..models.user_models import User,FCMTokens,NotificationLog


# def send_notification(token, title, body,image):
#     print(token)
#     print(title)
#     message = messaging.Message(
#         notification=messaging.Notification(title=title, body=body,image=image),
#         token=token,
#     )
#     response = messaging.send(message)
#     print("Notification sent:", response)

# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def send_notification(request):
#     try:
#         receiver_id = request.data.get('recv')
#         sender_id = request.data.get('send')
#         message = request.data.get('message')
        
#         if not all([receiver_id, sender_id, message]):
#             return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)
        
#         try:
#             sender = User.objects.get(id=sender_id)
#             sender_name = f"{sender.firstName} {sender.lastName}".strip()
#         except User.DoesNotExist:
#             return Response({'status': 'error', 'message': 'Sender not found'}, status=404)
        
#         receiver_tokens = FCMTokens.objects.filter(userid=receiver_id)
#         if not receiver_tokens.exists():
#             return Response({'status': 'success', 'message': 'No tokens found for receiver'})
        
#         success_count = 0
#         for token in receiver_tokens:
#             try:
#                 if not token.token or len(token.token) < 50: 
#                     continue
                    
#                 notification = messaging.Notification(
#                     title=sender_name,
#                     body=message,
#                     image=sender.profilePicture if sender.profilePicture else None
#                 )
                
#                 message = messaging.Message(
#                     notification=notification,
#                     token=token.token,
#                     data={
#                         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
#                         'type': 'message',
#                         'senderId': str(sender_id),
#                         'receiverId': str(receiver_id)
#                     }
#                 )
                
#                 response = messaging.send(message)
#                 success_count += 1
#                 print(f"Notification sent to {token.token}: {response}")
                
#             except Exception as e:
#                 print(f"Failed to send notification to {token.token}: {str(e)}")
        
#         return Response({
#             'status': 'success',
#             'sent_count': success_count,
#             'total_tokens': receiver_tokens.count()
#         })
        
#     except Exception as e:
#         print(f"Error in send_notification: {str(e)}")
#         return Response({'status': 'error', 'message': str(e)}, status=500)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def send_notification(request):
    try:
        receiver_id = request.data.get('recv')
        sender_id = request.data.get('send')
        message = request.data.get('message', '').strip()
        
        # Validate input
        if not receiver_id or not sender_id:
            return Response({'status': 'error', 'message': 'Missing receiver or sender ID'}, status=400)
            
        if not message or len(message) > 1000:
            return Response({'status': 'error', 'message': 'Invalid message'}, status=400)
        
        try:
            sender = User.objects.get(id=sender_id)
            sender_name = f"{sender.firstName} {sender.lastName}".strip()
        except User.DoesNotExist:
            return Response({'status': 'error', 'message': 'Sender not found'}, status=404)
        
        # Get valid tokens
        receiver_tokens = FCMTokens.objects.filter(
            userid=receiver_id,
            token__isnull=False
        ).exclude(token='').values_list('token', flat=True)
        
        if not receiver_tokens:
            return Response({'status': 'success', 'message': 'No valid tokens found for receiver'})
        
        # Prepare notification
        notification = messaging.Notification(
            title=sender_name,
            body=message,
            image=sender.profilePicture if sender.profilePicture else None
        )
        
        # Create message
        message_obj = messaging.MulticastMessage(
            notification=notification,
            tokens=list(receiver_tokens),
            data={
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'type': 'message',
                'senderId': str(sender_id),
                'receiverId': str(receiver_id),
                'message': message
            }
        )
        
        # Log before sending
        notification_log = NotificationLog.objects.create(
            sender=sender,
            receiver_id=receiver_id,
            message=message,
            status='pending'
        )
        
        try:
            # Send multicast message (more efficient for multiple tokens)
            response = messaging.send_multicast(message_obj)
            
            # Update log
            notification_log.status = 'sent'
            notification_log.save()
            
            # Handle failed tokens
            if response.failure_count > 0:
                for idx, resp in enumerate(response.responses):
                    if not resp.success:
                        token = receiver_tokens[idx]
                        print(f"Failed to send to token {token}: {resp.exception}")
                        
                        # Optionally remove invalid tokens
                        if isinstance(resp.exception, exceptions.InvalidArgumentError):
                            FCMTokens.objects.filter(token=token).delete()
            
            return Response({
                'status': 'success',
                'sent_count': response.success_count,
                'failure_count': response.failure_count,
                'total_tokens': len(receiver_tokens)
            })
            
        except Exception as e:
            notification_log.status = 'failed'
            notification_log.error_message = str(e)
            notification_log.save()
            
            print(f"Error sending notification: {str(e)}")
            return Response({'status': 'error', 'message': str(e)}, status=500)
        
    except Exception as e:
        print(f"Error in send_notification: {str(e)}")
        return Response({'status': 'error', 'message': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_fcm_token(request):
    token = request.data.get('token')
    userid = request.data.get('userId')
    userid = User.objects.get(id=userid)
    FCMTokens(userid=userid,token=token).save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_fcm_token(request):
    token = request.data.get('token')
    FCMTokens.objects.filter(token=token).delete()
    return Response({'status':'success'})

def cleanup_invalid_tokens():
    # Remove tokens that have consistently failed
    invalid_tokens = NotificationLog.objects.filter(
        status='failed',
        sent_at__lt=timezone.now() - timedelta(days=7)
    ).values_list('tokens', flat=True).distinct()
    
    FCMTokens.objects.filter(token__in=invalid_tokens).delete()