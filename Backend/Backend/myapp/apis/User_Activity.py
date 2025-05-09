# from rest_framework.decorators import api_view, permission_classes
# from rest_framework.permissions import IsAuthenticated
# from rest_framework.response import Response
# from django.utils.timezone import now
# from ..models import UserActivity
# from ..Serializers import UserActivitySerializer

# @api_view(['POST'])
# @permission_classes([IsAuthenticated])
# def log_user_activity(request):
#     action = request.data.get('action')
#     metadata = request.data.get('metadata', {})
#     # ✅ No separate duration_seconds anymore

#     valid_actions = dict(UserActivity.ACTIONS).keys()
#     if action not in valid_actions:
#         return Response({'status': 'error', 'message': 'Invalid action type'}, status=400)

#     serializer = UserActivitySerializer(data={
#         'user': request.user.id,
#         'action': action,
#         'metadata': metadata,
#         'timestamp': now()
#     })

#     if serializer.is_valid():
#         serializer.save()
#         return Response({'status': 'success', 'message': 'User activity logged successfully'})

#     return Response(serializer.errors, status=400)
