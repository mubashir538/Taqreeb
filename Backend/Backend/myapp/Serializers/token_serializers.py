import datetime
import json
from ..Models.user_models import User
from rest_framework import serializers as s
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.exceptions import AuthenticationFailed
from django.core.exceptions import ValidationError
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)

        # Add custom fields to the token
        token['user_id'] = user.id
        token['email'] = user.email
        token['first_name'] = user.firstName
        token['last_name'] = user.lastName

        return token
    
class CustomJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        user_id = validated_token.get('user_id')
        if user_id is None:
            raise AuthenticationFailed('Token payload missing "user_id".')
        try:
            return User.objects.get(id=user_id)
        except User.DoesNotExist:
            raise AuthenticationFailed('User not found')