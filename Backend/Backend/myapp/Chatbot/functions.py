from typing import Dict, List, Optional
from django.db.models import Q
from ..models.listing_types_models import (
    Venue,
    Caterers,
    Decorators,
    CarRenters,
    PhotographyPlaces,
    Parlors,
    Salons,
    Photographers,
    VideoEditors,
    GraphicDesigners
)

from ..models.listing_models import Listing

def search_services(
    location: Optional[str] = None,
    min_capacity: Optional[int] = None,
    max_capacity: Optional[int] = None,
    event_type: Optional[str] = None,
    min_price: Optional[int] = None,
    max_price: Optional[int] = None,
    listing_type: Optional[str] = None,
    name: Optional[str] = None,
    venue_type: Optional[str] = None,
    catering: Optional[str] = None,
    venue_staff: Optional[str] = None,
    basic_price: Optional[int] = None,
    owner_id: Optional[str] = None,
    freelancer_id: Optional[str] = None,
    caterer_service_type: Optional[str] = None,
    catering_options: Optional[str] = None,
    caterer_staff: Optional[str] = None,
    caterer_expertise: Optional[str] = None,
    car_rental_service_type: Optional[str] = None,
    decorator_type: Optional[str] = None,
    decorator_catering: Optional[str] = None,
    decorator_staff: Optional[str] = None,
    photography_place_type: Optional[str] = None,
    has_parlor: Optional[bool] = None,
    has_salon: Optional[bool] = None,
    has_portfolio: Optional[bool] = None,
) -> List[Dict]:
    """Search for services based on criteria provided using Django ORM."""
    # Start with base queryset
    queryset = Listing.objects.filter(status='active')
    
    # Apply general filters that apply to all listings
    if location:
        queryset = queryset.filter(location__icontains=location)
    if min_price:
        queryset = queryset.filter(priceMin__gte=min_price)
    if max_price:
        queryset = queryset.filter(priceMax__lte=max_price)
    if basic_price:
        queryset = queryset.filter(basicPrice__lte=basic_price)
    if name:
        queryset = queryset.filter(name__icontains=name)
    if listing_type:
        queryset = queryset.filter(type=listing_type)
    if owner_id:
        queryset = queryset.filter(ownerID=owner_id)
    if freelancer_id:
        queryset = queryset.filter(freelancerID=freelancer_id)
    
    # Now handle type-specific filters
    results = []
    for listing in queryset:
        include = True
        listing_data = {
            "id": listing.id,
            "name": listing.name,
            "location": listing.location,
            "price_range": {
                "min": listing.priceMin,
                "max": listing.priceMax,
            },
            "basic_price": listing.basicPrice,
            "description": listing.description,
            "type": listing.type,
        }
        
        # Handle each listing type with its specific filters
        if listing.type == "Venue":
            try:
                venue = Venue.objects.get(listingId=listing)
                if min_capacity and venue.guestminAllowed > min_capacity:
                    include = False
                if max_capacity and venue.guestmaxAllowed < max_capacity:
                    include = False
                if venue_type and venue_type.lower() not in venue.venueType.lower():
                    include = False
                if catering and catering.lower() not in venue.catering.lower():
                    include = False
                if venue_staff and venue_staff.lower() not in venue.staff.lower():
                    include = False
                
                if include:
                    listing_data.update({
                        "venue_type": venue.venueType,
                        "catering": venue.catering,
                        "staff": venue.staff,
                        "capacity": {
                            "min": venue.guestminAllowed,
                            "max": venue.guestmaxAllowed,
                        },
                    })
            except Venue.DoesNotExist:
                include = False
                
        elif listing.type == "Caterer":
            try:
                caterer = Caterers.objects.get(listingId=listing)
                if caterer_service_type and caterer_service_type.lower() not in caterer.serviceType.lower():
                    include = False
                if catering_options and catering_options.lower() not in caterer.cateringOptions.lower():
                    include = False
                if caterer_staff and caterer_staff.lower() not in caterer.staff.lower():
                    include = False
                if caterer_expertise and caterer_expertise.lower() not in caterer.expertise.lower():
                    include = False
                
                if include:
                    listing_data.update({
                        "caterer_service_type": caterer.serviceType,
                        "catering_options": caterer.cateringOptions,
                        "staff": caterer.staff,
                        "expertise": caterer.expertise,
                    })
            except Caterers.DoesNotExist:
                include = False
                
        elif listing.type == "Decorator":
            try:
                decorator = Decorators.objects.get(listingId=listing)
                if decorator_type and decorator_type.lower() not in decorator.decorType.lower():
                    include = False
                if decorator_catering and decorator_catering.lower() not in decorator.catering.lower():
                    include = False
                if decorator_staff and decorator_staff.lower() not in decorator.staff.lower():
                    include = False
                
                if include:
                    listing_data.update({
                        "decorator_type": decorator.decorType,
                        "catering": decorator.catering,
                        "staff": decorator.staff,
                    })
            except Decorators.DoesNotExist:
                include = False
                
        elif listing.type == "Car Renter":
            try:
                car_renter = CarRenters.objects.get(listingId=listing)
                if car_rental_service_type and car_rental_service_type.lower() not in car_renter.serviceType.lower():
                    include = False
                
                if include:
                    listing_data.update({
                        "car_rental_service_type": car_renter.serviceType,
                    })
            except CarRenters.DoesNotExist:
                include = False
                
        elif listing.type == "Photographer":
            try:
                photographer = Photographers.objects.get(listingId=listing)
                if has_portfolio and not photographer.portfolioLink:
                    include = False
                
                if include:
                    listing_data.update({
                        "portfolio": photographer.portfolioLink,
                    })
            except Photographers.DoesNotExist:
                include = False
                
        elif listing.type == "Photography Place":
            try:
                photo_place = PhotographyPlaces.objects.get(listingId=listing)
                if photography_place_type and photography_place_type.lower() not in photo_place.type.lower():
                    include = False
                
                if include:
                    listing_data.update({
                        "place_type": photo_place.type,
                    })
            except PhotographyPlaces.DoesNotExist:
                include = False
                
        elif listing.type == "Parlour":
            if has_parlor is not None:
                include = has_parlor
                
            if include:
                listing_data.update({
                    "parlor_exists": True,
                })
                
        elif listing.type == "Salon":
            if has_salon is not None:
                include = has_salon
                
            if include:
                listing_data.update({
                    "salon_exists": True,
                })
        
        if include:
            results.append(listing_data)
    
    return results


