// HomeScreen.jsx

import React, { useEffect, useState } from "react";
import "./HomeScreen.css";
import { Bar, Pie, Line } from 'react-chartjs-2';
import { Chart as ChartJS, CategoryScale, LinearScale, BarElement, PointElement, LineElement, ArcElement, Tooltip, Legend } from 'chart.js';
import apiService from "../../api/api";

ChartJS.register(CategoryScale, LinearScale, BarElement, PointElement, LineElement, ArcElement, Tooltip, Legend);

const HomeScreen = () => {
  const [mostSearchedItems, setMostSearchedItems] = useState([]);
  const [mostUsedServices, setMostUsedServices] = useState([]);
  const [topCategories, setTopCategories] = useState([]);
  const [recentActivities, setRecentActivities] = useState([]);
  const [topSearchTerms, setTopSearchTerms] = useState([]);

  useEffect(() => {
    fetchDashboardData();
  }, []);

  const fetchDashboardData = async () => {
    try {
      const searched = await apiService.get('dashboard_most_searched/');
      const used = await apiService.get('dashboard_most_used_services/');
      const categories = await apiService.get('dashboard_top_categories/');
      const activities = await apiService.get('dashboard_recent_activity/');
      const searchTerms = await apiService.get('dashboard_top_search_terms/');

      setMostSearchedItems(searched.data);
      setMostUsedServices(used.data);
      setTopCategories(categories.data);
      setRecentActivities(activities.data);
      setTopSearchTerms(searchTerms.data);
    } catch (error) {
      console.error("Error fetching dashboard data", error);
    }
  };

  return (
    <div className="dashboard-container">
      <div className="dashboard-main">
        <h2 className="dashboard-title">Dashboard Overview</h2>

        <div className="grid-dashboard">
          {/* Most Searched Items */}
          <div className="chart-card" style={{ height: "300px" }}>
            <h3 className="chart-title">Most Searched Items</h3>
            <Bar
              data={{
                labels: mostSearchedItems.map(item => item.day),
                datasets: [{
                  label: 'Searches',
                  data: mostSearchedItems.map(item => item.count),
                  backgroundColor: '#ff4d4f'
                }]
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
              }}
            />
          </div>

          {/* Top Categories */}
          <div className="chart-card" style={{ height: "300px" }}>
            <h3 className="chart-title">Top Categories</h3>
            <Pie
              data={{
                labels: topCategories.map(cat => cat.name),
                datasets: [{
                  data: topCategories.map(cat => cat.value),
                  backgroundColor: ['#4299e1', '#48bb78', '#f6ad55', '#f56565'],
                }]
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { position: 'right', labels: { color: 'white' } } }
              }}
            />
          </div>

          {/* Most Used Services */}
          <div className="chart-card" style={{ height: "300px" }}>
            <h3 className="chart-title">Most Used Services</h3>
            <Line
              data={{
                labels: mostUsedServices.map(item => item.month),
                datasets: [{
                  label: 'Services',
                  data: mostUsedServices.map(item => item.count),
                  borderColor: '#ff4d4f',
                  backgroundColor: '#ff4d4f',
                  tension: 0.3
                }]
              }}
              options={{
                responsive: true,
                maintainAspectRatio: false,
                scales: { y: { beginAtZero: true } },
                plugins: { legend: { display: false } }
              }}
            />
          </div>

          {/* Recent Activity */}
          <div className="list-card">
            <h3 className="list-title">Recent Activity</h3>
            <ul className="recent-activity-list">
              {recentActivities.map((activity, index) => (
                <li key={index} className="recent-activity-item">
                  {activity}
                </li>
              ))}
            </ul>
          </div>

          {/* Top 10 Searched Items */}
          <div className="list-card">
            <h3 className="list-title">Top 10 Searched Items</h3>
            <table className="table">
              <tbody>
                {topSearchTerms.map((item, idx) => (
                  <tr key={idx}>
                    <td>{item.term}</td>
                    <td className="percentage">{item.percentage}%</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

        </div>
      </div>
    </div>
  );
};

export default HomeScreen;
