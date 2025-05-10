from typing import Dict, List, Optional, Tuple
from django.db.models import Q
from ..models.listing_models import (
    Listing,Packages, AddOns,
    PicturesListings, PicturesPackages
)
from ..models.listing_types_models import (
     Venue, Caterers, Decorators, CarRenters, 
    PhotographyPlaces, Photographers, VideoEditors, GraphicDesigners,Parlors,Salons
)
from ..models.product_models import (
    Product, PicturesProducts
)
from ..models.event_models import (
    EventType, FunctionType,Functions,Events
)
from django.db import models as m 
from django.utils import timezone



# Constants for service types
SERVICE_TYPES = {
    'Venue': Venue,
    'Caterer': Caterers,
    'Decorator': Decorators,
    'Car Renter': CarRenters,
    'Photography Place': PhotographyPlaces,
    'Photographer': Photographers,
    'Video Editor': VideoEditors,
    'Graphic Designer': GraphicDesigners,
    'Parlor': Parlors,
    'Salon': Salons
}

def get_event_types() -> List[Dict]:
    """Get all available event types"""
    return list(EventType.objects.values('id', 'name'))

def get_function_types(event_type_id: Optional[int] = None) -> List[Dict]:
    """Get function types, optionally filtered by event type"""
    queryset = FunctionType.objects.all()
    if event_type_id:
        queryset = queryset.filter(eventtypeid_id=event_type_id)
    return list(queryset.values('id', 'name', 'eventtypeid_id'))

def search_listings(
    service_type: str,
    location: Optional[str] = None,
    min_price: Optional[int] = None,
    max_price: Optional[int] = None,
    min_capacity: Optional[int] = None,
    max_capacity: Optional[int] = None,
    # Venue specific filters
    venue_type: Optional[str] = None,
    venue_catering: Optional[str] = None,
    venue_staff: Optional[str] = None,
    # Caterer specific filters
    caterer_service_type: Optional[str] = None,
    catering_options: Optional[str] = None,
    caterer_staff: Optional[str] = None,
    caterer_expertise: Optional[str] = None,
    # Decorator specific filters
    decorator_type: Optional[str] = None,
    decorator_catering: Optional[str] = None,
    decorator_staff: Optional[str] = None,
    # Photography place filters
    photography_place_type: Optional[str] = None,
    # Photographer filters
    photographer_has_portfolio: Optional[bool] = None,
    # Car renter filters
    car_rental_service_type: Optional[str] = None,
    limit: int = 10
) -> List[Dict]:
    """
    Search listings based on service type and filters.
    Returns listings with their related packages and products.
    """
    if service_type not in SERVICE_TYPES:
        return []
    
    # Base query for listings of the specified type
    listings = Listing.objects.filter(
        type=service_type,
        status='active'
    ).select_related(SERVICE_TYPES[service_type].__name__.lower())
    
    # Apply common filters
    if location:
        listings = listings.filter(location__icontains=location)
    if min_price:
        listings = listings.filter(priceMin__gte=min_price)
    if max_price:
        listings = listings.filter(priceMax__lte=max_price)
    
    # Apply service-specific filters
    if service_type == 'Venue':
        venue_filters = Q()
        if venue_type:
            venue_filters &= Q(venue__venueType=venue_type)
        if venue_catering:
            venue_filters &= Q(venue__catering=venue_catering)
        if venue_staff:
            venue_filters &= Q(venue__staff=venue_staff)
        if min_capacity:
            venue_filters &= Q(venue__guestminAllowed__lte=min_capacity)
        if max_capacity:
            venue_filters &= Q(venue__guestmaxAllowed__gte=max_capacity)
        listings = listings.filter(venue_filters)
    
    elif service_type == 'Caterer':
        caterer_filters = Q()
        if caterer_service_type:
            caterer_filters &= Q(caterers__serviceType=caterer_service_type)
        if catering_options:
            caterer_filters &= Q(caterers__cateringOptions=catering_options)
        if caterer_staff:
            caterer_filters &= Q(caterers__staff=caterer_staff)
        if caterer_expertise:
            caterer_filters &= Q(caterers__expertise=caterer_expertise)
        listings = listings.filter(caterer_filters)
    
    elif service_type == 'Decorator':
        decorator_filters = Q()
        if decorator_type:
            decorator_filters &= Q(decorators__decorType=decorator_type)
        if decorator_catering:
            decorator_filters &= Q(decorators__catering=decorator_catering)
        if decorator_staff:
            decorator_filters &= Q(decorators__staff=decorator_staff)
        listings = listings.filter(decorator_filters)
    
    elif service_type == 'Car Renter':
        if car_rental_service_type:
            listings = listings.filter(carrenters__serviceType=car_rental_service_type)
    
    elif service_type == 'Photography Place':
        if photography_place_type:
            listings = listings.filter(photographyplaces__type=photography_place_type)
    
    elif service_type == 'Photographer':
        if photographer_has_portfolio:
            listings = listings.filter(photographers__portfolioLink__isnull=False)
    
    # Limit results
    listings = listings[:limit]
    
    results = []
    for listing in listings:
        listing_data = {
            'id': listing.id,
            'name': listing.name,
            'type': listing.type,
            'location': listing.location,
            'price_range': {
                'min': listing.priceMin,
                'max': listing.priceMax
            },
            'basic_price': listing.basicPrice,
            'description': listing.description,
            'rating': float(listing.rating) if listing.rating else None,
            'rating_count': listing.ratingCount,
            'images': list(PicturesListings.objects.filter(listingId=listing)
                        .values('picturePath')[:5]),
            'packages': list(Packages.objects.filter(listingId=listing)
                           .annotate_images()
                           .values('id', 'name', 'description', 'price')),
            'products': list(Product.objects.filter(listingId=listing)
                           .annotate_images()
                           .values('id', 'name', 'description', 'price', 'quantity')),
            'add_ons': list(AddOns.objects.filter(listingId=listing)
                         .values('id', 'name', 'price', 'isPer', 'perType'))
        }
        
        # Add service-specific details
        service_model = SERVICE_TYPES[service_type]
        service_obj = getattr(listing, service_model.__name__.lower(), None)
        if service_obj:
            listing_data.update(get_service_specific_details(service_obj, service_type))
        
        results.append(listing_data)
    
    return results

