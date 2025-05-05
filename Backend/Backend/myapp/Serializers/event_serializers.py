class EventsSerializer(s.ModelSerializer):
    class Meta:
        model = m.Events
        fields = '__all__'

class FunctionsSerializer(s.ModelSerializer):
    class Meta:
        model = m.Functions
        fields = '__all__'

class GuestListSerializer(s.ModelSerializer):
    class Meta:
        model = m.GuestList
        fields = '__all__'


class CheckListSerializer(s.ModelSerializer):
    class Meta:
        model = m.CheckList
        fields = '__all__'