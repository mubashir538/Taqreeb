from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny,IsAuthenticated
from rest_framework.response import Response
from myapp.firebase_db import db
from ..models.user_models import User,FCMTokens,NotificationLog
from ..models.business_models import BusinessOwner,Freelancer
import bcrypt

@api_view(['GET'])
@permission_classes([AllowAny])
def delete_table(request):
    # Get all users except those with IDs 16, 17, 27, 30, 31
    users_to_update = User.objects.exclude(id__in=[16, 17, 27, 30, 31])
    
    for user in users_to_update:
        if user.password:  # Only process if password exists
            # Skip if password is already hashed (optional check)
            if not user.password.startswith('bcrypt$'):
                salt = bcrypt.gensalt()
                hashed = bcrypt.hashpw(user.password.encode(), salt)
                user.password = hashed.decode()
                user.save()
    
    return Response({'status': 'success', 'message': 'Passwords updated successfully'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ownerToUser(request,oid,type):
    if type == 'freelancer':
        user = Freelancer.objects.get(id=oid)
    else:
        user = BusinessOwner.objects.get(id=oid)

        return Response({'status':'success','id':user.userID.id})
    

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    return Response({'status': 'ok'}, status=200)
