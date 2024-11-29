from django.db import models as m

class User(m.Model):
    id = m.AutoField()
    firstName = m.CharField(max_length=100)
    lastName = m.CharField(max_length=100)
    password = m.CharField(max_length=100)
    contactNumber = m.CharField(max_length=15)
    email = m.CharField(max_length=50)
    city = m.CharField(max_length=50)
    gender = m.CharField(max_length=6)
    profilePicture = m.CharField(max_length=100)

class BusinessOwner(m.Model):
    id = m.AutoField()
    UserID = m.ForeignKey(User,on_delete=m.CASCADE)
    CNICFormat = m.CharField(max_length=100)
    CNICBack = m.CharField(max_length=100)
    BuisnessName = m.CharField(max_length=100)
    email = m.CharField(max_length=50)
    BuisnerUsername = m.CharField(max_length=50)
    Description = m.CharField(max_length=1100)

class Freelancer(m.Model):
    id = m.AutoField()
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    BusinessName = m.CharField(max_length=100)
    BusinessUsername = m.CharField(max_length=100)
    portfolioLink= m.CharField(max_length=100)
    description = m.CharField(max_length=1100)


class Listing(m.Model):
    id = m.AutoField()
    OwnerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    Name = m.CharField(max_length=100)
    PriceMin = m.IntegerField()
    PriceMax = m.IntegerField()
    Location = m.CharField(max_length=100)
    Description = m.CharField(max_length=1100)
    BasicPrice = m.IntegerField()

class Packages(m.Model):
    id = m.AutoField()
    type = m.IntegerField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price= m.IntegerField()

class Orders(m.Model):
    id = m.AutoField()
    CustomerID = m.ForeignKey(User,on_delete=m.CASCADE)
    OwnerID = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    ServiceID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    Price = m.IntegerField()
    PackageID = m.ForeignKey(Packages,on_delete=m.CASCADE)
    Slot = m.DateTimeField()
    Status = m.CharField(max_length=100)


class AIEventQuestions(m.Models):
    id = m.AutoField()
    question = m.CharField(max_length=100)
    questionType = m.CharField(max_length=50)

class QuestionOptions(m.Models):
    id = m.AutoField()
    questionId = m.ForeignKey(AIEventQuestions,on_delete= m.CASCADE)
    optionType = m.TextField()
    name = m.TextField() 

class Freelancer(m.Model):
    id = m.AutoField()
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    businessName = m.CharField(max_length=100)
    businessUsername = m.CharField(max_length=100)
    portfolioLink = m.CharField(max_length=100)
    description = m.CharField(max_length=1100)


class Packages(m.Model):
    id = m.AutoField()
    type = m.IntegerField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    description = m.CharField(max_length=1100)
    price = m.IntegerField()

class Review(m.Model):
    id = m.AutoField()
    ListingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    UserID = m.ForeignKey(User,on_delete=m.CASCADE)
    Rating = m.DecimalField()
    Review = m.CharField(max_length=100)

class Events(m.Models):
    id = m.AutoField()
    UserID=  m.IntegerField()
    Name =m.CharField(max_length=100)
    Type =m.CharField(max_length=100)
    Date =m.CharField(max_length=100)
    Location =m.CharField(max_length=100)
    Description =m.CharField(max_length=1100)
    ThemeColor =m.CharField(max_length=100)
    Budget=  m.IntegerField()

class Functions(m.Models):
    id = m.AutoField()
    EventId = m.ForeignKey(Events, on_delete=m.CASCADE)
    name= m.CharField(max_length=100)
    budget = m.IntegerField()
    type = m.CharField(max_length=100)
    Date = m.DateField

class GuestList(m.Model):
    id = m.AutoField()
    Type = m.CharField(max_length=100)
    Name = m.CharField(max_length=100)
    Members = m.IntegerField()
    Phone = m.CharField(max_length=100)
    EventId = m.ForeignKey(Events,on_delete=m.CASCADE)
    FunctionId = m.IntegerField()

