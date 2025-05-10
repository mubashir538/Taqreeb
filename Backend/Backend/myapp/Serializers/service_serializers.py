from ..models import listing_types_models as m
from ..models import listing_models as lm
from rest_framework import serializers as s

class VenueSerializer(s.ModelSerializer):
    class Meta:
        model = m.Venue
        fields = '__all__'

class AddOnsSerializer(s.ModelSerializer):
    class Meta:
        model = lm.AddOns
        fields = '__all__'

class CaterersSerializer(s.ModelSerializer):
    class Meta:
        model = m.Caterers
        fields = '__all__'

class PhotographersSerializer(s.ModelSerializer):
    class Meta:
        model = m.Photographers
        fields = '__all__'


class CarRentersSerializer(s.ModelSerializer):
    class Meta:
        model = m.CarRenters
        fields = '__all__'

class DecoratorsSerializer(s.ModelSerializer):
    class Meta:
        model = m.Decorators
        fields = '__all__'

class PhotographyPlacesSerializer(s.ModelSerializer):
    class Meta:
        model = m.PhotographyPlaces
        fields = '__all__'

class ParlorsSerializer(s.ModelSerializer):
    class Meta:
        model = m.Parlors
        fields = '__all__'


class SalonsSerializer(s.ModelSerializer):
    class Meta:
        model = m.Salons
        fields = '__all__'

class VideoEditorsSerializer(s.ModelSerializer):
    class Meta:
        model = m.VideoEditors
        fields = '__all__'

class GraphicDesignersSerializer(s.ModelSerializer):
    class Meta:
        model = m.GraphicDesigners
        fields = '__all__'