# Generated by Django 5.0.8 on 2024-12-24 18:16

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0014_remove_bookedslots_venueid_alter_bookingcart_slot'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='businessowner',
            name='category',
        ),
        migrations.RemoveField(
            model_name='businessowner',
            name='email',
        ),
        migrations.RemoveField(
            model_name='venue',
            name='slot',
        ),
        migrations.AlterField(
            model_name='venue',
            name='catering',
            field=models.CharField(choices=[('Internal', 'Internal'), ('External', 'External'), ('Internal & External', 'Internal & External')], default='Internal', max_length=50),
        ),
        migrations.AlterField(
            model_name='venue',
            name='staff',
            field=models.CharField(choices=[('Male', 'Male'), ('Female', 'Female')], default='Male', max_length=10),
        ),
        migrations.AlterField(
            model_name='venue',
            name='venueType',
            field=models.CharField(choices=[('Banquet', 'Banquet'), ('Hall', 'Hall'), ('Lawn', 'Lawn'), ('Outdoor', 'Outdoor')], default='Banquet', max_length=50),
        ),
    ]
