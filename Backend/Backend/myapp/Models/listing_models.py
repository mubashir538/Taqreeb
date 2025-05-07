from django.db import models as m
from .user_models import User
from .business_models import BusinessOwner,Freelancer
from django.utils import timezone

class Listing(m.Model):
    id = m.AutoField(primary_key=True)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE,null=True)
    freelancerID = m.ForeignKey(Freelancer,on_delete=m.CASCADE,null=True)
    name = m.CharField(max_length=100)
    priceMin = m.IntegerField()
    priceMax = m.IntegerField() 
    location = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)
    rating = m.DecimalField(max_digits=2, decimal_places=1,default=0)
    ratingCount = m.IntegerField(default=0)
    basicPrice = m.IntegerField()
    type = m.TextField(blank=True)
    status = m.CharField(max_length=20,default='active')
    booked_dates = m.JSONField(default=list)
    created_at = m.DateTimeField(default=timezone.now)

class AddOns(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    price = m.IntegerField()
    isPer = m.BooleanField()
    perType = m.CharField(max_length=50)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class PicturesListings(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

class Packages(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100,default='Basic')
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price= m.IntegerField()

class PicturesPackages(m.Model):
    id = m.AutoField(primary_key=True)
    packageId = m.ForeignKey(Packages,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

class Wishlist(m.Model):
    id = m.AutoField(primary_key=True)
    user = m.ForeignKey(User,on_delete=m.CASCADE)
    listing = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Categories(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    picture = m.CharField(max_length=255)
    type = m.CharField(max_length=100,default='business')