def get_service_details(listing_id: str) -> Dict:
    """Get detailed information about a specific service using Django ORM."""
    try:
        listing = Listing.objects.get(id=listing_id)
    except Listing.DoesNotExist:
        return {"error": "Service not found"}
    
    result = {
        "id": listing.id,
        "name": listing.name,
        "location": listing.location,
        "price_range": {"min": listing.priceMin, "max": listing.priceMax},
        "basic_price": listing.basicPrice,
        "description": listing.description,
        "type": listing.type,
    }
    
    # Add type-specific details
    if listing.type == "Venue":
        try:
            venue = Venue.objects.get(listingId=listing)
            result.update({
                "capacity": {
                    "min": venue.guestminAllowed,
                    "max": venue.guestmaxAllowed,
                },
                "venue_type": venue.venueType,
                "catering": venue.catering,
                "staff": venue.staff,
            })
        except Venue.DoesNotExist:
            pass
            
    elif listing.type == "Caterer":
        try:
            caterer = Caterers.objects.get(listingId=listing)
            result.update({
                "caterer_service_type": caterer.serviceType,
                "catering_options": caterer.cateringOptions,
                "staff": caterer.staff,
                "expertise": caterer.expertise,
            })
        except Caterers.DoesNotExist:
            pass
            
    elif listing.type == "Decorator":
        try:
            decorator = Decorators.objects.get(listingId=listing)
            result.update({
                "decorator_type": decorator.decorType,
                "catering": decorator.catering,
                "staff": decorator.staff,
            })
        except Decorators.DoesNotExist:
            pass
            
    elif listing.type == "Car Renter":
        try:
            car_renter = CarRenters.objects.get(listingId=listing)
            result.update({
                "car_rental_service_type": car_renter.serviceType,
            })
        except CarRenters.DoesNotExist:
            pass
            
    elif listing.type == "Photographer":
        try:
            photographer = Photographers.objects.get(listingId=listing)
            result.update({
                "portfolio": photographer.portfolioLink,
            })
        except Photographers.DoesNotExist:
            pass
            
    elif listing.type == "Photography Place":
        try:
            photo_place = PhotographyPlaces.objects.get(listingId=listing)
            result.update({
                "place_type": photo_place.type,
            })
        except PhotographyPlaces.DoesNotExist:
            pass
            
    elif listing.type == "Parlour":
        result.update({
            "parlor_exists": True,
        })
        
    elif listing.type == "Salon":
        result.update({
            "salon_exists": True,
        })
    
    return result


