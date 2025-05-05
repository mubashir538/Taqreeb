from rest_framework.decorators import api_view, permission_classes
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .. import Serializers as s

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ShowChecklist(request,functionId=None,eventId=None):
    if request.GET.get('functionId'):
        checklist = m.CheckList.objects.filter(functionId=functionId,eventId=eventId)
    else:
        checklist = m.CheckList.objects.filter(eventId=eventId,functionId__isnull=True)
    serializer = s.CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

