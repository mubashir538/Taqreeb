from django.utils.timezone import now
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from ..models.user_models import UserActivity

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def log_user_activity(request):
    """
    Logs all user activities including searches, clicks, filters, and time spent.
    """
    action = request.data.get('action')
    metadata = request.data.get('metadata', {})

    valid_actions = dict(UserActivity.ACTIONS).keys()
    if action not in valid_actions:
        return Response({'status': 'error', 'message': 'Invalid action type'}, status=400)

    UserActivity.objects.create(
        user=request.user,
        action=action,
        metadata=metadata,
        timestamp=now()
    )

    return Response({'status': 'success', 'message': 'Activity logged successfully'})


@api_view(['POST'])
@permission_classes([AllowAny])
def application_errors(request):
    error = request.data.get('error')
    print('App Error: ', error)
    return Response({'status': 'success'})

