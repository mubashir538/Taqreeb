from ..models import user_models as m
from rest_framework import serializers as s

class UserSerializer(s.ModelSerializer):
    class Meta:
        model = m.User
        fields = '__all__'

