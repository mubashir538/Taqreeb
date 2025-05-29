from rest_framework import serializers as s
from .listing_serializers import ListingSerializer,PackagesSerializer,ProductsSerializer,PicturesListingSerializers
from ..models import booking_models as m
from ..models.listing_models import PicturesListings

class CartItemSerializer(s.ModelSerializer):
    item_details = s.SerializerMethodField()
    
    class Meta:
        model = m.CartItem
        fields = ['id', 'item_type', 'item_id', 'quantity', 'added_at', 'item_details']
        # Remove the extra_kwargs with coerce_to_string
    
    def get_item_details(self, obj):
        if obj.item_type == 'listing':
            item = m.Listing.objects.filter(id=obj.item_id).first()
            if item:
                item = ListingSerializer(item).data
                item['pictures'] = PicturesListingSerializers(PicturesListings.objects.filter(listingId=item['id']).first()).data
                print(item)
            
            else:
                item = None
            return item
        elif obj.item_type == 'product':
            item = m.Product.objects.filter(id=obj.item_id).first()
            return ProductsSerializer(item).data if item else None
        elif obj.item_type == 'package':
            item = m.Packages.objects.filter(id=obj.item_id).first()
            return PackagesSerializer(item).data if item else None
        return None
    
    def to_representation(self, instance):
        """
        Convert the item_id to string in the serialized output
        """
        representation = super().to_representation(instance)
        representation['item_id'] = str(representation['item_id'])
        return representation


class CartSerializer(s.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total_items = s.SerializerMethodField()
    total_price = s.SerializerMethodField()
    
    class Meta:
        model = m.Cart
        fields = ['id', 'user', 'created_at', 'updated_at', 'items', 'total_items', 'total_price']
    
    def get_total_items(self, obj):
        return obj.items.count()
    
    def get_total_price(self, obj):
        total = 0
        for item in obj.items.all():
            if item.item_type == 'listing':
                listing = m.Listing.objects.filter(id=item.item_id).first()
                total += listing.priceMin * item.quantity if listing else 0
            elif item.item_type == 'product':
                product = m.Product.objects.filter(id=item.item_id).first()
                total += product.price * item.quantity if product else 0
            elif item.item_type == 'package':
                package = m.Packages.objects.filter(id=item.item_id).first()
                total += package.price * item.quantity if package else 0
        return total
    