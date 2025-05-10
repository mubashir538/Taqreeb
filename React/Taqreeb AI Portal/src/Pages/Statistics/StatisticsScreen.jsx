import React, { useState, useEffect } from "react";
import "./StatisticsScreen.css";
import apiService from "../../api/api"; 

const StatisticsScreen = () => {
  const [statisticsData, setStatisticsData] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchStatistics = async () => {
      try {
        const data = await apiService.get('dashboard-statistics/');
        setStatisticsData(data);
        setLoading(false);
      } catch (error) {
        console.error('Error fetching dashboard statistics:', error);
        setLoading(false);
      }
    };

    fetchStatistics();
  }, []);

  if (loading) {
    return (
      <div className="statistics-container">
        <div className="statistics-main">
          <div className="statistics-header">
            <h1>Statistics Dashboard</h1>
          </div>
          <div style={{ textAlign: 'center', marginTop: '50px', fontSize: '20px' }}>
            Loading statistics...
          </div>
        </div>
      </div>
    );
  }

  if (!statisticsData) {
    return (
      <div className="statistics-container">
        <div className="statistics-main">
          <div className="statistics-header">
            <h1>Statistics Dashboard</h1>
          </div>
          <div style={{ textAlign: 'center', marginTop: '50px', fontSize: '20px', color: 'red' }}>
            Failed to load statistics.
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="statistics-container">
      <div className="statistics-main">
        <div className="statistics-header">
          <h1>Statistics Dashboard</h1>
        </div>

        <div className="sections-grid">
          {/* User Interaction Statistics */}
          <div className="stat-card">
            <h2 className="card-title">User Interaction Statistics</h2>
            <div className="stats-grid">
              <div className="stat-item">
                <div className="stat-label">Daily Active Users</div>
                <div className="stat-value">{statisticsData.userStats.dailyActiveUsers}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Searches Today</div>
                <div className="stat-value">{statisticsData.userStats.searchesToday}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">New Users (Today)</div>
                <div className="stat-value">{statisticsData.userStats.newUsersToday}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Average Session Time</div>
                <div className="stat-value">{statisticsData.userStats.averageSessionTime}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Total Users on App</div>
                <div className="stat-value">{statisticsData.userStats.totalUsers}</div>
              </div>
            </div>
          </div>

          {/* Event Statistics */}
          <div className="stat-card">
            <h2 className="card-title">Event Statistics</h2>
            <div className="stats-grid">
              <div className="stat-item single-stat">
                <div className="stat-label">Total Events on App</div>
                <div className="stat-value">{statisticsData.eventStats.totalEvents}</div>
              </div>
            </div>
          </div>

          {/* Vendor Statistics */}
          <div className="stat-card">
            <h2 className="card-title">Vendor Statistics</h2>
            <div className="stats-grid">
              <div className="stat-item">
                <div className="stat-label">Total Vendors</div>
                <div className="stat-value">{statisticsData.vendorStats.totalVendors}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Total Revenue</div>
                <div className="stat-value">{statisticsData.vendorStats.totalRevenue}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Active Services</div>
                <div className="stat-value">{statisticsData.vendorStats.activeServices}</div>
              </div>
              <div className="stat-item">
                <div className="stat-label">Satisfaction Rate</div>
                <div className="stat-value">{statisticsData.vendorStats.satisfactionRate}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default StatisticsScreen;
