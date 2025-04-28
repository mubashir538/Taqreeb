from rest_framework.permissions import BasePermission
from .react_models import ReactUser

class IsReactUser(BasePermission):
    def has_permission(self, request, view):
        return isinstance(request.user, ReactUser)