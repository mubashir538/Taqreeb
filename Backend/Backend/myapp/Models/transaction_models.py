from django.db import models as m
from .listing_models import Packages
from .user_models import User
from .business_models import BusinessOwner,Freelancer
from .booking_models import Order,Booking
class Transaction(m.Model):
    id = m.AutoField(primary_key=True)
    sender = m.ForeignKey(User, on_delete=m.CASCADE, null=True)
    receiverf = m.ForeignKey(Freelancer, on_delete=m.CASCADE, null=True)
    receiverb = m.ForeignKey(BusinessOwner, on_delete=m.CASCADE, null=True)
    amount = m.IntegerField()
    status = m.CharField(max_length=20, default='Completed') 
    date = m.DateTimeField(auto_now_add=True)
    package = m.ForeignKey(Packages, on_delete=m.CASCADE, null=True)
    order = m.ForeignKey(Order, on_delete=m.SET_NULL, null=True, blank=True) 
    booking = m.ForeignKey(Booking, on_delete=m.SET_NULL, null=True, blank=True) 

class BusinessTransaction(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.TextField(blank=True)
    date = m.DateTimeField(auto_now_add=True)
    ownerf = m.ForeignKey(Freelancer, on_delete=m.CASCADE, null=True)
    ownerb = m.ForeignKey(BusinessOwner, on_delete=m.CASCADE, null=True)
    amount = m.IntegerField()
    info = m.TextField()
    status = m.CharField(max_length=20, default='Completed')
    order = m.ForeignKey(Order, on_delete=m.SET_NULL, null=True, blank=True) 


class Payment(m.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
        ('refunded', 'Refunded'),
    )
    
    user = m.ForeignKey(User, on_delete=m.CASCADE)
    order = m.ForeignKey(Order, on_delete=m.CASCADE, null=True, blank=True)
    booking = m.ForeignKey(Booking, on_delete=m.CASCADE, null=True, blank=True)
    amount = m.DecimalField(max_digits=10, decimal_places=2)
    transaction_id = m.CharField(max_length=100, unique=True)
    payment_method = m.CharField(max_length=50)
    status = m.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = m.DateTimeField(auto_now_add=True)
    updated_at = m.DateTimeField(auto_now=True)
    payment_details = m.JSONField(default=dict)  