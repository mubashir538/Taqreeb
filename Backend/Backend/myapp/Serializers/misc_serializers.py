from rest_framework import serializers as s
from ..models import event_models as m
from ..models import listing_models as lm
from ..models import misc_models as mm


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
        model = lm.Categories
        fields = '__all__'

class HomePageImagesSerializer(s.ModelSerializer):
    class Meta:
        model = mm.HomePageImages
        fields = '__all__'