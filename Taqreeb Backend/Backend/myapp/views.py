from rest_framework.response import Response
import requests as rq
from . import models as md
from django.db.models import Max
from rest_framework.views import APIView
from rest_framework import status
from . import Serializers as s
import random as rd
from twilio.rest import Client
from rest_framework.decorators import api_view, permission_classes
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from django.core.mail import send_mail
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated,AllowAny

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTPEmail(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    subject = 'Password Reset for Taqreeb'
    message = f''' The Otp for your Taqreeb App is
    YOUR OTP IS: {otp}'''
    email_from = settings.EMAIL_HOST_USER
    email_to = email
    try:
        send_mail(subject,message,email_from,[email_to])
        return Response({'status': 200,'otp':otp,'email':email})
    except Exception as e:
        print(e)
        return Response({'status': 400})

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTPPhone(request):
    contactNumber = request.data.get('phone')
    otp = request.data.get('otp')
    client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    message = client.messages.create(
        body=f"Your OTP for Taqreeb is {otp}",
        from_=settings.TWILIO_PHONE_NUMBER,
        to=contactNumber
    )
    return Response({'status':'success','otp': otp,'contact':contactNumber})

@api_view(['POST'])
@permission_classes([AllowAny])
def sendOTPPhone(request):
    contactNumber = request.data.get('contactNumber')
    country = request.data.get('countryCode')
    if contactNumber.find(country) == -1:
        if contactNumber[0] == '0':
            contactNumber = contactNumber[1:]
        contactNumber = country + contactNumber

    otp = rd.randint(100000,999999)
    client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    message = client.messages.create(
        body=f"Your OTP for Taqreeb is {otp}",
        from_=settings.TWILIO_PHONE_NUMBER,
        to=contactNumber
    )
    return Response({'status':'success','otp': otp,'contact':contactNumber})

@api_view(['POST'])
@permission_classes([AllowAny])
def sendOTPEmail(request):
    email = request.data.get('email')
    otp = rd.randint(1000,9999)
    subject = 'Password Reset for Taqreeb'
    message = f''' The Otp for your Taqreeb App is
    YOUR OTP IS: {otp}'''
    email_from = settings.EMAIL_HOST_USER
    email_to = email
    try:
        send_mail(subject,message,email_from,[email_to])
        return Response({'status': 200,'otp':otp,'email':email})
    except Exception as e:
        print(e)
        return Response({'status': 400})

@api_view(['POST'])
@permission_classes([AllowAny])
def AccountSignupPage(request):
    print(request.data)
    firstName = request.data.get('firstName')
    lastName = request.data.get('lastName')
    password = request.data.get('password')
    contactType = request.data.get('contactType')
    city = request.data.get('city')
    gender = request.data.get('gender')
    profilePicture = request.FILES.get('profilePicture')
    if contactType=='email':
        contact = request.data.get('email')
        user = md.User.objects.filter(email=contact).first()
        if user:
            return Response({'status':'error', 'message': 'Email Already Exists'})
        user = md.User(firstName=firstName,lastName=lastName,password=password,email=contact,city=city,gender=gender)
    else:
        contact = request.data.get('contactNumber')
        user = md.User.objects.filter(contactNumber=contact).first()
        if user:
            return Response({'status':'error', 'message': 'Contact Already Exists'})

        user = md.User(firstName=firstName,lastName=lastName,password=password,contactNumber=contact,city=city,gender=gender)
    user.save()
    if contactType=='email':
        user = md.User.objects.filter(email=contact).first()
    else:
        user = md.User.objects.filter(contactNumber=contact).first()

    if profilePicture:
            filestorage = FileSystemStorage()
            filePath = filestorage.save(f'uploads/users/profilePicture/{user.id}.png', profilePicture)
            user.profilePicture = filestorage.url(filePath)   
            user.save(update_fields=["profilePicture"])
            
    refresh = RefreshToken.for_user(user)
    id = user.id    
    return Response({'status':'success','refresh':str(refresh),'access':str(refresh.access_token),'userId':id})

@api_view(['POST'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def BusinessOwnerSignup(request):
    userid = request.data.get('id')
    businessName = request.data.get('businessName')
    username = request.data.get('username')
    cnic = request.data.get('cnic')
    category = request.data.get('category')
    cnicFront = request.data.get('cnicFront')
    cnicBack = request.data.get('cnicBack')
    description = request.data.get('description')
    user = md.User.objects.get(id=userid)
    if md.BusinessOwner.objects.filter(userID=userid).exists():
        return Response({'status':'error', 'message': 'Business Owner Already Exists'}) 
    owner = md.BusinessOwner(userID=user,CNICFront=cnicFront,CNICBack=cnicBack,businessName=businessName,businessUsername=username,Description=description,category=category,cnic=cnic)
    owner.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
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
@permission_classes([AllowAny])
def ResetPasswordPage(request):
    password = request.data.get('password')
    id = request.data.get('id')
    user = md.User.objects.filter(id=id).update(password=password)
    return Response({'status':'success'})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def AccountInfoPage(request,id):
    userid = id
    user = md.User.objects.filter(id=userid).first()
    serializer = s.UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def ListingsPage(request,id):
    listings = md.Listing.objects.filter(BusinessOwnerID=id)
    serializer = s.ListingSerializer(listings,many=True)
    return Response({'status':'success','listings':serializer.data})
    
@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def DecoratorDetailPage(request,id):
    listingDetails = md.Listing.objects.get(id=id)
    decoratorDetails = md.Decorators.objects.filter(ListingID=id)
    return Response({'status':'success','listingDetails':listingDetails,'decoratorDetails':decoratorDetails})
    
@api_view(['PUT'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def EditAccountInfoPage(request):
    pass

@api_view(['POST'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def FreelancerSignup(request):
    BusinessName = request.data.get('BusinessName')
    BusinessUserName = request.data.get('BusinessUserName')
    PortfolioLink = request.data.get('Portfoliolink')
    Description = request.data.get('Description')
    Picture = request.data.get('Picture')
    UserId = request.data.get('UserId')
    Freelancer = md.Freelancer(userId = UserId,businessName = BusinessName,
        businessUsername = BusinessUserName,portfolioLink = PortfolioLink,description = Description)
    user = md.User.objects.get(id= UserId).update(profilePicture=Picture)
    Freelancer.save()
    return Response({'status': 'success'})

@api_view(['POST'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def CreateFunction(request):
    name = request.data.get('Function Name')
    Budget = request.data.get('Budget')
    type =request.fata.get('Event Type')

    CreateFunction = md.CreateFunction(name=name, type=type, Budget=Budget)
    CreateFunction.save()
    return Response({'status':'success'})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])


@permission_classes([AllowAny])
def EventDetails(request,eventId):
    EventDetail = md.Events.objects.get(id=eventId)
    serializer = s.EventsSerializer(EventDetail,many=False)
    Function = md.Functions.objects.filter(eventId=eventId)
    serializer2 = s.FunctionsSerializer(Function,many=True)
    return Response({'status':'success','EventDetail':serializer.data,'Functions':serializer2.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
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
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
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
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def YourEvents(request,id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer (YourEvent,many=True)
    numberofFunctions = []
    for i in YourEvent:
        functions = md.Fuctions.objects.filter(eventId=YourEvent.id)
        numberofFunctions.append(len(functions))
    return Response({'status':'success','Event':serializer.data,'nofunctions':numberofFunctions})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def PhotographerViewPage(request, listingID):
    photographerID = listingID
    PhotographerView = md.Photographers.objects.get( id = photographerID)
    Listing = md.Listing.objects.get(id = photographerID)
    Addons = md.AddOns.objects.filter(id = photographerID)
    Package = md.Packages.objects.filter(id = photographerID)
    Review = md.Review.objects.filter(id, photographerID)
    PhotographersSerializer = s.PhotographersSerializer(PhotographerView, many = False)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    return Response({'status': 'success','PhotographerView': PhotographersSerializer.data,'Addons': Addonsserializer.data,
                     'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data})
    pass

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def CarRenterViewPage(request, listingID):
    CarRenterid = listingID
    Listing = md.Listing.objects.get(id = CarRenterid)
    CarRenters = md.CarRenters.objects.get(id = CarRenterid)
    Cars = md.Cars.objects.filter(id = CarRenterid )
    Addons = md.AddOns.objects.filter(id =CarRenterid)
    Package = md.Packages.objects.filter(id = CarRenterid)
    Review = md.Review.objects.filter(id = CarRenterid)
    CarRentersSerializer = s.CarRentersSerializer(CarRenters, many = False)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    CarsSerializer = s.CarRentersSerializer(Cars , many = True)
    return Response({'status': 'success', 'CarRenters': CarRentersSerializer.data, 'Listing': Listingserializer.data, 
                     'Package': Packageserializer.data, 'Review': Reviewserializer.data,'Addons': Addonsserializer.data, 'Cars': CarsSerializer.data })

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def GraphicDesignerViewPage(request, listingID):
    graphicdesignerid = listingID
    Listing = md.Listing.objects.get(id= graphicdesignerid)
    package = md.Packages.objects.filter(id = graphicdesignerid)
    GraphicDesigners = md.GraphicDesigners.objects.get(id = graphicdesignerid)
    Review = md.Review.objects.filter(id = graphicdesignerid)
    ListingSerializer = s.ListingSerializer(Listing, many= False)
    PackageSerializer = s.PackagesSerializer(package, many = True)
    GraphicDesignersSerializer = s.GraphicDesignersSerializer(GraphicDesigners, many = False)
    ReviewSerializer = s.ReviewSerializer(Review, many = True)
    return Response({'status': 'success','GraphicDesigners': GraphicDesignersSerializer.data, 'Listing':ListingSerializer.data, 
                     'Package': PackageSerializer.data, 'Review': ReviewSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
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
    return Response({'status': 'success','CatererView':CatererSerializer.data,'Addons': Addonsserializer.data, 'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def BusinessOwnerAccountInfo(request, businessownerID):
    BusinessOwner = md.BusinessOwner.objects.get(id=businessownerID)
    BusinessOwnerSerializer = s.BusinessOwnerSerializer( BusinessOwner, many = False)
    return Response({'status': 'success','BusinessOwner':BusinessOwnerSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def ShowGuest(request, EventID, FunctionID):
    Guests = md.GuestList.objects.filter(eventId=EventID,functionId=FunctionID)
    GuestListSerializer = s.GuestListSerializer(Guests,many=True)
    return Response({'status': 'success', 'Guests':GuestListSerializer.data})
    
@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def HomeCategories(request):
    categories = md.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(many = True)
    return Response({'status': 'success'})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
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
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def ViewFunction(request, ViewFunctionID):
    Listing = md.Listing.objects.all()
    Functions = md.Functions.objects.get(ViewFunctionID=ViewFunctionID)
    Venue = md.Venue.objects.get(ViewFunctionID = ViewFunctionID)
    Caterers = md.Caterers.objects.get(ViewFunctionID = ViewFunctionID)
    Salons = md.Salons.objects.get(ViewFunctionID = ViewFunctionID)
    ListingSerializer = s.ListingSerializer(Listing, many=False)
    FunctionsSerializer = s.FunctionsSerializer(Functions, many=True)
    VenueSerializer = s.VenueSerializer(Venue, many=True)
    CaterersSerializer = s.CaterersSerializer(Caterers, many=True)
    SalonsSerializer = s.SalonsSerializer(Salons, many=True)
    return Response ({'status':'success', 'Fuctions':FunctionsSerializer.data, 'Listing':ListingSerializer.data, 'Venue':VenueSerializer.data, 'Caterers':CaterersSerializer.data, 'Salons':SalonsSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def HomeCategories(request):
    categories = md.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def HomeListings(request):
    Listing= md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    return Response({'status':'succuess', 'HomeListing':ListingSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])

@permission_classes([AllowAny])
def SearchListings(request, SearchListingsID):
    Listing = md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    return Response({'status':'succuess', 'SearchListing':ListingSerializer.data})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
@permission_classes([AllowAny])
def SearchListingsPARA(request):
    pass

@api_view(['POST'])
# @permission_classes([IsAuthenticated])
@permission_classes([AllowAny])
def AddGuests(request):
    pass

@api_view(['POST'])
@permission_classes([AllowAny])
def UserLogin(request):
    contact = request.data.get('contact')
    password = request.data.get('password')
    if contact.find('@') != -1:
        user = md.User.objects.filter(email=contact,password=password).first()
    else:
        user = md.User.objects.filter(contactNumber=contact,password=password).first()
    
    if user:
        refresh = RefreshToken.for_user(user)
        return Response({'status':'success','refresh': str(refresh),'access': str(refresh.access_token)})
    
    return Response({'status': 'error', 'message': 'Invalid Credentials'})

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
@permission_classes([AllowAny])
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

    