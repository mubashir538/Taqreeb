from .. import models2 as m
import random as rd
import requests as rq
import re
from .. import Serializers as s
import random as rd
from django.core.files.storage import FileSystemStorage
import json
import inspect

def urlShortener(url):
    try:
        response = rq.get("http://tinyurl.com/api-create.php?url="+url)
        response.raise_for_status()
        return response.text
    except Exception as e:
        print(e)
        return e

def clean_name(name):
    return re.sub(r'[^a-zA-Z0-9]', '', name.lower())

def generate_username(first_name, last_name):
    first = clean_name(first_name)
    last = clean_name(last_name)

    base_variants = [
        f"{first}{last}",
        f"{first}_{last}",
        f"{first}_{last[:1]}",
        f"{first[:1]}_{last}",
        f"{first[:1]}_{last[:1]}"
    ]

    for variant in base_variants:
        if not m.User.objects.filter(username=variant).exists():
            return variant

    while True:
        variant = f"{first}_{last}_{rd.randint(100, 9999)}"
        if not m.User.objects.filter(username=variant).exists():
            return variant
        
def get_picture(listing_id):
    picture = m.PicturesListings.objects.filter(listingId=listing_id).first()
    return s.PicturesListingSerializers(picture).data if picture else None


def get_view_data(listing_id):
    model_serializer_pairs = [
        (m.Venue, s.VenueSerializer, 'listingID'),
        (m.Caterers, s.CaterersSerializer, 'listingId'),
        (m.CarRenters, s.CarRentersSerializer, 'listingID'),
        (m.Decorators, s.DecoratorsSerializer, 'listingId'),
        (m.PhotographyPlaces, s.PhotographyPlacesSerializer, 'listingID'),
        (m.Photographers, s.PhotographersSerializer, 'listingId'),
        (m.VideoEditors, s.VideoEditorsSerializer, 'listingId'),
        (m.GraphicDesigners, s.GraphicDesignersSerializer, 'listingId'),
    ]

    for model, serializer_class, id_field in model_serializer_pairs:
        filters = {id_field: listing_id}
        obj = model.objects.filter(**filters).first()
        if obj:
            return serializer_class(obj).data

    return None

def create_listing(data, user, listing_type, category):
    data['priceMin'] = str(data['priceMin']).replace(',', '')
    data['priceMax'] = str(data['priceMax']).replace(',', '')
    avg_price = (int(data['priceMin']) + int(data['priceMax'])) / 2
    listing_kwargs = {
        'name': data['name'],
        'description': data['description'],
        'type': category,
        'location': data['location'],
        'priceMin': data['priceMin'],
        'priceMax': data['priceMax'],
        'basicPrice': avg_price,
        'status': 'Pending'
    }

    if listing_type == 'freelancer':
        freelancer = m.Freelancer.objects.get(userID=user.id)
        listing_kwargs['freelancerID'] = freelancer
    else:
        owner = m.BusinessOwner.objects.get(userID=user)
        listing_kwargs['ownerID'] = owner

    listing = m.Listing(**listing_kwargs)
    listing.save()
    return listing


def create_view_for_category(category, view_data, listing):
    view_models = {
        'Venue': (m.Venue, {
            'catering': view_data.get('catering'),
            'guestminAllowed': view_data.get('guestminAllowed'),
            'guestmaxAllowed': view_data.get('guestmaxAllowed'),
            'staff': view_data.get('staff'),
            'venueType': view_data.get('venueType'),
            'listingID': listing
        }),
        'PhotographyPlace': (m.PhotographyPlaces, {
            'type': view_data.get('type'),
            'listingID': listing
        }),
        'Decorator': (m.Decorators, {
            'decorType': view_data.get('decorType'),
            'catering': view_data.get('catering'),
            'staff': view_data.get('staff'),
            'listingId': listing
        }),
        'Photographer': (m.Photographers, {
            'portfolioLink': view_data.get('portfolioLink'),
            'listingId': listing
        }),
        'Caterer': (m.Caterers, {
            'serviceType': view_data.get('serviceType'),
            'cateringOptions': view_data.get('cateringOptions'),
            'staff': view_data.get('staff'),
            'expertise': view_data.get('expertise'),
            'listingId': listing
        }),
        'CarRenter': (m.CarRenters, {
            'serviceType': view_data.get('serviceType'),
            'listingID': listing
        }),
        'VideoEditor': (m.VideoEditors, {
            'portfolioLink': view_data.get('portfolioLink'),
            'listingId': listing
        }),
        'GraphicDesigner': (m.GraphicDesigners, {
            'portfolioLink': view_data.get('portfolioLink'),
            'listingId': listing
        })
    }

    if category in view_models:
        model_class, fields = view_models[category]
        view_instance = model_class(**fields)
        view_instance.save()


def save_listing_pictures(category, listing, pictures):
    storage = FileSystemStorage()
    for count, picture in enumerate(pictures, start=1):
        path = storage.save(f'uploads/listings/{category}/{listing.id}-{count}.png', picture)
        m.PicturesListings(
            listingId=listing,
            picturePath=storage.url(path)
        ).save()


def save_packages(listing, packages):
    if not packages:
        return
    try:
        package_list = json.loads(packages)
        for pkg in package_list:
            package_obj = m.Packages(
                listingId=listing,
                name=pkg.get('name'),
                price=pkg.get('price'),
                description=pkg.get('details')
            )
            package_obj.save()
            for image in pkg.get('images', []):
                m.PicturesPackages(packageId=package_obj, picturePath=image).save()
    except Exception as e:
        print(f"Package saving error: {e}")


def save_products(listing, products):
    if not products:
        return
    try:
        product_list = json.loads(products)
        product_list = products

        for prod in product_list:
            product_obj = m.Product(
                listingId=listing,
                name=prod.get('name'),
                description=prod.get('description'),
                price=prod.get('price'),
                quantity=prod.get('quantity', 1)
            )
            product_obj.save()
            if 'image' in prod:
                m.PicturesProducts(productId=product_obj, picturePath=prod['image']).save()
    except Exception as e:
        print(f"Product saving error: {e}")


def save_addons(listing, addons):
    if not addons:
        return
    try:
        addon_list = json.loads(addons)
        for addon in addon_list:
            m.AddOns(
                listingId=listing,
                name=addon.get('name'),
                price=addon.get('price'),
                isPer=addon.get('perhead') == "Yes",
                perType=addon.get('headtype') if addon.get('perhead') == "Yes" else None
            ).save()
    except Exception as e:
        print(f"Addon saving error: {e}")

def get_variable_name(var):
    callers_local_vars = inspect.currentframe().f_back.f_locals.items()
    listing = [name for name, value in callers_local_vars if value is var]
    return listing[0]