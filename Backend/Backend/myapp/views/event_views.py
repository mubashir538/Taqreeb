from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from ..models.event_models import Events,Functions
from ..Serializers.event_serializers import EventsSerializer,FunctionsSerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def youreventsandfunctions(request,id):
    yourevent = Events.objects.filter(userID=id)
    serializer = EventsSerializer(yourevent,many=True)
    for event in serializer.data:
        functions = Functions.objects.filter(eventId=event['id'])
        event['functions'] = FunctionsSerializer(functions,many=True).data
    return Response({'status':'success','Event':serializer.data})
