from ..models.misc_models import HomePageImages
from ..models.event_models import FunctionType
from ..Serializers.misc_serializers import HomePageImagesSerializer,FunctionTypeSerializer
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_home_images(request):
    images = HomePageImages.objects.all()
    serializer = HomePageImagesSerializer(images,many=True)
    return Response({'status':'success','images':serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_function_type(request,id):
    function_types = FunctionType.objects.filter(eventtypeid=id)
    serializer = FunctionTypeSerializer(function_types,many=True)
    return Response({'status':'success','functionTypes':serializer.data})

