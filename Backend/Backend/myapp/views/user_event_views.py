from rest_framework.response import Response
from .. import models as m
from rest_framework.decorators import api_view, permission_classes
from .. import Serializers as s
from myapp.models import UserActivity
from django.utils.timezone import now
from rest_framework.permissions import IsAuthenticated, AllowAny


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_event_type(request):
    event_types = m.EventType.objects.all()
    serializer = s.EventTypeSerializer(event_types,many=True)
    return Response({'status':'success','eventTypes':serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def event_details(request,eventid):
    event_detail = m.Events.objects.get(id=eventid)
    serializer = s.EventsSerializer(event_detail,many=False)
    function = m.Functions.objects.filter(eventId=eventid)
    serializer2 = s.FunctionsSerializer(function,many=True)
    UserActivity.objects.create(
        user=request.user,
        action='event_view',
        metadata={
            'event_id': eventid,
            'event_name': event_detail.name,
            'event_type': event_detail.type
        },
        timestamp=now()
    )

    return Response({'status':'success','EventDetail':serializer.data,'Functions':serializer2.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def edit_event(request):
    name = request.data.get('Event Name')
    edit_event_type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('description')
    theme_color = request.data.get('Theme')
    budget = request.data.get('Budget')
    guestmin= request.data.get('guestmin')
    guestmax = request.data.get('guestmax')
    event_id = request.data.get('EventId')
    budget = int(budget.replace(",", ""))
    edit_event = m.Events.objects.get(id=event_id)
    edit_event.name = name
    edit_event.guestsmin = guestmin
    edit_event.guestsmax = guestmax
    edit_event.type = edit_event_type
    edit_event.date = date
    edit_event.location = location
    edit_event.description = description
    edit_event.themeColor = theme_color
    edit_event.budget = budget
    edit_event.save(update_fields=['name','guestsmin','guestsmax','type','date','location','description','themeColor','budget'])
    UserActivity.objects.create(
        user=request.user,
        action='event_edit',
        metadata={
            'event_id': event_id,
            'updated_name': name,
            'updated_location': location
        },
        timestamp=now()
    )

    return Response({'status': 'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_event(request):
    userid = request.data.get('userId')
    name = request.data.get('Event Name')
    create_event_type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('description')
    theme_color = request.data.get('Theme')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    guestmin= request.data.get('guestmin')
    guestmax = request.data.get('guestmax')
    userid= m.User.objects.get(id=userid)
    create_event = m.Events(name=name,guestsmin=guestmin,guestsmax=guestmax,userID=userid,type=create_event_type,date=date,location=location,themeColor=theme_color,budget=budget)
    if description != None:
        create_event.description = description
    create_event.save()
    UserActivity.objects.create(
        user=request.user,
        action='event_create',
        metadata={
            'event_name': name,
            'event_type': create_event_type,
            'location': location,
            'budget': budget
        },
        timestamp=now()
    )

    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def your_events(request,id):
    your_event = m.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer (your_event,many=True)
    number_of_functions = []
    for i in your_event:
        functions = m.Functions.objects.filter(eventId=i.id)
        number_of_functions.append(len(functions))
    return Response({'status':'success','Event':serializer.data,'nofunctions':number_of_functions})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_event(request):
    delete_event_id = request.data.get('EventId')
    delete_event = m.Events.objects.get(id=delete_event_id)
    delete_event.delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def get_events_and_functions(request, id):
    user = m.User.objects.get(id=id)
    events = m.Events.objects.filter(userID=user).values('id', 'name', 'userID')
    response_data = []
    for event in events:
        event_data = {
            'id': event['id'],
            'name': event['name'],
            'userID': event['userID'],
            'functions': list(m.Functions.objects.filter(eventId=event['id'])
                             .values('id', 'name', 'eventId'))
        }
        response_data.append(event_data)
    
    return Response({'status': 'success', 'Event': response_data})
