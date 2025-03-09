from .. import models as md
import random as rd
from rest_framework.decorators import api_view, permission_classes
from django.core.files.storage import FileSystemStorage
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response


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
    user = md.User.objects.get(id=id)
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
