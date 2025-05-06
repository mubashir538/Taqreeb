from rest_framework.decorators import api_view, permission_classes
from .. import models as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_categories(request):
    categories = m.Categories.objects.all()
    categories_serializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': categories_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def business_categories(request,type):
    if type == 'freelancer':
        categories = m.Categories.objects.filter(type='freelancer')
    else:
        categories = m.Categories.objects.filter(type='business')
    categories_serializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': categories_serializer.data})