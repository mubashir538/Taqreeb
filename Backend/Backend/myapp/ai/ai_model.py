import pandas as pd
from myapp.models import UserActivity, Listing, User, Categories
from sklearn.preprocessing import LabelEncoder, StandardScaler
from myapp.models import Events, Functions,Listing,Orders
import joblib
from sklearn.neighbors import NearestNeighbors
from django.db.models import Count


def fetch_user_interaction_data():
    # Fetch user activities and their associated data
    user_activities = UserActivity.objects.select_related('user').all()
    
    activity_data = []
    for activity in user_activities:
        metadata = activity.metadata or {}
        activity_data.append({
            'user_id': activity.user.id,
            'action': activity.action,
            'timestamp': activity.timestamp,
            'metadata': metadata,
        })

    df_activities = pd.DataFrame(activity_data)
    return df_activities

def fetch_user_event_data():
    # Fetch all events along with their associated functions
    events = Events.objects.all()

    event_data = []
    for event in events:
        # Fetch functions related to this event
        functions = Functions.objects.filter(eventId=event)

        # If no functions are associated, still record the event
        if not functions.exists():
            event_data.append({
                'user_id': event.userID,
                'event_id': event.id,
                'event_name': event.name,
                'event_type': event.type,
                'event_budget': event.budget,
                'event_location': event.location,
                'event_date': event.date,
                'function_id': None,
                'function_name': None,
                'function_type': None,
                'function_budget': None,
                'function_date': None,
            })
        else:
            for function in functions:
                event_data.append({
                    'user_id': event.userID,
                    'event_id': event.id,
                    'event_name': event.name,
                    'event_type': event.type,
                    'event_budget': event.budget,
                    'event_location': event.location,
                    'event_date': event.date,
                    'function_id': function.id,
                    'function_name': function.name,
                    'function_type': function.type,
                    'function_budget': function.budget,
                    'function_date': function.date,
                })

    df_events = pd.DataFrame(event_data)
    return df_events

def fetch_listings_data():
    # Fetch listings/services from database
    listings = Listing.objects.select_related('ownerID', 'freelancerID').all()

    listing_data = []
    for listing in listings:
        category = Categories.objects.filter(name=listing.type).first()
        category_name = category.name if category else "Unknown"
        
        listing_data.append({
            'listing_id': listing.id,
            'name': listing.name,
            'category': category_name,
            'location': listing.location,
            'price_min': listing.priceMin,
            'price_max': listing.priceMax,
            'basic_price': listing.basicPrice,
        })

    df_listings = pd.DataFrame(listing_data)
    return df_listings

def prepare_training_data():
    # Fetch data using previous methods
    interactions_df = fetch_user_interaction_data()
    events_df = fetch_user_event_data()
    # listings_df = fetch_listings_data()

    # --- Merge and Structure Data ---

    # Merge user interactions with events data on user_id
    user_events = events_df.groupby('user_id').agg({
        'event_budget': ['mean', 'sum'],
        'event_type': lambda x: x.mode()[0] if len(x) > 0 else 'Unknown',
        'event_id': 'count'
    }).reset_index()
    
    user_events.columns = ['user_id', 'avg_event_budget', 'total_event_budget', 'favorite_event_type', 'events_count']

    # Merge interactions data with user_events
    interactions_agg = interactions_df.groupby('user_id').agg({
        'action': lambda x: x.mode()[0],
    }).reset_index()

    interactions_agg.columns = ['user_id', 'most_common_action']

    user_features = pd.merge(user_events, interactions_agg, on='user_id', how='left')

    # --- Encoding Categorical Variables ---

    le_event_type = LabelEncoder()
    le_action = LabelEncoder()

    user_features['favorite_event_type_enc'] = le_event_type.fit_transform(user_features['favorite_event_type'])
    user_features['most_common_action_enc'] = le_action.fit_transform(user_features['most_common_action'])

    # Drop original categorical columns after encoding
    user_features.drop(['favorite_event_type', 'most_common_action'], axis=1, inplace=True)

    # --- Handle NaN values (if any) ---
    user_features.fillna(user_features.mean(), inplace=True)

    # --- Scale Numerical Variables ---
    scaler = StandardScaler()
    scaled_features = scaler.fit_transform(user_features.drop('user_id', axis=1))
    
    X = pd.DataFrame(scaled_features, columns=user_features.columns[1:])
    X['user_id'] = user_features['user_id'].values

    return X, le_event_type, le_action, scaler



def train_and_save_model():
    # Prepare data
    X, le_event_type, le_action, scaler = prepare_training_data()

    # Remove user_id (we'll use it later separately)
    feature_data = X.drop('user_id', axis=1)

    # Train Nearest Neighbors model (recommendation-based model)
    model = NearestNeighbors(n_neighbors=5, metric='cosine')
    model.fit(feature_data)

    # Save the trained model and encoders for future use
    joblib.dump(model, 'ai_recommendation_model.pkl')
    joblib.dump(le_event_type, 'le_event_type.pkl')
    joblib.dump(le_action, 'le_action.pkl')
    joblib.dump(scaler, 'feature_scaler.pkl')

    print("✅ AI recommendation model successfully trained and saved.")



def test_recommendation_terminal():
    # Load trained model and encoders
    model = joblib.load('ai_recommendation_model.pkl')
    le_event_type = joblib.load('le_event_type.pkl')
    le_action = joblib.load('le_action.pkl')
    scaler = joblib.load('feature_scaler.pkl')

    # User input from terminal
    user_prompt = input("Describe your event: ").lower()
    user_budget = int(input("Budget for your event: "))
    user_location = input("Preferred location: ")

    # Prepare existing user data
    X, _, _, _ = prepare_training_data()
    feature_data = X.drop('user_id', axis=1)

    # Encode input safely
    event_type_encoded = le_event_type.transform([user_prompt])[0] if user_prompt in le_event_type.classes_ else 0
    action_encoded = le_action.transform(['search'])[0] if 'search' in le_action.classes_ else 0

    test_user_dict = {
        'avg_event_budget': user_budget,
        'total_event_budget': user_budget,
        'events_count': 1,
        'favorite_event_type_enc': event_type_encoded,
        'most_common_action_enc': action_encoded
    }

    test_user_df = pd.DataFrame([test_user_dict])
    test_user_scaled = scaler.transform(test_user_df)
    test_user_scaled = pd.DataFrame(test_user_scaled, columns=test_user_df.columns)


    # Find nearest neighbors (similar users)
    _, indices = model.kneighbors(test_user_scaled)
    similar_users_ids = X.iloc[indices[0]]['user_id'].tolist()
        
    # Analyze behavior of similar users clearly
    similar_events = Events.objects.filter(userID__in=similar_users_ids, type__icontains=user_prompt)
    popular_locations = similar_events.values('location').annotate(count=Count('location')).order_by('-count')


    # If no historical data found
    if not popular_locations:
        recommendation = (f"For a '{user_prompt}' event with a budget of {user_budget} in {user_location}, "
                          f"I recommend exploring local popular venues and services listed in your area.")
    else:
        top_location = popular_locations[0]['location']
        recommendation = (f"Based on similar '{user_prompt}' events, most users prefer hosting events "
                          f"in '{top_location}'. With your budget of {user_budget}, you might consider venues and services "
                          f"in '{top_location}', known for good value and high ratings.")

    # Print clearly formatted recommendation (GPT-style)
    print("\n🤖 **AI Recommendation:**")
    print(recommendation)