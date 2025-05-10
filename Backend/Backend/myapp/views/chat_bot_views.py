from asyncio import Event
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST
import json
from django.utils import timezone
from ..Chatbot.functions import  FunctionService, FunctionServiceProduct, FunctionServiceAddOn
from ..models.event_models import Functions
from ..Chatbot.chatbot import EventPlanningChatbot
from ..models.misc_models import ChatbotSession

@csrf_exempt
@require_POST
def chatbot_api(request):
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        message = data.get('message')
        
        if not user_id or not message:
            return JsonResponse({'error': 'user_id and message are required'}, status=400)
        
        # Get or create session
        session, created = ChatbotSession.objects.get_or_create(
            user_id=user_id,
            defaults={'conversation_state': '{}'}
        )
        
        # Initialize chatbot with previous state
        chatbot = EventPlanningChatbot()
        if not created:
            chatbot.load_state(json.loads(session.conversation_state))
        
        response = chatbot.process_message(user_id, message)
        
        # Save current state
        session.conversation_state = json.dumps(chatbot.get_state())
        session.save()
        
        # Process response
        processed_response = process_chatbot_response(response)
        
        print(processed_response['text'])
        return JsonResponse({
            'response': processed_response['text'],
            'formatted_response': processed_response['formatted_text'],
            'is_bold': processed_response['is_bold'],
            'session_id': session.id
        })
        
    except Exception as e:
        print(e)
        return JsonResponse({'error': str(e)}, status=500)
    
def _is_final_plan_response(response_text):
    """Determine if the response contains a complete event plan"""
    if not isinstance(response_text, str):
        return False
    
    # Look for markers that indicate a complete event plan
    markers = [
        "Event:",
        "Functions:",
        "Budget:",
        "Services:"
    ]
    
    return all(marker in response_text for marker in markers)

def _parse_final_plan(response_text):
    """
    Parse the structured event plan from the chatbot's response
    Returns a dictionary with the event data structure
    """
    try:
        # Initialize empty event structure
        event_data = {
            'eventName': '',
            'eventType': '',
            'date': '',
            'totalBudget': '',
            'functions': []
        }
        
        lines = response_text.split('\n')
        current_function = None
        
        for line in lines:
            line = line.strip()
            if not line:
                continue
                
            # Parse event header
            if line.startswith('Event:'):
                event_data['eventName'] = line.replace('Event:', '').strip()
            elif line.startswith('Type:'):
                event_data['eventType'] = line.replace('Type:', '').strip()
            elif line.startswith('Date:'):
                event_data['date'] = line.replace('Date:', '').strip()
            elif line.startswith('Budget:'):
                event_data['totalBudget'] = line.replace('Budget:', '').strip()
                
            # Parse functions
            elif line.startswith(tuple(str(i)+'.' for i in range(1, 10))):
                # New function
                if current_function:
                    event_data['functions'].append(current_function)
                
                func_name = line.split('.', 1)[1].strip().rstrip(':')
                current_function = {
                    'name': func_name,
                    'budget': '',
                    'date': '',
                    'guestCount': 0,
                    'services': []
                }
                
            elif line.startswith('\tBudget:'):
                if current_function:
                    current_function['budget'] = line.replace('\tBudget:', '').strip()
            elif line.startswith('\tDate:'):
                if current_function:
                    current_function['date'] = line.replace('\tDate:', '').strip()
            elif line.startswith('\tGuests:'):
                if current_function:
                    try:
                        current_function['guestCount'] = int(line.replace('\tGuests:', '').strip())
                    except ValueError:
                        pass
                        
            # Parse services
            elif line.startswith('\tServices:'):
                continue  # Skip services header
            elif line.startswith('\t\t') and current_function:
                # Service line
                service_parts = line.strip().split(maxsplit=1)
                if len(service_parts) >= 2:
                    service_name = service_parts[1].rsplit(maxsplit=1)
                    if len(service_name) == 2:
                        service_data = {
                            'name': service_name[0],
                            'price': service_name[1]
                        }
                        current_function['services'].append(service_data)
        
        # Add the last function if exists
        if current_function:
            event_data['functions'].append(current_function)
            
        return event_data
        
    except Exception as e:
        print(f"Error parsing event plan: {str(e)}")
        return None
    
