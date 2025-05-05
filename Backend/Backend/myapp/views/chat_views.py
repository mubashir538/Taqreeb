import os
from rest_framework.decorators import api_view, permission_classes
from firebase_admin import credentials, firestore, initialize_app
from .. import models as m
import random as rd
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.core.files.storage import FileSystemStorage

cred = credentials.Certificate(os.getenv('firebase_PATH'))
firebase_app = initialize_app(cred)
db = firestore.client()

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def saveChatImage(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filePath = filestorage.save(f'chats/{userid}/{rd.randint(1,1000)}.png', image)
    fileUrl = filestorage.url(filePath)
    return Response({'status':'success','path':fileUrl})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def saveGroupImage(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filePath = filestorage.save(f'groups/chats/{userid}/{rd.randint(1,1000)}.png', image)
    fileUrl = filestorage.url(filePath)
    return Response({'status':'success','path':fileUrl})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getUserInfoChat(request,id):
    user = m.User.objects.get(id=id)
    return Response({'status':'success','name':user.firstName,'profilePicture':user.profilePicture})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def saveGroupProfile(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filePath = filestorage.save(f'groups/profile/{userid}/{rd.randint(1,1000)}.png', image)
    fileUrl = filestorage.url(filePath)
    return Response({'status':'success','path':fileUrl})
