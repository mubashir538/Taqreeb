from django.db import models as m
import os

class HomePageImages(m.Model):
    id = m.AutoField(primary_key=True)
    image = m.CharField(max_length=255)

class TempInvitationCard(m.Model):
    file = m.ImageField(upload_to='uploads/tempCards/%Y/%m/%d/')
    created_at = m.DateTimeField(auto_now_add=True)
    def delete(self, *args, **kwargs):
        if self.file and os.path.isfile(self.file.path):
            os.remove(self.file.path)
        super().delete(*args, **kwargs)


class ChatbotSession(m.Model):
    user_id = m.CharField(max_length=100, unique=True)
    conversation_state = m.TextField()
    created_at = m.DateTimeField(auto_now_add=True)
    updated_at = m.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'chatbot_sessions'