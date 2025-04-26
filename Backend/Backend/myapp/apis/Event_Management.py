from .. import models as md
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.response import Response
from myapp.models import UserActivity
from django.utils.timezone import now


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getEventType(request):
    eventTypes = md.EventType.objects.all()
    serializer = s.EventTypeSerializer(eventTypes,many=True)
    return Response({'status':'success','eventTypes':serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def EventDetails(request,eventId):
    EventDetail = md.Events.objects.get(id=eventId)
    serializer = s.EventsSerializer(EventDetail,many=False)
    Function = md.Functions.objects.filter(eventId=eventId)
    serializer2 = s.FunctionsSerializer(Function,many=True)
    UserActivity.objects.create(
        user=request.user,
        action='event_view',
        metadata={
            'event_id': eventId,
            'event_name': EventDetail.name,
            'event_type': EventDetail.type
        },
        timestamp=now()
    )

    return Response({'status':'success','EventDetail':serializer.data,'Functions':serializer2.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def EditEvent(request):
    name = request.data.get('Event Name')
    type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('description')
    themeColor = request.data.get('Theme')
    budget = request.data.get('Budget')
    guestmin= request.data.get('guestmin')
    guestmax = request.data.get('guestmax')
    eventId = request.data.get('EventId')
    print(type)
    budget = int(budget.replace(",", ""))
    EditEvent = md.Events.objects.get(id=eventId)
    EditEvent.name = name
    EditEvent.guestsmin = guestmin
    EditEvent.guestsmax = guestmax
    EditEvent.type = type
    EditEvent.date = date
    EditEvent.location = location
    EditEvent.description = description
    EditEvent.themeColor = themeColor
    EditEvent.budget = budget
    EditEvent.save(update_fields=['name','guestsmin','guestsmax','type','date','location','description','themeColor','budget'])
    UserActivity.objects.create(
        user=request.user,
        action='event_edit',
        metadata={
            'event_id': eventId,
            'updated_name': name,
            'updated_location': location
        },
        timestamp=now()
    )

    return Response({'status': 'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def CreateEvent(request):
    userId = request.data.get('userId')
    name = request.data.get('Event Name')
    type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('description')
    themeColor = request.data.get('Theme')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    guestmin= request.data.get('guestmin')
    guestmax = request.data.get('guestmax')
    CreateEvent = md.Events(name=name,guestsmin=guestmin,guestsmax=guestmax,userID=userId,type=type,date=date,location=location,description=description,themeColor=themeColor,budget=budget)
    CreateEvent.save()
    UserActivity.objects.create(
        user=request.user,
        action='event_create',
        metadata={
            'event_name': name,
            'event_type': type,
            'location': location,
            'budget': budget
        },
        timestamp=now()
    )

    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def YourEvents(request,id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer (YourEvent,many=True)
    numberofFunctions = []
    for i in YourEvent:
        functions = md.Functions.objects.filter(eventId=i.id)
        numberofFunctions.append(len(functions))
    return Response({'status':'success','Event':serializer.data,'nofunctions':numberofFunctions})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def DeleteEvent(request):
    id = request.data.get('EventId')
    DeleteEvent = md.Events.objects.get(id=id)
    DeleteEvent.delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def getEventsAndFunctions(request, id):
    user = md.User.objects.get(id=id)
    events = md.Events.objects.filter(userID=user).values('id', 'name', 'userID')
    response_data = []
    for event in events:
        event_data = {
            'id': event['id'],
            'name': event['name'],
            'userID': event['userID'],
            'functions': list(md.Functions.objects.filter(eventId=event['id'])
                             .values('id', 'name', 'eventId'))
        }
        response_data.append(event_data)
    
    return Response({'status': 'success', 'Event': response_data})
