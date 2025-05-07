import os
from rest_framework import status, viewsets
from rest_framework.decorators import api_view, permission_classes
from .. import models2 as m
from .. import Serializers as s
from datetime import datetime
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, permissions, status


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def show_book_cart(request,id):
    cart = m.BookingCart.objects.filter(functionId=id,status='Cart')
    if cart.count() == 0:
        return Response({'status':'CartEmpty'})
    cartserializer = s.BookingCartSerializer(cart,many=True)
    print('Cart: ',cartserializer.data)
    items = []
    for i in cart:
        listing = i.listingId
        listingserializer = s.ListingSerializer(listing,many=False)
        pictures = m.PicturesListings.objects.filter(listingId=listing.id)
        pictures = s.PicturesListingSerializers(pictures,many=True).data
        view= None
        if i.type == 'Venue':
            view = m.Venue.objects.get(listingId=listing.id)
            view = s.VenueSerializer(view,many=False).data
        elif i.type == 'Salon':
            view = m.Salons.objects.get(listingId=listing.id)
            view = s.SalonsSerializer(view,many=False).data
        elif i.type == 'Parlor':
            view = m.Parlors.objects.get(listingId=listing.id)
            view = s.ParlorsSerializer(view,many=False).data
        elif i.type == 'PhotographyPlace':
            view = m.PhotographyPlaces.objects.get(listingId=listing.id)
            view = s.PhotographyPlacesSerializer(view,many=False).data
        elif i.type == 'Decorator':
            view = m.Decorators.objects.get(listingId=listing.id)
            view = s.DecoratorsSerializer(view,many=False).data
        elif i.type == 'Photographer':
            view = m.Photographers.objects.get(listingId=listing.id)
            view = s.PhotographersSerializer(view,many=False).data
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
    function = m.Functions.objects.get(id=fid)
    listing = m.Listing.objects.get(id=lid)
    user = m.User.objects.get(id=uid)
    if slot:
        if slot.find(' ') != -1:
            slot = slot[:-1]
            slot = datetime.strptime(slot, "%Y-%m-%d %H:%M:%S.%f").date()
        cart = m.BookingCart(userId=user,listingId=listing,functionId=function,type=listing_type,status='Cart',slot=slot)
    else:
        cart = m.BookingCart(userId=user,listingId=listing,functionId=function,type=listing_type,status='Cart')
    cart.save()
    if function.budget < listing.basicPrice:
        return Response({'status':'BudgetError','message':'Budget not enough'})
    return Response({'status':'success'})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def cart_items(request, cart_items_id):
    listing = m.Listing.objects.get(id = cart_items_id)
    cart_items = m.CartItems.objects.get(CartItemsID = cart_items_id)
    listing_serializer = s.ListingSerializer(listing, many=True)
    cart_items_serializer = s.CartItemsSerializer(cart_items, many = True)
    return Response({'Status': 'Success', 'Listing': listing_serializer.data, 'Cartitems': cart_items_serializer.data})

class CartViewSet(viewsets.ModelViewSet):
    serializer_class = s.CartSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return m.Cart.objects.filter(user=self.request.user)
    
    def retrieve(self, request, *args, **kwargs):
        cart = m.Cart.objects.get_or_create(user=request.user)
        serializer = self.get_serializer(cart)
        return Response(serializer.data)

class CartItemViewSet(viewsets.ModelViewSet):
    serializer_class = s.CartItemSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        cart, _ = m.Cart.objects.get_or_create(user=self.request.user)
        return cart.items.all()
    
    def create(self, request, *args, **kwargs):
        cart, _ = m.Cart.objects.get_or_create(user=request.user)
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