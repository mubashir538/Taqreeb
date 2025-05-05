# import datetime
# from datetime import timezone
# from decimal import Decimal
# from django.shortcuts import get_object_or_404
# from sympy import Q
# from .. import models as m
# from .. import Serializers as s
# from django.db import transaction
# from rest_framework.decorators import api_view, permission_classes
# from rest_framework.permissions import IsAuthenticated,AllowAny
# from rest_framework.response import Response
# from myapp.models import UserActivity
# from django.utils.timezone import now
# from django.db.models import Sum


# # views.py
# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def addTransaction(request):
#     senderId = request.data.get('senderId')
#     packageId = request.data.get('packageId')
#     amount = request.data.get('amount')
#     bookingId = request.data.get('bookingId', None)
    
#     try:
#         user = m.User.objects.get(id=senderId)
#         package = m.Packages.objects.get(id=packageId)
#         listing = m.Listing.objects.get(id=package.listingId)
        
#         # Create booking if bookingId not provided
#         booking = None
#         if bookingId:
#             booking = m.Booking.objects.get(id=bookingId)
#         else:
#             booking = m.Booking.objects.create(
#                 user=user,
#                 package=package,
#                 booking_date=timezone.now(),
#                 status='confirmed',
#                 payment_amount=amount
#             )
        
#         if listing.ownerID:
#             owner = m.BusinessOwner.objects.get(id=listing.ownerID)
#             # Create business transaction
#             m.BusinessTransaction.objects.create(
#                 ownerb=owner,
#                 amount=amount,
#                 type='package_payment',
#                 info=f"Payment for package #{package.id}",
#                 status='Completed'
#             )
#             # Create user transaction
#             m.Transaction.objects.create(
#                 sender=user,
#                 receiverb=owner,
#                 amount=amount,
#                 package=package,
#                 status='Completed',
#                 booking=booking
#             )
#         else:
#             owner = m.Freelancer.objects.get(id=listing.freelancerID)
#             # Create business transaction
#             m.BusinessTransaction.objects.create(
#                 ownerf=owner,
#                 amount=amount,
#                 type='package_payment',
#                 info=f"Payment for package #{package.id}",
#                 status='Completed'
#             )
#             # Create user transaction
#             m.Transaction.objects.create(
#                 sender=user,
#                 receiverf=owner,
#                 amount=amount,
#                 package=package,
#                 status='Completed',
#                 booking=booking
#             )
#             UserActivity.objects.create(
#             user=user,
#             action='vendor_revenue',
#             metadata={
#                 'receiver_type': 'freelancer',
#                 'receiver_id': owner.id,
#                 'amount': amount,
#                 'package_id': package.id,
#                 'listing_id': listing.id
#             },
#             timestamp=now()
#         )
        
#         return Response({'status':'success', 'booking_id': booking.id})
    
#     except Exception as e:
#         return Response({'status':'error', 'message': str(e)}, status=400)

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def getTransactions(request, id, type):
#     try:
#         user = m.User.objects.get(id=id)
#         now = timezone.now()
        
#         if type == 'freelancer':
#             freelancer = m.Freelancer.objects.get(userID=user)
#             transactions = m.BusinessTransaction.objects.filter(
#                 ownerf=freelancer,
#                 status='Completed'
#             ).order_by('-date')
#         else:
#             business_owner = m.BusinessOwner.objects.get(userID=user)
#             transactions = m.BusinessTransaction.objects.filter(
#                 ownerb=business_owner,
#                 status='Completed'
#             ).order_by('-date')
        
#         # Calculate totals
#         total_amount = transactions.aggregate(Sum('amount'))['amount__sum'] or 0
#         monthly_amount = transactions.filter(
#             date__year=now.year,
#             date__month=now.month
#         ).aggregate(Sum('amount'))['amount__sum'] or 0
        
#         transactionSerializer = s.BusinessTransactionSerializer(transactions, many=True)
        
