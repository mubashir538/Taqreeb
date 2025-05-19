import json
from django.apps import apps
from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.pagination import PageNumberPagination
from django.conf import settings
import os
import random as rd
from .helper_methods import create_view_for_category,create_listing,save_listing_pictures,save_packages,save_products,save_addons,get_picture,get_view_data,get_variable_name
from ..models.listing_types_models import Venue,Caterers,CarRenters,Decorators,PhotographyPlaces,Photographers,VideoEditors,GraphicDesigners
from ..models.event_models import Events,Functions,CheckList
from ..models.user_models import User
from ..models.listing_models import Listing,PicturesListings,Packages,AddOns
from ..Serializers.listing_serializers import ListingSerializer,PicturesListingSerializers,PackagesSerializer,ProductsSerializer
from ..models.user_models import UserActivity
from ..models.review_models import ReviewDetails
from ..models.product_models import Product
from ..models.business_models import BusinessOwner,Freelancer

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
            if field.name not in ['id', 'listingId','listingId','cars']:
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
        function = Functions.objects.get(id=function_id)
    event_id = request.data.get('eventId')
    event = Events.objects.get(id=event_id)
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    if request.data.get('functionId') != 'None':
        checklist = CheckList(functionId=function,eventId=event,description=item,isChecked=ischecked)
    else:
        checklist = CheckList(eventId=event,description=item,isChecked=ischecked)
    checklist.save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_list_item(request):
    item = request.data.get('item')
    ischecked = request.data.get('ischecked')
    lid = request.data.get('id')
    checklist = CheckList.objects.get(id=lid)
    checklist.isChecked = ischecked
    checklist.description = item
    checklist.save(update_fields=['isChecked','description'])
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_list_item(request):
    lid = request.data.get('id')
    CheckList.objects.get(id=lid).delete()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listings_page(request,id):
    listings = Listing.objects.filter(BusinessOwnerID=id,status='active')
    serializer = ListingSerializer(listings,many=True)
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
        required = ['userid', 'name', 'description', 'category', 'location', 'priceMin', 'priceMax']
        if not all([data.get(field) for field in required]):
            return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)

        user = User.objects.get(id=user_id)
        listing = create_listing(data, user, listing_type, category)

        create_view_for_category(category, view_data, listing)

        save_listing_pictures(category, listing, request.FILES.getlist('pictures'))
        
        save_packages(listing, data.get('packages'))
        
        save_products(listing, data.get('products'))
        
        save_addons(listing, data.get('addons'))

        ReviewDetails(listingId=listing).save()

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
    except User.DoesNotExist:
        return Response({'status': 'error', 'message': 'User not found'}, status=404)
    except Exception as e:
        print(e)
        return Response({'status': 'error', 'message': str(e)}, status=500)
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def delete_listing(request):
    lid = request.data.get('id')
    for i in PicturesListings.objects.filter(listingId=lid):
        full_path = os.path.join(settings.MEDIA_ROOT, i.picturePath)
        if os.path.exists(full_path):
            os.remove(full_path)
    Listing.objects.get(id=lid).delete()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_listing_fields(listing, data):
    fields = {
        'name': 'name',
        'location': 'location',
        'priceMin': 'priceMin',
        'priceMax': 'priceMax',
        'description': 'description'
    }
    for key, attr in fields.items():
        if data.get(key):
            setattr(listing, attr, data[key])
            if key in ['priceMin', 'priceMax']:
                listing.basicPrice = int((int(listing.priceMin.replace(',', ''))) + int(listing.priceMax.replace(',', '')) / 2)
                listing.save(update_fields=[attr, 'basicPrice'])
            else:
                listing.save(update_fields=[attr])
            return True
    return False


def _update_venue_fields(view, data):
    updated = []
    if data.get('catering'):
        view.catering = data['catering']
        updated.append('catering')
    if data.get('guestmin') or data.get('guestmax'):
        view.guestminAllowed = data.get('guestmin')
        view.guestmaxAllowed = data.get('guestmax')
        updated += ['guestminAllowed', 'guestmaxAllowed']
    if data.get('staff'):
        view.staff = data['staff']
        updated.append('staff')
    if data.get('venuetype'):
        view.venueType = data['venuetype']
        updated.append('venueType')
    view.save(update_fields=updated)


