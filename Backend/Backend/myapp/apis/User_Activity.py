from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.utils.timezone import now
from ..models import UserActivity
from ..Serializers import UserActivitySerializer

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def log_user_activity(request):
    """
    Logs user activities such as searches, clicks, filters, and time spent on pages.
    """
    action = request.data.get('action')  # The type of user action
    metadata = request.data.get('metadata', {})  # Additional data like search terms
    duration_seconds = request.data.get('duration_seconds', None)  # Time spent on a page (optional)

    valid_actions = dict(UserActivity.ACTIONS).keys()
    if action not in valid_actions:
        return Response({'status': 'error', 'message': 'Invalid action type'}, status=400)

    # ✅ Use serializer to validate and save data
    serializer = UserActivitySerializer(data={
        'user': request.user.id,  # 🔥 Ensure it's an ID, not an object
        'action': action,
        'metadata': metadata,
        'timestamp': now(),
        'duration_seconds': duration_seconds
    })

    if serializer.is_valid():
        serializer.save()
        return Response({'status': 'success', 'message': 'User activity logged successfully'})

    return Response(serializer.errors, status=400)