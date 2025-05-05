from django.db import models as m
from django.contrib.auth import get_user_model
from .listing_models import Listing,Packages
from .event_models import Functions
from .user_models import User
from .product_models import Product

class BookingCart(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE,null=True)
    slot = m.DateTimeField(null=True)
    type = m.CharField(max_length=100,blank=True)
    status = m.CharField(max_length=100)

User = get_user_model()

class Cart(m.Model):
    user = m.OneToOneField(User, on_delete=m.CASCADE, related_name='cart')
    created_at = m.DateTimeField(auto_now_add=True)
    updated_at = m.DateTimeField(auto_now=True)

class CartItem(m.Model):
    CART_ITEM_TYPES = (
        ('listing', 'Listing'),
        ('product', 'Product'),
        ('package', 'Package'),
    )
    
    cart = m.ForeignKey(Cart, on_delete=m.CASCADE, related_name='items')
    item_type = m.CharField(max_length=10, choices=CART_ITEM_TYPES)
    item_id = m.PositiveIntegerField()
    quantity = m.PositiveIntegerField(default=1)
    added_at = m.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('cart', 'item_type', 'item_id')

class Booking(m.Model):
    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('cancelled', 'Cancelled'),
        ('completed', 'Completed'),
    )
    
    user = m.ForeignKey(User, on_delete=m.CASCADE)
    listing = m.ForeignKey(Listing, on_delete=m.CASCADE, null=True, blank=True)
    product = m.ForeignKey(Product, on_delete=m.CASCADE, null=True, blank=True)
    package = m.ForeignKey(Packages, on_delete=m.CASCADE, null=True, blank=True)
    booking_date = m.DateTimeField()
    status = m.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    created_at = m.DateTimeField(auto_now_add=True)
    payment_amount = m.DecimalField(max_digits=10, decimal_places=2)
    payment_status = m.CharField(max_length=20, default='pending')
    additional_info = m.JSONField(default=dict)
    has_reviewed = m.BooleanField(default=False)

class Order(m.Model):
    user = m.ForeignKey(User, on_delete=m.CASCADE)
    cart = m.ForeignKey(Cart, on_delete=m.SET_NULL, null=True)
    total_amount = m.DecimalField(max_digits=10, decimal_places=2)
    payment_status = m.CharField(max_length=20, default='pending')
    status = m.CharField(max_length=20, default='processing')
    created_at = m.DateTimeField(auto_now_add=True)
    booking_info = m.JSONField(default=dict) 

class BookedSlots(m.Model):
    id = m.AutoField(primary_key=True)
    slot = m.DateField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)