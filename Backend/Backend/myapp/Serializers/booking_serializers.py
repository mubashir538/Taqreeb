from ..models.booking_models import BookingCart,Booking,Order 
from ..models.transaction_models import Transaction,BusinessTransaction,Payment 
from .listing_serializers import PackagesSerializer
from rest_framework import serializers as s

class BookingCartSerializer(s.ModelSerializer):
    class Meta:
        model = BookingCart
        fields = '__all__'

class BookingSerializer(s.ModelSerializer):
    class Meta:
        model = Booking
        fields = '__all__'

class OrderSerializer(s.ModelSerializer):
    bookings = BookingSerializer(many=True, read_only=True)
    
    class Meta:
        model = Order
        fields = '__all__'

class TransactionSerializer(s.ModelSerializer):
    package = PackagesSerializer(read_only=True)
    booking = BookingSerializer(read_only=True)
    
    class Meta:
        model = Transaction
        fields = '__all__'

class BusinessTransactionSerializer(s.ModelSerializer):
    class Meta:
        model = BusinessTransaction
        fields = '__all__'

class PaymentSerializer(s.ModelSerializer):
    class Meta:
        model = Payment
        fields = '__all__'