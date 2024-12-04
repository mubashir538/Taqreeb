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
    pass

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
    pass

@api_view(['GET'])
def YourEvents(request):
    pass

@api_view(['GET'])
def PhotographerViewPage(request):
    pass

@api_view(['GET'])
def CatererViewPage(request):
    pass

@api_view(['GET'])
def CatererViewPage(request):
    pass

@api_view(['GET'])
def VideoEditorViewPage(request):
    pass

@api_view(['GET'])
def HomeCategories(request):
    pass

@api_view(['GET'])
def HomeListings(request):
    pass

@api_view(['GET'])
def SearchListings(request):
    pass

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
def CartItems(request):
    pass

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

    