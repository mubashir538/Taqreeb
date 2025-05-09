from rest_framework.decorators import api_view, permission_classes
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from ..models.event_models import CheckList
from ..Serializers.event_serializers import CheckListSerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def showchecklist(request,functionid=None,eventid=None):
    if request.GET.get('functionId'):
        checklist = CheckList.objects.filter(functionId=functionid,eventId=eventid)
    else:
        checklist = CheckList.objects.filter(eventId=eventid,functionId__isnull=True)
    serializer = CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

