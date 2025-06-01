from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny,IsAuthenticated
from rest_framework.response import Response
from myapp.firebase_db import db
from ..models.user_models import User,FCMTokens,NotificationLog
from ..models.business_models import BusinessOwner,Freelancer

@api_view(['GET'])
@permission_classes([AllowAny])
def delete_table(request):
    FCMTokens.objects.all().delete()
    NotificationLog.objects.all().delete()
    return Response({'status': 'success'})


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