def get_service_specific_details(service_obj, service_type: str) -> Dict:
    """Get service-specific details based on the service type"""
    details = {}
    
    if service_type == 'Venue':
        details.update({
            'venue_type': service_obj.venueType,
            'catering': service_obj.catering,
            'staff': service_obj.staff,
            'capacity': {
                'min': service_obj.guestminAllowed,
                'max': service_obj.guestmaxAllowed
            }
        })
    elif service_type == 'Caterer':
        details.update({
            'service_type': service_obj.serviceType,
            'catering_options': service_obj.cateringOptions,
            'staff': service_obj.staff,
            'expertise': service_obj.expertise
        })
    elif service_type == 'Decorator':
        details.update({
            'decor_type': service_obj.decorType,
            'catering': service_obj.catering,
            'staff': service_obj.staff
        })
    elif service_type == 'Car Renter':
        details.update({
            'service_type': service_obj.serviceType
        })
    elif service_type == 'Photography Place':
        details.update({
            'place_type': service_obj.type
        })
    elif service_type == 'Photographer':
        details.update({
            'portfolio': service_obj.portfolioLink
        })
    elif service_type in ['Video Editor', 'Graphic Designer']:
        details.update({
            'portfolio': service_obj.portfolioLink
        })
    
    return details

def get_listing_details(listing_id: int) -> Dict:
    """Get detailed information about a specific listing"""
    try:
        listing = Listing.objects.get(id=listing_id)
    except Listing.DoesNotExist:
        return {'error': 'Listing not found'}
    
    service_type = listing.type
    service_model = SERVICE_TYPES.get(service_type)
    
    if not service_model:
        return {'error': 'Invalid service type'}
    
    listing_data = {
        'id': listing.id,
        'name': listing.name,
        'type': listing.type,
        'location': listing.location,
        'price_range': {
            'min': listing.priceMin,
            'max': listing.priceMax
        },
        'basic_price': listing.basicPrice,
        'description': listing.description,
        'rating': float(listing.rating) if listing.rating else None,
        'rating_count': listing.ratingCount,
        'images': list(PicturesListings.objects.filter(listingId=listing)
                      .values('picturePath')),
        'packages': list(Packages.objects.filter(listingId=listing)
                       .annotate_images()
                       .values('id', 'name', 'description', 'price')),
        'products': list(Product.objects.filter(listingId=listing)
                       .annotate_images()
                       .values('id', 'name', 'description', 'price', 'quantity')),
        'add_ons': list(AddOns.objects.filter(listingId=listing)
                     .values('id', 'name', 'price', 'isPer', 'perType'))
    }
    
    # Add service-specific details
    service_obj = getattr(listing, service_model.__name__.lower(), None)
    if service_obj:
        listing_data.update(get_service_specific_details(service_obj, service_type))
    
    return listing_data

