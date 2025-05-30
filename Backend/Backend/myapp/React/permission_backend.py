from django.contrib.auth.backends import ModelBackend
from ..models import User, ReactUser

class FlutterUserAuthBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            user = User.objects.get(username=username)
            if user.check_password(password):
                return user
        except User.DoesNotExist:
            return None

    def has_perm(self, user_obj, perm, obj=None):
        return perm.startswith('appname.can_access_flutter') or super().has_perm(user_obj, perm, obj)

class ReactUserAuthBackend(ModelBackend):
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            user = ReactUser.objects.get(username=username)
            if user.check_password(password):
                return user
        except ReactUser.DoesNotExist:
            return None

    def has_perm(self, user_obj, perm, obj=None):
        return perm.startswith('appname.can_access_react') or super().has_perm(user_obj, perm, obj)