#         return Response({
#             'status': 'success',
#             'data': transactionSerializer.data,
#             'stats': {
#                 'total_amount': total_amount,
#                 'monthly_amount': monthly_amount
#             }
#         })
    
#     except Exception as e:
#         return Response({'status': 'error', 'message': str(e)}, status=400)

# @api_view(['GET'])
# @permission_classes([AllowAny])
# def getTransactionsRecent(request, id, type):
#     try:
#         user = m.User.objects.get(id=id)
#         now = datetime.datetime.now()
        
#         if type == 'freelancer':
#             freelancer = m.Freelancer.objects.get(userID=user)
#             transactions = m.BusinessTransaction.objects.filter(
#                 ownerf=freelancer,
#                 date__year=now.year,
#                 date__month=now.month,
#                 status='Completed'
#             ).order_by('-date')
#         else:
#             business_owner = m.BusinessOwner.objects.get(userID=user)
#             transactions = m.BusinessTransaction.objects.filter(
#                 ownerb=business_owner,
#                 date__year=now.year,
#                 date__month=now.month,
#                 status='Completed'
#             ).order_by('-date')
        
#         transactionSerializer = s.BusinessTransactionSerializer(transactions, many=True)
#         return Response({'status': 'success', 'data': transactionSerializer.data})
    
#     except Exception as e:
#         return Response({'status': 'error', 'message': str(e)}, status=400)

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def getUserTransactions(request, user_id):
#     try:
#         user = m.User.objects.get(id=user_id)
#         transactions = m.Transaction.objects.filter(
#             sender=user,
#             status='Completed'
#         ).order_by('-date')
        
#         transactionSerializer = s.TransactionSerializer(transactions, many=True)
#         return Response({'status': 'success', 'data': transactionSerializer.data})
    
#     except Exception as e:
#         return Response({'status': 'error', 'message': str(e)}, status=400)

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def getWalletBalance(request,id,type):
#     userID = m.User.objects.get(id=id)
#     if type == 'freelancer':
#         Freelancer = m.Freelancer.objects.get(userID=userID)
#         return Response({'status':'success','balance':Freelancer.balance})
#     else:
#         BusinessOwner = m.BusinessOwner.objects.get(userID=userID)
#         return Response({'status':'success','balance':BusinessOwner.balance})
    
# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def WithdrawBalance(request):
#     amount = int(request.data.get('amount'))
#     userID = request.data.get('userID')
#     type = request.data.get('type')
#     userID = m.User.objects.get(id=userID)
#     bankDetails = request.data.get('bankDetails') 
#     if type == 'freelancer':
#         Freelancer = m.Freelancer.objects.get(userID=userID)
#         Freelancer.balance = Freelancer.balance - amount
#         Freelancer.save(update_fields=['balance'])
#         m.BusinessTransaction(type="Withdraw",amount=amount,ownerf=Freelancer,date=datetime.datetime.now(),info=f"Withdrawal to {bankDetails}").save()
#     else:
#         BusinessOwner = m.BusinessOwner.objects.get(userID=userID)
#         BusinessOwner.balance = BusinessOwner.balance - amount
#         BusinessOwner.save(update_fields=['balance'])
#         m.BusinessTransaction(type="Withdraw",amount=amount,ownerb=BusinessOwner,date=datetime.datetime.now(),info=f"Withdrawal to {bankDetails}").save()
#     return Response({'status':'success'})

# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def addBank(request):
#     bankName = request.data.get('bankName')
#     accountNumber = request.data.get('accountNumber')
#     IBANNumber = request.data.get('IBANNumber')
#     accountHolderName = request.data.get('accountHolderName')
#     userID = request.data.get('userID')
#     userID = m.User.objects.get(id=userID)
#     m.BankDetails(userID=userID,bankName=bankName,accountNumber=accountNumber,IBANNumber=IBANNumber,accountHolderName=accountHolderName).save()
#     return Response({'status':'success'})

# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def getBank(request,id):
#     userID = m.User.objects.get(id=id)
#     bank = m.BankDetails.objects.filter(userID=userID)
#     bankSerializer = s.BankDetailsSerializer(bank,many=True)
#     return Response({'status':'success','data':bankSerializer.data})


# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def mark_booking_reviewed(request):
#     booking_id = request.data.get('booking_id')
#     try:
#         booking = m.Booking.objects.get(id=booking_id, user=request.user)
#         booking.has_reviewed = True
#         booking.save()
#         return Response({'status': 'success'})
#     except m.Booking.DoesNotExist:
#         return Response({'status': 'error', 'message': 'Booking not found'}, status=404)

# # views.py
# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def process_payment(request):
#     try:
#         data = request.data
#         order_id = data.get('order_id')
#         amount = int(data.get('amount'))
#         is_full_payment = data.get('is_full_payment', False)
        
#         if not all([order_id, amount]):
#             return Response({'status': 'error', 'message': 'Missing required fields'}, status=400)
        
#         # Get the order
#         order = m.Order.objects.get(id=order_id, user=request.user)
        
#         # Create transaction records
#         if order.listing:
#             listing = order.listing
#             if listing.ownerID:
#                 # Business owner transaction
#                 m.BusinessTransaction.objects.create(
#                     ownerb=listing.ownerID,
#                     amount=amount,
#                     type='booking_payment',
#                     info=f"Payment for order #{order.id}"
#                 )
#                 # User transaction
#                 m.Transaction.objects.create(
#                     sender=request.user,
#                     receiverb=listing.ownerID,
#                     amount=amount,
#                     status='Completed',
#                     package=order.package if order.package else None
#                 )
#             else:
#                 # Freelancer transaction
#                 m.BusinessTransaction.objects.create(
#                     ownerf=listing.freelancerID,
#                     amount=amount,
#                     type='booking_payment',
#                     info=f"Payment for order #{order.id}"
#                 )
#                 m.Transaction.objects.create(
#                     sender=request.user,
#                     receiverf=listing.freelancerID,
#                     amount=amount,
#                     status='Completed',
#                     package=order.package if order.package else None
#                 )
        
#         # Update order status
#         order.payment_status = 'paid_in_full' if is_full_payment else 'deposit_paid'
#         order.status = 'confirmed'
#         order.save()
        
#         # Update all bookings in this order
#         bookings = m.Booking.objects.filter(order=order)
#         bookings.update(status='confirmed')
#         UserActivity.objects.create(
#             user=request.user,
#             action='book_venue',
#             metadata={
#                 'order_id': order.id,
#                 'amount': amount,
#                 'payment_status': order.payment_status
#             },
#             timestamp=now()
#         )

        
#         return Response({
#             'status': 'success',
#             'message': 'Payment processed successfully',
#             'order_status': order.status
#         })
        
#     except m.Order.DoesNotExist:
#         return Response({'status': 'error', 'message': 'Order not found'}, status=404)
#     except Exception as e:
#         return Response({'status': 'error', 'message': str(e)}, status=500)

# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def update_order_status(request):
#     try:
#         # Get request data
#         order_id = request.data.get('order_id')
#         new_status = request.data.get('status')
        
#         # Validate required fields
#         if not all([order_id, new_status]):
#             return Response({'status': 'error', 'message': 'Missing order_id or status'}, status=400)
        
#         # Get the order with related bookings
#         order = get_object_or_404(
#             m.Order.objects.select_related('cart').prefetch_related('bookings'),
#             id=order_id
#         )
        
