from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from ..models.user_models import User
@api_view(['GET'])
@permission_classes([AllowAny])
def delete_table(request):
    User.objects.filter(id=15).delete()
    return Response({'status': 'success'})

@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    return Response({'status': 'ok'}, status=200)
