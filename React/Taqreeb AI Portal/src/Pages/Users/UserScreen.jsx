import React from "react";
import "./UserScreen.css";

const UserScreen = () => {
  return (
    <div className="user-screen">
      {/* Main User Management Section */}
      <div className="user-main">
        <div className="user-header">
          <h2>User Management</h2>
          <p>Monitor and manage user activities</p>
        </div>

        <div className="dashboard-grid">
          {/* Warned Users Section */}
          <div className="card warned-users">
            <h3>Warned Users</h3>
            <div className="stat-box">
              <div>
              <p><strong>Ali Khan</strong></p>
              <p>Improvement content: 2 days ago</p>
              </div>
              <span className="warning-badge">Warning</span>
              </div>
            <div className="stat-box">
              <div>
              <p><strong>Fatima Zahra</strong></p>
              <p>Spam activity: 1 day ago</p>
              </div>
              <span className="warning-badge">Warning</span>
            </div>
            <div className="stat-box">
              <div>
              <p><strong>Hassan Abdullah</strong></p>
              <p>Terms violation: 3 hours ago</p>
              </div>
              <span className="warning-badge">Warning</span>
            </div>
            <button className="view-all">View All Warned Users</button>
          </div>

          {/* User Interaction Statistics */}
          <div className="card stats-card">
            <h3>User Interaction Statistics</h3>
            <div className="stats-grid">
              <div className="stat-box">
                <p>Daily Active Users</p>
                <span>1,234</span>
              </div>
              <div className="stat-box">
                <p>Avg. Session Time</p>
                <span>25m</span>
              </div>
              <div className="stat-box">
                <p>Content Created</p>
                <span>458</span>
              </div>
              <div className="stat-box">
                <p>Engagement Rate</p>
                <span>76%</span>
              </div>
            </div>
          </div>

          {/* Recent User Activities */}
          <div className="card recent-activities">
            <h3>Recent User Activities</h3>
            <div className="activity-item">
              <p>New Profile Update <span className="activity-time">By Cannon Walk</span></p>
            </div>
            <div className="activity-item">
              <p>Content Posted <span className="activity-time">By Oliver Quelch</span></p>
            </div>
          </div>

          {/* User Overview */}
          <div className="card user-overview">
            <h3>User Overview</h3>
            <div className="overview-grid">
              <div className="overview-box">
                <p>Total Users</p>
                <span>12,543</span>
              </div>
              <div className="overview-box">
                <p>New Users (Today)</p>
                <span>127</span>
              </div>
              <div className="overview-box">
                <p>Warned Users</p>
                <span>24</span>
              </div>
              <div className="overview-box">
                <p>Banned Users</p>
                <span>8</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default UserScreen;