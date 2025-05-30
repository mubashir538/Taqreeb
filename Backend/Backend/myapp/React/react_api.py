from rest_framework.decorators import api_view, permission_classes,authentication_classes
from .react_authentication import ReactJWTAuthentication
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .react_authentication import ReactTokenObtainPairSerializer
from .react_models import ReactUser
from .react_permission import IsReactUser
from .react_serializer import ReactUserSerializer, ReactUserCreateSerializer
from django.contrib.auth.hashers import check_password
from rest_framework import status
from ..models.user_models import UserActivity,User
from ..models.listing_models import  BusinessOwner,Freelancer,Listing
from ..models.booking_models import  Order
from ..models.transaction_models import  Payment
from ..models.review_models import  Review
from ..models.event_models import  Events
from django.utils.timezone import make_aware
from datetime import time, timedelta, date
import datetime
from django.db.models import Avg, Count, Sum
from datetime import datetime, date
from django.utils import timezone
from django.core.paginator import Paginator,EmptyPage
from ..Serializers.listing_serializers import ListingSerializer,PackagesSerializer,ProductsSerializer,PicturesListingSerializers
from ..Serializers.service_serializers import VenueSerializer,CaterersSerializer,AddOnsSerializer
from ..models.listing_types_models import Venue,Caterers,CarRenters,Decorators,PhotographyPlaces,Photographers,VideoEditors,GraphicDesigners
from ..models.listing_models import Packages,AddOns,PicturesListings
from ..models.product_models import Product
from django.db.models import Q

@api_view(['POST'])
@permission_classes([AllowAny])
def ReactUserLogin(request):
    email = request.data.get('email')
    password = request.data.get('password')
    
    user = ReactUser.objects.filter(email=email).first()
    
    if user and check_password(password, user.password):
        refresh = ReactTokenObtainPairSerializer.get_token(user)
        return Response({
            'status': 'success',
            'refresh': str(refresh),
            'access': str(refresh.access_token),
            'user': ReactUserSerializer(user).data
        })
    
    return Response({'status': 'error', 'message': 'Invalid credentials'}, status=400)


