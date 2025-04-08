import React from "react";
import "./VendorScreen.css";

const VendorScreen = () => {
  return (
    <div className="vendor-container">
      <div className="vendor-main">
        <div className="vendor-header">
          <h1>Vendor Management</h1>
          <p>Monitor and manage vendor statistics</p>
        </div>

        <div className="vendor-grid">
          {/* Top Vendors Section */}
          <div className="vendor-card">
            <h3>Top Vendors</h3>
            <div className="vendor-list">
              <div className="vendor-item">
                <div>
                  <p className="vendor-name">Text Solutions Ltd</p>
                  <p className="vendor-details">IT Services - Rating = 4.5</p>
                </div>
                <span className="vendor-status">Top Sales</span>
              </div>
              <div className="vendor-item">
                <div>
                  <p className="vendor-name">Global Marketing Co</p>
                  <p className="vendor-details">Marketing Services - Rating = 4.7</p>
                </div>
                <span className="vendor-status">Top Sales</span>
              </div>
              <div className="vendor-item">
                <div>
                  <p className="vendor-name">Design Masters Inc</p>
                  <p className="vendor-details">Design Sciences - Rating = 4.5</p>
                </div>
                <span className="vendor-status">Top Sales</span>
              </div>
            </div>
            <button className="see-more">View All Top Vendors</button>
          </div>

          {/* Recent Vendor Activities */}
          <div className="vendor-card">
            <h3>Recent Vendor Activities</h3>
            <div className="activity-list">
              
            </div>
            <div className="just-now">
              <h4>New Service added </h4>
              <p>by the Business Ltd</p>
            </div>
            <div className="just-now">
              <h5>Service Updated </h5>
              <p>By Global Marketing Co</p>
            </div>
          </div>

          {/* Vendor Statistics */}
          <div className="vendor-card">
            <h3>Vendor Statistics</h3>
            <div className="stats-grid">
              <div className="stat-box">
                <p>Text Investors</p>
                <span>856</span>
              </div>
              <div className="stat-box">
                <p>Active Services</p>
                <span>2,145</span>
              </div>
              <div className="stat-box">
                <p>Texti Investors</p>
                <span>$458K</span>
              </div>
              <div className="stat-box">
                <p>Satisfaction base</p>
                <span>92%</span>
              </div>
            </div>
          </div>

          {/* Vendor Overview */}
          <div className="vendor-card">
            <h3>Vendor Overview</h3>
            <div className="stats-grid">
              <div className="stat-box">
                <p>Texti Services</p>
                <span>3,254</span>
              </div>
              <div className="stat-box">
                <p>New vendors (Vents)</p>
                <span>45</span>
              </div>
              <div className="stat-box">
                <p>Wanted Vendors</p>
                <span>12</span>
              </div>
              <div className="stat-box">
                <p>Sustainable Vendors</p>
                <span>3</span>
              </div>
            </div>
          </div>
        </div>
        
        <div className="footer">
        </div>
      </div>
    </div>
  );
};

export default VendorScreen;