#         # Verify ownership (business owner or freelancer)
#         is_owner = False
#         if request.user.is_authenticated:
#             if hasattr(request.user, 'businessowner'):
#                 # Check if any booking belongs to this business owner
#                 is_owner = order.bookings.filter(
#                     Q(listing__ownerID__userID=request.user) |
#                     Q(package__listingId__ownerID__userID=request.user) |
#                     Q(product__listingId__ownerID__userID=request.user)
#                 ).exists()
#             elif hasattr(request.user, 'freelancer'):
#                 # Check if any booking belongs to this freelancer
#                 is_owner = order.bookings.filter(
#                     Q(listing__freelancerID__userID=request.user) |
#                     Q(package__listingId__freelancerID__userID=request.user) |
#                     Q(product__listingId__freelancerID__userID=request.user)
#                 ).exists()
        
#         if not is_owner and order.user != request.user:
#             return Response({'status': 'error', 'message': 'Unauthorized'}, status=403)
        
#         # Validate status transition
#         valid_statuses = ['pending', 'confirmed', 'completed', 'cancelled']
#         if new_status not in valid_statuses:
#             return Response({'status': 'error', 'message': 'Invalid status'}, status=400)
        
#         # Prevent invalid transitions
#         if order.status == 'completed' and new_status != 'completed':
#             return Response({'status': 'error', 'message': 'Completed orders cannot be modified'}, status=400)
        
#         if order.status == 'cancelled' and new_status != 'cancelled':
#             return Response({'status': 'error', 'message': 'Cancelled orders cannot be modified'}, status=400)
        
#         # Process the update
#         with transaction.atomic():
#             # Update order status
#             order.status = new_status
#             order.save(update_fields=['status'])
            
#             # Update all related bookings
#             bookings = order.bookings.all()
#             bookings.update(status=new_status)
#             # Log user activity after status update
#             if new_status == 'completed':
#                 UserActivity.objects.create(
#                     user=request.user,
#                     action='order_completed',
#                     metadata={
#                         'order_id': order.id,
#                         'status': new_status
#                     },
#                     timestamp=now()
#                 )
#             elif new_status == 'cancelled':
#                 UserActivity.objects.create(
#                     user=request.user,
#                     action='order_cancelled',
#                     metadata={
#                         'order_id': order.id,
#                         'status': new_status
#                     },
#                     timestamp=now()
#                 )

#             # If cancelling, handle refunds and availability
#             if new_status == 'cancelled':
#                 for booking in bookings:
#                     # Free up booked dates if this was a listing
#                     if booking.listing and booking.booking_date:
#                         booking_date_str = booking.booking_date.isoformat()
#                         if booking_date_str in booking.listing.booked_dates:
#                             booking.listing.booked_dates.remove(booking_date_str)
#                             booking.listing.save()
            
#             # If completing, create transactions for business owners/freelancers
#             elif new_status == 'completed':
#                 for booking in bookings:
#                     # Determine the recipient (business owner or freelancer)
#                     recipient = None
#                     if booking.listing:
#                         recipient = booking.listing.ownerID or booking.listing.freelancerID
#                     elif booking.package:
#                         recipient = booking.package.listingId.ownerID or booking.package.listingId.freelancerID
#                     elif booking.product:
#                         recipient = booking.product.listingId.ownerID or booking.product.listingId.freelancerID
                    
#                     if recipient:
#                         # Create business transaction
#                         if hasattr(recipient, 'businessowner'):
#                             m.BusinessTransaction.objects.create(
#                                 ownerb=recipient,
#                                 amount=booking.payment_amount,
#                                 type='order_completion',
#                                 info=f"Completed booking #{booking.id} from order #{order.id}",
#                                 status='Completed',
#                                 order=order
#                             )
#                         else:
#                             m.BusinessTransaction.objects.create(
#                                 ownerf=recipient,
#                                 amount=booking.payment_amount,
#                                 type='order_completion',
#                                 info=f"Completed booking #{booking.id} from order #{order.id}",
#                                 status='Completed',
#                                 order=order
#                             )
            
#             return Response({
#                 'status': 'success',
#                 'order_id': order.id,
#                 'new_status': new_status,
#                 'updated_bookings': bookings.count()
#             })
    
#     except Exception as e:
#         return Response({'status': 'error', 'message': str(e)}, status=500)