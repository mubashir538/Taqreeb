from .. import models2 as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_guests(request):
    guesttype = request.data.get('guesttype')
    eid = request.data.get('eid')
    event = m.Events.objects.get(id=eid)
    if request.data.get('fid') != 'None':
        fid = request.data.get('fid')
        function = m.Functions.objects.get(id=fid)
    else:
        fid = None
    if guesttype=='Family':
        family_name = request.data.get('FamilyName')
        member = request.data.get('member')
        if fid:
            guest_list = m.GuestList(name=family_name,members=member,type=guesttype,eventId=event,functionId=function)
        else:
            guest_list = m.GuestList(name=family_name,members=member,type=guesttype,eventId=event)
    else:   
        person_name = request.data.get('PersonName')
        person_contact = request.data.get('PersonContact')
        if fid:
            guest_list = m.GuestList(name=person_name,phone=person_contact,type=guesttype,eventId=event,functionId=function)
        else:
            guest_list = m.GuestList(name=person_name,phone=person_contact,type=guesttype,eventId=event)
    guest_list.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def show_guest(request):
    eventid = request.data.get('EventId')
    event = m.Events.objects.get(id=eventid)
    if request.data.get('FunctionID') == 'None':
        functionid = None
        guests = m.GuestList.objects.filter(eventId=event,functionId__isnull=True)
    else:
        functionid= request.data.get('FunctionID')
        guests = m.GuestList.objects.filter(eventId=event,functionId=functionid)
    guest_list_serializer = s.GuestListSerializer(guests,many=True)
    return Response({'status': 'success', 'Guests':guest_list_serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_guest(request):
    guestid = request.data.get('guestId')
    m.GuestList.objects.get(id=guestid).delete()
    return Response({'status': 'success'})