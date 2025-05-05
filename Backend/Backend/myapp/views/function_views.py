from .. import models as m
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def CreateFunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    EventId = request.data.get('Event Id')
    event = m.Events.objects.get(id=EventId)
    try:
        CreateFunction = m.Functions(name=name, eventId = event, type=type, budget=budget,date=date,guestsmin=guestsmin,guestsmax=guestsmax)
        CreateFunction.save()
        if int(budget) > event.budget:
            return Response({'status':'BudgetError','message':'Budget Exceeded'}) 
        else:
            return Response({'status':'success'})
    except Exception as e:
        print(e)
        return Response({'status':'error'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def EditFunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    functionId = int(request.data.get('Function Id'))
    function = m.Functions.objects.get(id=functionId)
    try:
        function.name = name
        function.type = type
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
def DeleteFunction(request):
    m.BookingCart.objects.all().delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ViewFunction(request, FunctionId):
    Functions = m.Functions.objects.get(id = FunctionId)
    FunctionsSerializer = s.FunctionsSerializer(Functions, many=False)
    return Response ({'status':'success', 'Fuctions':FunctionsSerializer.data})
