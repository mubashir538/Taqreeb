from .react_models import ReactUser
from rest_framework import serializers

class ReactUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReactUser
        fields = ['id', 'name', 'email', 'username', 'profilePicturePath']
        read_only_fields = ['id']

class ReactUserCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReactUser
        fields = ['id', 'name', 'email', 'username', 'password', 'profilePicturePath']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        user = ReactUser.objects.create_user(
            id=validated_data.get('id'),
            name=validated_data['name'],
            email=validated_data['email'],
            username=validated_data['username'],
            password=validated_data['password'],
            profilePicturePath=validated_data.get('profilePicturePath', '')
        )
        return user