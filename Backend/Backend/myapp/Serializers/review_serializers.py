class ReviewSerializer(s.ModelSerializer):
    class Meta:
        model = m.Review
        fields = '__all__'

class ReviewDetailsSerializer(s.ModelSerializer):
    class Meta:
        model = m.ReviewDetails
        fields = '__all__'
