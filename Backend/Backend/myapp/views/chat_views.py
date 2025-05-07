from rest_framework.decorators import api_view, permission_classes
from .. import models as m
import random as rd
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.core.files.storage import FileSystemStorage


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def save_chat_image(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filepath = filestorage.save(f'chats/{userid}/{rd.randint(1,1000)}.png', image)
    fileurl = filestorage.url(filepath)
    return Response({'status':'success','path':fileurl})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def savegroupimage(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filepath = filestorage.save(f'groups/chats/{userid}/{rd.randint(1,1000)}.png', image)
    fileurl = filestorage.url(filepath)
    return Response({'status':'success','path':fileurl})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getuserinfochat(request,id):
    user = m.User.objects.get(id=id)
    return Response({'status':'success','name':user.firstName,'profilePicture':user.profilePicture})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def savegroupprofile(request):
    userid = request.data.get('userid')
    image = request.FILES.get('image')
    filestorage = FileSystemStorage()
    filepath = filestorage.save(f'groups/profile/{userid}/{rd.randint(1,1000)}.png', image)
    fileurl = filestorage.url(filepath)
    return Response({'status':'success','path':fileurl})
