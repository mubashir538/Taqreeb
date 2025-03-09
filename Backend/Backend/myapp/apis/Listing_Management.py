from .. import models as md
from .. import Serializers as s
import random as rd
from rest_framework.decorators import api_view, permission_classes
from django.conf import settings
from django.core.files.storage import FileSystemStorage
from rest_framework.permissions import IsAuthenticated
from django.apps import apps
import json
import os
from rest_framework.response import Response
import inspect


def get_variable_name(var):
    callers_local_vars = inspect.currentframe().f_back.f_locals.items()
    list = [name for name, value in callers_local_vars if value is var]
    return list[0]

@api_view(['GET'])
@permission_classes([IsAuthenticated])
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
            if field.name not in ['id', 'listingID','listingId','cars']:
                field_info = {"name": field.name}
                if hasattr(field, 'choices') and field.choices:
                    # Extract only keys from choices as a list
                    field_info["choices"] = [choice[0] for choice in field.choices]
                field_data.append(field_info)
        return Response({"fields": field_data})
    except LookupError:
        return Response({"error": "Model not found"})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
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
@permission_classes([IsAuthenticated])
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
@permission_classes([IsAuthenticated])
def ListingsPage(request,id):
    listings = md.Listing.objects.filter(BusinessOwnerID=id)
    serializer = s.ListingSerializer(listings,many=True)
    return Response({'status':'success','listings':serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def AddListing(request):
    type = request.data.get('type')
    userid = request.data.get('userid')
    name = request.data.get('name')
    description = request.data.get('description')
    category = str(request.data.get('category'))
    location = request.data.get('location')
    pricemin = request.data.get('priceMin')
    print(request.data)
    pricemax = request.data.get('priceMax')
    pictures = request.FILES.getlist('pictures')
    packages = request.data.get('packages')
    addons = request.data.get('addons')
    user = md.User.objects.get(id=userid)
    avgprice = (int(pricemax)+int(pricemin))/2
    if type == 'freelancer':
        userid = md.Freelancer.objects.get(userID=userid)
        listing = md.Listing(freelancerID=userid,name=name,description=description,type=category,location=location,priceMin=pricemin,priceMax=pricemax,basicPrice=avgprice)
    else:
        userid = md.BusinessOwner.objects.get(userID=user)
        listing = md.Listing(ownerID=userid,name=name,description=description,type=category,location=location,priceMin=pricemin,priceMax=pricemax,basicPrice=avgprice)
    listingId = listing.save()
    if type == 'freelancer':
        listingId = md.Listing.objects.filter(freelancerID=userid).last().id
    else:
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
        # cars = request.data.get('cars')
        # for i in cars:
    elif category == 'BakerandSweet':
        view = md.BakersAndSweets(listingID=listingId)
    elif category == 'VideoEditor':
        view = md.VideoEditors(listingId=listingId,portfolioLink=request.data.get('portfolioLink'))
    elif category == 'GraphicDesigner':
        view = md.GraphicDesigners(listingId=listingId,portfolioLink=request.data.get('portfolioLink'))
    view.save()
    
    listId = listingId.id
    for i in pictures:
        filestorage = FileSystemStorage()
        filePath = filestorage.save(f'uploads/listings/{category}/{listId}-{i}.png', i)
        md.PicturesListings(listingId=listingId,picturePath=filestorage.url(filePath)).save()            
    packages = json.loads(packages) if packages else []
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
@permission_classes([IsAuthenticated])
def deleteListing(request):
    id = request.data.get('id')
    for i in md.PicturesListings.objects.filter(listingId=id):
        full_path = os.path.join(settings.MEDIA_ROOT, i.picturePath)
        if os.path.exists(full_path):
            os.remove(full_path)
    listing = md.Listing.objects.get(id=id).delete()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def updateListing(request):
    id = request.data.get('id')
    listing = md.Listing.objects.get(id=id)
    name = request.data.get('name')
    location = request.data.get('location')
    priceMin = request.data.get('priceMin')
    priceMax = request.data.get('priceMax')
    description = request.data.get('description')
    value= request.data.get('value')
    if name:
        listing.name = name
        listing.save(update_fields=['name'])
        return Response({'status':'success'})
    elif location:
        listing.location = location
        listing.save(update_fields=['location'])
        return Response({'status':'success'})
    elif priceMin:
        listing.priceMin = priceMin
        listing.basicPrice = int((int(listing.priceMin)+int(listing.priceMax))/2)
        listing.save(update_fields=['priceMin','basicPrice'])
        return Response({'status':'success'})
    elif priceMax:
        listing.priceMax = priceMax
        listing.basicPrice = int((int(listing.priceMin)+int(listing.priceMax))/2)
        listing.save(update_fields=['priceMax','basicPrice'])
        return Response({'status':'success'})
    elif description:
        listing.description = description
        listing.save(update_fields=['description'])
        return Response({'status':'success'})
    if not value:
        type = listing.type
    else:
        type = None
    updated = []
    if type == 'Venue':
        view = md.Venue.objects.get(listingID = listing)
        catering = request.data.get('catering')
        guestminAllowed = request.data.get('guestmin')
        guestmaxAllowed = request.data.get('guestmax')
        staff = request.data.get('staff')
        venueType = request.data.get('venuetype')
        if catering:
            view.catering = catering
            updated.append(get_variable_name(catering))
        elif guestminAllowed or guestmaxAllowed:
            view.guestminAllowed = guestminAllowed
            updated.append(get_variable_name(guestminAllowed))
            view.guestmaxAllowed = guestmaxAllowed
            updated.append(get_variable_name(guestmaxAllowed))
        elif staff:
            view.staff = staff
            updated.append(get_variable_name(staff))
        elif venueType:
            view.venueType = venueType
            updated.append(get_variable_name(venueType))
        view.save(update_fields=updated)
        return Response({'status':'success'})
    elif type == 'PhotographyPlace':
        view = md.PhotographyPlaces.objects.get(listingID = listing)
        type = request.data.get('type')
        if type:
            view.type = type
            view.save(update_fields=['type'])
        return Response({'status':'success'})
    elif type == 'Decorator':
        view = md.Decorators.objects.get(listingID = listing)
        decorType = request.data.get('decortype')
        catering = request.data.get('catering')
        staff = request.data.get('staff')
        updated = []
        if decorType:
            view.decorType = decorType
            updated.append(get_variable_name(decorType))
        elif catering:
            view.catering = catering
            updated.append(get_variable_name(catering))
        elif staff:
            view.staff = staff
            updated.append(get_variable_name(staff))
        view.save(update_fields=updated)
        return Response({'status':'success'})
    elif type == 'Photographer':
        view = md.Photographers.objects.get(listingID = listing)
        portfolioLink = request.data.get('portfoliolink')
        if portfolioLink:
            view.portfolioLink = portfolioLink
            view.save(update_fields=['portfolioLink'])
        return Response({'status':'success'})
    elif type == 'Caterer':
        view = md.Caterers.objects.get(listingID = listing)
        cateringOptions=request.data.get('cateringoptions')
        serviceType=request.data.get('servicetype')
        staff=request.data.get('staff')
        expertise=request.data.get('expertise')
        updated = []
        if cateringOptions:
            view.cateringOptions = cateringOptions
            updated.append(get_variable_name(cateringOptions))
        elif serviceType:
            view.serviceType = serviceType
            updated.append(get_variable_name(serviceType))
        elif staff:
            view.staff = staff
            updated.append(get_variable_name(staff))
        elif expertise:
            view.expertise = expertise
            updated.append(get_variable_name(expertise))
        return Response({'status':'success'})
    elif type == 'CarRenter':
        view = md.CarRenters.objects.get(listingID = listing)
        serviceType=request.data.get('servicetype')
        if serviceType:
            view.serviceType = serviceType
            view.save(update_fields=['serviceType'])
        return Response({'status':'success'})
    elif type == 'VideoEditor':
        view = md.VideoEditors.objects.get(listingID = listing)
        portfolioLink = request.data.get('portfoliolink')
        if portfolioLink:
            view.portfolioLink = portfolioLink
            view.save(update_fields=['portfolioLink'])
        return Response({'status':'success'})
    elif type == 'GraphicDesigner':
        view = md.GraphicDesigners.objects.get(listingID = listing)
        portfolioLink = request.data.get('portfoliolink')
        if portfolioLink:
            view.portfolioLink = portfolioLink
            view.save(update_fields=['portfolioLink'])
        return Response({'status':'success'})    

    operation = request.data.get('operation')
    value = request.data.get('value')
    if operation and value:
        if operation.lower() == 'add':
            if value.lower() == 'addon':
                name = request.data.get('namev')
                price = request.data.get('pricev')
                perhead = request.data.get('perheadv')
                headtype = request.data.get('headtypev')
                if perhead == "Yes":
                    md.AddOns(perType=headtype,isPer=True,listingId=listing,name=name,price=price).save()
                else:
                    md.AddOns(isPer=False,listingId=listing,name=name,price=price).save()
                return Response({'status':'success','id':md.AddOns.objects.filter(listingId=listing).last().id})
            elif value.lower() == 'package':
                name = request.data.get('namev')
                description = request.data.get('descv')
                price = request.data.get('pricev')
                md.Packages(name=name,listingId=listing,description=description,price=price).save()
                return Response({'status':'success','id':md.Packages.objects.filter(listingId=listing).last().id})
        if operation.lower() == 'delete':
            if value.lower() == 'addon':
                id = request.data.get('idv')
                addon = md.AddOns.objects.get(id=id).delete()
                return Response({'status':'success'})
            elif value.lower() == 'package':
                id = request.data.get('idv')
                md.Packages.objects.delete(id=id).delete()
                return Response({'status':'success'})
        if operation.lower() == 'edit':
            if value.lower() == 'addon':
                id = request.data.get('idv')
                addon = md.AddOns.objects.get(id=id)
                name = request.data.get('namev')
                price = request.data.get('pricev')
                addon.name = name
                addon.price = price
                addon.save(update_fields=['name','price'])
                return Response({'status':'success'})
            elif value.lower() == 'package':
                name = request.data.get('namev')
                description = request.data.get('descv')
                price = request.data.get('pricev')
                id = request.data.get('idv')
                pack = md.Packages.objects.get(id=id)
                pack.name = name
                pack.description = description
                pack.price = price
                pack.save(update_fields=['name','description','price'])
                return Response({'status':'success'})
        
    return Response({'status':'error'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def HomeListings(request):
    Listing= md.Listing.objects.all()
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    Pictures = []
    Listings = ListingSerializer.data[:]
    rd.shuffle(Listings)
    for i in Listings:
        pic = md.PicturesListings.objects.filter(listingId=i['id'])
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)
    return Response({'status':'success', 'HomeListing':Listings, 'pictures':Pictures})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def YourListings(request,id,type):
    if type == 'freelancer':
        user = md.Freelancer.objects.get(userID=id)
        Listing= md.Listing.objects.filter(freelancerID = user)
    else:
        user = md.BusinessOwner.objects.get(userID=id)
        Listing= md.Listing.objects.filter(ownerID = user)
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    Pictures = []
    for i in Listing:
        pic = md.PicturesListings.objects.filter(listingId=i.id)
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)

    return Response({'status':'succuess', 'YourListings':ListingSerializer.data,'pictures':Pictures})

