from rest_framework.decorators import api_view, permission_classes
from ..models.listing_models import Categories
from ..Serializers.misc_serializers import CategoriesSerializer
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_categories(request):
    categories = Categories.objects.all()
    categories_serializer = CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': categories_serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def business_categories(request,type):
    if type == 'freelancer':
        categories = Categories.objects.filter(type='freelancer')
    else:
        categories = Categories.objects.filter(type='business')
    categories_serializer = CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': categories_serializer.data})