@api_view(['POST'])
@permission_classes([AllowAny])
def create_react_user(request):
    serializer = ReactUserCreateSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response({
            'status': 'success',
            'message': 'React user created successfully',
            'user': serializer.data
        }, status=status.HTTP_201_CREATED)
    return Response({
        'status': 'error',
        'message': 'Invalid data',
        'errors': serializer.errors
    }, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def react_user_profile(request):
    """
    Test endpoint to verify React user authentication
    Returns user data if properly authenticated
    """
    try:
        if not isinstance(request.user, ReactUser):
            return Response(
                {"error": "Invalid user type - ReactUser required"},
                status=403
            )
        print('Authentication successful')
        serializer = ReactUserSerializer(request.user)
        
        return Response({
            "status": "success",
            "message": "You are properly authenticated as a React user",
            "user": serializer.data,
            "auth_headers": {
                "used_authorization": request.headers.get('Authorization'),
            }
        })
    except Exception as e:
        return Response(
            {"error": str(e)},
            status=500
        )

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_most_used_services(request):
    now = timezone.now()
    data = []
    for month in range(1, 8):  
        count = UserActivity.objects.filter(
            action='service_click',
            timestamp__year=now.year,
            timestamp__month=month
        ).count()
        month_name = date(1900, month, 1).strftime('%b') 
        data.append({'month': month_name, 'count': count})

    return Response({'status': 'success', 'data': data})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_top_categories(request):
    activities = UserActivity.objects.filter(action='category_click')
    category_counts = {}

    for activity in activities:
        cat_name = activity.metadata.get('category', 'Unknown')
        category_counts[cat_name] = category_counts.get(cat_name, 0) + 1

    top_categories = sorted(
        [{'name': k, 'value': v} for k, v in category_counts.items()],
        key=lambda x: x['value'],
        reverse=True
    )[:4]

    return Response({'status': 'success', 'data': top_categories})


@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_recent_activity(request):
    now = timezone.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    today_end = now.replace(hour=23, minute=59, second=59, microsecond=999999)
    pakistan_timezone = pytz.timezone('Asia/Karachi')
    orders = Order.objects.filter(created_at__gte=today_start, created_at__lte=today_end)
    reviews = Review.objects.filter(date__gte=today_start, date__lte=today_end)
    users = User.objects.filter(date_joined__gte=today_start, date_joined__lte=today_end)

    activities = []

    for order in orders:
        user_name = f"{order.user.firstName} {order.user.lastName}"
        local_time = order.created_at.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"User {user_name} placed a new order of amount ${order.total_amount} at {time_formatted}"
        })

    for review in reviews:
        user_name = f"{review.userID.firstName} {review.userID.lastName}"
        local_time = review.date.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"User {user_name} posted a review: \"{review.review}\" at {time_formatted}"
        })

    for user in users:
        full_name = f"{user.firstName} {user.lastName}"
        local_time = user.date_joined.astimezone(pakistan_timezone)
        time_formatted = local_time.strftime('%I:%M %p')
        activities.append({
            'timestamp': local_time,
            'description': f"New user registered: {full_name} at {time_formatted}"
        })

    activities_sorted = sorted(activities, key=lambda x: x['timestamp'], reverse=True)

    final_data = [activity['description'] for activity in activities_sorted[:10]]

    return Response({'status': 'success', 'data': final_data})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_top_search_terms(request):
    now = timezone.now()
    start_of_month = now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)

    search_activities = UserActivity.objects.filter(
        action='search',
        timestamp__gte=start_of_month,
        timestamp__lte=now
    )

    search_counts = {}

    for activity in search_activities:
        search_query = activity.metadata.get('search_query', '').lower()
        if search_query:
            search_counts[search_query] = search_counts.get(search_query, 0) + 1

    sorted_terms = sorted(search_counts.items(), key=lambda x: x[1], reverse=True)[:10]
    data = [{'term': term, 'count': count} for term, count in sorted_terms]

    return Response({'status': 'success', 'data': data})


@api_view(['GET']) 
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_most_searched(request):
    today = timezone.now().date()
    days = [today - timedelta(days=i) for i in range(6, -1, -1)]  
    counts = []

    for day in days:
        start_datetime = make_aware(datetime.combine(day, time.min))
        end_datetime = make_aware(datetime.combine(day, time.max))


        count = UserActivity.objects.filter(
            action='search',
            timestamp__range=(start_datetime, end_datetime)
        ).count()

        counts.append({'day': day.strftime('%a'), 'count': count})

    return Response({'status': 'success', 'data': counts})

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def dashboard_statistics(request):
    now = timezone.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)

    daily_active_users = UserActivity.objects.filter(timestamp__gte=today_start).values('user').distinct().count()
    searches_today = UserActivity.objects.filter(action='search', timestamp__gte=today_start).count()
    new_users_today = User.objects.filter(date_joined__gte=today_start).count()
    average_session_time = 25  
    total_users = User.objects.count()
    total_events = Events.objects.count()
    total_vendors = BusinessOwner.objects.count() + Freelancer.objects.count()
    total_revenue = Payment.objects.filter(status='completed').aggregate(Sum('amount'))['amount__sum'] or 0
    active_services = Listing.objects.filter(status='active').count()
    satisfaction_rate = Review.objects.aggregate(Avg('rating'))['rating__avg'] or 0
    satisfaction_rate = round((satisfaction_rate / 5) * 100)

    return Response({
        'userStats': {
            'dailyActiveUsers': daily_active_users,
            'searchesToday': searches_today,
            'newUsersToday': new_users_today,
            'averageSessionTime': f"{average_session_time}m",
            'totalUsers': total_users,
        },
        'eventStats': {
            'totalEvents': total_events
        },
        'vendorStats': {
            'totalVendors': total_vendors,
            'totalRevenue': f"${int(total_revenue/1000)}K" if total_revenue else "$0",
            'activeServices': active_services,
            'satisfactionRate': f"{satisfaction_rate}%",
        }
    })

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_approvals_stats(request):
    total_pending = Listing.objects.filter(status='pending').count()
    pending_by_type = Listing.objects.filter(status='pending').values('type').annotate(count=Count('id'))
    week_ago = timezone.now() - timezone.timedelta(days=7)
    recent_pending = Listing.objects.filter(
        status='pending', 
        created_at__gte=week_ago
    ).count()
    
    month_ago = timezone.now() - timezone.timedelta(days=30)
    oldest_pending = Listing.objects.filter(
        status='pending', 
        created_at__lte=month_ago
    ).count()
    
    return Response({
        'pendingStats': {
            'totalPending': total_pending,
            'pendingByType': {item['type']: item['count'] for item in pending_by_type},
            'recentPending': recent_pending,
            'oldestPending': oldest_pending,
        }
    })

