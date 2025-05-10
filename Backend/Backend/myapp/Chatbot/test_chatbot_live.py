from chatbot import EventBookingChatbot


# Example usage
def chat_example():
    chatbot = EventBookingChatbot()

    user_id = "user123"

    # Create a message list to store conversation history
    conversation_history = []

    print("Welcome to the Venue Booking Chatbot!")
    print("Type 'exit' or 'quit' to end the conversation")
    print("Type 'done' when you've finished your booking")
    print("-" * 50)

    while True:
        user_message = input("User: ").strip().lower()

        # Check for exit conditions
        if user_message in ["exit", "quit"]:
            print("Goodbye! Thank you for using our service.")
            break

        # Check if booking is complete
        if user_message == "done":
            print("Thank you for your booking! We hope to see you again.")
            break

        # Print and store user message
        conversation_history.append({"role": "user", "content": user_message})

        # Process message and get response
        response = chatbot.process_message(user_id, user_message)

        # Print and store assistant response
        print("Assistant:", response)
        conversation_history.append({"role": "assistant", "content": response})

        # Check if booking was just completed in the response
        if (
            "booking_initiated" in response.lower()
            and "our team will contact you" in response.lower()
        ):
            print("\nYour booking has been initiated successfully!")
            user_continue = (
                input("Would you like to make another booking? (yes/no): ")
                .strip()
                .lower()
            )
            if user_continue != "yes":
                print("Thank you for using our service. Goodbye!")
                break

        # Add a separator for readability
        print("-" * 50)


if __name__ == "__main__":
    chat_example()
