import React from "react";
import "./EventsScreen.css";

const EventsScreen = () => {
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
            <h3>User Submitted AI Event Requests</h3>
            <div className="event-list">
              <div className="event-item">
                <div>
                  <p className="event-name">Birthday Celebration</p>
                  <p className="event-user">by John Fox - 2 hours ago</p>
                </div>
                <span className="status pending">Pending</span>
              </div>
              <div className="event-item">
                <div>
                  <p className="event-name">Corporate Meeting</p>
                  <p className="event-user">by Sarah Smith - 3 hours ago</p>
                </div>
                <span className="status approved">Approved</span>
              </div>
              <div className="event-item">
                <div>
                  <p className="event-name">Wedding Anniversary</p>
                  <p className="event-user">by Max Johnson - 1 day ago</p>
                </div>
                <span className="status pending">Pending</span>
              </div>
            </div>
            <div className="divider"></div>
            <button className="see-more">See More</button>
          </div>

          {/* Recent Event Requests */}
          <div className="event-card">
            <h3>Recent Event Requests</h3>
            <div className="event-list">
              <div className="event-item">
                <div>
                  <p className="event-name">Birthday Party Planning</p>
                  <p className="event-user">Repeated by John Fox</p>
                </div>
                <span className="status pending">Pending</span>
              </div>
              <div className="event-item">
                <div>
                  <p className="event-name">Corporate Event</p>
                  <p className="event-user">Repeated by Jane Smith</p>
                </div>
                <span className="status approved">Approved</span>
              </div>
            </div>
          </div>

          {/* AI Suggested Plans */}
          <div className="event-card">
            <h3>AI Suggested Plans</h3>
            <div className="event-list">
              <div className="event-item">
                <div>
                  <p className="event-name">Outdoor Summer Party</p>
                  <p className="event-user">Suggested for birthday celebration</p>
                </div>
                <span className="status new">New</span>
              </div>
              <div className="event-item">
                <div>
                  <p className="event-name">Conference Room Setup</p>
                  <p className="event-user">Suggested for Corporate Meeting</p>
                </div>
                <span className="status new">New</span>
              </div>
              <div className="event-item">
                <div>
                  <p className="event-name">Romantic Dinner</p>
                  <p className="event-user">Suggested for Wedding Anniversary</p>
                </div>
                <span className="status modified">Modified</span>
              </div>
            </div>
            <button className="see-more">See More</button>
          </div>

          {/* Event Statistics */}
          <div className="event-card">
            <h3>Event Statistics</h3>
            <div className="stats-grid">
              <div className="stat-box">
                <p>Total Requests</p>
                <span>254</span>
              </div>
              <div className="stat-box">
                <p>Approved</p>
                <span>198</span>
              </div>
              <div className="stat-box">
                <p>Pending Approval</p>
                <span>28</span>
              </div>
              <div className="stat-box">
                <p>Rejected</p>
                <span>28</span>
              </div>
            </div>
          </div>
        </div>
        
        <div className="footer">
          <p>visionna Khan</p>
          <p>admin@zjstl</p>
        </div>
      </div>
    </div>
  );
};

export default EventsScreen;