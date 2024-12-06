from rest_framework.response import Response
import requests as rq
from . import models as md
from django.db.models import Max
from rest_framework.views import APIView
from rest_framework import status
from . import Serializers as s
import random as rd
from rest_framework.decorators import api_view


@api_view(['POST'])
def AccountSignupPage(request):
    firstName = request.data.get('firstName')
    lastName = request.data.get('lastName')
    password = request.data.get('password')
    contactType = request.data.get('contactType')
    city = request.data.get('city')
    gender = request.data.get('gender')
    profilePicture = request.data.get('profilePicture')
    if contactType=='email':
        contact = request.data.get('email')
        user = md.User(firstName=firstName,lastName=lastName,password=password,email=contact,city=city,gender=gender,profilePicture=profilePicture)
    else:
        contact = request.data.get('contactNumber')
        user = md.User(firstName=firstName,lastName=lastName,password=password,contactNumber=contact,city=city,gender=gender,profilePicture=profilePicture)
    
    user.save()
    return Response({'status':'success'})

@api_view(['POST'])
def BusinessOwnerSignup(request):
    userid = request.data.get('id')
    businessName = request.data.get('businessName')
    username = request.data.get('username')
    cnic = request.data.get('cnic')
    category = request.data.get('category')
    cnicFront = request.data.get('cnicFront')
    cnicBack = request.data.get('cnicBack')
    description = request.data.get('description')

    owner = md.BusinessOwner(UserID=userid,CNICFormat=cnicFront,CNICBack=cnicBack,BuisnessName=businessName,BuisnerUsername=username,Description=description,category=category,cnic=cnic)
    owner.save()
    return Response({'status':'success'})

@api_view(['POST'])
def ForgotPasswordPage(request):
    contact = request.data.get('contactNumber')
    otp = rd.randint(1000,9999)
    if str(contact).find('@') != -1:
        user = md.User.objects.filter(email=contact).first()
        # OTP Send Email Number
    else:
        user = md.User.objects.filter(contactNumber=contact).first()
        # OTP Send Contact Number
    if user != None:
        return Response({'status':'error', 'message': 'Enter a Valid Email or Phone Number'})
    else:
        return Response({'status':'success','otp':otp,'userid':user.id})
        
@api_view(['POST'])
def ResetPasswordPage(request):
    password = request.data.get('password')
    id = request.data.get('id')
    user = md.User.objects.filter(id=id).update(password=password)
    return Response({'status':'success'})

@api_view(['GET'])
def AccountInfoPage(request,id):
    userid = id
    user = md.User.objects.filter(id=userid).first()
    serializer = s.UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET'])
def ListingsPage(request,id):
    listings = md.Listing.objects.filter(BusinessOwnerID=id)
    serializer = s.ListingSerializer(listings,many=True)
    return Response({'status':'success','listings':serializer.data})
    
@api_view(['GET'])
def DecoratorDetailPage(request,id):
    listingDetails = md.Listing.objects.get(id=id)
    decoratorDetails = md.Decorators.objects.filter(ListingID=id)
    return Response({'status':'success','listingDetails':listingDetails,'decoratorDetails':decoratorDetails})
    
@api_view(['PUT'])
def EditAccountInfoPage(request):
    pass

@api_view(['POST'])
def FreelancerSignup(request):
    pass

@api_view(['POST'])
def CreateFunction(request):
    name = request.data.get('Function Name')
    Budget = request.data.get('Budget')
    type =request.fata.get('Event Type')

    CreateFunction = md.CreateFunction(name=name, type=type, Budget=Budget)
    CreateFunction.save()
    return Response({'status':'success'})
    

@api_view(['GET'])
def EventDetails(request,eventId):
    EventDetail = md.Events.objects.get(id=eventId)
    Funtion  = md.Functions.objects.filter(eventId = eventId)
    Funtionserializer = s.FunctionsSerializer(Funtion, many = True)
    serializer = s.EventsSerializer(EventDetail, many =False)
    return Response({'status':'success','Eventdetail':serializer.data,'Funtion': Funtionserializer.data})
    pass

