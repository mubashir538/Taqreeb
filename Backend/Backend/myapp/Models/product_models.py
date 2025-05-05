from django.db import models as m
from .listing_models import Listing

class Product(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100)
    description = m.TextField()
    price = m.DecimalField(max_digits=10, decimal_places=2)
    quantity = m.PositiveIntegerField(null=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class PicturesProducts(m.Model):
    id = m.AutoField(primary_key=True)
    productId = m.ForeignKey(Product,on_delete=m.CASCADE)
    picturePath = m.CharField(max_length=100)

