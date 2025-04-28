import React, { useState } from 'react';
import './ApprovalsPage.css';

const ApprovalsPage = () => {
  const [activeTab, setActiveTab] = useState('listings');
  const [selectedItems, setSelectedItems] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState('All Categories');
  const [sortOption, setSortOption] = useState('newest');
  const [searchQuery, setSearchQuery] = useState('');

  // Sample data
  const listingsData = [
    {
      id: 1,
      title: 'Premium Coffee Shop Experience',
      submittedBy: 'Artisan Brews Co.',
      date: 'April 25, 2025',
      category: 'Food & Beverages',
      location: 'Downtown District',
      status: 'pending'
    },
    {
      id: 2,
      title: 'NextGen Smartphone - Limited Edition',
      submittedBy: 'TechVision Electronics',
      date: 'April 26, 2025',
      category: 'Electronics',
      location: 'Online Store',
      status: 'pending'
    },
    {
      id: 3,
      title: 'Sustainable Fashion Collection 2025',
      submittedBy: 'EcoStyle Apparel',
      date: 'April 24, 2025',
      category: 'Fashion',
      location: 'Fashion District',
      status: 'pending'
    },
    {
      id: 4,
      title: 'Professional Photography Services',
      submittedBy: 'CaptureMoment Studios',
      date: 'April 23, 2025',
      category: 'Services',
      location: 'Multiple Locations',
      status: 'pending'
    }
  ];

  const vendorsData = [
    {
      id: 1,
      name: 'Artisan Brews Co.',
      type: 'Food & Beverage',
      dateRegistered: 'April 25, 2025',
      location: 'Downtown District',
      status: 'pending'
    },
    {
      id: 2,
      name: 'TechVision Electronics',
      type: 'Electronics',
      dateRegistered: 'April 26, 2025',
      location: 'Online',
      status: 'pending'
    }
  ];

  // Filter and sort functions
  const filteredListings = listingsData.filter(listing => {
    const matchesSearch = listing.title.toLowerCase().includes(searchQuery.toLowerCase()) || 
                         listing.submittedBy.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = categoryFilter === 'All Categories' || 
                          listing.category === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  const filteredVendors = vendorsData.filter(vendor => {
    const matchesSearch = vendor.name.toLowerCase().includes(searchQuery.toLowerCase()) || 
                         vendor.type.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = categoryFilter === 'All Categories' || 
                          vendor.type === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  const sortedListings = [...filteredListings].sort((a, b) => {
    return sortOption === 'newest' 
      ? new Date(b.date) - new Date(a.date)
      : new Date(a.date) - new Date(b.date);
  });

  const sortedVendors = [...filteredVendors].sort((a, b) => {
    return sortOption === 'newest' 
      ? new Date(b.dateRegistered) - new Date(a.dateRegistered)
      : new Date(a.dateRegistered) - new Date(b.dateRegistered);
  });

  const handleItemSelect = (id) => {
    if (selectedItems.includes(id)) {
      setSelectedItems(selectedItems.filter(itemId => itemId !== id));
    } else {
      setSelectedItems([...selectedItems, id]);
    }
  };

  const handleSelectAll = () => {
    const currentItems = activeTab === 'listings' ? sortedListings : sortedVendors;
    if (selectedItems.length === currentItems.length) {
      setSelectedItems([]);
    } else {
      setSelectedItems(currentItems.map(item => item.id));
    }
  };

  const handleApprove = () => {
    console.log('Approved items:', selectedItems);
    setSelectedItems([]);
  };

  const handleReject = () => {
    console.log('Rejected items:', selectedItems);
    setSelectedItems([]);
  };

  return (
    <div className="approvals-container">
      <div className="approvals-header">
        <h1>Approvals</h1>
        <p>Review and approve pending listings and vendors</p>
        
        <div className="approvals-tabs">
          <button 
            className={`tab ${activeTab === 'listings' ? 'active' : ''}`}
            onClick={() => setActiveTab('listings')}
          >
            Unapproved Listings ({listingsData.length})
          </button>
          <button 
            className={`tab ${activeTab === 'vendors' ? 'active' : ''}`}
            onClick={() => setActiveTab('vendors')}
          >
            Unapproved Vendors ({vendorsData.length})
          </button>
        </div>
      </div>

      <div className="search-filter">
        <div className="filter-row">
          <div className="search-bar">
            <input
              type="text"
              placeholder="Search listings"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>
          
          <select 
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
            className="category-select"
          >
            <option value="All Categories">All Categories</option>
            {[...new Set(listingsData.map(item => item.category))].map(category => (
              <option key={category} value={category}>{category}</option>
            ))}
          </select>
          
          <div className="sort-section">
            <span>Sort by:</span>
            <select 
              value={sortOption}
              onChange={(e) => setSortOption(e.target.value)}
              className="sort-select"
            >
              <option value="newest">Newest First</option>
              <option value="oldest">Oldest First</option>
            </select>
          </div>
        </div>
        
        <div className="select-all">
          <input 
            type="checkbox" 
            id="selectAll"
            checked={selectedItems.length > 0 && 
                    selectedItems.length === (activeTab === 'listings' ? sortedListings.length : sortedVendors.length)}
            onChange={handleSelectAll}
          />
          <label htmlFor="selectAll">Select All</label>
        </div>
      </div>

      <div className="approval-cards">
        {activeTab === 'listings' ? (
          sortedListings.length > 0 ? (
            sortedListings.map(listing => (
              <div key={listing.id} className="approval-card">
                <div className="card-checkbox">
                  <input 
                    type="checkbox"
                    checked={selectedItems.includes(listing.id)}
                    onChange={() => handleItemSelect(listing.id)}
                  />
                </div>
                <div className="card-content">
                  <h3>{listing.title}</h3>
                  <p className="submitted-by">Submitted by: {listing.submittedBy}</p>
                  
                  <div className="card-details">
                    <div className="detail-item">
                      <span className="icon">📞</span>
                      <span>{listing.date}</span>
                    </div>
                    <div className="detail-item">
                      <span className="icon">📞</span>
                      <span>{listing.category}</span>
                    </div>
                    <div className="detail-item">
                      <span className="icon">📞</span>
                      <span>{listing.location}</span>
                    </div>
                  </div>
                </div>
              </div>
            ))
          ) : (
            <div className="no-results">No listings found matching your search</div>
          )
        ) : (
          sortedVendors.length > 0 ? (
            sortedVendors.map(vendor => (
              <div key={vendor.id} className="approval-card">
                <div className="card-checkbox">
                  <input 
                    type="checkbox"
                    checked={selectedItems.includes(vendor.id)}
                    onChange={() => handleItemSelect(vendor.id)}
                  />
                </div>
                <div className="card-content">
                  <h3>{vendor.name}</h3>
                  <p className="submitted-by">Type: {vendor.type}</p>
                  
                  <div className="card-details">
                    <div className="detail-item">
                      <span className="icon">📞</span>
                      <span>{vendor.dateRegistered}</span>
                    </div>
                    <div className="detail-item">
                      <span className="icon">📞</span>
                      <span>{vendor.location}</span>
                    </div>
                  </div>
                </div>
              </div>
            ))
          ) : (
            <div className="no-results">No vendors found matching your search</div>
          )
        )}
      </div>

      <div className="approval-actions">
        <div className="action-buttons">
          <button 
            className="approve-btn"
            onClick={handleApprove}
            disabled={selectedItems.length === 0}
          >
            Approve Selected
          </button>
          <button 
            className="reject-btn"
            onClick={handleReject}
            disabled={selectedItems.length === 0}
          >
            Reject Selected
          </button>
        </div>
      </div>

      <div className="approval-footer">
        <p>Showing {sortedListings.length > 0 || sortedVendors.length > 0 ? 1 : 0}-{activeTab === 'listings' ? sortedListings.length : sortedVendors.length} of {' '}
          {activeTab === 'listings' ? listingsData.length : vendorsData.length} items</p>
      </div>
    </div>
  );
};

export default ApprovalsPage;