def get_venue_recommendations(
    event_type: str,
    location: str,
    guest_count: int,
    budget_range: Tuple[int, int]
) -> List[Dict]:
    """
    Get personalized venue recommendations based on event requirements.
    Includes a recommendation score based on how well the venue matches requirements.
    """
    venues = Listing.objects.filter(
        type='Venue',
        status='active',
        venue__guestminAllowed__lte=guest_count,
        venue__guestmaxAllowed__gte=guest_count,
        priceMin__gte=budget_range[0],
        priceMax__lte=budget_range[1]
    ).select_related('venue')
    
    if location and location.lower() not in ['home', 'street']:
        venues = venues.filter(location__icontains=location)
    
    results = []
    for venue in venues:
        # Calculate recommendation score (0-100)
        score = 0
        
        # Capacity score (30 points max)
        capacity_ratio = venue.venue.guestmaxAllowed / guest_count
        if 1.0 <= capacity_ratio <= 1.5:
            score += 30
        elif 1.5 < capacity_ratio <= 2.5:
            score += 20
        elif capacity_ratio > 2.5:
            score += 10
        else:
            score += max(0, int(capacity_ratio * 30))
        
        # Price score (30 points max)
        price_mid = (venue.priceMin + venue.priceMax) / 2
        budget_mid = (budget_range[0] + budget_range[1]) / 2
        price_ratio = min(price_mid, budget_mid) / max(price_mid, budget_mid)
        score += int(price_ratio * 30)
        
        # Location score (20 points if matches)
        if location and location.lower() in venue.location.lower():
            score += 20
        
        # Venue type score (20 points if matches typical event type)
        typical_venue_types = {
            'Wedding': ['Banquet', 'Lawn'],
            'Corporate': ['Hall', 'Banquet'],
            'Birthday': ['Outdoor', 'Hall']
        }
        if event_type in typical_venue_types:
            if venue.venue.venueType in typical_venue_types[event_type]:
                score += 20
        
        venue_data = {
            'id': venue.id,
            'name': venue.name,
            'location': venue.location,
            'price_range': {
                'min': venue.priceMin,
                'max': venue.priceMax
            },
            'capacity': {
                'min': venue.venue.guestminAllowed,
                'max': venue.venue.guestmaxAllowed
            },
            'venue_type': venue.venue.venueType,
            'catering': venue.venue.catering,
            'staff': venue.venue.staff,
            'images': list(PicturesListings.objects.filter(listingId=venue)
                          .values('picturePath')[:3]),
            'recommendation_score': min(100, score)  # Cap at 100
        }
        
        results.append(venue_data)
    
    # Sort by recommendation score
    results.sort(key=lambda x: x['recommendation_score'], reverse=True)
    return results[:10]  # Return top 10 recommendations

# Custom queryset methods for annotations
from django.db.models import Count, Case, When, Value

