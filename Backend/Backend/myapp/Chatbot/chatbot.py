import json
import os
from typing import Dict, List
from datetime import datetime
from .config import SYSTEM_MESSAGE
from dotenv import load_dotenv
from .functions import (
    get_event_types,
    get_function_types,
    search_listings,
    get_listing_details,
    check_date_availability,
    create_event,
    get_venue_recommendations
)
from openai import OpenAI
import re
from .data.event_types import EVENT_TYPES

# Load environment variables from .env file
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
    def __init__(self, api_key: str = "", model: str = "mistral-saba-24b"):
        self.client = OpenAI(api_key=api_key, base_url="https://api.groq.com/openai/v1/")
        self.model = model
        self.conversation_state = {
            'step': 'init',
            'event_data': {
                'name': None,
                'type': None,
                'date': datetime.now().strftime('%Y-%m-%d'),
                'location': DEFAULT_LOCATION,
                'budget': None,
                'total_guests': None,
                'gender': None,  # 'male' or 'female'
                'venue_type': None,  # 'home' or 'hall'
                'functions': {}
            },
            'current_function': None,
            'confirmed_services': {}
        }
        self.conversation_history = []

    def process_message(self, user_id: str, message: str) -> dict:
        try:
            # Add user message to history
            self.conversation_history.append({"role": "user", "content": message})
            
            # Process based on current step
            if self.conversation_state['step'] == 'init':
                return self._handle_initial_info(message)
            elif self.conversation_state['step'] == 'select_functions':
                return self._handle_function_selection(message)
            elif self.conversation_state['step'] == 'function_details':
                return self._handle_function_details(message)
            elif self.conversation_state['step'] == 'service_selection':
                return self._handle_service_selection(message)
            elif self.conversation_state['step'] == 'confirmation':
                return self._handle_confirmation(message)
                
        except Exception as e:
            return {"response": f"Error: {str(e)}", "status": "error"}

    def _handle_initial_info(self, message):
        """Collect initial event information"""
        # Extract info from message using regex
        self._extract_event_info(message)
        
        # Check what's still missing
        missing = []
        if not self.conversation_state['event_data']['name']:
            missing.append("event name")
        if not self.conversation_state['event_data']['type']:
            missing.append("event type (from: {})".format(", ".join(get_event_types())))
        if not self.conversation_state['event_data']['budget']:
            missing.append("total budget")
        if not self.conversation_state['event_data']['total_guests']:
            missing.append("total guests")
        if not self.conversation_state['event_data']['gender']:
            missing.append("gender of the person (male/female)")
        if not self.conversation_state['event_data']['venue_type']:
            missing.append("venue type (home/hall)")
            
        if missing:
            return {
                "response": "I still need: " + ", ".join(missing),
                "status": "in_progress"
            }
        else:
            self.conversation_state['step'] = 'select_functions'
            return {
                "response": "Great! Now please tell me which functions you'd like to include (e.g., Engagement, Mehndi, Valima).",
                "status": "in_progress"
            }

    def _handle_function_selection(self, message):
        """Handle selection of functions for the event"""
        # Get available function types for this event type
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

    def _handle_function_details(self, message):
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

    def _start_service_selection(self):
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

    def _extract_event_info(self, message):
        """Extract event information from user message"""
        # Extract event name
        if not self.conversation_state['event_data']['name']:
            name_match = re.search(r'(?:event name|name of event)[:\s]*(.+)', message, re.IGNORECASE)
            if name_match:
                self.conversation_state['event_data']['name'] = name_match.group(1).strip()
        
        # Extract event type
        if not self.conversation_state['event_data']['type']:
            for event_type in get_event_types():
                if event_type['name'].lower() in message.lower():
                    self.conversation_state['event_data']['type'] = event_type['name']
                    break
        
        # Extract budget
        if not self.conversation_state['event_data']['budget']:
            budget_match = re.search(r'(?:budget|price)[:\s]*(\d+)', message, re.IGNORECASE)
            if budget_match:
                self.conversation_state['event_data']['budget'] = float(budget_match.group(1))
        
        # Extract guests
        if not self.conversation_state['event_data']['total_guests']:
            guests_match = re.search(r'(?:guests|people|attendees)[:\s]*(\d+)', message, re.IGNORECASE)
            if guests_match:
                self.conversation_state['event_data']['total_guests'] = int(guests_match.group(1))
        
        # Extract gender
        if not self.conversation_state['event_data']['gender']:
            if 'male' in message.lower():
                self.conversation_state['event_data']['gender'] = 'male'
            elif 'female' in message.lower():
                self.conversation_state['event_data']['gender'] = 'female'
        
        # Extract venue type
        if not self.conversation_state['event_data']['venue_type']:
            if 'home' in message.lower():
                self.conversation_state['event_data']['venue_type'] = 'home'
            elif 'hall' in message.lower() or 'venue' in message.lower():
                self.conversation_state['event_data']['venue_type'] = 'hall'

    def _search_services(self, service_type, location, guests, budget):
        """Search for services based on criteria"""
        filters = {
            'service_type': service_type,
            'location': location if location.lower() not in ['home', 'street'] else None,
            'max_price': budget
        }
        
        if service_type == 'Venue':
            filters['min_capacity'] = guests
            filters['max_capacity'] = guests * 1.2  # Allow 20% buffer
        
        return search_listings(**filters)

    def _generate_event_summary(self):
        """Generate a summary of the planned event"""
        summary = f"Event: {self.conversation_state['event_data']['name']}\n"
        summary += f"Type: {self.conversation_state['event_data']['type']}\n"
        summary += f"Total Budget: {self.conversation_state['event_data']['budget']}\n"
        summary += "Functions:\n"
        
        for func_name, func_data in self.conversation_state['event_data']['functions'].items():
            summary += f"- {func_name}:\n"
            summary += f"  Budget: {func_data['budget']}\n"
            summary += f"  Guests: {func_data['guests']}\n"
            summary += f"  Location: {func_data['location']}\n"
            summary += f"  Date: {func_data['date']}\n"
            summary += "  Services:\n"
            
            for service_type, service in func_data['services'].items():
                summary += f"    {service_type}: {service['name']} (PKR {service['price']})\n"
        
        summary += "\nDoes this look good? Type 'confirm' to save or 'edit' to make changes."
        return {"response": summary, "status": "confirmation"}

    # ... (additional methods for handling confirmation, saving events, etc.)    def has_event_data(self):
        return bool(self.conversation_state['event_data']['event_type'])

    def has_function_data(self, function_name):
        return function_name in self.conversation_state['event_data']['functions']

    def get_missing_fields(self, required_fields):
        """Check which required fields are missing from current state"""
        current_data = self.get_current_data_context()
        return [field for field in required_fields if field not in current_data]

    def load_state(self, state):
        self.conversation_state = state
    
    def get_state(self):
        return self.conversation_state
        
    def get_or_create_history(self, user_id: str) -> List[Dict[str, str]]:
        """Get existing conversation history or create a new one"""
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
        print(f"\n=== NEW MESSAGE ===\nUser ID: {user_id}\nMessage: {message}")
        """Enhanced process_message with state persistence and error recovery"""
        if self.conversation_state['step'] == 'initial':
            self._parse_initial_message(message)
        try:
            if self._handle_numeric_input(message):
                # Don't process further if we handled it as a numeric response
                return self._continue_flow(user_id)
            
            # Load existing conversation state if available
            conversation_state = self._load_conversation_state(user_id)
            print(f"Loaded State: {json.dumps(conversation_state, indent=2)}")

            # Initialize history from state or create new
            if user_id not in self.conversation_histories:
                if conversation_state and 'history' in conversation_state:
                    self.conversation_histories[user_id] = conversation_state['history']
                else:
                    self.conversation_histories[user_id] = [
                        {"role": "system", "content": SYSTEM_MESSAGE}
                    ]

            # Add user message to history
            self.add_message(user_id, message)
            history = self.conversation_histories[user_id]

            # Prepare API call with error handling
            try:
                response = self.client.chat.completions.create(
                    model=self.model,
                    messages=history,
                    tools=[
                        {"type": "function", "function": schema}
                        for schema in self.function_schemas
                    ],
                    tool_choice="auto",
                )
                print("\n=== SENDING TO OPENAI ===")
                print(f"Model: {self.model}")
                print("Message History:")
                for idx, msg in enumerate(history):
                    print(f"{idx}. {msg['role']}: {msg.get('content', '[function call]')}")
                response_message = response.choices[0].message
            except Exception as api_error:
                # Save state before failing
                self._save_conversation_state(user_id, {
                    'history': history,
                    'error_count': conversation_state.get('error_count', 0) + 1
                })
                raise Exception(f"API Error: {str(api_error)}")

            # Process function calls if any
            if response_message.tool_calls:
                assistant_response = self._handle_function_calls(
                    user_id, 
                    history, 
                    response_message.tool_calls
                )
            else:
                assistant_response = response_message.content
                history.append({"role": "assistant", "content": assistant_response})

            # Check if this is a final plan response
            is_final_plan = self._is_final_plan_response(assistant_response)
            event_data = None
            if is_final_plan:
                event_data = self._parse_final_plan(assistant_response)
                # Store the complete plan in state
                conversation_state['final_plan'] = event_data

            # Save successful state
            self._save_conversation_state(user_id, {
                'history': history,
                'current_step': self._determine_next_step(assistant_response),
                'final_plan': event_data if is_final_plan else None,
                'last_response': assistant_response
            })

            return {
                'response': assistant_response,
                'is_final_plan': is_final_plan,
                'event_data': event_data,
                'status': 'success'
            }

        except Exception as e:
            # Return error while preserving existing state
            return {
                'response': f"Error: {str(e)}",
                'is_final_plan': False,
                'event_data': None,
                'status': 'error'
            }

    def _parse_initial_message(self, message):
        # Look for event type patterns
        for event_type in EVENT_TYPES:
            if event_type.lower() in message.lower():
                self.conversation_state['event_data']['event_type'] = event_type
                self.conversation_state['step'] = 'selecting_functions'
                break
            
        # Look for budget patterns
        budget_matches = re.findall(r'\$?\d+(?:,\d{3})*(?:\.\d{2})?', message)
        if budget_matches:
            self.conversation_state['event_data']['total_budget'] = float(budget_matches[0].replace('$', '').replace(',', ''))

        # Look for guest count
        guest_matches = re.findall(r'(\d+)\s+(?:guests|people|attendees)', message, re.IGNORECASE)
        if guest_matches:
            self.conversation_state['event_data']['guest_count'] = int(guest_matches[0])

    def get_next_questions(self):
        """Determine what information we still need in a single batch"""
        missing = []

        if not self.has_event_data():
            missing.append("What type of event would you like to plan?")
        elif not self.conversation_state['current_function']:
            missing.append("Which functions would you like to include?")
        else:
            func_data = self.get_current_function_data()
            required_fields = ['budget', 'date', 'guest_count']
            missing_fields = self.get_missing_fields(required_fields)

            if missing_fields:
                missing.append(f"For the {self.conversation_state['current_function']}, we need: {', '.join(missing_fields)}")

        return " ".join(missing) if missing else None

    def confirm_details(self):
        """Ask user to confirm collected details before proceeding"""
        confirmation_text = "Please confirm these details:\n"
        # Build confirmation text from state
        # ...
        return confirmation_text
    
    def _handle_numeric_input(self, message):
        """Process numeric inputs based on current context"""
        current_step = self.conversation_state['step']

        if current_step == 'awaiting_guest_count':
            try:
                guests = int(message)
                self.conversation_state['event_data']['functions'][
                    self.conversation_state['current_function']
                ]['guest_count'] = guests
                self.conversation_state['step'] = 'selecting_services'
                return True
            except ValueError:
                return False

        elif current_step == 'awaiting_budget':
            # Similar handling for budget
            pass
        
        return False
    

    def _handle_function_calls(self, user_id, history, tool_calls):
        """Handle function calls and return final assistant response"""
        print("\n=== FUNCTION CALLS DETECTED ===")
        for tool_call in tool_calls:
            function_name = tool_call.function.name
            function_args = json.loads(tool_call.function.arguments)
            print(f"\nCalling Function: {function_name}")
            print(f"Arguments: {json.dumps(function_args, indent=2)}")

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
                if function_name not in self.available_functions:
                    print(f"⚠️ Function not available! Available functions: {list(self.available_functions.keys())}")
            
            
                function_response = self.available_functions[function_name](
                    **function_args
                )
                print(f"Function Result: {json.dumps(function_response, indent=2)}")
                history.append({
                    "role": "tool",
                    "tool_call_id": tool_call.id,
                    "content": json.dumps(function_response),
                })
            except Exception as func_error:
                print(f"🚨 Function Error: {str(func_error)}")
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
        print("\n=== OPENAI RESPONSE ===")
        print(f"Finish Reason: {second_response.choices[0].finish_reason}")
        print(f"Message Content: {second_response.choices[0].message.content}")
        print("Tool Calls:")
        if second_response.choices[0].message.tool_calls:
            for tool in second_response.choices[0].message.tool_calls:
                print(f"- {tool.function.name}: {tool.function.arguments}")
        else:
            print("No tool calls")
        return second_response.choices[0].message.content

    def _format_response(self, response):
        """Ensure response is properly formatted text"""
        if isinstance(response, dict):
            # Handle dictionary responses
            if 'response' in response:
                return str(response['response'])
            return json.dumps(response, indent=2)
        elif isinstance(response, str):
            return response
        return str(response)

    def _load_conversation_state(self, user_id: str) -> dict:
        """Load conversation state from persistent storage"""
        # Implement your storage mechanism here (database, Redis, etc.)
        # Return empty dict if no state exists
        return {}  # Replace with actual implementation

    def _save_conversation_state(self, user_id: str, state: dict):
        """Save conversation state to persistent storage"""
        # Implement your storage mechanism here
        pass

    def _is_final_plan_response(self, response_text: str) -> bool:
        """Determine if the response contains a complete event plan"""
        markers = ["Event:", "Functions:", "Budget:", "Services:"]
        return all(marker in response_text for marker in markers)

    def _parse_final_plan(self, response_text: str) -> dict:
        """Parse the structured event plan from the response"""
        # Implement your parsing logic here
        return {}  # Replace with actual implementation

    def _determine_next_step(self, response_text: str) -> str:
        """Determine the next step in the conversation flow"""
        # Implement your step detection logic
        return "unknown" 