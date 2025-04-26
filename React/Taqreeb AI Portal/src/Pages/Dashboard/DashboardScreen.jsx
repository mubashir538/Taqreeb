import React from "react";
import "./DashboardScreen.css";
import StatsCard from "../../Components/StatsCard/statscard.jsx";
import Chart from "../../Components/Chart/chart.jsx";
import VendorCard from "../../Components/VendorCard/vendorcard.jsx";  
import EventCard from "../../Components/EventCard/eventcard.jsx";

import { FaUsers, FaDollarSign, FaShoppingCart, FaCalendarAlt } from "react-icons/fa";

const DashboardScreen = () => {
  const chartData = [
    { name: "Jan", value: 400 },
    { name: "Feb", value: 300 },
    { name: "Mar", value: 500 },
    { name: "Apr", value: 700 },
    { name: "May", value: 600 },
  ];

  return (
    <div className="dashboard-container">
      <div className="dashboard-main">
        <div className="dashboard-content">
          <h2 className="dashboard-title">Welcome back, Wishma</h2>

          {/* Stats Section */}
          <div className="stats-section">
            <StatsCard icon={<FaUsers />} label="Total Users" value="1,234" />
            <StatsCard icon={<FaDollarSign />} label="Revenue" value="$12,345" />
            <StatsCard icon={<FaShoppingCart />} label="Orders" value="567" />
            <StatsCard icon={<FaCalendarAlt />} label="Events" value="42" />
          </div>

          {/* Charts Section */}
          <div className="charts-section">
            <Chart data={chartData} title="Most Searched Items" />
            <Chart data={chartData} title="Top Categories" />
            <Chart data={chartData} title="Most Used Services" />
            <Chart data={chartData} title="All Package Success Rate" />
          </div>

          {/* Lists Section */}
          <div className="lists-section">
            <div className="list-card">
              <h3>Top 10 Searched Items</h3>
              <ul>
                <li>Top Halls in Pakistan - 89%</li>
                <li>Trending Halls in Karachi - 83%</li>
                <li>Best Photographers - 75%</li>
              </ul>
            </div>
            <div className="list-card">
              <h3>Recent Activity</h3>
              <ul>
                <li>New vendor approved</li>
                <li>New order placed</li>
              </ul>
            </div>
          </div>

        </div>
      </div>
    </div>
  );
};

export default DashboardScreen;


// import React, { useEffect, useState } from "react";
// import "./DashboardScreen.css";
// import StatsCard from "../../Components/StatsCard/statscard.jsx";
// import Chart from "../../Components/Chart/chart.jsx";
// import VendorCard from "../../Components/VendorCard/vendorcard.jsx";
// import EventCard from "../../Components/EventCard/eventcard.jsx";
// import { getDashboardData } from "../../api/dashboardApi";

// import { FaUsers, FaClock, FaClipboardList } from "react-icons/fa";

// const DashboardScreen = () => {
//   const [data, setData] = useState(null);

//   useEffect(() => {
//     getDashboardData().then(setData).catch(console.error);
//   }, []);

//   if (!data) return <div className="dashboard-container">Loading...</div>;

//   const {
//     top_categories,
//     home_listings,
//     user_activities
//   } = data;

//   return (
//     <div className="dashboard-container">
//       <div className="dashboard-main">
//         <div className="dashboard-content">
//           <h2 className="dashboard-title">Welcome back, Wishma</h2>

//           <div className="stats-section">
//             <StatsCard icon={<FaUsers />} label="Total Listings" value={home_listings.length} />
//             <StatsCard icon={<FaClock />} label="Recent Activity" value={user_activities.length} />
//             <StatsCard icon={<FaClipboardList />} label="Categories" value={top_categories.length} />
//           </div>

//           <div className="charts-section">
//             <Chart
//               title="Top Categories"
//               data={top_categories.map(cat => ({
//                 name: cat.category,
//                 value: cat.count
//               }))}
//             />

//             <Chart
//               title="Recent Listings"
//               data={home_listings.map((item, index) => ({
//                 name: item.name || `Listing ${index + 1}`,
//                 value: item.basicPrice
//               }))}
//             />
//           </div>

//           <div className="lists-section">
//             <div className="list-card">
//               <h3>Recent User Activities</h3>
//               <ul>
//                 {user_activities.slice(0, 5).map((activity, index) => (
//                   <li key={index}>
//                     <strong>{activity.action}</strong> - {activity.timestamp}
//                   </li>
//                 ))}
//               </ul>
//             </div>
//           </div>

//         </div>
//       </div>
//     </div>
//   );
// };

// export default DashboardScreen;