class CheckList(m.Model):
    id = m.AutoField()
    description = m.CharField(max_length=1100)
    isChecked = m.BooleanField()
    functionId = m.ForeignKey(Functions,on_delete=m.CASCADE)
    eventId = m.ForeignKey(Events,on_delete=m.CASCADE)

class Venue(m.Model):
    id = m.AutoField()
    ListingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    VenueType = m.CharField(max_length=100)
    Catering = m.CharField(max_length=100)
    Staff = m.CharField(max_length=100)
    Slot = m.DateTimeField()

class AddOns(m.Model):
    id = m.AutoField()
    name = m.CharField(max_length=255)
    price = m.IntegerField()
    isPer = m.BooleanField()
    perType = m.CharField(max_length=50)
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)

class Caterers(m.Models):
    id = m.AutoField()
    ListingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    ServiceType = m.TextField()
    CateringOptions = m.CharField(max_length=50)
    Staff = m.CharField(max_length=50)
    Expertise = m.CharField(max_length=100)

class MenuItems(m.Model):
    id = m.AutoField()
    CateringId = m.ForeignKey(Caterers,on_delete=m.CASCADE)
    Name = m.CharField(max_length=100)
    PricePerKg = m.IntegerField()
    Picture = m.CharField(max_length=100)

class Photographers(m.Model):
    id = m.AutoField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    portfolioLink = m.CharField(max_length=100)

class Cart(m.Model):
    id = m.AutoField()
    userId = m.ForeignKey(User,on_delete=m.CASCADE)
    productId = m.ForeignKey(MenuItems,on_delete=m.CASCADE)
    ownerId = m.ForeignKey(BusinessOwner,on_delete=m.CASCADE)
    quantity = m.IntegerField()

class CarRenters(m.Model):
    id = m.AutoField()
    ListingID = m.ForeignKey(Listing,on_delete=m.CASCADE)
    ServiceType = m.CharField(max_length=100)
    Drivers = m.IntegerField()

class Cars(m.Model):
    id = m.AutoField()
    carRenterId = m.ForeignKey(CarRenters,on_delete=m.CASCADE)
    pricePerDay = m.IntegerField()
    name = m.CharField(max_length=255)
    type = m.CharField(max_length=100)
    seats = m.IntegerField()
    driver = m.IntegerField()
    picture = m.CharField(max_length=255)

class Decorators(m.Models):
    id = m.AutoField()
    ListingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    DecorType = m.CharField(max_length=50)
    Catering = m.CharField(max_length=50)
    Staff = m.CharField(max_length=50)
    Slot = m.DateTimeField()
class Parlors(m.Model):
    id = m.AutoField()
    ListingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    Slot = m.DateTimeField()

class Salons(m.Model):
    id = m.AutoField()
    listingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    slot = m.CharField(max_length=100)

class BakersAndSweets(m.Model):
    id = m.AutoField()
    ListingID = m.ForeignKey(Listing,on_delete=m.CASCADE)

class VideoEditors(m.Models):
    id = m.AutoField()
    ListingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    PortfolioLink = m.TextField()

class GraphicDesigners(m.Model):
    id = m.AutoField()
    ListingId = m.ForeignKey(Listing,on_delete=m.CASCADE)
    PortFolioLink = m.CharField(max_length=100)

class EventType(m.Model):
    id = m.AutoField()
    name = m.CharField(max_length=100)

class FunctionType(m.Model):
    id = m.AutoField()
    name = m.TextField()

class DesertItems(m.Model):
    id = m.AutoField()
    name = m.CharField(max_length=255)
    bakersId = m.ForeignKey(BakersAndSweets,on_delete=m.CASCADE)
    price = m.IntegerField()
    type = m.CharField(max_length=100)
    description = m.CharField(max_length=500)
    picture = m.CharField(max_length=255)


class Categories(m.Model):
    id = m.AutoField()
    name = m.CharField(max_length=255)
    picture = m.CharField(max_length=255)
    