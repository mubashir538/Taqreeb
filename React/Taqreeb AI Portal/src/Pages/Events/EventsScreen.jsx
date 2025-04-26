import React, { useEffect, useState } from "react";
import "./EventsScreen.css";
import { getEventDashboardData } from "../../api/eventApi";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../App";
// import LoadingSpinner from "../../Components/"; // A reusable loading component
// import ErrorMessage from "../../components/ErrorMessage"; // A reusable error component

const EventsScreen = () => {
  const [eventStats, setEventStats] = useState({
    total_requests: 0,
    approved: 0,
    pending: 0,
    rejected: 0,
    recent_events: [],
    user_submitted_events: [],
    ai_suggestions: []
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const { authToken } = useAuth(); // Get token from auth context
  const navigate = useNavigate();

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        setError(null);
        
        const response = await getEventDashboardData(authToken);
        
        if (!response.success) {
          throw new Error(response.message || "Failed to fetch event data");
        }

        setEventStats({
          total_requests: response.stats?.total_requests || 0,
          approved: response.stats?.approved || 0,
          pending: response.stats?.pending || 0,
          rejected: response.stats?.rejected || 0,
          recent_events: response.recent_events || [],
          user_submitted_events: response.user_requests || [],
          ai_suggestions: response.suggested_plans?.map(plan => ({
            title: plan.title || plan.name || "Untitled Plan",
            related_event: plan.for || "General",
            tag: plan.status || "pending"
          })) || []
        });
      } catch (error) {
        console.error("Failed to fetch event dashboard data:", error);
        setError(error.message || "An error occurred while fetching data");
        
        // If unauthorized, redirect to login
        if (error.response?.status === 401) {
          navigate("/login");
        }
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [authToken, navigate]);

  const handleSeeMore = (type) => {
    // Navigate to detailed view based on type
    navigate(`/events/${type}`);
  };

  const getStatusClass = (status) => {
    if (!status) return 'pending';
    return status.toLowerCase().replace(/\s+/g, '-');
  };

  if (error) {
    return (
      <div className="events-container center-content">
        <ErrorMessage message={error} onRetry={() => window.location.reload()} />
      </div>
    );
  }

  return (
    <div className="events-container">
      <div className="events-main">
        <div className="events-header">
          <h1>Event Management</h1>
          <p>Monitor and manage AI event requests</p>
        </div>

        <div className="events-grid">
          {/* User Submitted AI Event Requests */}
          <div className="event-card">
            <div className="card-header">
              <h3>User Submitted AI Event Requests</h3>
              {eventStats.user_submitted_events.length > 0 && (
                <span className="badge">{eventStats.user_submitted_events.length}</span>
              )}
            </div>
            <div className="event-list">
              {eventStats.user_submitted_events.length > 0 ? (
                eventStats.user_submitted_events.map((item, index) => (
                  <div className="event-item" key={`user-${index}`}>
                    <div className="event-info">
                      <p className="event-name">{item.name || "Untitled Event"}</p>
                      <p className="event-meta">
                        <span className="event-user">by {item.user || "Unknown"}</span>
                        <span className="event-time"> • {item.time_ago || "recently"}</span>
                      </p>
                    </div>
                    <span className={`status ${getStatusClass(item.status)}`}>
                      {item.status || "Pending"}
                    </span>
                  </div>
                ))
              ) : (
                <div className="empty-state">No user submitted events</div>
              )}
            </div>
            <div className="card-footer">
              <button 
                className="see-more" 
                onClick={() => handleSeeMore('user-submitted')}
                disabled={eventStats.user_submitted_events.length === 0}
              >
                See More
              </button>
            </div>
          </div>

          {/* AI Suggested Plans */}
          <div className="event-card">
            <div className="card-header">
              <h3>AI Suggested Plans</h3>
              {eventStats.ai_suggestions.length > 0 && (
                <span className="badge">{eventStats.ai_suggestions.length}</span>
              )}
            </div>
            <div className="event-list">
              {eventStats.ai_suggestions.length > 0 ? (
                eventStats.ai_suggestions.map((item, index) => (
                  <div className="event-item" key={`ai-${index}`}>
                    <div className="event-info">
                      <p className="event-name">{item.title}</p>
                      <p className="event-meta">
                        Suggested for {item.related_event}
                      </p>
                    </div>
                    <span className={`status ${getStatusClass(item.tag)}`}>
                      {item.tag}
                    </span>
                  </div>
                ))
              ) : (
                <div className="empty-state">No AI suggestions available</div>
              )}
            </div>
            <div className="card-footer">
              <button 
                className="see-more" 
                onClick={() => handleSeeMore('ai-suggestions')}
                disabled={eventStats.ai_suggestions.length === 0}
              >
                See More
              </button>
            </div>
          </div>

          {/* Recent Event Requests */}
          <div className="event-card">
            <div className="card-header">
              <h3>Recent Event Requests</h3>
              {eventStats.recent_events.length > 0 && (
                <span className="badge">{eventStats.recent_events.length}</span>
              )}
            </div>
            <div className="event-list">
              {eventStats.recent_events.length > 0 ? (
                eventStats.recent_events.map((item, index) => (
                  <div className="event-item" key={`recent-${index}`}>
                    <div className="event-info">
                      <p className="event-name">{item.name || "Untitled Event"}</p>
                      <p className="event-meta">
                        Requested by {item.user || "Unknown"}
                      </p>
                    </div>
                    <span className={`status ${getStatusClass(item.status)}`}>
                      {item.status || "Pending"}
                    </span>
                  </div>
                ))
              ) : (
                <div className="empty-state">No recent events</div>
              )}
            </div>
          </div>

          {/* Event Statistics */}
          <div className="event-card stats-card">
            <h3>Event Statistics</h3>
            <div className="stats-grid">
              <div className="stat-box total">
                <p>Total Requests</p>
                <span>{eventStats.total_requests}</span>
              </div>
              <div className="stat-box approved">
                <p>Approved</p>
                <span>{eventStats.approved}</span>
              </div>
              <div className="stat-box pending">
                <p>Pending Approval</p>
                <span>{eventStats.pending}</span>
              </div>
              <div className="stat-box rejected">
                <p>Rejected</p>
                <span>{eventStats.rejected}</span>
              </div>
            </div>
            <div className="stats-footer">
              <p>Updated just now</p>
            </div>
          </div>
        </div>

        <div className="footer">
          <p>Wishma Khan</p>
          <p>admin@zjstl</p>
        </div>
      </div>
    </div>
  );
};

export default EventsScreen;