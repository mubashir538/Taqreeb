from rest_framework import serializers as s
from .. import models as m

class EventTypeSerializer(s.ModelSerializer):
    class Meta:
        model = m.EventType
        fields = '__all__'


class FunctionTypeSerializer(s.ModelSerializer):
    class Meta:
        model = m.FunctionType
        fields = '__all__'

class CategoriesSerializer(s.ModelSerializer):
    class Meta:
        model = m.Categories
        fields = '__all__'

class HomePageImagesSerializer(s.ModelSerializer):
    class Meta:
        model = m.HomePageImages
        fields = '__all__'