@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_booking(request):
    try:
        data = request.data
        serializer = s.BookingSerializer(data=data)
        if serializer.is_valid():
            booking = serializer.save(user=request.user)
            
            # Update booked dates if it's a listing
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
        cart = m.Cart.objects.get(user=user)
        cart_items = cart.items.all()
        
        if not cart_items.exists():
            return Response({'status': 'error', 'message': 'Cart is empty'}, status=400)
        
        # Calculate total amount
        total_amount = 0
        bookings = []
        
        for item in cart_items:
            if item.item_type == 'listing':
                listing = m.Listing.objects.get(id=item.item_id)
                total_amount += listing.priceMin * item.quantity
            elif item.item_type == 'product':
                product = m.Product.objects.get(id=item.item_id)
                total_amount += product.price * item.quantity
            elif item.item_type == 'package':
                package = m.Packages.objects.get(id=item.item_id)
                total_amount += package.price * item.quantity
        
        # Create order
        order_data = {
            'user': user.id,
            'cart': cart.id,
            'total_amount': total_amount,
            'booking_info': request.data.get('booking_info', {}),
        }
        
        order_serializer = s.OrderSerializer(data=order_data)
        if order_serializer.is_valid():
            order = order_serializer.save()
            
                # Log user activity: Booked Venue
            m.UserActivity.objects.create(
            user=user,
            action='book_venue',
            metadata={
                'order_id': order.id,
                'total_amount': total_amount,
                'item_count': cart_items.count()
            }
        )

            # Create bookings for each item
            for item in cart_items:
                booking_data = {
                    'user': user.id,
                    'payment_amount': 0,  # Will be updated based on payment
                    'booking_date': request.data.get('booking_date'),
                }
                
                if item.item_type == 'listing':
                    booking_data['listing'] = item.item_id
                    booking_data['payment_amount'] = m.Listing.objects.get(id=item.item_id).priceMin
                elif item.item_type == 'product':
                    booking_data['product'] = item.item_id
                    booking_data['payment_amount'] = m.Product.objects.get(id=item.item_id).price * item.quantity
                elif item.item_type == 'package':
                    booking_data['package'] = item.item_id
                    booking_data['payment_amount'] = m.Packages.objects.get(id=item.item_id).price
                
                booking_serializer = s.BookingSerializer(data=booking_data)
                if booking_serializer.is_valid():
                    booking_serializer.save()
                    bookings.append(booking_serializer.data)
            
            # Clear the cart
            cart.items.all().delete()
            
            return Response({
                'status': 'success', 
                'order': order_serializer.data,
                'bookings': bookings,
            })
        return Response({'status': 'error', 'errors': order_serializer.errors}, status=400)
    except m.Cart.DoesNotExist:
        return Response({'status': 'error', 'message': 'Cart not found'}, status=404)
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=500)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_bookings(request):
    bookings = m.Booking.objects.filter(user=request.user).order_by('-booking_date')
    serializer = s.BookingSerializer(bookings, many=True)
    return Response({'status': 'success', 'bookings': serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def cancel_booking(request, booking_id):
    try:
        booking = m.Booking.objects.get(id=booking_id, user=request.user)
        
        # Check if booking can be cancelled (not past date)
        if booking.booking_date.date() < timezone.now().date():
            return Response({'status': 'error', 'message': 'Cannot cancel past bookings'}, status=400)
            
        booking.status = 'cancelled'
        booking.save()
        
        # If it's a listing booking, remove from booked_dates
        if booking.listing:
            listing = booking.listing
            booking_date_str = booking.booking_date.isoformat()
            if booking_date_str in listing.booked_dates:
                listing.booked_dates.remove(booking_date_str)
                listing.save()
        
        return Response({'status': 'success'})
    except m.Booking.DoesNotExist:
        return Response({'status': 'error', 'message': 'Booking not found'}, status=404)
    
# views.py
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def business_bookings(request):
    listings = m.Listing.objects.filter(ownerID__userID=request.user)
    print(listings)  # Verify this works
    
    packages = m.Packages.objects.filter(listingId__in=listings)
    print(packages)  # Verify this works
    
    products = m.Product.objects.filter(listingId__in=listings)
    print(products)  # Verify this works

# Then try each Q object separately
    bookings = m.Booking.objects.filter(
        Q(listing__in=listings) | 
        Q(package__in=packages) | 
        Q(product__in=products)
    ).order_by('-booking_date')
    
    serializer = s.BookingSerializer(bookings, many=True)
    return Response({'status': 'success', 'bookings': serializer.data})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def update_booking_status(request, booking_id):