def annotate_images(queryset):
    """Annotate queryset with image count and first image"""
    return queryset.annotate(
        image_count=Count('pictures'),
        first_image=Case(
            When(pictures__isnull=False, then='pictures__picturePath'),
            default=Value(None),
            output_field=m.CharField()
        )
    )

def check_date_availability(listing_id: int, date: str) -> Dict:
    """
    Check if a listing is available on a specific date.
    Returns available status and any conflicting bookings if unavailable.
    """
    try:
        listing = Listing.objects.get(id=listing_id)
    except Listing.DoesNotExist:
        return {'available': False, 'reason': 'Listing not found'}
    
    # Convert date string to date object (assuming format YYYY-MM-DD)
    try:
        requested_date = timezone.datetime.strptime(date, '%Y-%m-%d').date()
    except ValueError:
        return {'available': False, 'reason': 'Invalid date format'}
    
    # Check if date is in the past
    if requested_date < timezone.now().date():
        return {'available': False, 'reason': 'Date is in the past'}
    
    # Check booked dates (assuming booked_dates is a list of date strings)
    booked_dates = listing.booked_dates or []
    
    if date in booked_dates:
        return {'available': False, 'reason': 'Date already booked'}
    
    return {'available': True}

def create_event(
    user_id: int,
    event_name: str,
    event_type_id: int,
    total_budget: float,
    functions: List[Dict],
    notes: Optional[str] = None
) -> Dict:
    """
    Create a new event with all its functions in the database.
    
    Args:
        user_id: ID of the user creating the event
        event_name: Name of the event
        event_type_id: ID from EventType model
        total_budget: Total budget for the event
        functions: List of function dictionaries with structure:
            {
                'function_type_id': int,
                'budget': float,
                'date': str (YYYY-MM-DD),
                'guest_count': int,
                'services': [
                    {
                        'listing_id': int,
                        'package_id': Optional[int],
                        'products': List[int],
                        'add_ons': List[int],
                        'notes': Optional[str]
                    }
                ]
            }
        notes: Optional notes about the event
    
    Returns:
        Dictionary with created event ID or error message
    """
    try:
        # Create the main event
        event = Events.objects.create(
            user_id=user_id,
            name=event_name,
            event_type_id=event_type_id,
            total_budget=total_budget,
            notes=notes,
            status='draft',
            created_at=timezone.now()
        )
        
        # Create each function
        for func in functions:
            function = Functions.objects.create(
                event=event,
                function_type_id=func['function_type_id'],
                budget=func['budget'],
                date=func['date'],
                guest_count=func['guest_count'],
                status='planned'
            )
            
            # Add services to the function
            for service in func.get('services', []):
                # You'll need to create a FunctionService model for this relationship
                function_service = FunctionService.objects.create(
                    function=function,
                    listing_id=service['listing_id'],
                    package_id=service.get('package_id'),
                    notes=service.get('notes')
                )
                
                # Add products
                for product_id in service.get('products', []):
                    FunctionServiceProduct.objects.create(
                        function_service=function_service,
                        product_id=product_id
                    )
                
                # Add add-ons
                for add_on_id in service.get('add_ons', []):
                    FunctionServiceAddOn.objects.create(
                        function_service=function_service,
                        add_on_id=add_on_id
                    )
        
        return {'success': True, 'event_id': event.id}
    
    except Exception as e:
        return {'success': False, 'error': str(e)}

# You'll need these additional models to support the relationships:
class FunctionService(m.Model):
    function = m.ForeignKey(Functions, on_delete=m.CASCADE)
    listing = m.ForeignKey(Listing, on_delete=m.CASCADE)
    package = m.ForeignKey(Packages, on_delete=m.SET_NULL, null=True)
    notes = m.TextField(blank=True)

class FunctionServiceProduct(m.Model):
    function_service = m.ForeignKey(FunctionService, on_delete=m.CASCADE)
    product = m.ForeignKey(Product, on_delete=m.CASCADE)

class FunctionServiceAddOn(m.Model):
    function_service = m.ForeignKey(FunctionService, on_delete=m.CASCADE)
    add_on = m.ForeignKey(AddOns, on_delete=m.CASCADE)