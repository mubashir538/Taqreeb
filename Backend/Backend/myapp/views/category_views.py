from rest_framework.decorators import api_view, permission_classes
from .. import models2 as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def HomeCategories(request):
    categories = m.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def BusinessCategories(request,type):
    if type == 'freelancer':
        categories = m.Categories.objects.filter(type='freelancer')
    else:
        categories = m.Categories.objects.filter(type='business')
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})