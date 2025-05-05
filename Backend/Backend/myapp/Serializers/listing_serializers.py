class PicturesListingSerializers(s.ModelSerializer):
    class Meta:
        model = m.PicturesListings
        fields = '__all__'

class PicturesPackagesSerializer(s.ModelSerializer):
    class Meta:
        model = m.PicturesPackages
        fields = ['picturePath']

class PicturesProductsSerializer(s.ModelSerializer):
    class Meta:
        model = m.PicturesProducts
        fields = ['picturePath']

class PackagesSerializer(s.ModelSerializer):
    pictures = PicturesPackagesSerializer(
        many=True,
        read_only=True,
        source='picturespackages_set' 
    )
    
    class Meta:
        model = m.Packages
        fields = ['id', 'name', 'listingId', 'description', 'price', 'pictures']

class ProductsSerializer(s.ModelSerializer):
    pictures = PicturesProductsSerializer(
        many=True,
        read_only=True,
        source='picturesproducts_set'  # This is the default related_name for reverse FK
    )
    
    class Meta:
        model = m.Product
        fields = ['id', 'name', 'listingId', 'description', 'price', 'pictures']

class ListingSerializer(s.ModelSerializer):
    booked_dates = s.SerializerMethodField()

    class Meta:
        model = m.Listing
        fields = '__all__'
        extra_kwargs = {
            'booked_dates': {'write_only': True}
        }

    def get_booked_dates(self, obj):
        """Convert the booked_dates JSON field to a proper list when reading"""
        if isinstance(obj.booked_dates, str):
            try:
                return json.loads(obj.booked_dates)
            except json.JSONDecodeError:
                return []
        return obj.booked_dates or []

    def to_internal_value(self, data):
        """Handle incoming data before validation"""
        if 'booked_dates' in data:
            if isinstance(data['booked_dates'], str):
                try:
                    data['booked_dates'] = json.loads(data['booked_dates'])
                except json.JSONDecodeError:
                    raise ValidationError({'booked_dates': 'Invalid JSON format'})
            elif not isinstance(data['booked_dates'], list):
                raise ValidationError({'booked_dates': 'Must be a list'})
        return super().to_internal_value(data)

    def validate_booked_dates(self, value):
        """Validate each date in the booked_dates list"""
        if not isinstance(value, list):
            raise s.ValidationError("Booked dates must be a list")

        valid_dates = []
        for date_str in value:
            try:
                # Validate date format
                parsed_date = datetime.fromisoformat(date_str.replace('Z', '+00:00'))
                valid_dates.append(parsed_date.isoformat())
            except (ValueError, AttributeError):
                raise s.ValidationError(
                    f"Invalid date format: {date_str}. Use ISO 8601 format."
                )

        return valid_dates

    def create(self, validated_data):
        """Ensure booked_dates is properly stored as JSON"""
        if 'booked_dates' in validated_data:
            validated_data['booked_dates'] = json.dumps(validated_data['booked_dates'])
        return super().create(validated_data)

    def update(self, instance, validated_data):
        """Ensure booked_dates is properly stored as JSON"""
        if 'booked_dates' in validated_data:
            validated_data['booked_dates'] = json.dumps(validated_data['booked_dates'])
        return super().update(instance, validated_data)