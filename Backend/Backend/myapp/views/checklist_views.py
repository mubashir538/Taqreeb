from rest_framework.decorators import api_view, permission_classes
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.event_models import CheckList,Functions,Events
from ..Serializers.event_serializers import CheckListSerializer


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def showchecklist(request,functionid=None,eventid=None):
    if functionid:
        function = Functions.objects.get(id=functionid)
        event = Events.objects.get(id=eventid)
        checklist = CheckList.objects.filter(functionId=function,eventId=event)
    else:
        event = Events.objects.get(id=eventid)
        checklist = CheckList.objects.filter(eventId=event,functionId__isnull=True)
    serializer = CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

