
from ..Models import user_models as m
from ..Models import listing_models as lm
from rest_framework import serializers as s


class UserActivitySerializer(s.ModelSerializer):
    class Meta:
        model = m.UserActivity
        fields = '__all__' 

class WishlistSerializer(s.ModelSerializer):
    class Meta:
        model = lm.Wishlist
        fields = '__all__'

class BankDetailsSerializer(s.ModelSerializer):
    masked_account_number = s.SerializerMethodField()
    
    class Meta:
        model = m.BankDetails
        fields = [
            'bankName',
            'masked_account_number',  # This will show the masked version
        ]
        extra_kwargs = {
            'accountNumber': {'write_only': True}  # Hide original in responses
        }
    
    def get_masked_account_number(self, obj):
        """Returns the account number with all but last 4 digits masked"""
        if not obj.accountNumber:
            return None
        
        # Get last 4 digits
        visible_digits = 4
        num_length = len(obj.accountNumber)
        last_digits = obj.accountNumber[-visible_digits:]
        
        # Return masked version (e.g., ******1234)
        return '*' * (num_length - visible_digits) + last_digits