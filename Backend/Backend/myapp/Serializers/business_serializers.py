class BusinessOwnerSerializer(s.ModelSerializer):
    class Meta:
        model = m.BusinessOwner
        fields = '__all__'

class FreelancerSerializer(s.ModelSerializer):
    class Meta:
        model = m.Freelancer
        fields = '__all__'