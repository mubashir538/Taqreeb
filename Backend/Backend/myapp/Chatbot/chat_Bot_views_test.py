# server/views.py
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json
from .chatbot import EventPlanningChatbot

@csrf_exempt
@require_POST
def chatbot_api(request):
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        message = data.get('message')
        
        if not user_id or not message:
            return JsonResponse({
                'status': 'error',
                'response': 'user_id and message are required'
            }, status=400)
        
        chatbot = EventPlanningChatbot()
        response = chatbot.process_message(user_id, message)
        
        return JsonResponse({
            'status': 'success',
            'response': response.get('response'),
            'is_final_plan': response.get('is_final_plan', False),
            'event_data': response.get('event_data'),
            'current_step': response.get('current_step')
        })
        
    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'response': str(e)
        }, status=500)

@csrf_exempt
@require_POST
def reset_chat_api(request):
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        
        if not user_id:
            return JsonResponse({
                'status': 'error',
                'response': 'user_id is required'
            }, status=400)
        
        chatbot = EventPlanningChatbot()
        if user_id in chatbot.conversation_histories:
            del chatbot.conversation_histories[user_id]
        
        return JsonResponse({
            'status': 'success',
            'response': 'Conversation reset'
        })
        
    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'response': str(e)
        }, status=500)