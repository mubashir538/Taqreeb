# Generated by Django 5.0.8 on 2024-12-12 11:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapp', '0005_alter_user_contactnumber_alter_user_email'),
    ]

    operations = [
        migrations.AddField(
            model_name='listing',
            name='type',
            field=models.TextField(null=True),
        ),
    ]
