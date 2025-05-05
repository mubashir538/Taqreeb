@api_view(['POST'])
@permission_classes([IsAuthenticated])
def log_user_activity(request):
    """
    Logs all user activities including searches, clicks, filters, and time spent.
    """
    action = request.data.get('action')  # Type of action (search, click, time spent, etc.)
    metadata = request.data.get('metadata', {})  # Additional details (search term, clicked item, etc.)
    # duration_seconds = request.data.get('duration_seconds', None)  # Time spent on a page (optional)

    valid_actions = dict(UserActivity.ACTIONS).keys()
    if action not in valid_actions:
        return Response({'status': 'error', 'message': 'Invalid action type'}, status=400)

    # Store the action in UserActivity model
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