def get_venue_recommendations(
    event_type: str,
    location: str,
    guest_count: int,
    budget_level: tuple,  # (min_price, max_price)
) -> List[Dict]:
    """Get personalized venue recommendations based on event requirements using Django ORM."""
    # Start with base queryset
    queryset = Listing.objects.filter(
        type='Venue',
        status='active'
    )
    
    # Apply basic filters
    if location:
        queryset = queryset.filter(location__icontains=location)
    
    # We'll filter venues in Python to properly calculate recommendation scores
    venues = []
    for listing in queryset:
        try:
            venue = Venue.objects.get(listingId=listing)
            
            # Check capacity and budget constraints
            if (venue.guestminAllowed > guest_count or 
                venue.guestmaxAllowed < guest_count or
                listing.priceMin > budget_level[1] or 
                listing.priceMax < budget_level[0]):
                continue
                
            # Calculate recommendation score
            score = 0
            
            # Score based on capacity match
            capacity_ratio = venue.guestmaxAllowed / guest_count
            if 1.0 <= capacity_ratio <= 1.5:
                score += 30
            elif 1.5 < capacity_ratio <= 2.5:
                score += 20
            elif capacity_ratio > 2.5:
                score += 10
            else:
                score += max(0, int(capacity_ratio * 30))
                
            # Score based on price match
            price_mid = (listing.priceMin + listing.priceMax) / 2
            budget_mid = (budget_level[0] + budget_level[1]) / 2
            price_ratio = min(price_mid, budget_mid) / max(price_mid, budget_mid)
            score += int(price_ratio * 30)
            
            # Add event type matching if needed
            # (You might want to add this based on your business logic)
            
            venue_data = {
                "id": listing.id,
                "name": listing.name,
                "location": listing.location,
                "capacity": {
                    "min": venue.guestminAllowed,
                    "max": venue.guestmaxAllowed,
                },
                "price_range": {
                    "min": listing.priceMin,
                    "max": listing.priceMax,
                },
                "description": listing.description,
                "type": venue.venueType,
                "catering": venue.catering,
                "staff": venue.staff,
                "recommendation_score": score,
            }
            
            venues.append(venue_data)
        except Venue.DoesNotExist:
            continue
    
    # Sort by recommendation score
    venues.sort(key=lambda x: x["recommendation_score"], reverse=True)
    return venues


def initiate_booking(
    user_id: str,
    date: str,
    customer_name: str,
    customer_email: str,
    customer_phone: str,
    event_type: str,
    estimated_guests: int,
    special_requests: Optional[str] = None,
) -> Dict:
    """Initiate a booking request for a venue."""
    # Note: You'll need to implement the actual booking logic with your models
    # This is a placeholder implementation
    
    return {
        "booking_initiated": True,
        "date": date,
        "customer_name": customer_name,
        "next_steps": "Our team will contact you within 24 hours to confirm your booking and discuss details.",
        "confirmation_sent_to": customer_email,
    }