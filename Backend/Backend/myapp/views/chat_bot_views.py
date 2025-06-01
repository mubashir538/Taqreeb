from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json
from myapp.chatbotConfig import chatbot

@csrf_exempt
@require_POST
def chatbot_api(request):
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        message = data.get('message')
        
        if not user_id or not message:
            return JsonResponse({'error': 'user_id and message are required'}, status=400)
        
        
        response = chatbot.process_message(user_id, message)
        
        # Process the response to remove "think" attribute and format bold text
        processed_response = process_chatbot_response(response)
        
        return JsonResponse({
            'response': processed_response['text'],
            'formatted_response': processed_response['formatted_text'],     
            'is_bold': processed_response['is_bold']
        })
        
    except Exception as e:
        print(e)
        return JsonResponse({'error': str(e)}, status=500)

def process_chatbot_response(response):
    """
    Processes the chatbot response to:
    1. Remove any "think" attribute if present
    2. Format bold text (**bold** to <b>bold</b>)
    3. Extract plain text and formatted text separately
    """
    if isinstance(response, dict) and 'think' in response:
        response = response['response'] if 'response' in response else response
    
    if not isinstance(response, str):
        response = str(response)
    
    # Process bold formatting
    formatted_response = response.replace('**', '<b>').replace('**', '</b>')
    
    # Remove markdown for plain text
    plain_text = response.replace('**', '')
    
    # Check if there was any bold text
    is_bold = '**' in response
    
    return {
        'text': plain_text,
        'formatted_text': formatted_response,
        'is_bold': is_bold
    }