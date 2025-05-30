
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from firebase_admin import messaging,exceptions
from django.utils import timezone
from datetime import timedelta
from ..models.user_models import User,FCMTokens,NotificationLog

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def send_notification(request):
    try:
        receiver_id = request.data.get('recv')
        sender_id = request.data.get('send')
        message = request.data.get('message', '').strip()
        
        if not receiver_id or not sender_id:
            return Response({'status': 'error', 'message': 'Missing receiver or sender ID'}, status=400)
            
        if not message or len(message) > 1000:
            return Response({'status': 'error', 'message': 'Invalid message'}, status=400)
        
        try:
            sender = User.objects.get(id=sender_id)
            sender_name = f"{sender.firstName} {sender.lastName}".strip()
        except User.DoesNotExist:
            return Response({'status': 'error', 'message': 'Sender not found'}, status=404)
        
        receiver_tokens = FCMTokens.objects.filter(
            userid=receiver_id,
            token__isnull=False
        ).exclude(token='').values_list('token', flat=True)
        
        if not receiver_tokens:
            return Response({'status': 'success', 'message': 'No valid tokens found for receiver'})
        
        notification = messaging.Notification(
            title=sender_name,
            body=message,
            image=sender.profilePicture if sender.profilePicture else None
        )
        
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
        
        notification_log = NotificationLog.objects.create(
            sender=sender,
            receiver_id=receiver_id,
            message=message,
            status='pending'
        )
        
        try:
            response = messaging.send_multicast(message_obj)
            
            notification_log.status = 'sent'
            notification_log.save()
            
            if response.failure_count > 0:
                for idx, resp in enumerate(response.responses):
                    if not resp.success:
                        token = receiver_tokens[idx]
                        print(f"Failed to send to token {token}: {resp.exception}")
                        
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
    invalid_tokens = NotificationLog.objects.filter(
        status='failed',
        sent_at__lt=timezone.now() - timedelta(days=7)
    ).values_list('tokens', flat=True).distinct()
    
    FCMTokens.objects.filter(token__in=invalid_tokens).delete()