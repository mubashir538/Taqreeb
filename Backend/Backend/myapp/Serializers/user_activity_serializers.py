
from ..models import user_models as m
from ..models import listing_models as lm
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
            'masked_account_number',  
        ]
        extra_kwargs = {
            'accountNumber': {'write_only': True}  
        }
    
    def get_masked_account_number(self, obj):
        """Returns the account number with all but last 4 digits masked"""
        if not obj.accountNumber:
            return None
        
        visible_digits = 4
        num_length = len(obj.accountNumber)
        last_digits = obj.accountNumber[-visible_digits:]
        
        return '*' * (num_length - visible_digits) + last_digits