def _update_type_specific_fields(listing, data):
    model_map = {
        'Venue': (Venue, _update_venue_fields),
        'PhotographyPlace': (PhotographyPlaces, lambda v, d: _simple_update(v, d, 'type')),
        'Decorator': (Decorators, lambda v, d: _bulk_update(v, d, ['decortype', 'catering', 'staff'])),
        'Photographer': (Photographers, lambda v, d: _simple_update(v, d, 'portfoliolink')),
        'Caterer': (Caterers, lambda v, d: _bulk_update(v, d, ['cateringoptions', 'servicetype', 'staff', 'expertise'])),
        'CarRenter': (CarRenters, lambda v, d: _simple_update(v, d, 'servicetype')),
        'VideoEditor': (VideoEditors, lambda v, d: _simple_update(v, d, 'portfoliolink')),
        'GraphicDesigner': (GraphicDesigners, lambda v, d: _simple_update(v, d, 'portfoliolink')),
    }

    model, updater = model_map.get(listing.type, (None, None))
    if model and updater:
        view = model.objects.get(listingId=listing)
        updater(view, data)
        return True
    return False


def _simple_update(view, data, key):
    value = data.get(key)
    if value:
        setattr(view, key, value)
        view.save(update_fields=[key])


def _bulk_update(view, data, keys):
    updated = []
    for key in keys:
        if data.get(key):
            setattr(view, key, data[key])
            updated.append(key)
    if updated:
        view.save(update_fields=updated)

def _handle_addon_package_operations(request, listing):
    operation = request.data.get('operation', '').lower()
    value = request.data.get('value', '').lower()

    if operation == 'add':
        return _add_addon_or_package(request, listing, value)
    elif operation == 'delete':
        return _delete_addon_or_package(request, value)
    elif operation == 'edit':
        return _edit_addon_or_package(request, value)
    return None


def _add_addon_or_package(request, listing, value):
    if value == 'addon':
        AddOns(
            isPer=(request.data.get('perheadv') == "Yes"),
            perType=request.data.get('headtypev'),
            listingId=listing,
            name=request.data.get('namev'),
            price=request.data.get('pricev')
        ).save()
        addon_id = AddOns.objects.filter(listingId=listing).last().id
        return Response({'status': 'success', 'id': addon_id})
    elif value == 'package':
        Packages(
            listingId=listing,
            name=request.data.get('namev'),
            description=request.data.get('descv'),
            price=request.data.get('pricev')
        ).save()
        pack_id = Packages.objects.filter(listingId=listing).last().id
        return Response({'status': 'success', 'id': pack_id})


def _delete_addon_or_package(request, value):
    idv = request.data.get('idv')
    if value == 'addon':
        AddOns.objects.filter(id=idv).delete()
    elif value == 'package':
        Packages.objects.filter(id=idv).delete()
    return Response({'status': 'success'})


