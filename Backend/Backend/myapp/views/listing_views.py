import json
from django.apps import apps
from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.pagination import PageNumberPagination
from ..paginations import RecommendationPagination
from django.conf import settings
import os
from rest_framework.exceptions import ValidationError
from rest_framework import status
import random as rd
from .helper_methods import create_view_for_category,create_listing,save_listing_pictures,save_packages,save_products,save_addons,get_picture,get_view_data,get_variable_name
from ..models.listing_types_models import Venue,Caterers,CarRenters,Decorators,PhotographyPlaces,Photographers,VideoEditors,GraphicDesigners
from ..models.event_models import Events,Functions,CheckList
from ..models.user_models import User
from ..models.listing_models import Listing,PicturesListings,Packages,AddOns,PicturesPackages
from ..Serializers.listing_serializers import ListingSerializer,PicturesListingSerializers,PackagesSerializer,ProductsSerializer
from ..models.user_models import UserActivity
from ..models.review_models import ReviewDetails
from ..models.product_models import Product
from ..models.business_models import BusinessOwner,Freelancer
import random
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
def update_listing_fields(request):
    try:
        data = request.data
        listing_id = data.get('id')
        
        if not listing_id:
            return Response({'error': 'Listing ID is required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            listing = Listing.objects.get(id=listing_id)
        except Listing.DoesNotExist:
            return Response({'error': 'Listing not found'}, status=status.HTTP_404_NOT_FOUND)

        if 'operation' in data and 'value' in data:
            operation = data.get('operation', '').lower()
            value = data.get('value', '').lower()
            
            if value == 'package':
                return _handle_package_with_files(request, listing, operation)
            if value in ['addon', 'package', 'product']:
                return _handle_item_operations(request, listing, operation, value)

        basic_fields_updated = _update_basic_listing_fields(listing, data)
        
        type_specific_updated = _update_type_specific_fields(listing, data)

        if basic_fields_updated or type_specific_updated:
            return Response({'status': 'success'})
        else:
            return Response({'error': 'No valid fields to update'}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        print(str(e))
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def _handle_package_with_files(request, listing, operation):
    try:
        data = request.POST
        files = request.FILES

        if operation == 'add':
            package = Packages(
                listingId=listing,
                name=data.get('namev'),
                description=data.get('descv'),
                price=data.get('pricev')
            )
            package.full_clean()
            package.save()

            pictures = []
            for file in files.getlist('pictures'):
                picture = PicturesPackages(
                    packageId=package,
                    picturePath=file
                )
                picture.full_clean()
                picture.save()
                pictures.append({
                    'id': picture.id,
                    'picturePath': picture.picturePath.url
                })

            return Response({
                'status': 'success',
                'id': package.id,
                'name': package.name,
                'description': package.description,
                'price': str(package.price),
                'pictures': pictures
            }, status=status.HTTP_201_CREATED)

        elif operation == 'edit':
            if 'idv' not in data:
                return Response({'error': 'Package ID is required'}, status=status.HTTP_400_BAD_REQUEST)
            
            try:
                package = Packages.objects.get(id=data['idv'], listingId=listing)
                if 'namev' in data:
                    package.name = data['namev']
                if 'descv' in data:
                    package.description = data['descv']
                if 'pricev' in data:
                    package.price = data['pricev']
                package.full_clean()
                package.save()

                pictures = list(PicturesPackages.objects.filter(packageId=package))
                if files.getlist('pictures'):
                    for file in files.getlist('pictures'):
                        picture = PicturesPackages(
                            packageId=package,
                            picturePath=file
                        )
                        picture.full_clean()
                        picture.save()
                        pictures.append(picture)

                picture_data = [{
                    'id': p.id,
                    'picturePath': p.picturePath.url
                } for p in pictures]

                return Response({
                    'status': 'success',
                    'id': package.id,
                    'name': package.name,
                    'description': package.description,
                    'price': str(package.price),
                    'pictures': picture_data
                })

            except Packages.DoesNotExist:
                return Response({'error': 'Package not found'}, status=status.HTTP_404_NOT_FOUND)
    
        return Response({'error': 'Invalid operation'}, status=status.HTTP_400_BAD_REQUEST)

    except ValidationError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(e)
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def _handle_item_operations(request, listing, operation, item_type):
    try:
        data = request.data
        
        if operation == 'add':
            return _add_item(listing, data, item_type)
        elif operation == 'edit':
            return _edit_item(listing, data, item_type)
        elif operation == 'delete':
            return _delete_item(listing, data, item_type)
        else:
            return Response({'error': 'Invalid operation'}, status=status.HTTP_400_BAD_REQUEST)
            
    except ValidationError as e:
        return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        print(str(e))
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

def _add_item(listing, data, item_type):
    required_fields = {
        'addon': ['namev', 'pricev'],
        'package': ['namev', 'pricev', 'descv'],
        'product': ['namev', 'pricev', 'descv']
    }[item_type]
    
    if not all(field in data for field in required_fields):
        return Response({'error': 'Missing required fields'}, status=status.HTTP_400_BAD_REQUEST)
    
    if item_type == 'addon':
        addon = AddOns(
            listingId=listing,
            name=data['namev'],
            price=str(data['pricev']).replace(',',''),
            isPer=data.get('perheadv', '').lower() == 'yes',
            perType=str(data.get('headtypev', ''))
        )
        addon.full_clean()
        addon.save()
        
        return Response({
            'status': 'success',
            'id': addon.id,
            'name': addon.name,
            'price': str(addon.price),
            'isPer': addon.isPer,
            'perType': addon.perType or ''
        }, status=status.HTTP_201_CREATED)
        
    elif item_type == 'package':
        package = Packages(
            listingId=listing,
            name=data['namev'],
            description=data['descv'],
            price=str(data['pricev']).replace(',','')
        )
        package.full_clean()
        package.save()
        
        return Response({
            'status': 'success',
            'id': package.id,
            'name': package.name,
            'description': package.description,
            'price': str(package.price)
        }, status=status.HTTP_201_CREATED)
        
    elif item_type == 'product':
        product = Product(
            listingId=listing,
            name=data['namev'],
            description=data['descv'],
            price=str(data['pricev']).replace(',','')
        )
        product.full_clean()
        product.save()
        
        return Response({
            'status': 'success',
            'id': product.id,
            'name': product.name,
            'description': product.description,
            'price': str(product.price)
        }, status=status.HTTP_201_CREATED)

def _edit_item(listing, data, item_type):
    if 'idv' not in data:
        return Response({'error': f'{item_type.capitalize()} ID is required'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    try:
        if item_type == 'addon':
            addon = AddOns.objects.get(id=data['idv'], listingId=listing)
            if 'namev' in data:
                addon.name = data['namev']
            if 'pricev' in data:
                addon.price = str(data['pricev']).replace(',','')
            if 'perheadv' in data:
                addon.isPer = data['perheadv'].lower() == 'yes'
            if 'headtypev' in data:
                addon.perType = data['headtypev']
            addon.full_clean()
            addon.save()
            
            return Response({
                'status': 'success',
                'id': addon.id,
                'name': addon.name,
                'price': str(addon.price),
                'isPer': addon.isPer,
                'perType': addon.perType or ''
            })
            
        elif item_type == 'package':
            package = Packages.objects.get(id=data['idv'], listingId=listing)
            if 'namev' in data:
                package.name = data['namev']
            if 'descv' in data:
                package.description = data['descv']
            if 'pricev' in data:
                package.price = str(data['pricev']).replace(',','')
            package.full_clean()
            package.save()
            
            return Response({
                'status': 'success',
                'id': package.id,
                'name': package.name,
                'description': package.description,
                'price': str(package.price)
            })
            
        elif item_type == 'product':
            product = Product.objects.get(id=data['idv'], listingId=listing)
            if 'namev' in data:
                product.name = data['namev']
            if 'descv' in data:
                product.description = data['descv']
            if 'pricev' in data:
                product.price = str(data['pricev']).replace(',','')
            product.full_clean()
            product.save()
            
            return Response({
                'status': 'success',
                'id': product.id,
                'name': product.name,
                'description': product.description,
                'price': str(product.price)
            })
            
    except (AddOns.DoesNotExist, Packages.DoesNotExist, Product.DoesNotExist):
        return Response({'error': f'{item_type.capitalize()} not found'}, 
                      status=status.HTTP_404_NOT_FOUND)

def _delete_item(listing, data, item_type):
    if 'idv' not in data:
        return Response({'error': f'{item_type.capitalize()} ID is required'}, 
                      status=status.HTTP_400_BAD_REQUEST)
    
    try:
        if item_type == 'addon':
            AddOns.objects.get(id=data['idv'], listingId=listing).delete()
        elif item_type == 'package':
            Packages.objects.get(id=data['idv'], listingId=listing).delete()
        elif item_type == 'product':
            Product.objects.get(id=data['idv'], listingId=listing).delete()
            
        return Response({'status': 'success'})
        
    except (AddOns.DoesNotExist, Packages.DoesNotExist, Product.DoesNotExist):
        return Response({'error': f'{item_type.capitalize()} not found'}, 
                      status=status.HTTP_404_NOT_FOUND)

def _update_basic_listing_fields(listing, data):
    fields_map = {
        'name': 'name',
        'location': 'location',
        'priceMin': 'priceMin',
        'priceMax': 'priceMax',
        'description': 'description'
    }
    
    updated = False
    update_fields = []
    
    for key, attr in fields_map.items():
        if key in data:
            value = data[key]
            if key in ['priceMin', 'priceMax']:
                value = str(value).replace(',', '').strip()
                if not value.isdigit():
                    continue
            setattr(listing, attr, value)
            update_fields.append(attr)
            updated = True
    
    if updated:
        if 'priceMin' in update_fields or 'priceMax' in update_fields:
            try:
                price_min = int(listing.priceMin.replace(',', '')) if listing.priceMin else 0
                price_max = int(listing.priceMax.replace(',', '')) if listing.priceMax else 0
                listing.basicPrice = (price_min + price_max) // 2
                update_fields.append('basicPrice')
            except (ValueError, AttributeError):
                pass
        
        listing.save(update_fields=update_fields)
    
    return updated


def _update_venue_fields(venue, data):
    updated_fields = []
    
    if 'catering' in data:
        venue.catering = data['catering']
        updated_fields.append('catering')
    
    if 'guestmin' in data:
        venue.guestminAllowed = data['guestmin']
        updated_fields.append('guestminAllowed')
    
    if 'guestmax' in data:
        venue.guestmaxAllowed = data['guestmax']
        updated_fields.append('guestmaxAllowed')
    
    if 'staff' in data:
        venue.staff = data['staff']
        updated_fields.append('staff')
    
    if 'venuetype' in data:
        venue.venueType = data['venuetype']
        updated_fields.append('venueType')
    
    if updated_fields:
        venue.save(update_fields=updated_fields)
    
    return bool(updated_fields)


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

    model_info = model_map.get(listing.type)
    if not model_info:
        return False

    model_class, updater = model_info
    try:
        view = model_class.objects.get(listingId=listing)
        return updater(view, data)
    except model_class.DoesNotExist:
        return False


def _simple_update(view, data, field_name):
    if field_name in data:
        setattr(view, field_name, data[field_name])
        view.save(update_fields=[field_name])
        return True
    return False

def _bulk_update(view, data, field_names):
    updated_fields = []
    for field_name in field_names:
        if field_name in data:
            setattr(view, field_name, data[field_name])
            updated_fields.append(field_name)
    
    if updated_fields:
        view.save(update_fields=updated_fields)
        return True
    return False
    
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

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def home_listings(request):
#     listings = Listing.objects.filter(status='active').order_by('?')
#     paginated_listings, paginator = _paginate_listings(request, listings)
    
#     listings_data = ListingSerializer(paginated_listings, many=True).data
#     pictures = _get_listing_pictures(listings_data)

#     return paginator.get_paginated_response({
#         'status': 'success',
#         'HomeListing': listings_data,
#         'pictures': pictures
#     })

# def _paginate_listings(request, queryset):
#     paginator = PageNumberPagination()
#     paginator.page_size = request.GET.get('page_size', 10)
#     result_page = paginator.paginate_queryset(queryset, request)
#     return result_page, paginator

# def _get_listing_pictures(listings_data):
#     pictures = []
#     for listing in listings_data:
#         pic_qs = PicturesListings.objects.filter(listingId=listing['id'])
#         pic_serializer = PicturesListingSerializers(pic_qs, many=True)
#         pictures.append(pic_serializer.data)
#     return pictures


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def home_listings(request):
    user = request.user
    excluded_ids = request.GET.get('excluded_ids', '')
    excluded_ids = [int(id) for id in excluded_ids.split(',') if id.isdigit()] if excluded_ids else []
    
    # Get user's category preferences
    user_preferences = get_user_preferences(user.id)
    
    # Get all active listings excluding already shown ones
    base_query = Listing.objects.filter(status='active').exclude(id__in=excluded_ids)
    
    if not user_preferences:
        # No user history - return random order
        listings = base_query.order_by('?')
    else:
        # Get preferred categories (70% of results)
        preferred_categories = [cat for cat, _ in user_preferences.most_common(3)]
        preferred_query = base_query.filter(type__in=preferred_categories)
        
        # Get other categories (30% of results)
        other_query = base_query.exclude(type__in=preferred_categories)
        
        # Calculate counts for each portion
        total_count = base_query.count()
        preferred_count = min(int(0.7 * total_count), preferred_query.count())
        other_count = min(total_count - preferred_count, other_query.count())
        
        # Get listings from each portion
        preferred_listings = list(preferred_query.order_by('?')[:preferred_count])
        other_listings = list(other_query.order_by('?')[:other_count])
        
        # Combine and shuffle while maintaining ratio
        listings = preferred_listings + other_listings
        random.shuffle(listings)
    
    # Paginate the results
    paginator = RecommendationPagination()
    paginated_listings = paginator.paginate_queryset(listings, request)
    
    # Prepare response data
    listings_data = ListingSerializer(paginated_listings, many=True).data
    pictures = _get_listing_pictures(listings_data)
    
    # Get IDs of listings being returned to exclude in next request
    returned_ids = [listing['id'] for listing in listings_data]
    
    response = paginator.get_paginated_response({
        'status': 'success',
        'HomeListing': listings_data,
        'pictures': pictures,
        'excluded_ids': ','.join(map(str, excluded_ids + returned_ids))
    })
    
    return response

def get_user_preferences(user_id):
    """
    Analyze user activity to determine category preferences.
    Returns a Counter object with categories and their weights.
    """
    from collections import Counter
    
    # Get all relevant user activities
    activities = UserActivity.objects.filter(
        user_id=user_id,
        action__in=['category_click', 'category_view_duration']
    ).exclude(metadata__category__isnull=True)
    
    category_weights = Counter()
    
    for activity in activities:
        category = activity.metadata.get('category')
        if not category:
            continue
            
        # Different weights for different actions
        if activity.action == 'category_click':
            weight = 1
        elif activity.action == 'category_view_duration':
            # Weight based on time spent (1 point per 30 seconds)
            time_spent = activity.metadata.get('time_spent_seconds', 0)
            weight = max(1, time_spent // 30)
        
        category_weights[category] += weight
    
    return category_weights

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