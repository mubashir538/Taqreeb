from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from ..models.user_models import User
from myapp.firebase_db import db
import random
from ..models.user_models import User

@api_view(['GET'])
@permission_classes([AllowAny])
def delete_table(request):
    try:
        # IDs to exclude from updates
        excluded_ids = [14,16,17,19,21,23,27,30,31]
        
        # Get all business owners except the excluded ones
        owners_to_update = User.objects.exclude(id__in=excluded_ids)
        
        update_count = 0
        firebase_update_count = 0
        
        for owner in owners_to_update:
            # Generate random profile picture path
            random_num = random.choice([14, 16, 19, 21,23,27,30,32])
            new_profile_pic = f"/media/uploads/users/profilePicture/{random_num}.png"
            
            # Update Django model
            owner.profilePicture = new_profile_pic
            owner.save()
            update_count += 1
            
            # Update Firebase
            doc_ref = db.collection("users").document(str(owner.id))
            doc_ref.update({"profilePicture": new_profile_pic})
            firebase_update_count += 1
        
        return Response({
            'status': 'success',
            'message': f'Updated {update_count} Django records and {firebase_update_count} Firebase records',
            'excluded_ids': excluded_ids,
            'new_profile_pattern': '/media/uploads/Business/profilePicture/[1-4].png'
        })
    
    except Exception as e:
        return Response({
            'status': 'error',
            'message': str(e)
        }, status=500)


@api_view(['GET'])
@permission_classes([AllowAny])
def health_check(request):
    return Response({'status': 'ok'}, status=200)
