@api_view(['GET'])
@permission_classes([AllowAny])
def deleteTable(request):
    # md.Listing.objects.filter(ownerID=None).delete()
    # listings = md.Listing.objects.all()
    # for list in listings:
    #     md.ReviewDetails(listingID=list).save()
    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    return Response({'status': 'ok'}, status=200)

