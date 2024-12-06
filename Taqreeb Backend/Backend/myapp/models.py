from django.db import models as m

class User(m.Model):
    id = m.AutoField(primary_key=True)
    firstName = m.CharField(max_length=100)
    lastName = m.CharField(max_length=100)
    password = m.CharField(max_length=100)
    contactNumber = m.CharField(max_length=15)
    email = m.CharField(max_length=50)
    city = m.CharField(max_length=50)
    gender = m.CharField(max_length=6)
    profilePicture = m.CharField(max_length=100)

class BusinessOwner(m.Model):
    id = m.AutoField(primary_key=True)
    cnic = m.TextField(null=True)
    category = m.TextField(null=True)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    CNICFront = m.CharField(max_length=100)
    CNICBack = m.CharField(max_length=100)
    businessName = m.CharField(max_length=100)
    email = m.CharField(max_length=50)
    businessUsername = m.CharField(max_length=50)
    Description = m.CharField(max_length=1100)

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100)
    businessUsername = m.CharField(max_length=100)
    portfolioLink= m.CharField(max_length=100)
    description = m.CharField(max_length=1100)


class Listing(m.Model):
    id = m.AutoField(primary_key=True)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    name = m.CharField(max_length=100)
    priceMin = m.IntegerField()
    priceMax = m.IntegerField()
    location = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)
    basicPrice = m.IntegerField()

class Packages(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.IntegerField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price= m.IntegerField()

class Orders(m.Model):
    id = m.AutoField(primary_key=True)
    customerID = m.ForeignKey(User,on_delete=m.CASCADE)
    ownerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    ServiceID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    price = m.IntegerField()
    packageID = m.ForeignKey(Packages,on_delete=m.CASCADE)
    slot = m.DateTimeField()
    status = m.CharField(max_length=100)


class AIEventQuestions(m.Model):
    id = m.AutoField(primary_key=True)
    question = m.CharField(max_length=100)
    questionType = m.CharField(max_length=50)

class QuestionOptions(m.Model):
    id = m.AutoField(primary_key=True)
    questionId = m.ForeignKey(AIEventQuestions,on_delete= m.CASCADE)
    optionType = m.TextField()
    name = m.TextField() 

class Freelancer(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100)
    businessUsername = m.CharField(max_length=100)
    portfolioLink = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)


class Review(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    userID = m.ForeignKey(User,on_delete=m.CASCADE)
    rating = m.DecimalField(max_digits=20,decimal_places=10)
    review = m.CharField(max_length=100)

class Events(m.Model):
    id = m.AutoField(primary_key=True)
    userID=  m.IntegerField()
    name =m.CharField(max_length=100)
    type =m.CharField(max_length=100)
    date =m.CharField(max_length=100)
    location =m.CharField(max_length=100)
    description =m.CharField(max_length=1100)
    themeColor =m.CharField(max_length=100)
    budget=  m.IntegerField()
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True) 

class Functions(m.Model):
    id = m.AutoField(primary_key=True)
    eventId = m.ForeignKey(Events, on_delete=m.CASCADE)
    name= m.CharField(max_length=100)
    budget = m.IntegerField()
    type = m.CharField(max_length=100)
    date = m.DateField(null=True)
    guestsmin = m.IntegerField(null=True)
    guestsmax = m.IntegerField(null=True)

class GuestList(m.Model):
    id = m.AutoField(primary_key=True)
    type = m.CharField(max_length=100)
    name = m.CharField(max_length=100)
    members = m.IntegerField()
    phone = m.CharField(max_length=100)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)
    functionId = m.IntegerField()

class CheckList(m.Model):
    id = m.AutoField(primary_key=True)
    description = m.CharField(max_length=1100)
    isChecked = m.BooleanField()
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)

class Venue(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    venueType = m.CharField(max_length=100)
    catering = m.CharField(max_length=100)
    staff = m.CharField(max_length=100)
    slot = m.DateTimeField()

class AddOns(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    price = m.IntegerField()
    isPer = m.BooleanField()
    perType = m.CharField(max_length=50)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Caterers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    serviceType = m.TextField()
    cateringOptions = m.CharField(max_length=50)
    staff = m.CharField(max_length=50)
    expertise = m.CharField(max_length=100)

class MenuItems(m.Model):
    id = m.AutoField(primary_key=True)
    cateringId = m.ForeignKey(Caterers,on_delete=m.CASCADE)
    name = m.CharField(max_length=100)
    pricePerKg = m.IntegerField()
    picture = m.CharField(max_length=100)

class Photographers(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class Cart(m.Model):
    id = m.AutoField(primary_key=True)
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    productId = m.ForeignKey(MenuItems,on_delete=m.CASCADE)
    ownerId = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    quantity = m.IntegerField()

class CarRenters(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    serviceType = m.CharField(max_length=100)
    drivers = m.IntegerField()

class Cars(m.Model):
    id = m.AutoField(primary_key=True)
    carRenterId = m.ForeignKey(CarRenters,on_delete=m.CASCADE)
    pricePerDay = m.IntegerField()
    name = m.CharField(max_length=255)
    type = m.CharField(max_length=100)
    seats = m.IntegerField()
    driver = m.IntegerField()
    picture = m.CharField(max_length=255)

class Decorators(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    decorType = m.CharField(max_length=50)
    catering = m.CharField(max_length=50)
    staff = m.CharField(max_length=50)
    slot = m.DateTimeField()
class Parlors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    slot = m.DateTimeField()

class Salons(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    slot = m.CharField(max_length=100)

class BakersAndSweets(m.Model):
    id = m.AutoField(primary_key=True)
    listingID = m.ForeignKey(Listing,on_delete=m.CASCADE)

class VideoEditors(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.TextField()

class GraphicDesigners(m.Model):
    id = m.AutoField(primary_key=True)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class EventType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=100)

class FunctionType(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.TextField()

class DesertItems(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    bakersId = m.ForeignKey(BakersAndSweets,on_delete=m.CASCADE)
    price = m.IntegerField()
    type = m.CharField(max_length=100)
    description = m.CharField(max_length=500)
    picture = m.CharField(max_length=255)


class Categories(m.Model):
    id = m.AutoField(primary_key=True)
    name = m.CharField(max_length=255)
    picture = m.CharField(max_length=255)
    