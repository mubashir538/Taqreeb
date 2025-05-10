# server/terminal_chatbot.py
import os
import sys
import json
from datetime import datetime
from colorama import init, Fore, Style
from .chatbot import EventPlanningChatbot  # Your existing chatbot class
from .config import SYSTEM_MESSAGE  # Import other necessary components
from .functions import *  # Import all your functions
import django
from django.conf import settings

init()  # Initialize colorama

class TerminalChatbot:
    def __init__(self):
        self.chatbot = EventPlanningChatbot()
        self.user_id = "terminal_user_1"
    
    def print_colored(self, text, color=Fore.WHITE):
        print(f"{color}{text}{Style.RESET_ALL}")
    
    def start(self):
        self.print_colored("\n=== Event Planning Chatbot (Terminal Mode) ===", Fore.GREEN)
        self.print_colored("Type 'exit' to quit or 'reset' to start over\n", Fore.CYAN)
        
        while True:
            try:
                user_input = input(Fore.YELLOW + "You: " + Style.RESET_ALL).strip()
                
                if user_input.lower() == 'exit':
                    break
                if user_input.lower() == 'reset':
                    self.chatbot.conversation_histories.pop(self.user_id, None)
                    self.print_colored("Conversation reset", Fore.MAGENTA)
                    continue
                
                response = self.chatbot.process_message(self.user_id, user_input)
                
                # Print bot response
                self.print_colored("\n🤖 Assistant:", Fore.BLUE)
                print(response.get('response', 'No response'))
                
                # Print debug info if available
                if response.get('current_step'):
                    self.print_colored(f"[Current Step: {response['current_step']}]", Fore.MAGENTA)
                if response.get('is_final_plan'):
                    self.print_colored("\n🎉 FINAL PLAN DETECTED:", Fore.GREEN)
                    print(json.dumps(response.get('event_data'), indent=2))
                
            except Exception as e:
                self.print_colored(f"Error: {str(e)}", Fore.RED)

if __name__ == "__main__":
    # Add server directory to Python path
    server_dir = os.path.dirname(os.path.abspath(__file__))
    sys.path.append(server_dir)
    
    # Now you can import all server modules correctly
    from chatbot import EventPlanningChatbot
    from config import SYSTEM_MESSAGE
    from functions import *
    
    chatbot = TerminalChatbot()
    chatbot.start()