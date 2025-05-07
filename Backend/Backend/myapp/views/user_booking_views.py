from rest_framework.response import Response
from django.db.models import Q
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from datetime import timezone
from ..models.booking_models import Booking
from ..Serializers.booking_serializers import BookingSerializer,OrderSerializer
from ..models.booking_models import Cart
from ..models.user_models import UserActivity
from ..models.listing_models import Listing,Packages
from ..models.product_models import Product

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_booking(request):
    try:
        data = request.data
        serializer = BookingSerializer(data=data)
        if serializer.is_valid():
            booking = serializer.save(user=request.user)
            
            if booking.listing:
                listing = booking.listing
                booking_date_str = booking.booking_date.isoformat()
                if listing.booked_dates is None:
                    listing.booked_dates = []
                listing.booked_dates.append(booking_date_str)
                listing.save()
            
            return Response({'status': 'success', 'booking': serializer.data})
        return Response({'status': 'error', 'errors': serializer.errors}, status=400)
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_order(request):
    try:
        user = request.user
        cart = get_user_cart(user)
        cart_items = cart.items.all()
        
        if not cart_items.exists():
            return Response({'status': 'error', 'message': 'Cart is empty'}, status=400)
        
        total_amount = calculate_total_amount(cart_items)
        order_data = build_order_data(user, cart, total_amount, request)
        
        order_serializer = OrderSerializer(data=order_data)
        if not order_serializer.is_valid():
            return Response({'status': 'error', 'errors': order_serializer.errors}, status=400)

        order = order_serializer.save()
        log_user_activity(user, order, total_amount, cart_items.count())
        
        bookings = process_bookings(user, cart_items, request)
        cart.items.all().delete()

        return Response({
            'status': 'success', 
            'order': order_serializer.data,
            'bookings': bookings,
        })
        
    except Cart.DoesNotExist:
        return Response({'status': 'error', 'message': 'Cart not found'}, status=404)
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=500)


def get_user_cart(user):
    return Cart.objects.get(user=user)

def calculate_total_amount(cart_items):
    total = 0
    for item in cart_items:
        model = get_model_for_item(item)
        price = model.price if item.item_type != 'listing' else model.priceMin
        total += price * item.quantity
    return total

def build_order_data(user, cart, total_amount, request):
    return {
        'user': user.id,
        'cart': cart.id,
        'total_amount': total_amount,
        'booking_info': request.data.get('booking_info', {}),
    }

def log_user_activity(user, order, total_amount, item_count):
    UserActivity.objects.create(
        user=user,
        action='book_venue',
        metadata={
            'order_id': order.id,
            'total_amount': total_amount,
            'item_count': item_count
        }
    )

def process_bookings(user, cart_items, request):
    bookings = []
    booking_date = request.data.get('booking_date')

    for item in cart_items:
        booking_data = build_booking_data(user, item, booking_date)
        booking_serializer = BookingSerializer(data=booking_data)
        if booking_serializer.is_valid():
            booking_serializer.save()
            bookings.append(booking_serializer.data)
    return bookings

def build_booking_data(user, item, booking_date):
    model = get_model_for_item(item)
    payment_amount = model.priceMin if item.item_type == 'listing' else model.price * item.quantity
    
    data = {
        'user': user.id,
        'payment_amount': payment_amount,
        'booking_date': booking_date,
    }

    if item.item_type == 'listing':
        data['listing'] = item.item_id
    elif item.item_type == 'product':
        data['product'] = item.item_id
    elif item.item_type == 'package':
        data['package'] = item.item_id

    return data

def get_model_for_item(item):
    if item.item_type == 'listing':
        return Listing.objects.get(id=item.item_id)
    elif item.item_type == 'product':
        return Product.objects.get(id=item.item_id)
    elif item.item_type == 'package':
        return Packages.objects.get(id=item.item_id)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_bookings(request):
    bookings = Booking.objects.filter(user=request.user).order_by('-booking_date')
    serializer = BookingSerializer(bookings, many=True)
    return Response({'status': 'success', 'bookings': serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def cancel_booking(request, booking_id):
    try:
        booking = Booking.objects.get(id=booking_id, user=request.user)
        if booking.booking_date.date() < timezone.now().date():
            return Response({'status': 'error', 'message': 'Cannot cancel past bookings'}, status=400)
            
        booking.status = 'cancelled'
        booking.save()
        
        if booking.listing:
            listing = booking.listing
            booking_date_str = booking.booking_date.isoformat()
            if booking_date_str in listing.booked_dates:
                listing.booked_dates.remove(booking_date_str)
                listing.save()
        
        return Response({'status': 'success'})
    except Booking.DoesNotExist:
        return Response({'status': 'error', 'message': 'Booking not found'}, status=404)
    
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def business_bookings(request):
    listings = Listing.objects.filter(ownerID__userID=request.user)
    print(listings)
    
    packages = Packages.objects.filter(listingId__in=listings)
    print(packages)
    
    products = Product.objects.filter(listingId__in=listings)
    print(products) 

    bookings = Booking.objects.filter(
        Q(listing__in=listings) | 
        Q(package__in=packages) | 
        Q(product__in=products)
    ).order_by('-booking_date')
    
    serializer = BookingSerializer(bookings, many=True)
    return Response({'status': 'success', 'bookings': serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_booking_status(request, booking_id):
    try:
        booking = Booking.objects.get(id=booking_id)
        
        if not (
            (booking.listing and booking.listing.ownerID.userID == request.user) or
            (booking.package and booking.package.listingId.ownerID.userID == request.user) or
            (booking.product and booking.product.listingId.ownerID.userID == request.user)
        ):
            return Response({'status': 'error', 'message': 'Unauthorized'}, status=403)
            
        new_status = request.data.get('status')
        if new_status not in [choice[0] for choice in Booking.STATUS_CHOICES]:
            return Response({'status': 'error', 'message': 'Invalid status'}, status=400)
            
        booking.status = new_status
        booking.save()
        
        return Response({'status': 'success'})
    except Booking.DoesNotExist:
        return Response({'status': 'error', 'message': 'Booking not found'}, status=404)