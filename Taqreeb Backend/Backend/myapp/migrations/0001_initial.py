# Generated by Django 5.0.8 on 2024-11-29 15:38

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='AIEventQuestions',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('question', models.CharField(max_length=100)),
                ('questionType', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='BakersAndSweets',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
            ],
        ),
        migrations.CreateModel(
            name='BusinessOwner',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('CNICFormat', models.CharField(max_length=100)),
                ('CNICBack', models.CharField(max_length=100)),
                ('BuisnessName', models.CharField(max_length=100)),
                ('email', models.CharField(max_length=50)),
                ('BuisnerUsername', models.CharField(max_length=50)),
                ('Description', models.CharField(max_length=1100)),
            ],
        ),
        migrations.CreateModel(
            name='CarRenters',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('ServiceType', models.CharField(max_length=100)),
                ('Drivers', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='Categories',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=255)),
                ('picture', models.CharField(max_length=255)),
            ],
        ),
        migrations.CreateModel(
            name='Events',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('UserID', models.IntegerField()),
                ('Name', models.CharField(max_length=100)),
                ('Type', models.CharField(max_length=100)),
                ('Date', models.CharField(max_length=100)),
                ('Location', models.CharField(max_length=100)),
                ('Description', models.CharField(max_length=1100)),
                ('ThemeColor', models.CharField(max_length=100)),
                ('Budget', models.IntegerField()),
            ],
        ),
        migrations.CreateModel(
            name='EventType',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='FunctionType',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.TextField()),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('firstName', models.CharField(max_length=100)),
                ('lastName', models.CharField(max_length=100)),
                ('password', models.CharField(max_length=100)),
                ('contactNumber', models.CharField(max_length=15)),
                ('email', models.CharField(max_length=50)),
                ('city', models.CharField(max_length=50)),
                ('gender', models.CharField(max_length=6)),
                ('profilePicture', models.CharField(max_length=100)),
            ],
        ),
        migrations.CreateModel(
            name='Cars',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('pricePerDay', models.IntegerField()),
                ('name', models.CharField(max_length=255)),
                ('type', models.CharField(max_length=100)),
                ('seats', models.IntegerField()),
                ('driver', models.IntegerField()),
                ('picture', models.CharField(max_length=255)),
                ('carRenterId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.carrenters')),
            ],
        ),
        migrations.CreateModel(
            name='DesertItems',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=255)),
                ('price', models.IntegerField()),
                ('type', models.CharField(max_length=100)),
                ('description', models.CharField(max_length=500)),
                ('picture', models.CharField(max_length=255)),
                ('bakersId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.bakersandsweets')),
            ],
        ),
        migrations.CreateModel(
            name='Functions',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=100)),
                ('budget', models.IntegerField()),
                ('type', models.CharField(max_length=100)),
                ('EventId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.events')),
            ],
        ),
        migrations.CreateModel(
            name='CheckList',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('description', models.CharField(max_length=1100)),
                ('isChecked', models.BooleanField()),
                ('eventId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.events')),
                ('functionId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.functions')),
            ],
        ),
        migrations.CreateModel(
            name='GuestList',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Type', models.CharField(max_length=100)),
                ('Name', models.CharField(max_length=100)),
                ('Members', models.IntegerField()),
                ('Phone', models.CharField(max_length=100)),
                ('FunctionId', models.IntegerField()),
                ('EventId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.events')),
            ],
        ),
        migrations.CreateModel(
            name='Listing',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Name', models.CharField(max_length=100)),
                ('PriceMin', models.IntegerField()),
                ('PriceMax', models.IntegerField()),
                ('Location', models.CharField(max_length=100)),
                ('Description', models.CharField(max_length=1100)),
                ('BasicPrice', models.IntegerField()),
                ('OwnerID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.businessowner')),
            ],
        ),
        migrations.CreateModel(
            name='GraphicDesigners',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('PortFolioLink', models.CharField(max_length=100)),
                ('ListingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='Decorators',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('DecorType', models.CharField(max_length=50)),
                ('Catering', models.CharField(max_length=50)),
                ('Staff', models.CharField(max_length=50)),
                ('Slot', models.DateTimeField()),
                ('ListingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='Caterers',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('ServiceType', models.TextField()),
                ('CateringOptions', models.CharField(max_length=50)),
                ('Staff', models.CharField(max_length=50)),
                ('Expertise', models.CharField(max_length=100)),
                ('ListingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.AddField(
            model_name='carrenters',
            name='ListingID',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing'),
        ),
        migrations.AddField(
            model_name='bakersandsweets',
            name='ListingID',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing'),
        ),
        migrations.CreateModel(
            name='AddOns',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=255)),
                ('price', models.IntegerField()),
                ('isPer', models.BooleanField()),
                ('perType', models.CharField(max_length=50)),
                ('listingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='MenuItems',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Name', models.CharField(max_length=100)),
                ('PricePerKg', models.IntegerField()),
                ('Picture', models.CharField(max_length=100)),
                ('CateringId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.caterers')),
            ],
        ),
        migrations.CreateModel(
            name='Packages',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('type', models.IntegerField()),
                ('description', models.CharField(max_length=1100)),
                ('price', models.IntegerField()),
                ('listingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='Parlors',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Slot', models.DateTimeField()),
                ('ListingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='Photographers',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('portfolioLink', models.CharField(max_length=100)),
                ('listingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='QuestionOptions',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('optionType', models.TextField()),
                ('name', models.TextField()),
                ('questionId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.aieventquestions')),
            ],
        ),
        migrations.CreateModel(
            name='Salons',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('slot', models.CharField(max_length=100)),
                ('listingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='Review',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Rating', models.DecimalField(decimal_places=10, max_digits=20)),
                ('Review', models.CharField(max_length=100)),
                ('ListingID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
                ('UserID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.user')),
            ],
        ),
        migrations.CreateModel(
            name='Orders',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('Price', models.IntegerField()),
                ('Slot', models.DateTimeField()),
                ('Status', models.CharField(max_length=100)),
                ('OwnerID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.businessowner')),
                ('ServiceID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
                ('PackageID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.packages')),
                ('CustomerID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.user')),
            ],
        ),
        migrations.CreateModel(
            name='Freelancer',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('businessName', models.CharField(max_length=100)),
                ('businessUsername', models.CharField(max_length=100)),
                ('portfolioLink', models.CharField(max_length=100)),
                ('description', models.CharField(max_length=1100)),
                ('userId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.user')),
            ],
        ),
        migrations.CreateModel(
            name='Cart',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('quantity', models.IntegerField()),
                ('ownerId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.businessowner')),
                ('productId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.menuitems')),
                ('userId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.user')),
            ],
        ),
        migrations.AddField(
            model_name='businessowner',
            name='UserID',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.user'),
        ),
        migrations.CreateModel(
            name='Venue',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('VenueType', models.CharField(max_length=100)),
                ('Catering', models.CharField(max_length=100)),
                ('Staff', models.CharField(max_length=100)),
                ('Slot', models.DateTimeField()),
                ('ListingID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
        migrations.CreateModel(
            name='VideoEditors',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('PortfolioLink', models.TextField()),
                ('ListingId', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
    ]
