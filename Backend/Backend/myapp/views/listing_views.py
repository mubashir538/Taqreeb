import json
from django.apps import apps
from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from .. import models as m
from .. import Serializers as s
from myapp.models import UserActivity
from rest_framework.pagination import PageNumberPagination
from django.conf import settings
import os
import random as rd
from .helper_methods import create_view_for_category,create_listing,save_listing_pictures,save_packages,save_products,save_addons,get_picture,get_view_data,get_variable_name


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_listing_details(request, type):
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
        model = apps.get_model('myapp', model_name)
        field_data = []
        
        for field in model._meta.get_fields():
            if field.name not in ['id', 'listingID','listingId','cars']:
                field_info = {"name": field.name, "type": field.get_internal_type()}
                
                if hasattr(field, 'choices') and field.choices:
                    field_info["choices"] = [choice[0] for choice in field.choices]
                
                field_data.append(field_info)
                
        return Response({"fields": field_data})
    except LookupError:
        return Response({"error": "Model not found"})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_list_item(request):
    if request.data.get('functionId') != 'None':
        function_id = request.data.get('functionId')
        function = m.Functions.objects.get(id=function_id)
    event_id = request.data.get('eventId')
    event = m.Events.objects.get(id=event_id)
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    if request.data.get('functionId') != 'None':
        checklist = m.CheckList(functionId=function,eventId=event,description=item,isChecked=ischecked)
    else:
        checklist = m.CheckList(eventId=event,description=item,isChecked=ischecked)
    checklist.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_list_item(request):
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    lid = request.data.get('id')
    checklist = m.CheckList.objects.get(id=lid)
    checklist.isChecked = ischecked
    checklist.description = item
    checklist.save(update_fields=['isChecked','description'])
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_list_item(request):
    lid = request.data.get('id')
    checklist = m.CheckList.objects.get(id=lid).delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listings_page(request,id):
    listings = m.Listing.objects.filter(BusinessOwnerID=id,status='active')
    serializer = s.ListingSerializer(listings,many=True)
    return Response({'status':'success','listings':serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_listing(request):
    try:
        data = request.data
        listing_type = data.get('type')
        user_id = data.get('userid')
        category = str(data.get('category')).replace(' ', '')
        view_data = json.loads(data.get('viewData')) if data.get('viewData') else data.get('viewData', {})
        print(data)
        print(view_data)
        print(view_data['venueType'])
        required = ['userid', 'name', 'description', 'category', 'location', 'priceMin', 'priceMax']
        if not all([data.get(field) for field in required]):
            return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)

        user = m.User.objects.get(id=user_id)
        listing = create_listing(data, user, listing_type, category)

        create_view_for_category(category, view_data, listing)

        save_listing_pictures(category, listing, request.FILES.getlist('pictures'))
        
        save_packages(listing, data.get('packages'))
        
        save_products(listing, data.get('products'))
        
        save_addons(listing, data.get('addons'))

        m.ReviewDetails(listingID=listing).save()

        UserActivity.objects.create(
        user=request.user,
        action='vendor_add_service',
        metadata={
            'listing_id': listing.id,
            'listing_name': listing.name,
            'listing_type': listing.type
        },
        timestamp=now()
    )

        return Response({'status': 'success', 'listing_id': listing.id})

    except json.JSONDecodeError:
        return Response({'status': 'error', 'message': 'Invalid JSON data'}, status=400)
    except m.User.DoesNotExist:
        return Response({'status': 'error', 'message': 'User not found'}, status=404)
    except Exception as e:
        print(e)
        return Response({'status': 'error', 'message': str(e)}, status=500)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_listing(request):
    lid = request.data.get('id')
    for i in m.PicturesListings.objects.filter(listingId=lid):
        full_path = os.path.join(settings.MEDIA_ROOT, i.picturePath)
        if os.path.exists(full_path):
            os.remove(full_path)
    m.Listing.objects.get(id=lid).delete()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def updateListing(request):
    id = request.data.get('id')
    listing = m.Listing.objects.get(id=id,status='active')
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
        view = m.Venue.objects.get(listingID = listing)
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
        view = m.PhotographyPlaces.objects.get(listingID = listing)
        type = request.data.get('type')
        if type:
            view.type = type
            view.save(update_fields=['type'])
        return Response({'status':'success'})
    elif type == 'Decorator':
        view = m.Decorators.objects.get(listingID = listing)
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
        view = m.Photographers.objects.get(listingID = listing)
        portfolioLink = request.data.get('portfoliolink')
        if portfolioLink:
            view.portfolioLink = portfolioLink
            view.save(update_fields=['portfolioLink'])
        return Response({'status':'success'})
    elif type == 'Caterer':
        view = m.Caterers.objects.get(listingID = listing)
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
        view = m.CarRenters.objects.get(listingID = listing)
        serviceType=request.data.get('servicetype')
        if serviceType:
            view.serviceType = serviceType
            view.save(update_fields=['serviceType'])
        return Response({'status':'success'})
    elif type == 'VideoEditor':
        view = m.VideoEditors.objects.get(listingID = listing)
        portfolioLink = request.data.get('portfoliolink')
        if portfolioLink:
            view.portfolioLink = portfolioLink
            view.save(update_fields=['portfolioLink'])
        return Response({'status':'success'})
    elif type == 'GraphicDesigner':
        view = m.GraphicDesigners.objects.get(listingID = listing)
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
                    m.AddOns(perType=headtype,isPer=True,listingId=listing,name=name,price=price).save()
                else:
                    m.AddOns(isPer=False,listingId=listing,name=name,price=price).save()
                return Response({'status':'success','id':m.AddOns.objects.filter(listingId=listing).last().id})
            elif value.lower() == 'package':
                name = request.data.get('namev')
                description = request.data.get('descv')
                price = request.data.get('pricev')
                m.Packages(name=name,listingId=listing,description=description,price=price).save()
                return Response({'status':'success','id':m.Packages.objects.filter(listingId=listing).last().id})
        if operation.lower() == 'delete':
            if value.lower() == 'addon':
                id = request.data.get('idv')
                addon = m.AddOns.objects.get(id=id).delete()
                return Response({'status':'success'})
            elif value.lower() == 'package':
                id = request.data.get('idv')
                m.Packages.objects.delete(id=id).delete()
                return Response({'status':'success'})
        if operation.lower() == 'edit':
            if value.lower() == 'addon':
                id = request.data.get('idv')
                addon = m.AddOns.objects.get(id=id)
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
                pack = m.Packages.objects.get(id=id)
                pack.name = name
                pack.description = description
                pack.price = price
                pack.save(update_fields=['name','description','price'])
                
                return Response({'status':'success'})
            UserActivity.objects.create(
    user=request.user,
    action='content_updated',
    metadata={
        'listing_id': listing.id,
        'listing_name': listing.name,
        'listing_type': listing.type,
    },
    timestamp=now()
)
        
    return Response({'status':'error'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listing_with_views(request):
    listings = m.Listing.objects.filter(status='active').prefetch_related(
        'pictureslistings_set',
        'venue_set',
        'caterers_set',
        'carrenters_set',
        'decorators_set',
        'photographyplaces_set',
        'photographers_set',
        'videoeditors_set',
        'graphicdesigners_set'
    )

    listing_serializer = s.ListingSerializer(listings, many=True)
    listings_data = listing_serializer.data[:]
    rd.shuffle(listings_data)

    for listing in listings_data:
        listing_id = listing['id']
        listing['pictures'] = get_picture(listing_id)

        view_data = get_view_data(listing_id)
        if view_data:
            listing['View'] = view_data

    return Response({
        'status': 'success',
        'listings': listings_data
    })


@api_view(['GET'])
@permission_classes([AllowAny])
def unified_search(request):
    search_query = request.GET.get('q', '')
    if search_query:
            UserActivity.objects.create(
            user=request.user,
            action='search',
            metadata={'search_query': search_query},
            timestamp=now()
        )

    category = request.GET.get('category', 'All')
    min_price = request.GET.get('min_price')
    max_price = request.GET.get('max_price')
    min_rating = request.GET.get('min_rating')
    max_rating = request.GET.get('max_rating')
    location = request.GET.get('location')
    date = request.GET.get('date')
    content_type = request.GET.get('type', 'listings')
    
    if content_type == 'listings':
        queryset = m.Listing.objects.filter(status='active').prefetch_related(
            'pictureslistings_set',
            'venue_set',
            'caterers_set',
            'carrenters_set',
            'decorators_set',
            'photographyplaces_set',
            'photographers_set',
            'videoeditors_set',
            'graphicdesigners_set'
        )
        
        if search_query:
            queryset = queryset.filter(name__icontains=search_query)
        if category != 'All':
            queryset = queryset.filter(type=category)
        if location:
            queryset = queryset.filter(location__icontains=location)
        if min_price and max_price:
            queryset = queryset.filter(basicPrice__range=(min_price, max_price))
        
        serializer = s.ListingSerializer(queryset, many=True)
        results = serializer.data
        for listing in results:
            listing_id = listing['id']
            listing['pictures'] = get_picture(listing_id)
            view_data = get_view_data(listing_id)
            if view_data:
                listing['View'] = view_data
    
    elif content_type == 'packages':
        queryset = m.Packages.objects.all().prefetch_related('picturespackages_set')
        
        if search_query:
            queryset = queryset.filter(name__icontains=search_query)
        if min_price and max_price:
            queryset = queryset.filter(price__range=(min_price, max_price))
        if category != 'All':
            queryset = queryset.filter(listingId__type=category)
        
        serializer = s.PackagesSerializer(queryset, many=True)
        results = serializer.data
    
    elif content_type == 'products':
        queryset = m.Product.objects.all().prefetch_related('picturesproducts_set')
        
        if search_query:
            queryset = queryset.filter(name__icontains=search_query)
        if min_price and max_price:
            queryset = queryset.filter(price__range=(min_price, max_price))
        if category != 'All':
            queryset = queryset.filter(listingId__type=category)
        
        serializer = s.ProductsSerializer(queryset, many=True)
        results = serializer.data
    
    return Response({
        'status': 'success',
        'results': results,
        'count': len(results)
    })

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def HomeListings(request):
    paginator = PageNumberPagination()
    paginator.page_size = request.GET.get('page_size', 10)
    
    listings = m.Listing.objects.filter(status='active').order_by('?') 
    result_page = paginator.paginate_queryset(listings, request)
    
    serializer = s.ListingSerializer(result_page, many=True)
    listings_data = serializer.data
    
    pictures = []
    for listing in listings_data:
        pic = m.PicturesListings.objects.filter(listingId=listing['id'])
        serializer = s.PicturesListingSerializers(pic, many=True)
        pictures.append(serializer.data)
    
    return paginator.get_paginated_response({
        'status': 'success',
        'HomeListing': listings_data,
        'pictures': pictures
    })

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_packages(request):
    paginator = PageNumberPagination()
    paginator.page_size = request.GET.get('page_size', 10)
    
    packages = m.Packages.objects.all().order_by('?')
    result_page = paginator.paginate_queryset(packages, request)
    
    serializer = s.PackagesSerializer(result_page, many=True)
    packages_data = serializer.data
    
    return paginator.get_paginated_response({
        'status': 'success',
        'HomePackages': packages_data
    })

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_products(request):
    paginator = PageNumberPagination()
    paginator.page_size = request.GET.get('page_size', 10)
    
    products = m.Product.objects.all().order_by('?')
    result_page = paginator.paginate_queryset(products, request)
    
    serializer = s.ProductsSerializer(result_page, many=True)
    products_data = serializer.data
    
    return paginator.get_paginated_response({
        'status': 'success',
        'HomeProducts': products_data
    })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def YourListings(request,id,type):
    if type == 'freelancer':
        user = m.Freelancer.objects.get(userID=id)
        Listing= m.Listing.objects.filter(freelancerID = user,status='active')
    else:
        user = m.BusinessOwner.objects.get(userID=id)
        Listing= m.Listing.objects.filter(ownerID = user,status='active')
    ListingSerializer= s.ListingSerializer(Listing, many=True)
    Pictures = []
    for i in Listing:
        pic = m.PicturesListings.objects.filter(listingId=i.id)
        serializer = s.PicturesListingSerializers(pic, many=True)
        Pictures.append(serializer.data)

    return Response({'status':'succuess', 'YourListings':ListingSerializer.data,'pictures':Pictures})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_booked_dates(request, listing_id):
    try:
        listing = m.Listing.objects.get(id=listing_id,status='active')
        if request.user.id != listing.ownerID.userID.id:
            return Response({'status': 'error', 'message': 'Unauthorized'}, status=403)
        
        dates = request.data.get('dates', [])
        listing.booked_dates = dates
        listing.save()
        return Response({'status': 'success'})
    
    except m.Listing.DoesNotExist:
        return Response({'status': 'error', 'message': 'Listing not found'}, status=404)