def _edit_addon_or_package(request, value):
    idv = request.data.get('idv')
    if value == 'addon':
        addon = AddOns.objects.get(id=idv)
        addon.name = request.data.get('namev')
        addon.price = request.data.get('pricev')
        addon.save(update_fields=['name', 'price'])
        return Response({'status': 'success'})
    elif value == 'package':
        pack = Packages.objects.get(id=idv)
        pack.name = request.data.get('namev')
        pack.description = request.data.get('descv')
        pack.price = request.data.get('pricev')
        pack.save(update_fields=['name', 'description', 'price'])
        return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def listing_with_views(request):
    listings = Listing.objects.filter(status='active').prefetch_related(
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

    listing_serializer = ListingSerializer(listings, many=True)
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

    content_type = request.GET.get('type', 'listings')
    
    filters = {
        'query': search_query,
        'category': request.GET.get('category', 'All'),
        'min_price': int(str(request.GET.get('min_price')).replace('.', ''))if request.GET.get('min_price') else  None,
        'max_price': int(str(request.GET.get('max_price')).replace('.', '')) if request.GET.get('max_price') else None,
        'location': request.GET.get('location'),
        'date': request.GET.get('date'),
        'min_rating': request.GET.get('min_rating'),
        'max_rating': request.GET.get('max_rating'),
    }

    if content_type == 'listings':
        results = _search_listings(filters)
    elif content_type == 'packages':
        results = _search_packages(filters)
    elif content_type == 'products':
        results = _search_products(filters)
    else:
        results = []

    return Response({
        'status': 'success',
        'results': results,
        'count': len(results)
    })

def _search_listings(filters):
    queryset = Listing.objects.filter(status='active').prefetch_related(
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

    if filters['query']:
        queryset = queryset.filter(name__icontains=filters['query'])
    if filters['category'] != 'All':
        queryset = queryset.filter(type=filters['category'])
    if filters['location']:
        queryset = queryset.filter(location__icontains=filters['location'])
    if filters['min_price'] and filters['max_price']:
        queryset = queryset.filter(basicPrice__range=(filters['min_price'], filters['max_price']))

    serializer = ListingSerializer(queryset, many=True)
    results = serializer.data

    for listing in results:
        listing_id = listing['id']
        listing['pictures'] = get_picture(listing_id)
        view_data = get_view_data(listing_id)
        if view_data:
            listing['View'] = view_data

    return results


def _search_packages(filters):
    queryset = Packages.objects.all().prefetch_related('picturespackages_set')

    if filters['query']:
        queryset = queryset.filter(name__icontains=filters['query'])
    if filters['min_price'] and filters['max_price']:
        queryset = queryset.filter(price__range=(filters['min_price'], filters['max_price']))
    if filters['category'] != 'All':
        queryset = queryset.filter(listingId__type=filters['category'])

    serializer = PackagesSerializer(queryset, many=True)
    return serializer.data

def _search_products(filters):
    queryset = Product.objects.all().prefetch_related('picturesproducts_set')

    if filters['query']:
        queryset = queryset.filter(name__icontains=filters['query'])
    if filters['min_price'] and filters['max_price']:
        queryset = queryset.filter(price__range=(filters['min_price'], filters['max_price']))
    if filters['category'] != 'All':
        queryset = queryset.filter(listingId__type=filters['category'])

    serializer = ProductsSerializer(queryset, many=True)
    return serializer.data

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_listings(request):
    listings = Listing.objects.filter(status='active').order_by('?')
    paginated_listings, paginator = _paginate_listings(request, listings)
    
    listings_data = ListingSerializer(paginated_listings, many=True).data
    pictures = _get_listing_pictures(listings_data)

    return paginator.get_paginated_response({
        'status': 'success',
        'HomeListing': listings_data,
        'pictures': pictures
    })

def _paginate_listings(request, queryset):
    paginator = PageNumberPagination()
    paginator.page_size = request.GET.get('page_size', 10)
    result_page = paginator.paginate_queryset(queryset, request)
    return result_page, paginator

def _get_listing_pictures(listings_data):
    pictures = []
    for listing in listings_data:
        pic_qs = PicturesListings.objects.filter(listingId=listing['id'])
        pic_serializer = PicturesListingSerializers(pic_qs, many=True)
        pictures.append(pic_serializer.data)
    return pictures

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_packages(request):
    paginator = PageNumberPagination()
    paginator.page_size = request.GET.get('page_size', 10)
    
    packages = Packages.objects.all().order_by('?')
    result_page = paginator.paginate_queryset(packages, request)
    
    serializer = PackagesSerializer(result_page, many=True)
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
    
    products = Product.objects.all().order_by('?')
    result_page = paginator.paginate_queryset(products, request)
    
    serializer = ProductsSerializer(result_page, many=True)
    products_data = serializer.data
    
    return paginator.get_paginated_response({
        'status': 'success',
        'HomeProducts': products_data
    })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def your_listings(request, id, type):
    user = _get_user_by_type(id, type)
    listings = _get_user_listings(user, type)
    
    listing_data = ListingSerializer(listings, many=True).data

    pictures = _get_listing_pictures(listing_data)

    return Response({
        'status': 'success',
        'YourListings': listing_data,
        'pictures': pictures
    })
def _get_user_by_type(user_id, user_type):
    if user_type == 'freelancer':
        return Freelancer.objects.get(userID=user_id)
    return BusinessOwner.objects.get(userID=user_id)
def _get_user_listings(user, user_type):
    if user_type == 'freelancer':
        return Listing.objects.filter(freelancerID=user, status='active')
    return Listing.objects.filter(ownerID=user, status='active')


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_booked_dates(request, listing_id):
    try:
        listing = Listing.objects.get(id=listing_id,status='active')
        if request.user.id != listing.ownerID.userID.id:
            return Response({'status': 'error', 'message': 'Unauthorized'}, status=403)
        
        dates = request.data.get('dates', [])
        listing.booked_dates = dates
        listing.save()
        return Response({'status': 'success'})
    
    except Listing.DoesNotExist:
        return Response({'status': 'error', 'message': 'Listing not found'}, status=404)