import os
from rest_framework import status, viewsets
from rest_framework.decorators import api_view, permission_classes
from ..models.booking_models import BookingCart
from ..models.listing_models import PicturesListings
from ..Serializers.booking_serializers import BookingCartSerializer
from ..Serializers.listing_serializers import ListingSerializer,PicturesListingSerializers
from ..models.listing_models import Listing
from ..models.listing_types_models import Venue,Salons,Parlors,PhotographyPlaces,Decorators,Photographers
from ..models.booking_models import BookingCart,Cart,CartItem
from ..Serializers.ecommerce_serializers import CartItemSerializer,CartSerializer
from ..models.event_models import Functions
from ..models.user_models import User
from ..Serializers.service_serializers import VenueSerializer,SalonsSerializer,ParlorsSerializer,PhotographersSerializer,DecoratorsSerializer,PhotographyPlacesSerializer
from datetime import datetime
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, permissions, status


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def show_book_cart(request,id):
    cart = BookingCart.objects.filter(functionId=id,status='Cart')
    if cart.count() == 0:
        return Response({'status':'CartEmpty'})
    cartserializer = BookingCartSerializer(cart,many=True)
    print('Cart: ',cartserializer.data)
    items = []
    for i in cart:
        listing = i.listingId
        listingserializer = ListingSerializer(listing,many=False)
        pictures = PicturesListings.objects.filter(listingId=listing.id)
        pictures = PicturesListingSerializers(pictures,many=True).data
        view= None
        if i.type == 'Venue':
            view = Venue.objects.get(listingId=listing.id)
            view = VenueSerializer(view,many=False).data
        elif i.type == 'Salon':
            view = Salons.objects.get(listingId=listing.id)
            view = SalonsSerializer(view,many=False).data
        elif i.type == 'Parlor':
            view = Parlors.objects.get(listingId=listing.id)
            view = ParlorsSerializer(view,many=False).data
        elif i.type == 'PhotographyPlace':
            view = PhotographyPlaces.objects.get(listingId=listing.id)
            view = PhotographyPlacesSerializer(view,many=False).data
        elif i.type == 'Decorator':
            view = Decorators.objects.get(listingId=listing.id)
            view = DecoratorsSerializer(view,many=False).data
        elif i.type == 'Photographer':
            view = Photographers.objects.get(listingId=listing.id)
            view = PhotographersSerializer(view,many=False).data
        item = {'id':i.id,'listing':listingserializer.data,'type':i.type,'view':view,'pictures':pictures}
        items.append(item)
    return Response({'status':'success','cart':items})

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_to_book_cart(request):
    fid = request.data.get('fid')
    lid = request.data.get('lid')
    uid = request.data.get('uid')
    listing_type = request.data.get('type')
    slot = request.data.get('slot')
    function = Functions.objects.get(id=fid)
    listing = Listing.objects.get(id=lid)
    user = User.objects.get(id=uid)
    if slot:
        if slot.find(' ') != -1:
            slot = slot[:-1]
            slot = datetime.strptime(slot, "%Y-%m-%d %H:%M:%S.%f").date()
        cart = BookingCart(userId=user,listingId=listing,functionId=function,type=listing_type,status='Cart',slot=slot)
    else:
        cart = BookingCart(userId=user,listingId=listing,functionId=function,type=listing_type,status='Cart')
    cart.save()
    if function.budget < listing.basicPrice:
        return Response({'status':'BudgetError','message':'Budget not enough'})
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def cart_items(request, cart_items_id):
    listing = Listing.objects.get(id = cart_items_id)
    cart_items = CartItem.objects.get(CartItemsID = cart_items_id)
    listing_serializer = ListingSerializer(listing, many=True)
    cart_items_serializer = CartItemSerializer(cart_items, many = True)
    return Response({'Status': 'Success', 'Listing': listing_serializer.data, 'Cartitems': cart_items_serializer.data})

class CartViewSet(viewsets.ModelViewSet):
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)
    
    def retrieve(self, request, *args, **kwargs):
        cart = Cart.objects.get_or_create(user=request.user)
        serializer = self.get_serializer(cart)
        return Response(serializer.data)

class CartItemViewSet(viewsets.ModelViewSet):
    serializer_class = CartItemSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        cart, _ = Cart.objects.get_or_create(user=self.request.user)
        return cart.items.all()
    
    def create(self, request, *args, **kwargs):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        data = request.data.copy()
        data['cart'] = cart.id
        
        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
    
    def destroy(self, request, *args, **kwargs):
        instance = self.get_object()
        self.perform_destroy(instance)
        return Response(status=status.HTTP_204_NO_CONTENT)