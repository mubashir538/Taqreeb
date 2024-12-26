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
from django.core.files.base import ContentFile
from django.core.mail import send_mail
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework.permissions import IsAuthenticated,AllowAny
from datetime import datetime
from django.apps import apps
import json

@api_view(['GET'])
@permission_classes([AllowAny])
def getEventType(request):
    eventTypes = md.EventType.objects.all()
    serializer = s.EventTypeSerializer(eventTypes,many=True)
    return Response({'status':'success','eventTypes':serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def getFunctionType(request,id):
    functionTypes = md.FunctionType.objects.filter(eventtypeid=id)
    serializer = s.FunctionTypeSerializer(functionTypes,many=True)
    return Response({'status':'success','functionTypes':serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def searchType(request,userid):
    business = md.BusinessOwner.objects.filter(userID=userid)
    response = {'status':'success','business':False,'freelancer':False}
    if business:
        response['business'] = True
    freelancer = md.Freelancer.objects.filter(userId=userid)
    if freelancer:
        response['freelancer'] = True
    return Response(response)

@api_view(['GET'])
@permission_classes([AllowAny])
def getListingDetails(request, type):
    model_mapping = {
        'Venue': 'Venue',
        'Salon': 'Salons',
        'Parlour': 'Parlors',
        'Baker': 'BakersAndSweets',
        'PhotographyPlace': 'PhotographyPlaces',
        'Decorator': 'Decorators',
        'Photographer': 'Photographers',
        'Caterer':'Caterers',
        'CarRenter':'CarRenters',
        'BakerandSweet':'BakersAndSweets',
        'VideoEditor':'VideoEditors',
        'GraphicDesigner':'GraphicDesigners'
    }

    model_name = model_mapping.get(type)
    if not model_name:
        return Response({"error": "Invalid type provided"})

    try:
        # Get the model dynamically
        model = apps.get_model('myapp', model_name)

        # Fetch all field names and their choices if available
        field_data = []
        for field in model._meta.get_fields():
            if field.name not in ['id', 'listingID','listingId']:
                field_info = {"name": field.name}
                if hasattr(field, 'choices') and field.choices:
                    # Extract only keys from choices as a list
                    field_info["choices"] = [choice[0] for choice in field.choices]
                field_data.append(field_info)

        return Response({"fields": field_data})
    except LookupError:
        return Response({"error": "Model not found"})

@api_view(['GET'])
@permission_classes([AllowAny])
def ShowChecklist(request,functionId=None,eventId=None):
    if request.GET.get('functionId'):
        checklist = md.CheckList.objects.filter(functionId=functionId,eventId=eventId)
    else:
        checklist = md.CheckList.objects.filter(eventId=eventId,functionId__isnull=True)
    serializer = s.CheckListSerializer(checklist,many=True)
    return Response({'status':'success','checklist':serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def showBookCart(request,id):
    cart = md.BookingCart.objects.filter(functionId=id,status='Cart')
    cartserializer = s.BookingCartSerializer(cart,many=True)
    items = []
    for i in cart:
        listing = i.listingId
        listingserializer = s.ListingSerializer(listing,many=False)
        pictures = md.PicturesListings.objects.filter(listingId=listing.id)
        pictures = s.PicturesListingSerializers(pictures,many=True).data
        view= None
        if i.type == 'Venue':
            view = md.Venue.objects.get(listingID=listing.id)
            view = s.VenueSerializer(view,many=False).data
        elif i.type == 'Salon':
            view = md.Salons.objects.get(listingID=listing.id)
            view = s.SalonsSerializer(view,many=False).data
        elif i.type == 'Parlor':
            view = md.Parlors.objects.get(listingID=listing.id)
            view = s.ParlorsSerializer(view,many=False).data
        elif i.type == 'Baker':
            view = md.BakersAndSweets.objects.get(listingID=listing.id)
            view = s.BakersAndSweetsSerializer(view,many=False).data
        elif i.type == 'PhotographyPlace':
            view = md.PhotographyPlaces.objects.get(listingID=listing.id)
            view = s.PhotographyPlacesSerializer(view,many=False).data
        elif i.type == 'Decorator':
            view = md.Decorators.objects.get(listingID=listing.id)
            view = s.DecoratorsSerializer(view,many=False).data
        elif i.type == 'Photographer':
            view = md.Photographers.objects.get(listingID=listing.id)
            view = s.PhotographersSerializer(view,many=False).data
        item = {'id':i.id,'listing':listingserializer.data,'type':i.type,'view':view,'pictures':pictures}
        items.append(item)
    return Response({'status':'success','cart':items})

@api_view(['POST'])
@permission_classes([AllowAny])
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
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
def AddListItem(request):
    if request.data.get('functionId') != 'None':
        functionId = request.data.get('functionId')
        function = md.Functions.objects.get(id=functionId)
    eventId = request.data.get('eventId')
    event = md.Events.objects.get(id=eventId)
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    if request.data.get('functionId') != 'None':
        checklist = md.CheckList(functionId=function,eventId=event,description=item,isChecked=ischecked)
    else:
        checklist = md.CheckList(eventId=event,description=item,isChecked=ischecked)
    checklist.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
def UpdateListItem(request):
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    id = request.data.get('id')
    checklist = md.CheckList.objects.get(id=id)
    checklist.isChecked = ischecked
    checklist.description = item
    checklist.save(update_fields=['isChecked','description'])
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def getHomeImages(request):
    images = md.HomePageImages.objects.all()
    serializer = s.HomePageImagesSerializer(images,many=True)
    return Response({'status':'success','images':serializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def resendOTPEmail(request):
    email = request.data.get('email')
    otp = request.data.get('otp')
    subject = 'OTP for Taqreeb'
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
    subject = 'The OTP for Taqreeb'
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
@permission_classes([AllowAny])
def BusinessOwnerSignup(request):
    userid = request.data.get('id')
    businessName = request.data.get('businessName')
    username = request.data.get('username')
    cnic = request.data.get('cnic')
    cnicFront = request.data.get('cnicFront')
    cnicBack = request.data.get('cnicBack')
    description = request.data.get('description')
    user = md.User.objects.get(id=userid)
    if md.BusinessOwner.objects.filter(userID=userid).exists():
        return Response({'status':'error', 'message': 'Business Owner Already Exists'}) 
    owner = md.BusinessOwner(userID=user,CNICFront=cnicFront,CNICBack=cnicBack,businessName=businessName,businessUsername=username,Description=description,cnic=cnic)
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
@permission_classes([AllowAny])
def AccountInfoPage(request,id):
    userid = id
    user = md.User.objects.filter(id=userid).first()
    serializer = s.UserSerializer(user)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([AllowAny])
def ListingsPage(request,id):
    listings = md.Listing.objects.filter(BusinessOwnerID=id)
    serializer = s.ListingSerializer(listings,many=True)
    return Response({'status':'success','listings':serializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
def AddListing(request):
    userid = request.data.get('userid')
    name = request.data.get('name')
    description = request.data.get('description')
    category = str(request.data.get('category'))
    location = request.data.get('location')
    pricemin = request.data.get('priceMin')
    pricemax = request.data.get('priceMax')
    pictures = request.FILES.getlist('pictures')
    packages = request.data.get('packages')
    addons = request.data.get('addons')
    print(request.data)
    userid = md.User.objects.get(id=userid).id
    userid = md.BusinessOwner.objects.get(userID=userid)
    avgprice = (int(pricemax)+int(pricemin))/2
    listing = md.Listing(ownerID=userid,name=name,description=description,type=category,location=location,priceMin=pricemin,priceMax=pricemax,basicPrice=avgprice)
    listingId = listing.save()
    listingId = md.Listing.objects.filter(ownerID=userid).last().id
    listingId = md.Listing.objects.get(id=listingId)
    category = category.replace(' ','')
    if category == 'Venue':
        view = md.Venue(catering=request.data.get('catering'),guestminAllowed=request.data.get('guestminAllowed'),guestmaxAllowed=request.data.get('guestmaxAllowed'),staff=request.data.get('staff'),venueType=request.data.get('venueType'),listingID=listingId)
    elif category == 'Salon':
        view = md.Salons(listingId=listingId)
    elif category == 'Parlour':
        view = md.Parlors(listingId=listingId)
    elif category == 'PhotographyPlace':
        view = md.PhotographyPlaces(listingID=listingId,type=request.data.get('type'))
    elif category == 'Decorator':
        view = md.Decorators(listingId=listingId,decorType=request.data.get('decorType'),catering=request.data.get('catering'),staff=request.data.get('staff'))
    elif category == 'Photographer':
        view = md.Photographers(listingId=listingId,portfolioLink=request.data.get('portfolioLink'))
    elif category == 'Caterer':
        view = md.Caterers(listingId=listingId,serviceType=request.data.get('serviceType'),cateringOptions=request.data.get('cateringOptions'),staff=request.data.get('staff'),expertise=request.data.get('expertise'))
    elif category == 'CarRenter':
        view = md.CarRenters(listingID=listingId,serviceType=request.data.get('serviceType'))
    elif category == 'BakerandSweet':
        view = md.BakersAndSweets(listingID=listingId)
    elif category == 'VideoEditor':
        view = md.VideoEditors(listingId=listingId,portfolioLink=request.data.get('portfolioLink'))
    elif category == 'GraphicDesigner':
        view = md.GraphicDesigners(listingId=listingId,portfolioLink=request.data.get('portfolioLink'))
    view.save()
    
    print(pictures)
    for i in pictures:
        filestorage = FileSystemStorage()
        filePath = filestorage.save(f'uploads/listings/{category}/{listingId}.png', i)
        md.PicturesListings(listingId=listingId,picturePath=filestorage.url(filePath)).save()            
    packages = json.loads(packages) if packages else []
    print('Addons: ',packages)
    if packages:
        for i in packages:
            md.Packages(listingId=listingId,name=i['name'],price=i['price'],description=i['details']).save()
    addons = json.loads(addons) if addons else []
    if addons:
        for i in addons:
            if i['perhead'] == "Yes":
                md.AddOns(perType=i['headtype'],isPer=True,listingId=listingId,name=i['name'],price=i['price']).save()
            else:
                md.AddOns(isPer=False,listingId=listingId,name=i['name'],price=i['price']).save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
def EditAccountInfoPage(request):
    userid = request.data.get('userid')
    firstName = request.data.get('firstName')
    profilePicture = request.data.get('profilePicture')
    gender = request.data.get('gender')
    city = request.data.get('city')
    lastname = request.data.get('lastName')
    user = md.User.objects.get(id=userid)
    user.firstName = firstName
    user.lastName = lastname
    user.gender = gender
    user.city = city
    if profilePicture:
        filestorage = FileSystemStorage()
        filePath = filestorage.save(f'uploads/users/profilePicture/{user.id}.png', profilePicture)
        user.profilePicture = filestorage.url(filePath)   
        user.save(update_fields=["profilePicture",'firstName','lastName','gender','city'])
    else:
        user.save(update_fields=['firstName','lastName','gender','city'])
    return Response({'status':'success'})

@api_view(['POST'])
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
@permission_classes([AllowAny])
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
def UserLogin(request):
    password = request.data.get('password')
    contactType = request.data.get('contactType')
    if contactType=='email':
        contact = request.data.get('email')
        UserLogin = md.UserLogin(password=password,email=contact)
    else:   
        contact = request.data.get('contactNumber')
        UserLogin = md.UserLogin(password=password,contactNumber=contact)
    
    UserLogin.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
def EditFunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
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
@permission_classes([AllowAny])
def CreateFunction(request):
    name= request.data.get('Function Name')
    budget = request.data.get('Budget')
    type = request.data.get('Type')
    date = request.data.get('Date')
    guestsmin = request.data.get('guest min')
    guestsmax = request.data.get('guest max')
    EventId = int(request.data.get('Event Id'))
    event = md.Events.objects.get(id=EventId)
    try:
        CreateFunction = md.Functions(name=name, eventId = event, type=type, budget=budget,date=date,guestsmin=guestsmin,guestsmax=guestsmax)
        CreateFunction.save()
        return Response({'status':'success'})
    except Exception as e:
        print(e)
        return Response({'status':'error'})

@api_view(['GET'])
@permission_classes([AllowAny])
def EventDetails(request,eventId):
    EventDetail = md.Events.objects.get(id=eventId)
    serializer = s.EventsSerializer(EventDetail,many=False)
    Function = md.Functions.objects.filter(eventId=eventId)
    serializer2 = s.FunctionsSerializer(Function,many=True)
    return Response({'status':'success','EventDetail':serializer.data,'Functions':serializer2.data})

@api_view(['POST'])
@permission_classes([AllowAny])
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
    return Response({'status': 'success'})

@api_view(['POST'])
@permission_classes([AllowAny])
def CreateEvent(request):
    userId = request.data.get('userId')
    name = request.data.get('Event Name')
    type = request.data.get('Event Type')
    date = request.data.get('Date')
    location = request.data.get('Location')
    description = request.data.get('description')
    themeColor = request.data.get('Theme')
    budget = request.data.get('Budget')
    guestmin= request.data.get('guestmin')
    guestmax = request.data.get('guestmax')
    CreateEvent = md.Events(name=name,guestsmin=guestmin,guestsmax=guestmax,userID=userId,type=type,date=date,location=location,description=description,themeColor=themeColor,budget=budget)
    CreateEvent.save()
    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def YourEvents(request,id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer (YourEvent,many=True)
    numberofFunctions = []
    for i in YourEvent:
        functions = md.Functions.objects.filter(eventId=YourEvent.first().id)
        numberofFunctions.append(len(functions))
    return Response({'status':'success','Event':serializer.data,'nofunctions':numberofFunctions})

@api_view(['GET'])
@permission_classes([AllowAny])
def YourEventsandFunctions(request,id):
    YourEvent = md.Events.objects.filter(userID=id)
    serializer = s.EventsSerializer(YourEvent,many=True)
    for event in serializer.data:
        functions = md.Functions.objects.filter(eventId=event['id'])
        event['functions'] = s.FunctionsSerializer(functions,many=True).data
    return Response({'status':'success','Event':serializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def VenueViewPage(request, listingid):
    venueId = listingid
    Listing = md.Listing.objects.get(id = venueId)
    VenueView = md.Venue.objects.get(listingID= venueId)
    Addons = md.AddOns.objects.filter(listingId = venueId)
    Package = md.Packages.objects.filter(listingId = venueId)
    Review = md.Review.objects.filter(listingID =venueId)
    pic = md.PicturesListings.objects.filter(listingId=venueId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.VenueSerializer( VenueView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    bookedDates = md.BookedSlots.objects.filter(listingId=venueId)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    return Response({'status': 'success','VenueView': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def SalonViewPage(request, listingid):
    salonView = md.Salons.objects.get(listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.SalonsSerializer( salonView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def ParlourViewPage(request, listingid):
    parlorView = md.Parlors.objects.get(listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.ParlorsSerializer(parlorView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def BakersViewPage(request, listingid):
    bakers = md.BakersAndSweets.objects.get( listingID =listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    cakes = md.DesertItems.objects.filter(bakersId = bakers.id)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    serializer = s.BakersAndSweetsSerializer( bakers, many=False)
    cakeSerializer  = s.DesertItemsSerializer(cakes, many=True)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','View': serializer.data,'reveiewData':reviewData, 'items':cakeSerializer.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def PhotographyPlacesViewPage(request, listingid):
    PhotographerView = md.PhotographyPlaces.objects.get( listingID =listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographyPlacesSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingid)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def DecoratorDetailPage(request,listingId):
    listingDetails = md.Listing.objects.get(id=listingId)
    decoratorDetails = md.Decorators.objects.get(listingId=listingId)
    Addons = md.AddOns.objects.filter(listingId = listingId)
    Package = md.Packages.objects.filter(listingId = listingId)
    Review = md.Review.objects.filter(listingID =listingId)
    pic = md.PicturesListings.objects.filter(listingId=listingId)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.DecoratorsSerializer( decoratorDetails, many=False)
    Listingserializer = s.ListingSerializer (listingDetails, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingId)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

def CalculateReviews(data):
    reviewData = {
        'count' : len(data),
        '5': 0,
        '4': 0,
        '3': 0,
        '2': 0,
        '1': 0,
        'average':0
    }
    for i in data:
        value = int(float(i['rating']))
        if value == 5:
            reviewData['5'] += 1
        elif value == 4:
            reviewData['4'] += 1
        elif value == 3:
            reviewData['3'] += 1
        elif value == 2:
            reviewData['2'] += 1
        elif value == 1:
            reviewData['1'] += 1
    if len(data) != 0:
        reviewData['average'] = sum(int(float(data[i]['rating'])) for i in range(len(data)))/len(data)
    else:
        reviewData['average'] = 0

    return reviewData

@api_view(['GET'])
@permission_classes([AllowAny])
def PhotographerViewPage(request, listingid):
    PhotographerView = md.Photographers.objects.get( listingId = listingid)
    Listing = md.Listing.objects.get(id = listingid)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.PhotographersSerializer( PhotographerView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    bookedDates = md.BookedSlots.objects.filter(listingId=listingid)
    bookedDatesSerializer = s.BookedSlotsSerializer(bookedDates, many=True)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data,'bookedDates':bookedDatesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def CarRenterViewPage(request, listingid):
    Listing = md.Listing.objects.get(id = listingid)
    CarRenters = md.CarRenters.objects.get(listingID = listingid)
    Cars = md.Cars.objects.filter(id =CarRenters.id)
    CarsSerializer = s.CarsSerializer(Cars , many = True)
    Addons = md.AddOns.objects.filter(listingId = listingid)
    Package = md.Packages.objects.filter(listingId = listingid)
    Review = md.Review.objects.filter(listingID =listingid)
    pic = md.PicturesListings.objects.filter(listingId=listingid)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.CarRentersSerializer(CarRenters, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','VenueView': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
                    'cars':CarsSerializer.data,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def GraphicDesignerViewPage(request, listingID):
    graphicdesignerid = listingID
    Listing = md.Listing.objects.get(id= graphicdesignerid)
    GraphicDesigners = md.GraphicDesigners.objects.get(id = graphicdesignerid)
    Addons = md.AddOns.objects.filter(listingId = listingID)
    Package = md.Packages.objects.filter(listingId = listingID)
    Review = md.Review.objects.filter(listingID =listingID)
    pic = md.PicturesListings.objects.filter(listingId=listingID)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.GraphicDesignersSerializer(GraphicDesigners,many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','GraphicDesigners': serializer.data, 'Listing':Listingserializer.data, 
                     'Package': PackageSerializer.data, 'Review': ReviewSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def CatererViewPage(request,listingid):
    CatererID= listingid
    CatererView = md.Caterers.objects.get(listingId = CatererID)
    Listing = md.Listing.objects.get(id = CatererID)
    Addons = md.AddOns.objects.filter(listingId =  CatererID)
    Package = md.Packages.objects.filter(listingId =  CatererID)
    Review = md.Review.objects.filter(listingID = CatererID)
    pic = md.PicturesListings.objects.filter(listingId= CatererID)
    pictureSerializer = s.PicturesListingSerializers(pic, many=True)
    Reviewserializer = s.ReviewSerializer( Review, many = True)
    Packageserializer = s.PackagesSerializer( Package, many = True)
    Addonsserializer = s.AddOnsSerializer( Addons, many = True)
    serializer = s.CaterersSerializer( CatererView, many=False)
    Listingserializer = s.ListingSerializer (Listing, many =False)
    reviewData = CalculateReviews(Reviewserializer.data)
    return Response({'status': 'success','View': serializer.data,
                    'Addons': Addonsserializer.data,'reveiewData':reviewData,
    'Package': Packageserializer.data,'Review': Reviewserializer.data, 'Listing': Listingserializer.data,'pictures':pictureSerializer.data})

@api_view(['GET'])
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
@permission_classes([AllowAny])
def BusinessOwnerAccountInfo(request, businessownerID):
    BusinessOwner = md.BusinessOwner.objects.get(id=businessownerID)
    BusinessOwnerSerializer = s.BusinessOwnerSerializer( BusinessOwner, many = False)
    return Response({'status': 'success','BusinessOwner':BusinessOwnerSerializer.data})

@api_view(['POST'])
@permission_classes([AllowAny])
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

@api_view(['GET'])
@permission_classes([AllowAny])
def HomeCategories(request):
    categories = md.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(many = True)
    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def ViewFunction(request, FunctionId):
    Functions = md.Functions.objects.get(id = FunctionId)
    FunctionsSerializer = s.FunctionsSerializer(Functions, many=False)
    return Response ({'status':'success', 'Fuctions':FunctionsSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def HomeCategories(request):
    categories = md.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
@permission_classes([AllowAny])
def HomeListings(request):
    Listing= md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    Pictures = []
    for i in Listing:
        pic = md.PicturesListings.objects.filter(listingId=i.id)
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)

    return Response({'status':'succuess', 'HomeListing':ListingSerializer.data,'pictures':Pictures})

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
        return Response({'status':'success','refresh': str(refresh),'access': str(refresh.access_token),'userid':user.id})
    
    return Response({'status': 'error', 'message': 'Invalid Credentials'})

@api_view(['GET'])
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

@api_view(['GET'])
@permission_classes([AllowAny])
def deleteTable(request):
    md.Listing.objects.all().delete()
    return Response({'status': 'success'})