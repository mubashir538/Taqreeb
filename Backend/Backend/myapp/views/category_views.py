@api_view(['GET'])
@permission_classes([IsAuthenticated])
def HomeCategories(request):
    categories = m.Categories.objects.all()
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def BusinessCategories(request,type):
    if type == 'freelancer':
        categories = m.Categories.objects.filter(type='freelancer')
    else:
        categories = m.Categories.objects.filter(type='business')
    CategoriesSerializer = s.CategoriesSerializer(categories,many = True)
    return Response({'status': 'success','categories': CategoriesSerializer.data})