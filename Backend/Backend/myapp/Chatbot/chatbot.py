import json
import os
from typing import Dict, List

from .config import SYSTEM_MESSAGE
from dotenv import load_dotenv
from .functions import (
    # check_availability,
    get_service_details,
    get_venue_recommendations,
    create_event,
    search_services,
)
from openai import OpenAI

# Load environment variables from .env file
load_dotenv()


class EventBookingChatbot:
    def __init__(self, api_key: str = "", model: str = "gpt-4-turbo"):
        groq_api_key = os.getenv("GROQ_API_KEY")
        self.client = OpenAI(
            api_key=groq_api_key,
            base_url="https://api.groq.com/openai/v1/",
        )
        # self.model = "llama-3.1-8b-instant"   # faster less intelligent model
        # self.model = "llama3-70b-8192"          # slower intelligent model
        # self.model = "llama-3.3-70b-specdec"
        # self.model = "deepseek-r1-distill-llama-70b"
        self.model = "meta-llama/llama-4-scout-17b-16e-instruct"

        # To Store conversation history by user
        self.conversation_histories = {}

        # Available functions
        self.available_functions = {
            "search_services": search_services,
            "get_venue_details": get_service_details,
            # "check_availability": check_availability,
            "create_event": create_event,
            # "get_venue_recommendations": get_venue_recommendations,
        }

        # Define function schemas for OpenAI
        self.function_schemas = [
            {
                "name": "search_services",
                "description": """Search for venues and other event services based on various criteria. 
                    When user tell location at home, DO NOT SEARCH using that location, instead ask for location.
                    Search the budget using min or max price. If not mentioned, do not search for budget.
                """,
                "parameters": {
                    "type": "object",
                    "properties": {
                        "location": {
                            "type": "string",
                            "description": "City or area where the service is located",
                            "optional": True,
                        },
                        "listing_type": {
                            "type": "string",
                            "description": "Type of service (Venue, Caterer, Decorator, Car Renter, Photographer, Photography Place, Parlour, Salon)",
                            "optional": True,
                        },
                        "name": {
                            "type": "string",
                            "description": "Name of the service provider to search for",
                            "optional": True,
                        },
                        "min_capacity": {
                            "type": "integer",
                            "description": "Minimum guest capacity required (for venues)",
                            "optional": True,
                        },
                        "max_capacity": {
                            "type": "integer",
                            "description": "Maximum guest capacity required (for venues)",
                            "optional": True,
                        },
                        "min_price": {
                            "type": "integer",
                            "description": "Minimum price in PKR",
                            "optional": True,
                        },
                        "max_price": {
                            "type": "integer",
                            "description": "Maximum price in PKR",
                            "optional": True,
                        },
                        "basic_price": {
                            "type": "integer",
                            "description": "Maximum basic price in PKR",
                            "optional": True,
                        },
                        "venue_type": {
                            "type": "string",
                            "description": "Type of venue (Hall, Banquet, etc.)",
                            "optional": True,
                        },
                        "catering": {
                            "type": "string",
                            "description": "Catering options (Internal, External, Internal & External)",
                            "optional": True,
                        },
                        "venue_staff": {
                            "type": "string",
                            "description": "Type of staff (Male, Female, Mixed)",
                            "optional": True,
                        },
                        "owner_id": {
                            "type": "string",
                            "description": "ID of the owner",
                            "optional": True,
                        },
                        "freelancer_id": {
                            "type": "string",
                            "description": "ID of the freelancer",
                            "optional": True,
                        },
                        "caterer_service_type": {
                            "type": "string",
                            "description": "Type of catering service (Wedding, etc.)",
                            "optional": True,
                        },
                        "catering_options": {
                            "type": "string",
                            "description": "Catering options (Buffet, etc.)",
                            "optional": True,
                        },
                        "caterer_staff": {
                            "type": "string",
                            "description": "Type of caterer staff (Male, Female, Mixed)",
                            "optional": True,
                        },
                        "caterer_expertise": {
                            "type": "string",
                            "description": "Cuisine expertise (Pakistani, etc.)",
                            "optional": True,
                        },
                        "car_rental_service_type": {
                            "type": "string",
                            "description": "Type of car rental (Economy, Luxury, etc.)",
                            "optional": True,
                        },
                        "decorator_type": {
                            "type": "string",
                            "description": "Type of decorator (Themed, Floral, etc.)",
                            "optional": True,
                        },
                        "decorator_catering": {
                            "type": "string",
                            "description": "Decorator catering options (Provided, etc.)",
                            "optional": True,
                        },
                        "decorator_staff": {
                            "type": "string",
                            "description": "Type of decorator staff (Male, Female, Mixed)",
                            "optional": True,
                        },
                        "photography_place_type": {
                            "type": "string",
                            "description": "Type of photography place (Outdoor, Destination, etc.)",
                            "optional": True,
                        },
                        "has_parlor": {
                            "type": "boolean",
                            "description": "Whether the service has a parlor",
                            "optional": True,
                        },
                        "has_salon": {
                            "type": "boolean",
                            "description": "Whether the service has a salon",
                            "optional": True,
                        },
                        "has_portfolio": {
                            "type": "boolean",
                            "description": "Whether the photographer has a portfolio",
                            "optional": True,
                        },
                    },
                },
            },
            {
                "name": "get_venue_details",
                "description": "Get detailed information about a specific venue",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "venue_id": {
                            "type": "string",
                            "description": "ID of the venue to get details for",
                        }
                    },
                    "required": ["venue_id"],
                },
            },
            # {
            #     "name": "get_venue_recommendations",
            #     "description": "Get personalized venue recommendations based on event requirements",
            #     "parameters": {
            #         "type": "object",
            #         "properties": {
            #             "event_type": {
            #                 "type": "string",
            #                 "description": "Type of event (wedding, conference, party, etc.)",
            #             },
            #             "location": {
            #                 "type": "string",
            #                 "description": "Preferred location",
            #             },
            #             "guest_count": {
            #                 "type": "integer",
            #                 "description": "Expected number of guests",
            #             },
            #             "budget_level": {
            #                 "type": "array",
            #                 "items": {"type": "number"},
            #                 "minItems": 2,
            #                 "maxItems": 2,
            #                 "description": "Budget level tuple (min, max)"
            #             }
            #         },
            #         "required": ["event_type", "location", "guest_count", "budget_level"]
            #     }
            # },
            {
                "name": "create_event",
                "description": "create a event for the user",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "venue_id": {
                            "type": "string",
                            "description": "ID of the venue to book",
                        },
                        "date": {
                            "type": "string",
                            "description": "Date in YYYY-MM-DD format",
                        },
                        "customer_name": {
                            "type": "string",
                            "description": "Name of the customer",
                        },
                        "customer_email": {
                            "type": "string",
                            "description": "Email of the customer",
                        },
                        "customer_phone": {
                            "type": "string",
                            "description": "Phone number of the customer",
                        },
                        "event_type": {
                            "type": "string",
                            "description": "Type of event",
                        },
                        "estimated_guests": {
                            "type": "integer",
                            "description": "Estimated number of guests",
                        },
                        "special_requests": {
                            "type": "string",
                            "description": "Any special requests or notes",
                            "optional": True,
                        },
                    },
                    "required": [
                        "venue_id",
                        "date",
                        "customer_name",
                        "customer_email",
                        "customer_phone",
                        "event_type",
                        "estimated_guests",
                    ],
                },
            },
        ]

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

    def process_message(self, user_id: str, message: str) -> str:
        """Process a user message and return the response"""
        # Add the user message to history
        self.add_message(user_id, message)
        history = self.conversation_histories[user_id]

        # Get response from OpenAI
        response = self.client.chat.completions.create(
            model=self.model,
            messages=history,
            tools=[
                {"type": "function", "function": schema}
                for schema in self.function_schemas
            ],
            tool_choice="auto",
        )

        # Process the response
        response_message = response.choices[0].message

        # Check if the model wants to call a function
        if response_message.tool_calls:
            # Handle function calls
            function_responses = []

            for tool_call in response_message.tool_calls:
                function_name = tool_call.function.name
                function_args = json.loads(tool_call.function.arguments)

                # print('>>> calling function', function_name, function_args)

                # Call the function
                function_response = self.available_functions[function_name](
                    **function_args
                )

                # Add the function call and response to history
                history.append(
                    {
                        "role": "assistant",
                        "content": None,
                        "tool_calls": [
                            {
                                "id": tool_call.id,
                                "type": "function",
                                "function": {
                                    "name": function_name,
                                    "arguments": tool_call.function.arguments,
                                },
                            }
                        ],
                    }
                )

                history.append(
                    {
                        "role": "tool",
                        "tool_call_id": tool_call.id,
                        "content": json.dumps(function_response),
                    }
                )

                function_responses.append(
                    {"name": function_name, "response": function_response}
                )

            # Get a new response that incorporates the function results
            second_response = self.client.chat.completions.create(
                model=self.model, messages=history
            )

            assistant_response = second_response.choices[0].message.content

            # Add final assistant response to history
            history.append({"role": "assistant", "content": assistant_response})

            return assistant_response
        else:
            # No function call, just return the response
            assistant_response = response_message.content

            # Add to history
            history.append({"role": "assistant", "content": assistant_response})

            return assistant_response
