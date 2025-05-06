from ..Models import booking_models as m
from .listing_serializers import PackagesSerializer
from rest_framework import serializers as s

class BookingCartSerializer(s.ModelSerializer):
    class Meta:
        model = m.BookingCart
        fields = '__all__'

class BookingSerializer(s.ModelSerializer):
    class Meta:
        model = m.Booking
        fields = '__all__'

class OrderSerializer(s.ModelSerializer):
    bookings = BookingSerializer(many=True, read_only=True)
    
    class Meta:
        model = m.Order
        fields = '__all__'

class TransactionSerializer(s.ModelSerializer):
    package = PackagesSerializer(read_only=True)
    booking = BookingSerializer(read_only=True)
    
    class Meta:
        model = m.Transaction
        fields = '__all__'

class BusinessTransactionSerializer(s.ModelSerializer):
    class Meta:
        model = m.BusinessTransaction
        fields = '__all__'

class PaymentSerializer(s.ModelSerializer):
    class Meta:
        model = m.Payment
        fields = '__all__'