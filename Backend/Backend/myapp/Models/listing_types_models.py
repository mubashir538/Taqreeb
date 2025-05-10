from django.db import models as m
from .listing_models import Listing

class Venue(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey('Listing', on_delete=m.CASCADE)
    VENUE_TYPE_CHOICES = [
        ('Banquet', 'Banquet'),
        ('Hall', 'Hall'),
        ('Lawn', 'Lawn'),
        ('Outdoor', 'Outdoor'),
    ]
    venueType = m.CharField(
        max_length=50,
        choices=VENUE_TYPE_CHOICES,
        default='Banquet'
    )
    CATERING_CHOICES = [
        ('Internal', 'Internal'),
        ('External', 'External'),
        ('Internal & External', 'Internal & External'),
    ]
    catering = m.CharField(
        max_length=50,
        choices=CATERING_CHOICES,
        default='Internal'
    )

    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Both', 'Both'),
    ]
    staff = m.CharField(
        max_length=10,
        choices=STAFF_CHOICES,
        default='Male'
    )
    guestminAllowed = m.IntegerField(default=0)
    guestmaxAllowed = m.IntegerField(default=0)

    def __str__(self):
        return f"{self.listingID} - {self.venueType}"
    
class Caterers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

    SERVICE_TYPE_CHOICES = [
        ('Wedding', 'Wedding'),
        ('Corporate', 'Corporate'),
        ('Birthday', 'Birthday'),
        ('Anniversary', 'Anniversary'),
        ('Other', 'Other'),
    ]
    CATERING_OPTIONS_CHOICES = [
        ('Buffet', 'Buffet'),
        ('Plated', 'Plated'),
        ('Family Style', 'Family Style'),
        ('Food Stations', 'Food Stations'),
        ('Cocktail Reception', 'Cocktail Reception'),
    ]
    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Mixed', 'Mixed'),
    ]
    EXPERTISE_CHOICES = [
        ('Pakistani', 'Pakistani'),
        ('Chinese', 'Chinese'),
        ('Continental', 'Continental'),
        ('Italian', 'Italian'),
        ('Desserts', 'Desserts'),
    ]

    serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Wedding')
    cateringOptions = m.CharField(max_length=100, choices=CATERING_OPTIONS_CHOICES, default='Buffet')
    staff = m.CharField(max_length=100, choices=STAFF_CHOICES, default='Mixed')
    expertise = m.CharField(max_length=100, choices=EXPERTISE_CHOICES, default='Pakistani')

class CarRenters(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)
    SERVICE_TYPE_CHOICES = [
        ('Luxury', 'Luxury'),
        ('Economy', 'Economy'),
        ('SUV', 'SUV'),
        ('Convertible', 'Convertible'),
        ('Van', 'Van'),
    ]
    serviceType = m.CharField(max_length=100, choices=SERVICE_TYPE_CHOICES, default='Economy')

from ..constants.model_constants  import not_provided
class Decorators(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing, on_delete=m.CASCADE)

    DECOR_TYPE_CHOICES = [
        ('Floral', 'Floral'),
        ('Lighting', 'Lighting'),
        ('Drapery', 'Drapery'),
        ('Furniture', 'Furniture'),
        ('Themed', 'Themed'),
    ]
    CATERING_CHOICES = [
        ('Provided', 'Provided'),
        (not_provided, not_provided),
    ]
    STAFF_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female'),
        ('Mixed', 'Mixed'),
    ]

    decorType = m.CharField(max_length=50, choices=DECOR_TYPE_CHOICES, default='Floral')
    catering = m.CharField(max_length=50, choices=CATERING_CHOICES, default='Not Provided')
    staff = m.CharField(max_length=50, choices=STAFF_CHOICES, default='Mixed')

class PhotographyPlaces(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing, on_delete=m.CASCADE)

    TYPE_CHOICES = [
        ('Studio', 'Studio'),
        ('Outdoor', 'Outdoor'),
        ('Indoor', 'Indoor'),
        ('Destination', 'Destination'),
        ('Event', 'Event'),
    ]

    type = m.CharField(max_length=100, choices=TYPE_CHOICES, default='Studio')

class Parlors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Salons(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Photographers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class VideoEditors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.TextField()

class GraphicDesigners(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)