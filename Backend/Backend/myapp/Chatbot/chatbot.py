import json
import os
import re
import random
from typing import Dict, List, Optional, Tuple
from datetime import datetime
from dotenv import load_dotenv
from openai import OpenAI
from .config import SYSTEM_MESSAGE
from .functions import (
    get_event_types,
    get_function_types,
    search_listings,
    get_listing_details,
    check_date_availability,
    create_event,
    get_venue_recommendations
)
from .data.event_types import EVENT_TYPES

# Load environment variables
load_dotenv()

# Constants
DEFAULT_LOCATION = "Karachi"
SERVICE_PRIORITY = [
    'Venue', 'Decorator',  # 30% budget
    'Caterer',             # 30% budget
    'Photographer',        # 20% budget
    'Salon', 'Parlor',     # 5% budget
    'Car Renter',          # Optional
    'Photography Place',   # Optional
    'Graphic Designer',    # Optional
    'Video Editor'         # Optional
]

BUDGET_ALLOCATION = {
    'Venue': 0.3,
    'Decorator': 0.3,
    'Caterer': 0.3,
    'Photographer': 0.2,
    'Salon': 0.05,
    'Parlor': 0.05
}

class EventPlanningChatbot:
    def __init__(self, api_key: str = "", model: str = "deepseek-r1-distill-llama-70b"):
        self.client = OpenAI(api_key=api_key, base_url="https://api.groq.com/openai/v1/")
        self.model = model
        self.conversation_state = {
            'step': 'init',
            'event_data': {
                'name': '',
                'type': '',
                'budget': 0,
                'total_guests': 0,
                'gender': '',
                'venue_type': '',
                'location': DEFAULT_LOCATION,
                'date': datetime.now().strftime('%Y-%m-%d'),
                'functions': {}
            },
            'current_function': None,
            'confirmed_services': {},
            'current_service': None,
            'retry_count': 0
        }
        self.conversation_histories = {}
        self.function_schemas = self._initialize_function_schemas()
        self.available_functions = self._initialize_available_functions()

    def _initialize_function_schemas(self):
        """Initialize all function schemas for the chatbot"""
        return [
            {
                "name": "get_event_types",
                "description": "Get all available event types",
                "parameters": {
                    "type": "object",
                    "properties": {},
                    "required": []
                }
            },
            {
                "name": "get_function_types",
                "description": "Get function types for an event type",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "event_type_id": {
                            "type": "integer",
                            "description": "ID of the event type"
                        }
                    },
                    "required": []
                }
            },
            {
                "name": "search_listings",
                "description": "Search for service listings",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "service_type": {"type": "string"},
                        "location": {"type": "string"},
                        "min_price": {"type": "integer"},
                        "max_price": {"type": "integer"},
                        "min_capacity": {"type": "integer"},
                        "max_capacity": {"type": "integer"}
                    },
                    "required": ["service_type"]
                }
            },
            {
                "name": "get_listing_details",
                "description": "Get detailed information about a specific listing",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "listing_id": {"type": "integer"}
                    },
                    "required": ["listing_id"]
                }
            },
            {
                "name": "check_date_availability",
                "description": "Check if a listing is available on a specific date",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "listing_id": {"type": "integer"},
                        "date": {"type": "string"}
                    },
                    "required": ["listing_id", "date"]
                }
            },
            {
                "name": "create_event",
                "description": "Create a new event with all its functions in the database",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "user_id": {"type": "integer"},
                        "event_name": {"type": "string"},
                        "event_type_id": {"type": "integer"},
                        "total_budget": {"type": "number"},
                        "functions": {
                            "type": "array",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "function_type_id": {"type": "integer"},
                                    "budget": {"type": "number"},
                                    "date": {"type": "string"},
                                    "guest_count": {"type": "integer"},
                                    "services": {
                                        "type": "array",
                                        "items": {
                                            "type": "object",
                                            "properties": {
                                                "listing_id": {"type": "integer"},
                                                "notes": {"type": "string"}
                                            }
                                        }
                                    }
                                }
                            }
                        },
                        "notes": {"type": "string"}
                    },
                    "required": ["user_id", "event_name", "event_type_id", "total_budget", "functions"]
                }
            },
            {
                "name": "get_venue_recommendations",
                "description": "Get personalized venue recommendations based on event requirements",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "event_type": {"type": "string"},
                        "location": {"type": "string"},
                        "guest_count": {"type": "integer"},
                        "budget_range": {
                            "type": "array",
                            "items": {"type": "integer"}
                        }
                    },
                    "required": ["event_type", "guest_count", "budget_range"]
                }
            }
        ]

    def _initialize_available_functions(self):
        """Map function names to their implementations"""
        return {
            "get_event_types": get_event_types,
            "get_function_types": get_function_types,
            "search_listings": search_listings,
            "get_listing_details": get_listing_details,
            "check_date_availability": check_date_availability,
            "create_event": create_event,
            "get_venue_recommendations": get_venue_recommendations
        }

    def get_or_create_history(self, user_id: str) -> List[Dict[str, str]]:
        """Get or initialize conversation history for a user"""
        if user_id not in self.conversation_histories:
            self.conversation_histories[user_id] = [
                {"role": "system", "content": SYSTEM_MESSAGE}
            ]
        return self.conversation_histories[user_id]

    def add_message(self, user_id: str, message: str) -> None:
        """Add a user message to the conversation history"""
        history = self.get_or_create_history(user_id)
        history.append({"role": "user", "content": message})

    def process_message(self, user_id: str, message: str) -> dict:
        """Main method to process user messages and maintain conversation flow"""
        try:
            # Initialize conversation history
            history = self.get_or_create_history(user_id)
            self.add_message(user_id, message)

            # Handle reset commands
            if message.lower() in ['reset', 'start over', 'new event']:
                self._reset_conversation(user_id)
                return {
                    "response": "Okay, let's start over. What type of event would you like to plan?",
                    "status": "init"
                }

            # Process based on current step
            current_step = self.conversation_state['step']
            print(f"Current step: {current_step}")
            print(f"Conversation state: {self.conversation_state}")
            print(f"Conversation history: {history}")
            if current_step == 'init':
                return self._handle_initial_info(message, user_id)
            elif current_step == 'select_functions':
                return self._handle_function_selection(message, user_id)
            elif current_step == 'function_details':
                return self._handle_function_details(message, user_id)
            elif current_step == 'service_selection':
                return self._handle_service_selection(message, user_id)
            elif current_step == 'confirmation':
                return self._handle_confirmation(message, user_id)
            else:
                return self._handle_unknown_state(user_id)

        except Exception as e:
            print(f"Error processing message: {str(e)}")
            self.conversation_state['retry_count'] += 1
            
            if self.conversation_state['retry_count'] > 3:
                self._reset_conversation(user_id)
                return {
                    "response": "I'm having trouble understanding. Let's start over.",
                    "status": "error",
                    "data": {"reset": True}
                }
            
            return {
                "response": f"Sorry, I didn't understand that. Could you please rephrase?",
                "status": "error",
                "data": {"error": str(e)}
            }

    def _reset_conversation(self, user_id: str) -> None:
        """Reset the conversation state and history"""
        self.conversation_state = {
            'step': 'init',
            'event_data': {
                'name': '',
                'type': '',
                'budget': 0,
                'total_guests': 0,
                'gender': '',
                'venue_type': '',
                'location': DEFAULT_LOCATION,
                'date': datetime.now().strftime('%Y-%m-%d'),
                'functions': {}
            },
            'current_function': None,
            'confirmed_services': {},
            'current_service': None,
            'retry_count': 0
        }
        self.conversation_histories[user_id] = [
            {"role": "system", "content": SYSTEM_MESSAGE}
        ]

    def _handle_initial_info(self, message: str, user_id: str) -> dict:
        """Collect initial event information"""
        self._extract_event_info(message)
        
        # Check what's still missing
        missing = []
        if not self.conversation_state['event_data']['name']:
            missing.append("event name")
        if not self.conversation_state['event_data']['type']:
            event_types = [et['name'] for et in get_event_types()]
            missing.append(f"event type (from: {', '.join(event_types)})")
        if not self.conversation_state['event_data']['budget']:
            missing.append("total budget")
        if not self.conversation_state['event_data']['total_guests']:
            missing.append("total guests")
        if not self.conversation_state['event_data']['gender']:
            missing.append("gender of the person (male/female)")
        if not self.conversation_state['event_data']['venue_type']:
            missing.append("venue type (home/hall)")
            
        if missing:
            response = "I still need: " + ", ".join(missing)
            if len(missing) > 3:
                response += "\nPlease provide this information one piece at a time."
            return {
                "response": response,
                "status": "in_progress"
            }
        else:
            self.conversation_state['step'] = 'select_functions'
            event_type_id = self._get_event_type_id(self.conversation_state['event_data']['type'])
            functions = get_function_types(event_type_id)
            function_names = [f['name'] for f in functions]
            
            return {
                "response": f"Great! Now please tell me which functions you'd like to include (e.g., {', '.join(function_names[:3])}).",
                "status": "in_progress"
            }

    def _handle_function_selection(self, message: str, user_id: str) -> dict:
        """Handle selection of functions for the event"""
        event_type_id = self._get_event_type_id(self.conversation_state['event_data']['type'])
        functions = get_function_types(event_type_id)
        
        # Extract selected functions from message
        selected_functions = []
        for func in functions:
            if func['name'].lower() in message.lower():
                selected_functions.append(func['name'])
                
        if not selected_functions:
            return {
                "response": "Please select at least one function from: " + ", ".join([f['name'] for f in functions]),
                "status": "in_progress"
            }
            
        # Initialize function data
        for func in selected_functions:
            self.conversation_state['event_data']['functions'][func] = {
                'date': self.conversation_state['event_data']['date'],
                'location': self.conversation_state['event_data']['location'],
                'budget': None,
                'guests': None,
                'services': {}
            }
        
        self.conversation_state['current_function'] = selected_functions[0]
        self.conversation_state['step'] = 'function_details'
        
        return {
            "response": f"Let's start with {selected_functions[0]}. How many guests, budget, and any date/location preferences?",
            "status": "in_progress"
        }

    def _handle_function_details(self, message: str, user_id: str) -> dict:
        """Collect details for each function"""
        current_func = self.conversation_state['current_function']
        func_data = self.conversation_state['event_data']['functions'][current_func]
        
        # Extract details from message
        self._extract_function_details(message, current_func)
        
        # Check what's still missing
        missing = []
        if not func_data['budget']:
            missing.append("budget")
        if not func_data['guests']:
            missing.append("number of guests")
            
        if missing:
            return {
                "response": f"For {current_func}, I still need: " + ", ".join(missing),
                "status": "in_progress"
            }
        else:
            # Move to next function or start service selection
            remaining_functions = [
                f for f in self.conversation_state['event_data']['functions'].keys()
                if not self.conversation_state['event_data']['functions'][f]['budget']
            ]
            
            if remaining_functions:
                self.conversation_state['current_function'] = remaining_functions[0]
                return {
                    "response": f"Now let's setup {remaining_functions[0]}. Please provide guest count, budget, and any date/location preferences.",
                    "status": "in_progress"
                }
            else:
                self.conversation_state['step'] = 'service_selection'
                self.conversation_state['current_function'] = list(self.conversation_state['event_data']['functions'].keys())[0]
                return self._start_service_selection()

    def _start_service_selection(self) -> dict:
        """Begin the service selection process for the current function"""
        func_name = self.conversation_state['current_function']
        func_data = self.conversation_state['event_data']['functions'][func_name]
        
        # Calculate budget allocations
        total_budget = func_data['budget']
        remaining_budget = total_budget
        
        # Determine which services to search for based on venue type
        if self.conversation_state['event_data']['venue_type'] == 'home':
            services_to_find = ['Decorator'] + SERVICE_PRIORITY[2:]  # Skip Venue
        else:
            services_to_find = SERVICE_PRIORITY.copy()
        
        # Adjust for gender
        if 'Salon' in services_to_find and 'Parlor' in services_to_find:
            if self.conversation_state['event_data']['gender'] == 'male':
                services_to_find.remove('Parlor')
            else:
                services_to_find.remove('Salon')
        
        # Search for services in priority order
        for service_type in services_to_find:
            if remaining_budget <= 0:
                break
                
            service_budget = min(remaining_budget, total_budget * BUDGET_ALLOCATION.get(service_type, 0))
            
            # Search for services
            results = self._search_services(
                service_type,
                func_data['location'],
                func_data['guests'],
                service_budget
            )
            
            if results:
                self.conversation_state['current_service'] = {
                    'type': service_type,
                    'options': results,
                    'budget': service_budget
                }
                remaining_budget -= service_budget
                
                return {
                    "response": self._format_service_options(service_type, results),
                    "status": "in_progress"
                }
        
        # If we get here, we've processed all services within budget
        self.conversation_state['step'] = 'confirmation'
        return self._generate_event_summary()

    def _handle_service_selection(self, message: str, user_id: str) -> dict:
        """Handle user selection of a service option"""
        current_func = self.conversation_state['current_function']
        current_service = self.conversation_state['current_service']
        options = current_service['options']

        # Check if user wants to skip this service
        if 'skip' in message.lower():
            # Move to next service or finish
            return self._move_to_next_service_or_finish()

        # Try to parse selection number
        try:
            selection = int(re.search(r'\d+', message).group())
            if 1 <= selection <= len(options):
                selected_option = options[selection-1]

                # Store the selected service
                self.conversation_state['event_data']['functions'][current_func]['services'][current_service['type']] = {
                    'id': selected_option['id'],
                    'name': selected_option['name'],
                    'price': selected_option['price_range']['max'],  # Use max as conservative estimate
                    'details': selected_option
                }

                # Move to next service or finish
                return self._move_to_next_service_or_finish()
            else:
                return {
                    "response": f"Please select a number between 1 and {len(options)}, or 'skip'.",
                    "status": "in_progress"
                }
        except (AttributeError, ValueError):
            return {
                "response": "I didn't understand your selection. Please reply with the number of your choice or 'skip'.",
                "status": "in_progress"
            }

    def _handle_confirmation(self, message: str, user_id: str) -> dict:
        """Handle final confirmation or edits to the event plan"""
        if 'confirm' in message.lower():
            # Create the event in the database
            event_data = self.conversation_state['event_data']
            functions = []

            for func_name, func_details in event_data['functions'].items():
                functions.append({
                    'function_type_id': self._get_function_type_id(func_name),
                    'budget': func_details['budget'],
                    'date': func_details['date'],
                    'guest_count': func_details['guests'],
                    'services': [{
                        'listing_id': service['id'],
                        'notes': f"Selected via chatbot for {func_name}"
                    } for service in func_details['services'].values()]
                })

            result = create_event(
                user_id=1,  # Replace with actual user ID
                event_name=event_data['name'],
                event_type_id=self._get_event_type_id(event_data['type']),
                total_budget=event_data['budget'],
                functions=functions,
                notes="Created via chatbot"
            )

            if result.get('success'):
                self.conversation_state['step'] = 'complete'
                return {
                    "response": f"Your event has been created! Event ID: {result['event_id']}",
                    "status": "complete"
                }
            else:
                return {
                    "response": f"Error creating event: {result.get('error', 'Unknown error')}",
                    "status": "error"
                }

        elif 'edit' in message.lower():
            # Reset to initial state but keep collected data
            self.conversation_state['step'] = 'init'
            return {
                "response": "What would you like to change? You can modify: name, type, budget, guests, or venue type.",
                "status": "in_progress"
            }
        else:
            return {
                "response": "Please reply with 'confirm' to save this event or 'edit' to make changes.",
                "status": "confirmation"
            }

    def _handle_unknown_state(self, user_id: str) -> dict:
        """Handle cases where the conversation state is unknown"""
        self.conversation_state['retry_count'] += 1
        
        if self.conversation_state['retry_count'] > 2:
            self._reset_conversation(user_id)
            return {
                "response": "I'm having trouble understanding. Let's start over. What type of event would you like to plan?",
                "status": "init"
            }
        
        return {
            "response": "I'm not sure what to do next. Could you please clarify or say 'reset' to start over?",
            "status": "error"
        }

    def _extract_event_info(self, message: str) -> None:
        """Extract event information from user message"""
        event_data = self.conversation_state['event_data']
        
        # Extract event name
        if not event_data['name']:
            name_match = re.search(r'(?:event name|name of event)[:\s]*(.+)', message, re.IGNORECASE)
            if name_match:
                event_data['name'] = name_match.group(1).strip()
        
        # Extract event type
        if not event_data['type']:
            for event_type in get_event_types():
                if event_type['name'].lower() in message.lower():
                    event_data['type'] = event_type['name']
                    break
        
        # Extract budget
        if not event_data['budget']:
            budget_match = re.search(r'(?:budget|price)[:\s]*(\d+)', message, re.IGNORECASE)
            if budget_match:
                event_data['budget'] = float(budget_match.group(1))
        
        # Extract guests
        if not event_data['total_guests']:
            guests_match = re.search(r'(?:guests|people|attendees)[:\s]*(\d+)', message, re.IGNORECASE)
            if guests_match:
                event_data['total_guests'] = int(guests_match.group(1))
        
        # Extract gender
        if not event_data['gender']:
            if 'male' in message.lower():
                event_data['gender'] = 'male'
            elif 'female' in message.lower():
                event_data['gender'] = 'female'
        
        # Extract venue type
        if not event_data['venue_type']:
            if 'home' in message.lower():
                event_data['venue_type'] = 'home'
            elif 'hall' in message.lower() or 'venue' in message.lower():
                event_data['venue_type'] = 'hall'

        # Extract location if specified
        location_match = re.search(r'(?:location|city|place)[:\s]*(.+)', message, re.IGNORECASE)
        if location_match and location_match.group(1).lower() not in ['home', 'street']:
            event_data['location'] = location_match.group(1).strip()

    def _extract_function_details(self, message: str, function_name: str) -> None:
        """Extract function details (budget, guests, date, location) from message"""
        func_data = self.conversation_state['event_data']['functions'][function_name]

        # Extract budget
        if not func_data['budget']:
            budget_match = re.search(r'(?:budget|price)[:\s]*(\d+)', message, re.IGNORECASE)
            if budget_match:
                func_data['budget'] = float(budget_match.group(1))

        # Extract guest count
        if not func_data['guests']:
            guests_match = re.search(r'(?:guests|people|attendees)[:\s]*(\d+)', message, re.IGNORECASE)
            if guests_match:
                func_data['guests'] = int(guests_match.group(1))

        # Extract date (format: YYYY-MM-DD)
        if func_data['date'] == self.conversation_state['event_data']['date']:  # Only if not already customized
            date_match = re.search(r'(\d{4}-\d{2}-\d{2})|(\d{1,2}/\d{1,2}/\d{4})', message)
            if date_match:
                date_str = date_match.group(1) or date_match.group(2)
                try:
                    func_data['date'] = datetime.strptime(date_str, '%Y-%m-%d').strftime('%Y-%m-%d') if date_match.group(1) \
                        else datetime.strptime(date_str, '%m/%d/%Y').strftime('%Y-%m-%d')
                except ValueError:
                    pass
                
        # Extract location
        if func_data['location'] == self.conversation_state['event_data']['location']:  # Only if not already customized
            location_match = re.search(r'(?:location|venue|place)[:\s]*(.+)', message, re.IGNORECASE)
            if location_match and location_match.group(1).lower() not in ['home', 'street']:
                func_data['location'] = location_match.group(1).strip()

    def _search_services(self, service_type: str, location: str, guests: int, budget: float) -> List[Dict]:
        """Search for services based on criteria with fallback logic"""
        try:
            # First try with all criteria
            filters = {
                'service_type': service_type,
                'location': location if location.lower() not in ['home', 'street'] else None,
                'max_price': budget
            }
            
            if service_type == 'Venue':
                filters['min_capacity'] = guests
                filters['max_capacity'] = guests * 1.2  # Allow 20% buffer
            
            results = search_listings(**filters)
            
            # If no results, try relaxing the location constraint
            if not results and location:
                del filters['location']
                results = search_listings(**filters)
                
            # If still no results, try relaxing the price constraint
            if not results and budget > 0:
                filters['max_price'] = budget * 1.5  # Increase budget by 50%
                results = search_listings(**filters)
                
            # If still no results, try removing capacity filter for venues
            if not results and service_type == 'Venue' and 'min_capacity' in filters:
                del filters['min_capacity']
                del filters['max_capacity']
                results = search_listings(**filters)
                
            return results
            
        except Exception as e:
            print(f"Error searching services: {str(e)}")
            return []

    def _format_service_options(self, service_type: str, options: List[Dict]) -> str:
        """Format service options for display to user"""
        if not options:
            return f"No {service_type} options found within your budget. We'll skip this service."

        response = f"Here are some {service_type} options:\n"
        for i, option in enumerate(options[:3], 1):  # Show top 3 options
            response += f"{i}. {option['name']} - {option['location']}\n"
            response += f"   Price Range: PKR {option['price_range']['min']} - {option['price_range']['max']}\n"
            if 'capacity' in option:
                response += f"   Capacity: {option['capacity']['min']} - {option['capacity']['max']} guests\n"
            response += f"   Rating: {option['rating'] or 'Not rated'}\n\n"

        response += "Please reply with the number of your preferred option, or 'skip' to skip this service."
        return response

    def _move_to_next_service_or_finish(self) -> dict:
        """Helper to move to next service or finish service selection"""
        # Determine next service to recommend
        func_name = self.conversation_state['current_function']
        func_data = self.conversation_state['event_data']['functions'][func_name]
        remaining_budget = func_data['budget'] - sum(
            s['price'] for s in func_data['services'].values()
        )

        # Get services already selected
        selected_services = set(func_data['services'].keys())

        # Find next service to recommend
        for service_type in SERVICE_PRIORITY:
            if service_type not in selected_services and remaining_budget > 0:
                service_budget = min(
                    remaining_budget, 
                    func_data['budget'] * BUDGET_ALLOCATION.get(service_type, 0)
                )

                # Skip services not needed based on venue type
                if service_type == 'Venue' and self.conversation_state['event_data']['venue_type'] == 'home':
                    continue

                # Skip gender-specific services
                if service_type == 'Salon' and self.conversation_state['event_data']['gender'] == 'male':
                    continue
                if service_type == 'Parlor' and self.conversation_state['event_data']['gender'] == 'female':
                    continue

                # Search for services
                results = self._search_services(
                    service_type,
                    func_data['location'],
                    func_data['guests'],
                    service_budget
                )

                if results:
                    self.conversation_state['current_service'] = {
                        'type': service_type,
                        'options': results,
                        'budget': service_budget
                    }
                    return {
                        "response": self._format_service_options(service_type, results),
                        "status": "in_progress"
                    }

        # If no more services to recommend, move to next function or finish
        all_functions = list(self.conversation_state['event_data']['functions'].keys())
        current_index = all_functions.index(self.conversation_state['current_function'])

        if current_index + 1 < len(all_functions):
            # Move to next function
            self.conversation_state['current_function'] = all_functions[current_index + 1]
            return self._start_service_selection()
        else:
            # All functions processed
            self.conversation_state['step'] = 'confirmation'
            return self._generate_event_summary()

    def _generate_event_summary(self) -> dict:
        """Generate a summary of the planned event"""
        event_data = self.conversation_state['event_data']
        summary = f"Event: {event_data['name']}\n"
        summary += f"Type: {event_data['type']}\n"
        summary += f"Total Budget: PKR {event_data['budget']:,.2f}\n"
        summary += "Functions:\n"
        
        for func_name, func_data in event_data['functions'].items():
            summary += f"- {func_name}:\n"
            summary += f"  Budget: PKR {func_data['budget']:,.2f}\n"
            summary += f"  Guests: {func_data['guests']}\n"
            summary += f"  Location: {func_data['location']}\n"
            summary += f"  Date: {func_data['date']}\n"
            summary += "  Services:\n"
            
            for service_type, service in func_data['services'].items():
                summary += f"    {service_type}: {service['name']} (PKR {service['price']:,.2f})\n"
        
        summary += "\nDoes this look good? Type 'confirm' to save or 'edit' to make changes."
        return {"response": summary, "status": "confirmation"}

    def _get_event_type_id(self, event_type_name: str) -> Optional[int]:
        """Get event type ID from name"""
        for event_type in get_event_types():
            if event_type['name'].lower() == event_type_name.lower():
                return event_type['id']
        return None

    def _get_function_type_id(self, function_name: str) -> Optional[int]:
        """Get function type ID from name"""
        for function_type in get_function_types():
            if function_type['name'].lower() == function_name.lower():
                return function_type['id']
        return None

    def _handle_function_calls(self, user_id: str, history: List[Dict], tool_calls: List) -> str:
        """Handle function calls and return final assistant response"""
        for tool_call in tool_calls:
            function_name = tool_call.function.name
            function_args = json.loads(tool_call.function.arguments)
            
            # Log function call in history
            history.append({
                "role": "assistant",
                "content": None,
                "tool_calls": [{
                    "id": tool_call.id,
                    "type": "function",
                    "function": {
                        "name": function_name,
                        "arguments": tool_call.function.arguments,
                    },
                }]
            })

            try:
                if function_name in self.available_functions:
                    function_response = self.available_functions[function_name](**function_args)
                    history.append({
                        "role": "tool",
                        "tool_call_id": tool_call.id,
                        "content": json.dumps(function_response),
                    })
                else:
                    history.append({
                        "role": "tool",
                        "tool_call_id": tool_call.id,
                        "content": json.dumps({
                            "error": f"Function {function_name} not available",
                            "failed_function": function_name
                        }),
                    })
            except Exception as func_error:
                history.append({
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps({
                        "error": str(func_error),
                        "failed_function": function_name
                    }),
                })

        # Get final response after function calls
        second_response = self.client.chat.completions.create(
            model=self.model, 
            messages=history
        )
        return second_response.choices[0].message.content

    def _generate_random_event(self) -> dict:
        """Generate a random event when there's confusion in user input"""
        event_types = [et['name'] for et in get_event_types()]
        event_type = random.choice(event_types)
        event_type_id = self._get_event_type_id(event_type)
        functions = get_function_types(event_type_id)
        
        # Create a basic event structure
        event_data = {
            'name': f"Sample {event_type} Event",
            'type': event_type,
            'budget': random.randint(50000, 500000),
            'total_guests': random.randint(50, 500),
            'gender': random.choice(['male', 'female']),
            'venue_type': random.choice(['home', 'hall']),
            'location': DEFAULT_LOCATION,
            'date': (datetime.now() + timedelta(days=random.randint(30, 365))).strftime('%Y-%m-%d'),
            'functions': {}
        }
        
        # Select 1-3 random functions
        selected_functions = random.sample([f['name'] for f in functions], k=random.randint(1, min(3, len(functions))))
        
        for func_name in selected_functions:
            event_data['functions'][func_name] = {
                'date': event_data['date'],
                'location': event_data['location'],
                'budget': round(event_data['budget'] / len(selected_functions)),
                'guests': round(event_data['total_guests'] * random.uniform(0.7, 1.3)),
                'services': {}
            }
            
            # Add random services
            services_to_add = random.sample(SERVICE_PRIORITY, k=random.randint(2, 5))
            for service_type in services_to_add:
                # Skip venue if home
                if service_type == 'Venue' and event_data['venue_type'] == 'home':
                    continue
                    
                # Skip gender-specific services
                if service_type == 'Salon' and event_data['gender'] == 'male':
                    continue
                if service_type == 'Parlor' and event_data['gender'] == 'female':
                    continue
                    
                # Search for services
                results = self._search_services(
                    service_type,
                    event_data['location'],
                    event_data['total_guests'],
                    event_data['budget'] * BUDGET_ALLOCATION.get(service_type, 0.1)
                )
                
                if results:
                    selected = random.choice(results)
                    event_data['functions'][func_name]['services'][service_type] = {
                        'id': selected['id'],
                        'name': selected['name'],
                        'price': selected['price_range']['max'],
                        'details': selected
                    }
        
        return event_data