@api_view(['GET'])
def VenueViewPage(request, venueId):
    Listing = md.Listing.objects.get(id = venueId)
    VenueView = md.Venue.objects.get(listingID= venueId)
    Addons = md.AddOns.objects.filter(id = venueId)
    Package = md.Packages.objects.filter(id = venueId)
    Review = md.Review.objects.filter(id, venueId)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.VenueSerializer( VenueView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    return Response({'status': 'success','VenueView': serializer.data,'Addons': Addonsserializer.data,
                     'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data})
    pass

@api_view(['POST'])
def CreateEvent(request):
    name = request.data.get('Event Name')
    type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('Describe your Event')
    themeColor = request.data.get('Theme')
    budget = request.data.get('Budget')

    CreateEvent = md.CreateEvent(name=name,type=type,date=date,location=location,description=description,themeColor=themeColor,budget=budget)
    CreateEvent.save()
    return Response({'status': 'success'})

@api_view(['GET'])
def YourEvents(request: id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer (YourEvent,many=True)
    return Response({'status':'success','Event':serializer.data})
    pass

@api_view(['GET'])
def PhotographerViewPage(request, photograpgerID):
    PhotographerView = md.Photographers.objects.get( id = photograpgerID)
    Listing = md.Listing.objects.get(id = photograpgerID)
    Addons = md.AddOns.objects.filter(id = photograpgerID)
    Package = md.Packages.objects.filter(id = photograpgerID)
    Review = md.Review.objects.filter(id, photograpgerID)
    PhotographersSerializer = s.PhotographersSerializer(PhotographerView, many = False)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    return Response({'status': 'success','PhotographerView': PhotographersSerializer.data,'Addons': Addonsserializer.data,
                     'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data})
    pass

@api_view(['GET'])
def CatererViewPage(request,CatererID):
    CatererView = md.Caterers.objects.get( id = CatererID)
    Listing = md.Listing.objects.get(id = CatererID)
    Addons = md.AddOns.objects.filter(id = CatererID)
    Package = md.Packages.objects.filter(id = CatererID)
    Review = md.Review.objects.filter(id, CatererID)
    CatererSerializer = s.CaterersSerializer(CatererView, many = False)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    return Response({'status': 'success','CatererView':CatererSerializer.data,'Addons': Addonsserializer.data,
                     'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data})
    pass

@api_view(['GET'])
def CatererViewPage(request):
    pass

@api_view(['GET'])
def VideoEditorViewPage(request, VideoEditorID):
    Listing =md.Listing.objects.get(id = VideoEditorID)
    VideoEditors = md.VideoEditors.objects.get(VideoEditorID = VideoEditorID)
    Package = md.Packages.objects.filter(VideoEditorID = VideoEditorID)
    Review = md.Review.objects.filter(VideoEditorID = VideoEditorID)
    VideoEditorsSerializer = s.VideoEditorsSerializer(VideoEditors, many =False)
    PackageSerializer = s.PackagesSerializer(Package, many = True)
    ReviewSerializer = s.ReviewSerializer(Review,many=True)
    ListingSerializer = s.ListingSerializer(Listing, many=False)
    return Response({'status': 'success', 'VideoEditors':VideoEditorsSerializer.data, 'Listing':ListingSerializer.data, 'Package':PackageSerializer.data, 'Review':ReviewSerializer.data})

@api_view(['GET'])
def ViewFunction(request, ViewFunctionID):
    Listing = md.Listing.objects.all()
    Functions = md.Functions.objects.get(ViewFunctionID=ViewFunctionID)
    Venue = md.Venue.objects.get(ViewFunctionID = ViewFunctionID)
    Caterers = md.Caterers.objects.get(ViewFunctionID = ViewFunctionID)
    Salons - md.Salons.objects.get(ViewFunctionID = ViewFunctionID)
    ListingSerializer = s.ListingSerializer(Listing, many=False)
    FunctionsSerializer = s.FunctionsSerializer(Functions, many=True)
    VenueSerializer = s.VenueSerializer(Venue, many=True)
    CaterersSerializer = s.CaterersSerializer(Caterers, many=True)
    SalonsSerializer = s.SalonsSerializer(Salons, many=True)
    return Response ({'status':'success', 'Fuctions':FunctionsSerializer.data, 'Listing':ListingSerializer.data, 'Venue':VenueSerializer.data, 'Caterers':CaterersSerializer.data, 'Salons':SalonsSerializer.data})


@api_view(['GET'])
def HomeCategories(request):
    pass

@api_view(['GET'])
def HomeListings(request, HomeListingsID):
    Listing= md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    return Response({'status':'succuess', 'HomeListing':ListingSerializer.data})

@api_view(['GET'])
def SearchListings(request, SearchListingsID):
    Listing = md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    return Response({'status':'succuess', 'SearchListing':ListingSerializer.data})
    

@api_view(['GET'])
def SearchListingsPARA(request):
    pass

@api_view(['GET'])
def ShowGuest(request):
    pass

@api_view(['POST'])
def AddGuests(request):
    pass

@api_view(['GET'])
def BusinessOwnerAccountInfo(request):
    pass

@api_view(['POST'])
def UserLogin(request):
    pass

@api_view(['GET'])
def CartItems(request, CartItemsID):
    Listing = md.Listing.objects.get(id = CartItemsID)
    CartItems = md.CartItems.objects.get(CartItemsID = CartItemsID)
    ListingSerializer = s.ListingSerializer(Listing, many=True)
    CartItemsSerializer = s.CartItemsSerializer(CartItems, many = True)
    return Response({'Status': 'Success', 'Listing': ListingSerializer.data, 'Cartitems': CartItemsSerializer.data})
    

@api_view(['GET'])
def GraphicDesignerViewPage(request):
    pass

@api_view(['GET'])
def CarRenterViewPage(request):
    pass




# @api_view(['GET','POST','PUT'])
# def user(request):
#     if request.method == 'POST':
#         if request.data.get('type') == 'basicInfo':
#             firstName = request.data.get('firstName')
#             lastName = request.data.get('lastName')
#             password = request.data.get('password')
#             user = md.User.objects.create(firstName=firstName,lastName=lastName,password=password)
#             user.save()
#             id = md.User.objects.aaggregate(Max('id'))['id__max']
#             return Response({"message":"success",'status': 200,'yourId':id})
#         elif request.data.get('type') == 'contactNumber':
#             contact = request.data.get('contactNumber')
#             # userid = request.data.get('id')
#             #user = md.User.objects.filter(id=userid).update(contact=contact)


#     elif request.method == 'GET':
#         pass
#     elif request.method == 'PUT':
#         pass
#     # print(request)
#     # return Response({"message":request.data})

def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

    