def process_chatbot_response(response):
    """
    Enhanced response processor that:
    1. Handles dict responses with 'think' or 'response' keys
    2. Converts non-string responses to string
    3. Processes markdown-style bold formatting (**text**)
    4. Preserves any structured data in the response
    
    Returns:
        dict: {
            'text': plain text without formatting,
            'formatted_text': HTML-formatted text,
            'is_bold': whether bold formatting was found,
            'structured_data': any extracted structured data
        }
    """
    # Handle dictionary responses
    structured_data = {}
    print('running...')
    if isinstance(response, dict):
        print('is Dictionary')
        if 'think' in response:
            response = response.get('response', response)
        
        # Preserve any structured data
        structured_data = {k: v for k, v in response.items() 
                         if k not in ['think', 'response']}
        
        response = str(response.get('response', response))
    else:
        print('not dictionary')
        response = str(response)
    
    # Process bold formatting (markdown style)
    formatted_response = response
    is_bold = False
    
    # Count the number of ** markers to ensure proper pairing
    bold_markers = response.count('**')
    if bold_markers >= 2 and bold_markers % 2 == 0:
        parts = response.split('**')
        formatted_response = ''
        for i, part in enumerate(parts):
            if i % 2 == 1:  # Odd indices are bold text
                formatted_response += f'<b>{part}</b>'
                is_bold = True
            else:
                formatted_response += part
    
    # Remove markdown for plain text
    plain_text = response.replace('**', '')
    
    return {
        'text': plain_text,
        'formatted_text': formatted_response,
        'is_bold': is_bold,
        'structured_data': structured_data if structured_data else None
    }


@csrf_exempt
@require_POST
def save_event(request):
    try:
        data = json.loads(request.body)
        user_id = data.get('user_id')
        event_data = data.get('event_data')
        
        if not user_id or not event_data:
            return JsonResponse({
                'status': 'error',
                'message': 'user_id and event_data are required'
            }, status=400)

        # Create the main event
        event = Event.objects.create(
            user_id=user_id,
            name=event_data.get('event_name'),
            event_type_id=event_data.get('event_type_id'),
            total_budget=event_data.get('total_budget'),
            notes=event_data.get('notes', ''),
            status='planned',
            created_at=timezone.now()
        )

        # Create functions and services
        for function_data in event_data.get('functions', []):
            function = Functions.objects.create(
                event=event,
                function_type_id=function_data.get('function_type_id'),
                budget=function_data.get('budget'),
                date=function_data.get('date'),
                guest_count=function_data.get('guest_count'),
                status='planned'
            )

            # Create services for this function
            for service_data in function_data.get('services', []):
                service = FunctionService.objects.create(
                    function=function,
                    listing_id=service_data.get('listing_id'),
                    package_id=service_data.get('package_id'),
                    notes=service_data.get('notes', '')
                )

                # Add products
                for product_id in service_data.get('products', []):
                    FunctionServiceProduct.objects.create(
                        function_service=service,
                        product_id=product_id
                    )

                # Add add-ons
                for add_on_id in service_data.get('add_ons', []):
                    FunctionServiceAddOn.objects.create(
                        function_service=service,
                        add_on_id=add_on_id
                    )

        return JsonResponse({
            'status': 'success',
            'event_id': event.id,
            'message': 'Event saved successfully'
        })

    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'message': str(e)
        }, status=500)
    

# def process_chatbot_response(response):
#     """
#     Processes the chatbot response to:
#     1. Remove any "think" attribute if present
#     2. Format bold text (**bold** to <b>bold</b>)
#     3. Extract plain text and formatted text separately
#     """
#     if isinstance(response, dict) and 'think' in response:
#         response = response['response'] if 'response' in response else response
    
#     if not isinstance(response, str):
#         response = str(response)
    
#     # Process bold formatting
#     formatted_response = response.replace('**', '<b>').replace('**', '</b>')
    
#     # Remove markdown for plain text
#     plain_text = response.replace('**', '')
    
#     # Check if there was any bold text
#     is_bold = '**' in response
    
#     return {
#         'text': plain_text,
#         'formatted_text': formatted_response,
#         'is_bold': is_bold
#     }