from rest_framework.decorators import api_view, permission_classes
from .. import models2 as m
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .. import Serializers as s

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def showchecklist(request,functionid=None,eventid=None):
    if request.GET.get('functionId'):
        checklist = m.CheckList.objects.filter(functionId=functionid,eventId=eventid)
    else:
        checklist = m.CheckList.objects.filter(eventId=eventid,functionId__isnull=True)
    serializer = s.CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

