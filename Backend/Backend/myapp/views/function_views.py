from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from ..models.event_models import Events,Functions
from ..Serializers.event_serializers import FunctionsSerializer
from ..Serializers.booking_serializers import BookingCartSerializer
from ..models.booking_models import BookingCart

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def createfunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    create_function_type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    eventid = request.data.get('Event Id')
    event = Events.objects.get(id=eventid)
    try:
        createfunction = Functions(name=name, eventId = event, type=create_function_type, budget=budget,date=date,guestsmin=guestsmin,guestsmax=guestsmax)
        createfunction.save()
        if int(budget) > event.budget:
            return Response({'status':'BudgetError','message':'Budget Exceeded'}) 
        else:
            return Response({'status':'success'})
    except Exception as e:
        print(e)
        return Response({'status':'error'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def editfunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    edit_funtion_type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    functionid = int(request.data.get('Function Id'))
    function = Functions.objects.get(id=functionid)
    try:
        function.name = name
        function.type = edit_funtion_type
        function.budget = budget
        function.date = date
        function.guestsmin = guestsmin
        function.guestsmax = guestsmax
        function.save(update_fields=['name','type','budget','date','guestsmin','guestsmax'])
        return Response({'status':'success'})
    except Exception as e:
        print(e)
        return Response({'status':'error'})
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def deletefunction(request):
    BookingCart.objects.all().delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def viewfunction(request, functionid):
    functions = Functions.objects.get(id = functionid)
    functions_serializer = FunctionsSerializer(functions, many=False)
    return Response ({'status':'success', 'Fuctions':functions_serializer.data})
