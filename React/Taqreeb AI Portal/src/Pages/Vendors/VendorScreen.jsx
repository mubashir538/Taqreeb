import React from "react";
import "./VendorScreen.css";
import VendorCard from "../../Components/VendorCard/vendorcard.jsx";


const VendorScreen = () => {
  return (
    <div className="vendor-screen">
      <div className="vendor-main">
        <Navbar />
        <div className="vendor-header">
          <h2>Vendor Management</h2>
          <p>Monitor and manage vendor activities</p>
        </div>

        <div className="vendor-content">
          <div className="vendor-stats">
            <div className="stat-card">
              <h3>Total Vendors</h3>
              <p>856</p>
            </div>
            <div className="stat-card">
              <h3>Active Services</h3>
              <p>2,145</p>
            </div>
            <div className="stat-card">
              <h3>Total Revenue</h3>
              <p>$458K</p>
            </div>
            <div className="stat-card">
              <h3>Satisfaction Rate</h3>
              <p>92%</p>
            </div>
          </div>

          <div className="vendor-overview">
            <h3>Vendor Overview</h3>
            <div className="overview-stats">
              <div className="overview-card">
                <h3>Total Services</h3>
                <p>3,254</p>
              </div>
              <div className="overview-card">
                <h3>New Vendors (Month)</h3>
                <p>45</p>
              </div>
              <div className="overview-card">
                <h3>Warned Vendors</h3>
                <p>12</p>
              </div>
              <div className="overview-card">
                <h3>Suspended Vendors</h3>
                <p>3</p>
              </div>
            </div>
          </div>

          <div className="top-vendors">
            <h3>Top Vendors</h3>
            <div className="vendor-list">
              <VendorCard
                name="Tech Solutions Ltd"
                service="IT Services - Rating: 4.8"
                topRated={true}
              />
              <VendorCard
                name="Global Marketing Co"
                service="Marketing Services - Rating: 4.7"
                topRated={true}
              />
              <VendorCard
                name="Design Masters Inc"
                service="Design Services - Rating: 4.6"
                topRated={true}
              />
            </div>
            <button className="view-all">View All Top Vendors</button>
          </div>

          <div className="recent-activities">
            <h3>Recent Vendor Activities</h3>
            <div className="activity-card">
              <p>New Service Added <br /> By Tech Solutions Ltd</p>
              <span className="activity-time">Just Now</span>
            </div>
            <div className="activity-card">
              <p>Service Updated <br /> By Global Marketing Co</p>
              <span className="activity-time">5m ago</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default VendorScreen;