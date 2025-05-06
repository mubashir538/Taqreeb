class UserSerializer(s.ModelSerializer):
    class Meta:
        model = m.User
        fields = '__all__'

