import datetime
from django.db import transaction
from django.db.models import Sum
from django.shortcuts import get_object_or_404
from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from .. import models2 as m
from .. import Serializers as s
from Backend.Backend.myapp.models2 import UserActivity
from django.db.models import Q
from datetime import timezone

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_transaction(request):
    senderid = request.data.get('senderId')
    packageid = request.data.get('packageId')
    amount = request.data.get('amount')
    bookingid = request.data.get('bookingId', None)
    
    try:
        user = m.User.objects.get(id=senderid)
        package = m.Packages.objects.get(id=packageid)
        listing = m.Listing.objects.get(id=package.listingId)
        
        booking = None
        if bookingid:
            booking = m.Booking.objects.get(id=bookingid)
        else:
            booking = m.Booking.objects.create(
                user=user,
                package=package,
                booking_date=timezone.now(),
                status='confirmed',
                payment_amount=amount
            )
        
        if listing.ownerID:
            owner = m.BusinessOwner.objects.get(id=listing.ownerID)
            m.BusinessTransaction.objects.create(
                ownerb=owner,
                amount=amount,
                type='package_payment',
                info=f"Payment for package #{package.id}",
                status='Completed'
            )
            m.Transaction.objects.create(
                sender=user,
                receiverb=owner,
                amount=amount,
                package=package,
                status='Completed',
                booking=booking
            )
        else:
            owner = m.Freelancer.objects.get(id=listing.freelancerID)
            m.BusinessTransaction.objects.create(
                ownerf=owner,
                amount=amount,
                type='package_payment',
                info=f"Payment for package #{package.id}",
                status='Completed'
            )
            m.Transaction.objects.create(
                sender=user,
                receiverf=owner,
                amount=amount,
                package=package,
                status='Completed',
                booking=booking
            )
            UserActivity.objects.create(
            user=user,
            action='vendor_revenue',
            metadata={
                'receiver_type': 'freelancer',
                'receiver_id': owner.id,
                'amount': amount,
                'package_id': package.id,
                'listing_id': listing.id
            },
            timestamp=now()
        )
        
        return Response({'status':'success', 'booking_id': booking.id})
    
    except Exception as e:
        return Response({'status':'error', 'message': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_transactions(request, id, type):
    try:
        user = m.User.objects.get(id=id)
        now = timezone.now()
        
        if type == 'freelancer':
            freelancer = m.Freelancer.objects.get(userID=user)
            transactions = m.BusinessTransaction.objects.filter(
                ownerf=freelancer,
                status='Completed'
            ).order_by('-date')
        else:
            business_owner = m.BusinessOwner.objects.get(userID=user)
            transactions = m.BusinessTransaction.objects.filter(
                ownerb=business_owner,
                status='Completed'
            ).order_by('-date')
        
        total_amount = transactions.aggregate(Sum('amount'))['amount__sum'] or 0
        monthly_amount = transactions.filter(
            date__year=now.year,
            date__month=now.month
        ).aggregate(Sum('amount'))['amount__sum'] or 0
        
        transaction_serializer = s.BusinessTransactionSerializer(transactions, many=True)
        
        return Response({
            'status': 'success',
            'data': transaction_serializer.data,
            'stats': {
                'total_amount': total_amount,
                'monthly_amount': monthly_amount
            }
        })
    
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_transactions_recent(request, id, type):
    try:
        user = m.User.objects.get(id=id)
        now = datetime.datetime.now()
        
        if type == 'freelancer':
            freelancer = m.Freelancer.objects.get(userID=user)
            transactions = m.BusinessTransaction.objects.filter(
                ownerf=freelancer,
                date__year=now.year,
                date__month=now.month,
                status='Completed'
            ).order_by('-date')
        else:
            business_owner = m.BusinessOwner.objects.get(userID=user)
            transactions = m.BusinessTransaction.objects.filter(
                ownerb=business_owner,
                date__year=now.year,
                date__month=now.month,
                status='Completed'
            ).order_by('-date')
        
        transaction_serializer = s.BusinessTransactionSerializer(transactions, many=True)
        return Response({'status': 'success', 'data': transaction_serializer.data})
    
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_user_transactions(request, user_id):
    try:
        user = m.User.objects.get(id=user_id)
        transactions = m.Transaction.objects.filter(
            sender=user,
            status='Completed'
        ).order_by('-date')
        
        transaction_serializer = s.TransactionSerializer(transactions, many=True)
        return Response({'status': 'success', 'data': transaction_serializer.data})
    
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_wallet_balance(request,id,type):
    userid = m.User.objects.get(id=id)
    if type == 'freelancer':
        freelancer = m.Freelancer.objects.get(userID=userid)
        return Response({'status':'success','balance':freelancer.balance})
    else:
        business_owner = m.BusinessOwner.objects.get(userID=userid)
        return Response({'status':'success','balance':business_owner.balance})
    
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def withdraw_balance(request):
    amount = int(request.data.get('amount'))
    userid = request.data.get('userID')
    withdraw_type = request.data.get('type')
    userid = m.User.objects.get(id=userid)
    bank_details = request.data.get('bankDetails') 
    if withdraw_type == 'freelancer':
        freelancer = m.Freelancer.objects.get(userID=userid)
        freelancer.balance = freelancer.balance - amount
        freelancer.save(update_fields=['balance'])
        m.BusinessTransaction(type="Withdraw",amount=amount,ownerf=freelancer,date=datetime.datetime.now(),info=f"Withdrawal to {bank_details}").save()
    else:
        business_owner = m.BusinessOwner.objects.get(userID=userid)
        business_owner.balance = business_owner.balance - amount
        business_owner.save(update_fields=['balance'])
        m.BusinessTransaction(type="Withdraw",amount=amount,ownerb=business_owner,date=datetime.datetime.now(),info=f"Withdrawal to {bank_details}").save()
    return Response({'status':'success'})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_bank(request):
    bank_name = request.data.get('bankName')
    account_number = request.data.get('accountNumber')
    iban_number = request.data.get('IBANNumber')
    account_holder_name = request.data.get('accountHolderName')
    userid = request.data.get('userID')
    userid = m.User.objects.get(id=userid)
    m.BankDetails(userID=userid,bankName=bank_name,accountNumber=account_number,IBANNumber=iban_number,accountHolderName=account_holder_name).save()
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_bank(request,id):
    userid = m.User.objects.get(id=id)
    bank = m.BankDetails.objects.filter(userID=userid)
    bank_serializer = s.BankDetailsSerializer(bank,many=True)
    return Response({'status':'success','data':bank_serializer.data})


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def mark_booking_reviewed(request):
    booking_id = request.data.get('booking_id')
    try:
        booking = m.Booking.objects.get(id=booking_id, user=request.user)
        booking.has_reviewed = True
        booking.save()
        return Response({'status': 'success'})
    except m.Booking.DoesNotExist:
        return Response({'status': 'error', 'message': 'Booking not found'}, status=404)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def process_payment(request):
    try:
        data = request.data
        order_id = data.get('order_id')
        amount = int(data.get('amount'))
        is_full_payment = data.get('is_full_payment', False)
        
        if not all([order_id, amount]):
            return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)
        
        order = m.Order.objects.get(id=order_id, user=request.user)
        
        if order.listing:
            listing = order.listing
            if listing.ownerID:
                m.BusinessTransaction.objects.create(
                    ownerb=listing.ownerID,
                    amount=amount,
                    type='booking_payment',
                    info=f"Payment for order #{order.id}"
                )
                m.Transaction.objects.create(
                    sender=request.user,
                    receiverb=listing.ownerID,
                    amount=amount,
                    status='Completed',
                    package=order.package if order.package else None
                )
            else:
                m.BusinessTransaction.objects.create(
                    ownerf=listing.freelancerID,
                    amount=amount,
                    type='booking_payment',
                    info=f"Payment for order #{order.id}"
                )
                m.Transaction.objects.create(
                    sender=request.user,
                    receiverf=listing.freelancerID,
                    amount=amount,
                    status='Completed',
                    package=order.package if order.package else None
                )
        
        order.payment_status = 'paid_in_full' if is_full_payment else 'deposit_paid'
        order.status = 'confirmed'
        order.save()
        
        bookings = m.Booking.objects.filter(order=order)
        bookings.update(status='confirmed')
        UserActivity.objects.create(
            user=request.user,
            action='book_venue',
            metadata={
                'order_id': order.id,
                'amount': amount,
                'payment_status': order.payment_status
            },
            timestamp=now()
        )

        
        return Response({
            'status': 'success',
            'message': 'Payment processed successfully',
            'order_status': order.status
        })
        
    except m.Order.DoesNotExist:
        return Response({'status': 'error', 'message': 'Order not found'}, status=404)
    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
@api_view(['POST'])
def update_order_status(request):
    try:
        order_id, new_status = request.data.get('order_id'), request.data.get('status')
        if not all([order_id, new_status]):
            return Response({'status': 'error', 'message': 'Missing order_id or status'}, status=400)
        
        order = _get_order_with_related_data(order_id)

        if not _is_authorized(request.user, order):
            return Response({'status': 'error', 'message': 'Unauthorized'}, status=403)

        if not _is_valid_status(new_status):
            return Response({'status': 'error', 'message': 'Invalid status'}, status=400)

        if _is_non_modifiable(order.status, new_status):
            return Response({'status': 'error', 'message': f'{order.status.capitalize()} orders cannot be modified'}, status=400)

        with transaction.atomic():
            _update_order_and_bookings(order, new_status)
            _record_user_activity(request.user, order.id, new_status)
            _handle_booking_side_effects(order.bookings.all(), order, new_status)
        
        return Response({
            'status': 'success',
            'order_id': order.id,
            'new_status': new_status,
            'updated_bookings': order.bookings.count()
        })

    except Exception as e:
        return Response({'status': 'error', 'message': str(e)}, status=500)
def _get_order_with_related_data(order_id):
    return get_object_or_404(
        m.Order.objects.select_related('cart').prefetch_related('bookings'),
        id=order_id
    )
def _is_authorized(user, order):
    if not user.is_authenticated:
        return False

    if hasattr(user, 'businessowner'):
        return order.bookings.filter(
            Q(listing__ownerID__userID=user) |
            Q(package__listingId__ownerID__userID=user) |
            Q(product__listingId__ownerID__userID=user)
        ).exists()
    elif hasattr(user, 'freelancer'):
        return order.bookings.filter(
            Q(listing__freelancerID__userID=user) |
            Q(package__listingId__freelancerID__userID=user) |
            Q(product__listingId__freelancerID__userID=user)
        ).exists()

    return order.user == user
def _is_valid_status(status):
    return status in ['pending', 'confirmed', 'completed', 'cancelled']
def _is_non_modifiable(current_status, new_status):
    return (current_status == 'completed' and new_status != 'completed') or \
           (current_status == 'cancelled' and new_status != 'cancelled')
def _update_order_and_bookings(order, new_status):
    order.status = new_status
    order.save(update_fields=['status'])
    order.bookings.all().update(status=new_status)
def _record_user_activity(user, order_id, status):
    action_map = {
        'completed': 'order_completed',
        'cancelled': 'order_cancelled'
    }
    if status in action_map:
        UserActivity.objects.create(
            user=user,
            action=action_map[status],
            metadata={'order_id': order_id, 'status': status},
            timestamp=now()
        )
def _handle_booking_side_effects(bookings, order, status):
    if status == 'cancelled':
        _cancel_booking_dates(bookings)
    elif status == 'completed':
        _record_completed_transactions(bookings, order)
def _cancel_booking_dates(bookings):
    for booking in bookings:
        if _should_remove_booking_date(booking):
            _remove_booking_date(booking)
def _should_remove_booking_date(booking):
    return booking.listing and booking.booking_date and \
           booking.booking_date.isoformat() in booking.listing.booked_dates
def _remove_booking_date(booking):
    date_str = booking.booking_date.isoformat()
    booking.listing.booked_dates.remove(date_str)
    booking.listing.save()
def _record_completed_transactions(bookings, order):
    for booking in bookings:
        recipient = _get_booking_recipient(booking)
        if recipient:
            _create_business_transaction(booking, order, recipient)
def _create_business_transaction(booking, order, recipient):
    is_business_owner = hasattr(recipient, 'businessowner')
    m.BusinessTransaction.objects.create(
        ownerb=recipient if is_business_owner else None,
        ownerf=None if is_business_owner else recipient,
        amount=booking.payment_amount,
        type='order_completion',
        info=f"Completed booking #{booking.id} from order #{order.id}",
        status='Completed',
        order=order
    )

def _get_booking_recipient(booking):
    if booking.listing:
        return booking.listing.ownerID or booking.listing.freelancerID
    if booking.package:
        return booking.package.listingId.ownerID or booking.package.listingId.freelancerID
    if booking.product:
        return booking.product.listingId.ownerID or booking.product.listingId.freelancerID
    return None
