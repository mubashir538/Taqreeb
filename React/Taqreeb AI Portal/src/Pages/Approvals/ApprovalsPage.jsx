import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './ApprovalsPage.css';
import ListingCard from './ListingCard';
import VendorCard from './VendorCard';

const ApprovalsPage = () => {
  const [activeTab, setActiveTab] = useState('listings');
  const [selectedItems, setSelectedItems] = useState([]);
  const [categoryFilter, setCategoryFilter] = useState('All Categories');
  const [sortOption, setSortOption] = useState('newest');
  const [searchQuery, setSearchQuery] = useState('');
  const [listingsData, setListingsData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [stats, setStats] = useState(null);
  const [pagination, setPagination] = useState({
    page: 1,
    pageSize: 10,
    total: 0,
    totalPages: 1
  });

  useEffect(() => {
    const fetchStats = async () => {
      try {
        const response = await axios.get('/api/approvals/stats/');
        setStats(response.data.pendingStats);
      } catch (err) {
        console.error('Error fetching stats:', err);
      }
    };
    fetchStats();
  }, []);

  useEffect(() => {
    const fetchPendingListings = async () => {
      try {
        setLoading(true);
        const response = await axios.get('/api/approvals/listings/', {
          params: {
            type: categoryFilter === 'All Categories' ? null : categoryFilter,
            search: searchQuery,
            page: pagination.page,
            page_size: pagination.pageSize
          }
        });

        if (
          typeof response.data === 'string' &&
          response.data.startsWith('<!DOCTYPE html')
        ) {
          setError('Unexpected HTML response from server');
          setLoading(false);
          return;
        }

        const { listings = [], pagination: paginationData } = response.data;
        setListingsData(listings);

        if (paginationData) {
          setPagination(prev => ({
            ...prev,
            total: paginationData.total,
            totalPages: paginationData.total_pages
          }));
        } else {
          setPagination(prev => ({
            ...prev,
            total: 0,
            totalPages: 1
          }));
        }

        setLoading(false);
      } catch (err) {
        console.error('Error fetching listings:', err.response?.data || err.message);
        setError(err.message);
        setLoading(false);
      }
    };

    if (activeTab === 'listings') {
      fetchPendingListings();
    }
  }, [activeTab, categoryFilter, searchQuery, pagination.page]);

  const handleApprove = async () => {
    try {
      await axios.post('/api/approvals/bulk-status/', {
        ids: selectedItems,
        status: 'active'
      });
      refreshListings();
    } catch (err) {
      console.error('Error approving listings:', err);
    }
  };

  const handleReject = async () => {
    try {
      await axios.post('/api/approvals/bulk-status/', {
        ids: selectedItems,
        status: 'rejected'
      });
      refreshListings();
    } catch (err) {
      console.error('Error rejecting listings:', err);
    }
  };

  const refreshListings = async () => {
    try {
      const response = await axios.get('/api/approvals/listings/', {
        params: {
          page: pagination.page,
          page_size: pagination.pageSize
        }
      });
      setListingsData(response.data.listings || []);
      setSelectedItems([]);
    } catch (err) {
      console.error('Error refreshing listings:', err);
    }
  };

  const handlePageChange = (newPage) => {
    setPagination(prev => ({ ...prev, page: newPage }));
  };

  const handleItemSelect = (id) => {
    if (selectedItems.includes(id)) {
      setSelectedItems(selectedItems.filter(itemId => itemId !== id));
    } else {
      setSelectedItems([...selectedItems, id]);
    }
  };

  const handleSelectAll = () => {
    const currentItems = listingsData.map(item => item.id);
    if (Array.isArray(selectedItems) && Array.isArray(listingsData) && selectedItems.length === listingsData.length) {
      setSelectedItems([]);
    } else {
      setSelectedItems(currentItems);
    }
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (error) return <div className="error">Error: {error}</div>;

  return (
    <div className="approvals-container">
      <div className="approvals-tabs">
        <button className={`tab ${activeTab === 'listings' ? 'active' : ''}`} onClick={() => setActiveTab('listings')}>
          Unapproved Listings ({stats?.totalPending || 0})
        </button>
        <button className={`tab ${activeTab === 'vendors' ? 'active' : ''}`} onClick={() => setActiveTab('vendors')}>
          Unapproved Vendors (8)
        </button>
      </div>

      <div className="search-filter">
        <div className="filter-row">
          <div className="search-bar">
            <input
              type="text"
              placeholder={`Search ${activeTab}...`}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
            />
          </div>

          <select
            value={categoryFilter}
            onChange={(e) => setCategoryFilter(e.target.value)}
            className="category-select"
          >
            <option value="All Categories">All {activeTab === 'listings' ? 'Categories' : 'Vendor Types'}</option>
            {stats && Object.keys(stats.pendingByType).map(type => (
              <option key={type} value={type}>{type}</option>
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
            checked={
              Array.isArray(selectedItems) &&
              Array.isArray(listingsData) &&
              selectedItems.length > 0 &&
              selectedItems.length === listingsData.length
            }
            onChange={handleSelectAll}
          />
          <label htmlFor="selectAll">Select All</label>
        </div>
      </div>

      <div className="approval-cards">
        {Array.isArray(listingsData) && listingsData.length > 0 ? (
          listingsData.map(listing => (
            activeTab === 'listings' ? (
              <ListingCard
                key={listing.id}
                listing={listing}
                isSelected={selectedItems.includes(listing.id)}
                onSelect={handleItemSelect}
              />
            ) : (
              <VendorCard
                key={listing.id}
                vendor={listing}
                isSelected={selectedItems.includes(listing.id)}
                onSelect={handleItemSelect}
              />
            )
          ))
        ) : (
          <div className="no-results">No pending {activeTab} found</div>
        )}
      </div>

      <div className="pagination-controls">
        <button
          onClick={() => handlePageChange(pagination.page - 1)}
          disabled={pagination.page === 1}
        >
          &lt;
        </button>
        {[...Array(pagination.totalPages)].map((_, index) => (
          <button
            key={index}
            className={pagination.page === index + 1 ? 'active' : ''}
            onClick={() => handlePageChange(index + 1)}
          >
            {index + 1}
          </button>
        ))}
        <button
          onClick={() => handlePageChange(pagination.page + 1)}
          disabled={pagination.page === pagination.totalPages}
        >
          &gt;
        </button>
      </div>

      <div className="approval-actions">
        <div className="action-buttons">
          <button
            className="approve-btn"
            onClick={handleApprove}
            disabled={selectedItems.length === 0}
          >
            Approve Selected ({selectedItems.length})
          </button>
          <button
            className="reject-btn"
            onClick={handleReject}
            disabled={selectedItems.length === 0}
          >
            Reject Selected ({selectedItems.length})
          </button>
        </div>
      </div>
    </div>
  );
};

export default ApprovalsPage;