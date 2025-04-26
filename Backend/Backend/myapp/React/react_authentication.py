from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .react_models import ReactUser
from rest_framework.exceptions import AuthenticationFailed

class ReactJWTAuthentication(JWTAuthentication):
    def get_user(self, validated_token):
        try:
            print(validated_token.get('user_id'))
            print(validated_token.get('email'))
            user_id = validated_token.get('user_id')
            email = validated_token.get('email')
            
            if not user_id:
                raise AuthenticationFailed('Token missing user_id', code='invalid_token')

            # Get user and verify type
            user = ReactUser.objects.get(id=user_id)
            
            # Additional consistency checks
            if user.email != email:
                raise AuthenticationFailed('Token email mismatch', code='invalid_token')
                
            return user
            
        except ReactUser.DoesNotExist:
            # More detailed error message
            from django.contrib.auth import get_user_model
            User = get_user_model()
            
            if User.objects.filter(id=user_id).exists():
                raise AuthenticationFailed(
                    'User exists but is not a ReactUser. '
                    'Please login through the correct endpoint.',
                    code='wrong_user_type'
                )
            raise AuthenticationFailed(
                f'ReactUser with ID {user_id} not found', 
                code='user_not_found'
            )
        except Exception as e:
            raise AuthenticationFailed(str(e), code='authentication_error')
        
class ReactTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        if not isinstance(user, ReactUser):
            raise ValueError('This token endpoint is only for ReactUsers')
            
        token = super().get_token(user)
        # Add essential claims
        token['user_id'] = user.id
        token['email'] = user.email
        token['name'] = user.name
        token['username'] = user.username
        token['token_type'] = 'react_access'  # Add type identifier
        return token

    def validate(self, attrs):
        data = super().validate(attrs)
        refresh = self.get_token(self.user)
        
        # Add token type to response
        data['token_type'] = 'react'
        return data