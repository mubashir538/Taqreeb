import sqlite3
from typing import Dict, List, Optional


def get_db_connection():
    """Helper function to create database connection"""
    return sqlite3.connect("listings.db", check_same_thread=False)

# Function definitions that will be exposed to the assistant
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
    """Search for services based on criteria provided."""
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
    SELECT * FROM listings 
    WHERE 1=1
    """
    params = []

    if listing_type:
        query += " AND Type = ?"
        params.append(listing_type)

    if location:
        query += " AND Location LIKE ?"
        params.append(f"%{location}%")

    if min_capacity:
        query += " AND [Guest Min Allowed] <= ?"
        params.append(min_capacity)

    if max_capacity:
        query += " AND [Guest Max Allowed] >= ?"
        params.append(max_capacity)

    if min_price:
        query += " AND [Price Min] >= ?"
        params.append(min_price)

    if max_price:
        query += " AND [Price Max] <= ?"
        params.append(max_price)

    if venue_type:
        query += " AND [Venue Type] LIKE ?"
        params.append(f"%{venue_type}%")

    if catering:
        query += " AND [Catering] LIKE ?"
        params.append(f"%{catering}%")

    if name:
        query += " AND Name LIKE ?"
        params.append(f"%{name}%")

    if venue_staff:
        query += " AND [Venue Staff] LIKE ?"
        params.append(f"%{venue_staff}%")

    if basic_price:
        query += " AND [Basic Price] <= ?"
        params.append(basic_price)

    if owner_id:
        query += " AND [Owner ID] = ?"
        params.append(owner_id)

    if freelancer_id:
        query += " AND [Freelancer ID] = ?"
        params.append(freelancer_id)

    if caterer_service_type:
        query += " AND [Caterer Service Type] LIKE ?"
        params.append(f"%{caterer_service_type}%")

    if catering_options:
        query += " AND [Catering Options] LIKE ?"
        params.append(f"%{catering_options}%")

    if caterer_staff:
        query += " AND [Caterer Staff] LIKE ?"
        params.append(f"%{caterer_staff}%")

    if caterer_expertise:
        query += " AND [Caterer Expertise] LIKE ?"
        params.append(f"%{caterer_expertise}%")

    if car_rental_service_type:
        query += " AND [Car Rental Service Type] LIKE ?"
        params.append(f"%{car_rental_service_type}%")

    if decorator_type:
        query += " AND [Decorator Type] LIKE ?"
        params.append(f"%{decorator_type}%")

    if decorator_catering:
        query += " AND [Decorator Catering] LIKE ?"
        params.append(f"%{decorator_catering}%")

    if decorator_staff:
        query += " AND [Decorator Staff] LIKE ?"
        params.append(f"%{decorator_staff}%")

    if photography_place_type:
        query += " AND [Photography Place Type] LIKE ?"
        params.append(f"%{photography_place_type}%")

    if has_parlor is not None:
        query += " AND [Parlor Exists] = ?"
        params.append("Yes" if has_parlor else "No")

    if has_salon is not None:
        query += " AND [Salon Exists] = ?"
        params.append("Yes" if has_salon else "No")

    if has_portfolio is not None and has_portfolio:
        query += " AND [Photographer Portfolio] IS NOT NULL AND [Photographer Portfolio] != ''"

    print(">> query", query)
    print(">> params", params)

    cursor.execute(query, params)
    print('Cursor: ',cursor)
    columns = [description[0] for description in cursor.description]
    print('columns: ',columns)
    results = []

    for row in cursor.fetchall():
        service_dict = dict(zip(columns, row))
        result = {
            "id": service_dict["Listing ID"],
            "name": service_dict["Name"],
            "location": service_dict["Location"],
            "price_range": {
                "min": service_dict["Price Min"],
                "max": service_dict["Price Max"],
            },
            "basic_price": service_dict["Basic Price"],
            "description": service_dict["Description"],
            "type": service_dict["Type"],
        }

        # Add type-specific fields
        if service_dict["Type"] == "Venue":
            result.update(
                {
                    "venue_type": service_dict["Venue Type"],
                    "catering": service_dict["Catering"],
                    "staff": service_dict["Venue Staff"],
                    "capacity": {
                        "min": service_dict["Guest Min Allowed"],
                        "max": service_dict["Guest Max Allowed"],
                    },
                }
            )
        elif service_dict["Type"] == "Caterer":
            result.update(
                {
                    "caterer_service_type": service_dict["Caterer Service Type"],
                    "catering_options": service_dict["Catering Options"],
                    "staff": service_dict["Caterer Staff"],
                    "expertise": service_dict["Caterer Expertise"],
                }
            )
        elif service_dict["Type"] == "Decorator":
            result.update(
                {
                    "decorator_type": service_dict["Decorator Type"],
                    "catering": service_dict["Decorator Catering"],
                    "staff": service_dict["Decorator Staff"],
                }
            )
        elif service_dict["Type"] == "Car Renter":
            result.update(
                {"car_rental_service_type": service_dict["Car Rental Service Type"]}
            )
        elif service_dict["Type"] == "Photographer":
            result.update({"portfolio": service_dict["Photographer Portfolio"]})
        elif service_dict["Type"] == "Photography Place":
            result.update({"place_type": service_dict["Photography Place Type"]})
        elif service_dict["Type"] == "Parlour":
            result.update({"parlor_exists": service_dict["Parlor Exists"]})
        elif service_dict["Type"] == "Salon":
            result.update({"salon_exists": service_dict["Salon Exists"]})

        results.append(result)

    conn.close()
    print("*" * 50)
    print(results)
    print("*" * 50)
    return results


def get_service_details(venue_id: str) -> Dict:
    """Get detailed information about a specific service."""
    conn = get_db_connection()
    cursor = conn.cursor()

    query = "SELECT * FROM listings WHERE [Listing ID] = ?"
    cursor.execute(query, (venue_id,))

    columns = [description[0] for description in cursor.description]
    row = cursor.fetchone()

    if not row:
        conn.close()
        return {"error": "Venue not found"}

    venue_dict = dict(zip(columns, row))
    result = {
        "id": venue_dict["Listing ID"],
        "name": venue_dict["Name"],
        "location": venue_dict["Location"],
        "capacity": {
            "min": venue_dict["Guest Min Allowed"],
            "max": venue_dict["Guest Max Allowed"],
        },
        "price_range": {"min": venue_dict["Price Min"], "max": venue_dict["Price Max"]},
        "basic_price": venue_dict["Basic Price"],
        "description": venue_dict["Description"],
        "type": venue_dict["Type"],
        "venue_type": venue_dict["Venue Type"],
        "catering": venue_dict["Catering"],
        "staff": venue_dict["Venue Staff"],
    }

    conn.close()
    return result


def get_venue_recommendations(
    event_type: str,
    location: str,
    guest_count: int,
    budget_level: tuple,  # (min_price, max_price)
) -> List[Dict]:
    """Get personalized venue recommendations based on event requirements."""
    conn = get_db_connection()
    cursor = conn.cursor()

    query = """
    SELECT * FROM listings 
    WHERE Type = 'Venue'
    AND [Guest Min Allowed] <= ?
    AND [Guest Max Allowed] >= ?
    AND [Price Min] >= ?
    AND [Price Max] <= ?
    """

    if location:
        query += " AND Location LIKE ?"
        params = [
            guest_count,
            guest_count,
            budget_level[0],
            budget_level[1],
            f"%{location}%",
        ]
    else:
        params = [guest_count, guest_count, budget_level[0], budget_level[1]]

    cursor.execute(query, params)
    columns = [description[0] for description in cursor.description]
    results = []

    for row in cursor.fetchall():
        venue_dict = dict(zip(columns, row))

        # Calculate recommendation score
        score = 0

        # Score based on capacity match
        capacity_ratio = venue_dict["Guest Max Allowed"] / guest_count
        if 1.0 <= capacity_ratio <= 1.5:
            score += 30
        elif 1.5 < capacity_ratio <= 2.5:
            score += 20
        elif capacity_ratio > 2.5:
            score += 10
        else:
            score += max(0, int(capacity_ratio * 30))

        # Score based on price match
        price_mid = (venue_dict["Price Min"] + venue_dict["Price Max"]) / 2
        budget_mid = (budget_level[0] + budget_level[1]) / 2
        price_ratio = min(price_mid, budget_mid) / max(price_mid, budget_mid)
        score += int(price_ratio * 30)

        result = {
            "id": venue_dict["Listing ID"],
            "name": venue_dict["Name"],
            "location": venue_dict["Location"],
            "capacity": {
                "min": venue_dict["Guest Min Allowed"],
                "max": venue_dict["Guest Max Allowed"],
            },
            "price_range": {
                "min": venue_dict["Price Min"],
                "max": venue_dict["Price Max"],
            },
            "description": venue_dict["Description"],
            "type": venue_dict["Venue Type"],
            "catering": venue_dict["Catering"],
            "staff": venue_dict["Venue Staff"],
            "recommendation_score": score,
        }

        results.append(result)

    conn.close()

    # Sort by recommendation score
    results.sort(key=lambda x: x["recommendation_score"], reverse=True)
    return results


def initiate_booking(
    venue_id: str,
    date: str,
    customer_name: str,
    customer_email: str,
    customer_phone: str,
    event_type: str,
    estimated_guests: int,
    special_requests: Optional[str] = None,
) -> Dict:
    """Initiate a booking request for a venue."""
    # If we need to have do availibility check
    # availability = check_availability(venue_id, date)

    # if not availability["available"]:
    #     return {
    #         "booking_initiated": False,
    #         "reason": "Venue not available on requested date",
    #         "suggested_alternatives": availability.get("suggested_alternatives", []),
    #     }

    # booking_id = f"BK{datetime.now().strftime('%Y%m%d%H%M%S')}"

    return {
        "booking_initiated": True,
        "venue_id": venue_id,
        # "booking_id": booking_id,
        # "venue_name": availability["venue_name"],
        "date": date,
        "customer_name": customer_name,
        "next_steps": "Our team will contact you within 24 hours to confirm your booking and discuss details.",
        "confirmation_sent_to": customer_email,
    }
