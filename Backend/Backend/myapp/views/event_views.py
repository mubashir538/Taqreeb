from .. import models2 as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def YourEventsandFunctions(request,id):
    YourEvent = m.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer(YourEvent,many=True)
    for event in serializer.data:
        functions = m.Functions.objects.filter(eventId=event['id'])
        event['functions'] = s.FunctionsSerializer(functions,many=True).data
    return Response({'status':'success','Event':serializer.data})
