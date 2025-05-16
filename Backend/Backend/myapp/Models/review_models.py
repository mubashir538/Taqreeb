from django.db import models as m
from .listing_models import Listing
from .user_models import User

class Review(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    rating = m.DecimalField(max_digits=2, decimal_places=1)
    review = m.CharField(max_length=100)
    date = m.DateTimeField(auto_now_add=True,null=True)

class ReviewDetails(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    s5 = m.IntegerField(default=0)
    s4 = m.IntegerField(default=0)
    s3 = m.IntegerField(default=0)
    s2 = m.IntegerField(default=0)
    s1 = m.IntegerField(default=0)