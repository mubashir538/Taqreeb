from .. import models as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getHomeImages(request):
    images = m.HomePageImages.objects.all()
    serializer = s.HomePageImagesSerializer(images,many=True)
    return Response({'status':'success','images':serializer.data})
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getFunctionType(request,id):
    functionTypes = m.FunctionType.objects.filter(eventtypeid=id)
    serializer = s.FunctionTypeSerializer(functionTypes,many=True)
    return Response({'status':'success','functionTypes':serializer.data})