from django.forms.models import model_to_dict  

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_listings(request):
    listing_type = request.query_params.get('type', None)
    search_query = request.query_params.get('search', None)
    page = int(request.query_params.get('page', 1))
    page_size = int(request.query_params.get('page_size', 10))
    BASE_URL = request.build_absolute_uri('/')[:-1]
    queryset = Listing.objects.filter(status='pending').select_related(
        'ownerID__userID', 
        'freelancerID__userID'
    ).prefetch_related(
        'pictureslistings_set',
        'packages_set',
        'packages_set__picturespackages_set',
        'product_set',
        'product_set__picturesproducts_set',
        'addons_set'
    )
    
    if listing_type:
        queryset = queryset.filter(type=listing_type)
    
    if search_query:
        queryset = queryset.filter(
            Q(name__icontains=search_query) |
            Q(description__icontains=search_query) |
            Q(location__icontains=search_query)
        )
    
    def get_service_details(listing):
        service_details = None
        if listing.type == 'Venue':
            service_details = Venue.objects.filter(listingId=listing).first()
        elif listing.type == 'Caterers':
            service_details = Caterers.objects.filter(listingId=listing).first()
        elif listing.type == 'Decorator':
            service_details = Decorators.objects.filter(listingId=listing).first()
        elif listing.type == 'Photographer':
            service_details = Photographers.objects.filter(listingId=listing).first()
        elif listing.type == 'VideoEditor':
            service_details = VideoEditors.objects.filter(listingId=listing).first()
        elif listing.type == 'GraphicDesigner':
            service_details = GraphicDesigners.objects.filter(listingId=listing).first()
        elif listing.type == 'CarRenter':
            service_details = CarRenters.objects.filter(listingId=listing).first()
        elif listing.type == 'PhotographyPlace':
            service_details = PhotographyPlaces.objects.filter(listingId=listing).first()
        
        if service_details:
            return model_to_dict(service_details, exclude=['id', 'listingId'])
        return None

    paginator = Paginator(queryset, page_size)
    try:
        listings = paginator.page(page)
    except EmptyPage:
        listings = paginator.page(paginator.num_pages)
    
    listing_data = []
    
    for listing in listings:
        owner_name = None
        if listing.ownerID:
            owner_name = listing.ownerID.businessName
        elif listing.freelancerID:
            owner_name = listing.freelancerID.businessName or \
                        f"{listing.freelancerID.userID.firstName} {listing.freelancerID.userID.lastName}"
        
        listing_images = []
        for pic in listing.pictureslistings_set.all():
            if pic.picturePath:
                clean_path = pic.picturePath.lstrip('/')
                listing_images.append(f"{BASE_URL}/app/{clean_path}")
        
        listing_data.append({
            'id': listing.id,
            'name': listing.name,
            'type': listing.type,
            'location': listing.location,
            'description': listing.description,
            'priceMin': listing.priceMin,
            'priceMax': listing.priceMax,
            'basicPrice': listing.basicPrice,
            'rating': float(listing.rating),
            'ratingCount': listing.ratingCount,
            'status': listing.status,
            'created_at': listing.created_at,
            'booked_dates': listing.booked_dates,
            'owner_name': owner_name,
            'images': listing_images,
            'packages': [{
                'id': pkg.id,
                'name': pkg.name,
                'description': pkg.description,
                'price': pkg.price,
                'images': [f"{BASE_URL}/app/{pic.picturePath.lstrip('/')}" 
                          for pic in pkg.picturespackages_set.all() if pic.picturePath]
            } for pkg in listing.packages_set.all()],
            'products': [{
                'id': prod.id,
                'name': prod.name,
                'description': prod.description,
                'price': float(prod.price),
                'quantity': prod.quantity,
                'images': [f"{BASE_URL}/app/{pic.picturePath.lstrip('/')}" 
                          for pic in prod.picturesproducts_set.all() if pic.picturePath]
            } for prod in listing.product_set.all()],
            'addons': [{
                'id': addon.id,
                'name': addon.name,
                'price': addon.price,
                'isPer': addon.isPer,
                'perType': addon.perType
            } for addon in listing.addons_set.all()],
            'serviceDetails': get_service_details(listing)
        })
    
    return Response({
        'listings': listing_data,
        'pagination': {
            'total': paginator.count,
            'page': page,
            'page_size': page_size,
            'total_pages': paginator.num_pages,
        }
    })


