# Generated by Django 5.0.8 on 2024-12-21 20:04

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0005_bookedslots'),
    ]

    operations = [
        migrations.CreateModel(
            name='PhotographyPlaces',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('type', models.CharField(max_length=100)),
                ('listingID', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='myapp.listing')),
            ],
        ),
    ]
