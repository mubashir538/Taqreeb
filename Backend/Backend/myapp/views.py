from . import models as md
from . import Serializers as s
import random as rd
from rest_framework.decorators import api_view, permission_classes
from django.core.files.storage import FileSystemStorage
from rest_framework.permissions import IsAuthenticated,AllowAny
from datetime import datetime
import requests as rq
from rest_framework.response import Response
from .models import UserActivity
from django.utils.timezone import now
# from .Serializers import UserActivitySerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getFunctionType(request,id):
    functionTypes = md.FunctionType.objects.filter(eventtypeid=id)
    serializer = s.FunctionTypeSerializer(functionTypes,many=True)
    return Response({'status':'success','functionTypes':serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def searchType(request,userid):
    business = md.BusinessOwner.objects.filter(userID=userid,status='Approved')
    response = {'status':'success','business':False,'freelancer':False}
    if business:
        response['business'] = True
    freelancer = md.Freelancer.objects.filter(userID=userid,status='Approved')
    if freelancer:
        response['freelancer'] = True
    return Response(response)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ShowChecklist(request,functionId=None,eventId=None):
    if request.GET.get('functionId'):
        checklist = md.CheckList.objects.filter(functionId=functionId,eventId=eventId)
    else:
        checklist = md.CheckList.objects.filter(eventId=eventId,functionId__isnull=True)
    serializer = s.CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def showBookCart(request,id):
    cart = md.BookingCart.objects.filter(functionId=id,status='Cart')
    if cart.count() == 0:
        return Response({'status':'CartEmpty'})
    cartserializer = s.BookingCartSerializer(cart,many=True)
    print('Cart: ',cartserializer.data)
    items = []
    for i in cart:
        listing = i.listingId
        listingserializer = s.ListingSerializer(listing,many=False)
        pictures = md.PicturesListings.objects.filter(listingId=listing.id)
        pictures = s.PicturesListingSerializers(pictures,many=True).data
        view= None
        if i.type == 'Venue':
            view = md.Venue.objects.get(listingId=listing.id)
            view = s.VenueSerializer(view,many=False).data
        elif i.type == 'Salon':
            view = md.Salons.objects.get(listingId=listing.id)
            view = s.SalonsSerializer(view,many=False).data
        elif i.type == 'Parlor':
            view = md.Parlors.objects.get(listingId=listing.id)
            view = s.ParlorsSerializer(view,many=False).data
        # elif i.type == 'Baker':
        #     view = md.BakersAndSweets.objects.get(listingID=listing.id)
        #     view = s.BakersAndSweetsSerializer(view,many=False).data
        elif i.type == 'PhotographyPlace':
            view = md.PhotographyPlaces.objects.get(listingId=listing.id)
            view = s.PhotographyPlacesSerializer(view,many=False).data
        elif i.type == 'Decorator':
            view = md.Decorators.objects.get(listingId=listing.id)
            view = s.DecoratorsSerializer(view,many=False).data
        elif i.type == 'Photographer':
            view = md.Photographers.objects.get(listingId=listing.id)
            view = s.PhotographersSerializer(view,many=False).data
        item = {'id':i.id,'listing':listingserializer.data,'type':i.type,'view':view,'pictures':pictures}
        items.append(item)
    return Response({'status':'success','cart':items})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def AddtoBookCart(request):
    fid = request.data.get('fid')
    lid = request.data.get('lid')
    uid = request.data.get('uid')
    type = request.data.get('type')
    slot = request.data.get('slot')
    function = md.Functions.objects.get(id=fid)
    listing = md.Listing.objects.get(id=lid)
    user = md.User.objects.get(id=uid)
    if slot:
        if slot.find(' ') != -1:
            slot = slot[:-1]
            slot = datetime.strptime(slot, "%Y-%m-%d %H:%M:%S.%f").date()
        cart = md.BookingCart(userId=user,listingId=listing,functionId=function,type=type,status='Cart',slot=slot)
    else:
        cart = md.BookingCart(userId=user,listingId=listing,functionId=function,type=type,status='Cart')
    cart.save()
    if function.budget < listing.basicPrice:
        return Response({'status':'BudgetError','message':'Budget not enough'})
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def getHomeImages(request):
    images = md.HomePageImages.objects.all()
    serializer = s.HomePageImagesSerializer(images,many=True)
    return Response({'status':'success','images':serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def AddGuests(request):
    guesttype = request.data.get('guesttype')
    eid = request.data.get('eid')
    event = md.Events.objects.get(id=eid)
    if request.data.get('fid') != 'None':
        fid = request.data.get('fid')
        function = md.Functions.objects.get(id=fid)
    else:
        fid = None
    if guesttype=='Family':
        FamilyName = request.data.get('FamilyName')
        member = request.data.get('member')
        if fid:
            GuestList = md.GuestList(name=FamilyName,members=member,type=guesttype,eventId=event,functionId=function)
        else:
            GuestList = md.GuestList(name=FamilyName,members=member,type=guesttype,eventId=event)
    else:   
        PersonName = request.data.get('PersonName')
        PersonContact = request.data.get('PersonContact')
        if fid:
            GuestList = md.GuestList(name=PersonName,phone=PersonContact,type=guesttype,eventId=event,functionId=function)
        else:
            GuestList = md.GuestList(name=PersonName,phone=PersonContact,type=guesttype,eventId=event)
    GuestList.save()
    return Response({'status':'success'})

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
    function = md.Functions.objects.get(id=functionId)
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
def CreateFunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    budget = int(budget.replace(",", ""))
    type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    EventId = request.data.get('Event Id')
    event = md.Events.objects.get(id=EventId)
    try:
        CreateFunction = md.Functions(name=name, eventId = event, type=type, budget=budget,date=date,guestsmin=guestsmin,guestsmax=guestsmax)
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
def DeleteFunction(request):
    # id = request.data.get('FunctionId')
    # DeleteFunction = md.Functions.objects.get(id=id)
    # DeleteFunction.delete()
    md.BookingCart.objects.all().delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def YourEventsandFunctions(request,id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer(YourEvent,many=True)
    for event in serializer.data:
        functions = md.Functions.objects.filter(eventId=event['id'])
        event['functions'] = s.FunctionsSerializer(functions,many=True).data
    return Response({'status':'success','Event':serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def ShowGuest(request):
    EventId = request.data.get('EventId')
    event = md.Events.objects.get(id=EventId)
    if request.data.get('FunctionID') == 'None':
        functionid = None
        Guests = md.GuestList.objects.filter(eventId=event,functionId__isnull=True)
    else:
        functionid= request.data.get('FunctionID')
        Guests = md.GuestList.objects.filter(eventId=event,functionId=functionid)
    GuestListSerializer = s.GuestListSerializer(Guests,many=True)
    return Response({'status': 'success', 'Guests':GuestListSerializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def DeleteGuest(request):
    guestId = request.data.get('guestId')
    guest = md.GuestList.objects.get(id=guestId).delete()
    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def ViewFunction(request, FunctionId):
    Functions = md.Functions.objects.get(id = FunctionId)
    FunctionsSerializer = s.FunctionsSerializer(Functions, many=False)
    return Response ({'status':'success', 'Fuctions':FunctionsSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def HomeCategories(request):
    categories = md.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def BusinessCategories(request,type):
    if type == 'freelancer':
        categories = md.Categories.objects.filter(type='freelancer')
    else:
        categories = md.Categories.objects.filter(type='business')
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def CartItems(request, CartItemsID):
    Listing = md.Listing.objects.get(id = CartItemsID)
    CartItems = md.CartItems.objects.get(CartItemsID = CartItemsID)
    ListingSerializer = s.ListingSerializer(Listing, many=True)
    CartItemsSerializer = s.CartItemsSerializer(CartItems, many = True)
    return Response({'Status': 'Success', 'Listing': ListingSerializer.data, 'Cartitems': CartItemsSerializer.data})
    
def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_business_usernames(request):
    if request.method == 'GET':
        business_usernames = md.BusinessOwner.objects.values_list('businessUsername', flat=True)
        usernames_list = list(business_usernames)
        return Response({'status':'success','businessUsernames': usernames_list})

@api_view(['GET'])
@permission_classes([AllowAny])
def getWishlist(request,uid):
    uid = md.User.objects.get(id=uid)
    list = md.Wishlist.objects.filter(user=uid)
    list = md.Listing.objects.filter(id__in=list.values_list('listing', flat=True))
    ListingSerializer = s.ListingSerializer(list, many=True)
    Pictures = []
    Listings = ListingSerializer.data[:]
    for i in Listings:
        pic = md.PicturesListings.objects.filter(listingId=i['id'])
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)
    return Response({'status':'success', 'list':Listings, 'pictures':Pictures})
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def addtoWishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = md.Listing.objects.get(id=listing)
    userid = md.User.objects.get(id=userid)
    md.Wishlist(user=userid,listing=listing).save()
    return Response({'status':'success'}) 

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def removeFromWishlist(request):
    userid = request.data.get('userid')
    listing = request.data.get('listing')
    listing = md.Listing.objects.get(id=listing)
    userid = md.User.objects.get(id=userid)
    md.Wishlist.objects.filter(user=userid,listing=listing).delete()
    return Response({'status':'success'}) 

@api_view(['GET'])
@permission_classes([AllowAny])
def deleteTable(request):
    # md.Listing.objects.filter(ownerID=None).delete()
    # listings = md.Listing.objects.all()
    # for list in listings:
    #     md.ReviewDetails(listingID=list).save()
    return Response({'status': 'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def log_user_activity(request):
    """
    Logs all user activities including searches, clicks, filters, and time spent.
    """
    action = request.data.get('action')  # Type of action (search, click, time spent, etc.)
    metadata = request.data.get('metadata', {})  # Additional details (search term, clicked item, etc.)
    # duration_seconds = request.data.get('duration_seconds', None)  # Time spent on a page (optional)

    valid_actions = dict(UserActivity.ACTIONS).keys()
    if action not in valid_actions:
        return Response({'status': 'error', 'message': 'Invalid action type'}, status=400)

    # Store the action in UserActivity model
    UserActivity.objects.create(
        user=request.user,
        action=action,
        metadata=metadata,
        timestamp=now()
    )

    return Response({'status': 'success', 'message': 'Activity logged successfully'})

@api_view(['POST'])
@permission_classes([AllowAny])
def application_errors(request):
    error = request.data.get('error')
    print('App Error: ', error)
    return Response({'status': 'success'})