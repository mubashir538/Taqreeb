import os
from django.conf import settings
from rest_framework.decorators import api_view, permission_classes
from firebase_admin import credentials, firestore, initialize_app
from .. import models as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated

cred = credentials.Certificate(os.getenv('firebase_PATH'))
firebase_app = initialize_app(cred)
db = firestore.client()

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