@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_listing_detail(request, pk):
    try:
        listing = Listing.objects.get(pk=pk, status='pending')
    except Listing.DoesNotExist:
        return Response({'error': 'Listing not found'}, status=404)
    listing_serializer = ListingSerializer(listing)
    service_details = None
    if listing.type == 'Venue':
        service_details = Venue.objects.filter(listingId=listing).first()
    elif listing.type == 'Caterers':
        service_details = Caterers.objects.filter(listingId=listing).first()
        service_serializer = None
    if service_details:
        if listing.type == 'Venue':
            service_serializer = VenueSerializer(service_details)
        elif listing.type == 'Caterers':
            service_serializer = CaterersSerializer(service_details)
    packages = Packages.objects.filter(listingId=listing)
    products = Product.objects.filter(listingId=listing)
    
    return Response({
        'listing': listing_serializer.data,
        'serviceDetails': service_serializer.data if service_serializer else None,
        'packages': PackagesSerializer(packages, many=True).data,
        'products': ProductsSerializer(products, many=True).data,
        'addOns': AddOnsSerializer(AddOns.objects.filter(listingId=listing), many=True).data,
        'images': PicturesListingSerializers(
            PicturesListings.objects.filter(listingId=listing), 
            many=True
        ).data,
    })

@api_view(['POST'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def update_listing_status(request, pk):
    try:
        listing = Listing.objects.get(pk=pk, status='pending')
    except Listing.DoesNotExist:
        return Response({'error': 'Listing not found'}, status=404)
    
    new_status = request.data.get('status')
    if new_status not in ['active', 'rejected']:
        return Response({'error': 'Invalid status'}, status=400)
    
    listing.status = new_status
    listing.save()
    
    if new_status == 'active':
        pass
    
    return Response({
        'success': True,
        'message': f'Listing status updated to {new_status}',
        'newStatus': new_status
    })

@api_view(['POST'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def bulk_update_listing_status(request):
    listing_ids = request.data.get('ids', [])
    new_status = request.data.get('status')
    
    if not listing_ids:
        return Response({'error': 'No listings selected'}, status=400)
    
    if new_status not in ['active', 'rejected']:
        return Response({'error': 'Invalid status'}, status=400)
    
    updated = Listing.objects.filter(
        pk__in=listing_ids,
        status='pending'
    ).update(status=new_status)
    
    return Response({
        'success': True,
        'message': f'Updated {updated} listings to {new_status}',
        'count': updated
    })

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_vendors_stats(request):
    pending_business = BusinessOwner.objects.filter(status='pending').count()
    pending_freelancers = Freelancer.objects.filter(status='pending').count()
    total_pending = pending_business + pending_freelancers
    
    return Response({
        'pendingStats': {
            'totalPending': total_pending,
            'pendingByType': {
                'Business Owners': pending_business,
                'Freelancers': pending_freelancers
            }
        }
    })

@api_view(['GET'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def pending_vendors(request):
    pending_business = BusinessOwner.objects.filter(status='pending').select_related('userID')
    pending_freelancers = Freelancer.objects.filter(status='pending').select_related('userID')
    vendor_data = []
    BASE_URL = request.build_absolute_uri('/')[:-1]  
    
    for business in pending_business:
        vendor_data.append({
            'id': business.id,
            'type': 'Business Owner',
            'name': business.businessName,
            'user': {
                'firstName': business.userID.firstName,
                'lastName': business.userID.lastName,
                'email': business.userID.email,
                'contactNumber': business.userID.contactNumber,  
                'city': business.userID.city,
                'profilePicture': f"{BASE_URL}/app{business.userID.profilePicture}" if business.userID.profilePicture else None,
            },
            'description': business.Description,
            'cnic': business.cnic,
            'cnicFront': f"{BASE_URL}/app{business.CNICFront}" if business.CNICFront else None,
            'cnicBack': f"{BASE_URL}/app{business.CNICBack}" if business.CNICBack else None,
            'profilePic': f"{BASE_URL}/app{business.profilepic}" if business.profilepic else None,
            'created_at': business.userID.date_joined,
            'balance': business.balance,
            'status': business.status
        })
    
    for freelancer in pending_freelancers:
        vendor_data.append({
            'id': freelancer.id,
            'type': 'Freelancer',
            'name': freelancer.businessName or f"{freelancer.userID.firstName} {freelancer.userID.lastName}",
            'user': {
                'firstName': freelancer.userID.firstName,
                'lastName': freelancer.userID.lastName,
                'email': freelancer.userID.email,
                'contactNumber': freelancer.userID.contactNumber,  
                'city': freelancer.userID.city,
                'profilePicture': freelancer.userID.profilePicture,
            },
            'description': freelancer.Description,
            'cnic': freelancer.cnic,
            'portfolioLink': freelancer.portfolioLink,
            'profilePic': f"{BASE_URL}{freelancer.profilepic}" if freelancer.profilepic else None,
            'created_at': freelancer.userID.date_joined,
            'balance': freelancer.balance,
            'status': freelancer.status
        })
    page = int(request.query_params.get('page', 1))
    page_size = int(request.query_params.get('page_size', 10))
    paginator = Paginator(vendor_data, page_size)
    
    try:
        paginated_vendors = paginator.page(page)
    except EmptyPage:
        paginated_vendors = paginator.page(paginator.num_pages)
    
    return Response({
        'vendors': list(paginated_vendors),
        'pagination': {
            'total': paginator.count,
            'page': page,
            'page_size': page_size,
            'total_pages': paginator.num_pages,
        }
    })

@api_view(['POST'])
@authentication_classes([ReactJWTAuthentication])
@permission_classes([IsReactUser])
def bulk_update_vendor_status(request):
    vendor_ids = request.data.get('ids', [])
    vendor_type = request.data.get('vendor_type')  
    new_status = request.data.get('status')
    
    if not vendor_ids:
        return Response({'error': 'No vendors selected'}, status=400)
    
    if new_status not in ['Approved', 'Rejected']:
        return Response({'error': 'Invalid status'}, status=400)
    
    updated = 0
    if vendor_type == 'business':
        updated = BusinessOwner.objects.filter(
            id__in=vendor_ids,
            status='pending'
        ).update(status=new_status)
    elif vendor_type == 'freelancer':
        updated = Freelancer.objects.filter(
            id__in=vendor_ids,
            status='pending'
        ).update(status=new_status)
    
    return Response({
        'success': True,
        'message': f'Updated {updated} vendors to {new_status}',
        'count': updated
    })