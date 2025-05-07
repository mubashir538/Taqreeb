from .. import models2 as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def AddGuests(request):
    guesttype = request.data.get('guesttype')
    eid = request.data.get('eid')
    event = m.Events.objects.get(id=eid)
    if request.data.get('fid') != 'None':
        fid = request.data.get('fid')
        function = m.Functions.objects.get(id=fid)
    else:
        fid = None
    if guesttype=='Family':
        FamilyName = request.data.get('FamilyName')
        member = request.data.get('member')
        if fid:
            GuestList = m.GuestList(name=FamilyName,members=member,type=guesttype,eventId=event,functionId=function)
        else:
            GuestList = m.GuestList(name=FamilyName,members=member,type=guesttype,eventId=event)
    else:   
        PersonName = request.data.get('PersonName')
        PersonContact = request.data.get('PersonContact')
        if fid:
            GuestList = m.GuestList(name=PersonName,phone=PersonContact,type=guesttype,eventId=event,functionId=function)
        else:
            GuestList = m.GuestList(name=PersonName,phone=PersonContact,type=guesttype,eventId=event)
    GuestList.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def ShowGuest(request):
    EventId = request.data.get('EventId')
    event = m.Events.objects.get(id=EventId)
    if request.data.get('FunctionID') == 'None':
        functionid = None
        Guests = m.GuestList.objects.filter(eventId=event,functionId__isnull=True)
    else:
        functionid= request.data.get('FunctionID')
        Guests = m.GuestList.objects.filter(eventId=event,functionId=functionid)
    GuestListSerializer = s.GuestListSerializer(Guests,many=True)
    return Response({'status': 'success', 'Guests':GuestListSerializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def DeleteGuest(request):
    guestId = request.data.get('guestId')
    guest = m.GuestList.objects.get(id=guestId).delete()
    return Response({'status': 'success'})