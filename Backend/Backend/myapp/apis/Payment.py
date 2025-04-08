from .. import models as md
from .. import Serializers as s
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated,AllowAny
from rest_framework.response import Response


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def addTransaction(request):
    senderId = request.data.get('senderId')
    listingId = request.data.get('listingId')
    amount = request.data.get('amount')
    
    user = md.User.objects.get(id = senderId)
    listing = md.Listing.objects.get(id = listingId)
    if listing.ownerID:
        owner = md.BusinessOwner.objects.get(id = listing.ownerID)
        md.Transaction(sender = user, receiverb = owner, amount = amount, listing = listing,status='Pending').save()
    
    else:
        owner = md.Freelancer.objects.get(id = listing.freelancerID)
        md.Transaction(sender = user, receiverf = owner, amount = amount, listing = listing,status='Pending').save()
    return Response({'status':'success'})