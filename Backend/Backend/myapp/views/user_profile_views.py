import os
from rest_framework.response import Response
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from .. import Serializers as s
from myapp.models import UserActivity
from django.utils.timezone import now
from rest_framework.permissions import IsAuthenticated
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from firebase_admin import credentials, firestore, initialize_app

cred = credentials.Certificate(os.getenv('firebase_PATH'))
print(cred)
firebase_app = initialize_app(cred)
db = firestore.client()


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def AccountInfoPage(request,id):
    userid = id
    user = m.User.objects.filter(id=userid).first()
    serializer = s.UserSerializer(user)
    UserActivity.objects.create(
        user=user,
        action='profile_updated',
        metadata={
            'firstName': user.firstName,
            'lastName': user.lastName,
            'city': user.city,
            'gender': user.gender,
        },
        timestamp=now()
    )
    
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_basic_userinfo(request,id):
    userid = id
    user = m.User.objects.filter(id=userid).first()
    return Response({'name':f'{user.firstName.capitalize()} {user.lastName.capitalize()}','profilePicture':user.profilePicture})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def EditAccountInfoPage(request):
    userid = request.data.get('userid')
    firstName = request.data.get('firstName')
    profilePicture = request.data.get('profilePicture')
    gender = request.data.get('gender')
    city = request.data.get('city')
    lastname = request.data.get('lastName')
    user = m.User.objects.get(id=userid)
    user.firstName = firstName
    user.lastName = lastname
    user.gender = gender
    user.city = city
    if profilePicture:
        relative_path = user.profilePicture.replace('/media/', '', 1) 
        full_path = os.path.join(settings.MEDIA_ROOT, relative_path)
        full_path = full_path.replace('\\', '/')
        if os.path.exists(full_path):
            os.remove(full_path)
        filestorage = FileSystemStorage()
        filePath = filestorage.save(f'uploads/users/profilePicture/{user.id}.png', profilePicture)
        user.profilePicture = filestorage.url(filePath)   
        user.save(update_fields=["profilePicture",'firstName','lastName','gender','city'])
    else:
        user.save(update_fields=['firstName','lastName','gender','city'])
    user = m.User.objects.get(id=userid)
    UserActivity.objects.create(
    user=user,
    action='profile_update',
    metadata={
        'firstName': user.firstName,
        'lastName': user.lastName,
        'gender': user.gender,
        'city': user.city
    },
    timestamp=now()
)

    firebase_user_data = {
        "firstName": user.firstName,
        "lastName": user.lastName,
        "username": user.username,
        "age":user.age,
        "email": user.email,
        "contactNumber": user.contactNumber,
        "city": user.city,
        "gender": user.gender,
        "profilePicture": user.profilePicture if user.profilePicture else None,
    }
    try:
        db.collection("users").document(str(user.id)).set(firebase_user_data)
    except Exception as e:
        return Response({'status': 'error', 'message': f'Failed to store user data in Firebase: {str(e)}'})

    
    return Response({'status':'success'})
