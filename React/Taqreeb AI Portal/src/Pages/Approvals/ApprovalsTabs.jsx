import React from 'react';
import './ApprovalsTabs.css';

const ApprovalsTabs = ({ activeTab, setActiveTab, listingsCount, vendorsCount }) => {
  return (
    <div className="approvals-tabs">
      <button
        className={`tab ${activeTab === 'listings' ? 'active' : ''}`}
        onClick={() => setActiveTab('listings')}
      >
        Unapproved Listings ({listingsCount})
      </button>
      <button
        className={`tab ${activeTab === 'vendors' ? 'active' : ''}`}
        onClick={() => setActiveTab('vendors')}
      >
        Unapproved Vendors ({vendorsCount})
      </button>
    </div>
  );
};

export default ApprovalsTabs;