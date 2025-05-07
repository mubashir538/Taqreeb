from ..models import review_models as m
from rest_framework import serializers as s


class ReviewSerializer(s.ModelSerializer):
    class Meta:
        model = m.Review
        fields = '__all__'

class ReviewDetailsSerializer(s.ModelSerializer):
    class Meta:
        model = m.ReviewDetails
        fields = '__all__'
